// Copyright © 2019-2023
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`include "VX_define.vh"

module VX_fetch_scalar import VX_gpu_pkg::*; #(
    parameter CORE_ID = 0,
    parameter THREAD_CNT = `NUM_THREADS,
    parameter WARP_CNT = `NUM_WARPS,
    parameter ISSUE_CNT = `MIN(WARP_CNT, 4),
    parameter WARP_CNT_WIDTH = `LOG2UP(WARP_CNT)
) (
    `SCOPE_IO_DECL

    input  wire             clk,
    input  wire             reset,

    // Icache interface
    VX_mem_bus_if.master    icache_bus_if,
    
    // inputs
    VX_schedule_if.slave    schedule_if,

    // flush mechanism
	input [ISSUE_CNT-1:0] branch_mispredict_flush,

    // outputs
    VX_fetch_if.master      fetch_if
);
    `UNUSED_PARAM (CORE_ID)
    `UNUSED_VAR (reset)
`IGNORE_WARNINGS_BEGIN
    localparam ISSUE_IDX_W = `LOG2UP(ISSUE_CNT); 
    localparam ISW_WIDTH  = `LOG2UP(ISSUE_CNT);
`IGNORE_WARNINGS_END

    wire icache_req_valid;
    wire [ICACHE_ADDR_WIDTH-1:0] icache_req_addr;
    wire [ICACHE_TAG_WIDTH-1:0] icache_req_tag;
    wire icache_req_ready;

    wire [`UUID_WIDTH-1:0] rsp_uuid;
    wire [`NW_WIDTH-1:0] req_tag, rsp_tag;    

    wire icache_req_fire = icache_req_valid && icache_req_ready;

    wire [ISW_WIDTH-1:0] schedule_isw = `WID_TO_ISW(schedule_if.data.wid, ISW_WIDTH, ISSUE_IDX_W);
    
    assign req_tag = `NW_WIDTH'(schedule_if.data.wid);
    
    assign {rsp_uuid, rsp_tag} = icache_bus_if.rsp_data.tag;

    wire [`XLEN-1:0] rsp_PC;
    wire [THREAD_CNT-1:0] rsp_tmask;

    // buffer to store the PC and thread mask until the response is received from the icache
    localparam IBUF_SIZE_WIDTH = `LOG2UP((2 * (WARP_CNT / ISSUE_CNT))+1);
    wire icache_response_squashed_successfully;	
    reg squashing_in_progress;
    reg [IBUF_SIZE_WIDTH:0] sent_icache_requests;
    wire [IBUF_SIZE_WIDTH:0] sent_icache_requests_n;

    VX_fifo_queue #(
        .DATAW  (`XLEN + THREAD_CNT),
        .DEPTH  ((2 * (WARP_CNT / ISSUE_CNT))),
        .LUTRAM (1)
    ) tag_store (
        .clk   (clk),  
        .reset (reset | (|branch_mispredict_flush)),
        .push  (icache_bus_if.req_valid & icache_bus_if.req_ready),        
        .pop   (icache_bus_if.rsp_valid & !squashing_in_progress), //only pop when response received which is not squashed
        `UNUSED_PIN (empty),
        `UNUSED_PIN (alm_empty),
        `UNUSED_PIN (full),
        `UNUSED_PIN (alm_full),
        `UNUSED_PIN (size),
        .data_in ({{icache_bus_if.req_data.addr,2'b0}, {(THREAD_CNT){1'b1}} }),
        .data_out ({rsp_PC, rsp_tmask})
    );

    // to raise assertion errors for out of order responses
    //
    // Note: I suspect that the icache returns out of order. This would cause
    // a problem when we are operating in 1Warp 1Thread config. We have seen
    // icache do out of order responses for instructions of different warps 
    // but I am yet to see a out of order response for instructions within
    // a single warp. I believe 99% that the icache does not do out of order
    // response/returns for instructions within a single warp. Cause if it did
    // then the program order would get messed up and there is no
    // mechanism in this pipeline that does reordering of the
    // returned instructions. But I have not been able to confirm it so
    // as a fail safe I have a put a tracker mechanism with assertion that
    // will fail if there is a out of order response from icache within
    // a single warp. It is PITA to debug if the program order gets messed so
    // assertion is a better solution.
    //
    // TODO : remove the ooo_tracking fifo before synthesis/tapeout to save
    // area/power

    wire [(`UUID_WIDTH+`NW_WIDTH)-1:0] tmp;
    VX_fifo_queue #(
        .DATAW  (`UUID_WIDTH+`NW_WIDTH),
        .DEPTH  (4*`IBUF_SIZE),
        .LUTRAM (1)
    ) ooo_tracking (
        .clk   (clk),  
        .reset (reset),
        .push  (icache_bus_if.req_valid & icache_bus_if.req_ready),        
        .pop   (icache_bus_if.rsp_valid),
        `UNUSED_PIN (empty),
        `UNUSED_PIN (alm_empty),
        `UNUSED_PIN (full),
        `UNUSED_PIN (alm_full),
        `UNUSED_PIN (size),
        .data_in (icache_bus_if.req_data.tag),
        .data_out (tmp)
    );
	`RUNTIME_ASSERT(!(icache_bus_if.rsp_valid & (tmp != icache_bus_if.rsp_data.tag)), ("Possibly a OOO ICache Return???? Not sure. Please check icache responses") )


    // Ensure that the ibuffer doesn't fill up.
    // This resolves potential deadlock if ibuffer fills and the LSU stalls the execute stage due to pending dcache request.
    // This issue is particularly prevalent when the icache and dcache is disabled and both requests share the same bus.
    wire [ISSUE_CNT-1:0] pending_ibuf_full;
    for (genvar i = 0; i < ISSUE_CNT; ++i) begin
        VX_pending_size #( 
            .SIZE (`IBUF_SIZE)
        ) pending_reads (
            .clk   (clk),
            .reset (reset | (|branch_mispredict_flush) ),
            .incr  (icache_req_fire && schedule_isw == i),
            .decr  (fetch_if.ibuf_pop[i]),
            .full  (pending_ibuf_full[i]),
            `UNUSED_PIN (size),
            `UNUSED_PIN (empty)
        );
    end

    `RUNTIME_ASSERT((!schedule_if.valid || schedule_if.data.PC != 0), 
        ("%t: *** invalid PC=0x%0h, wid=%0d, tmask=%b (#%0d)", $time, schedule_if.data.PC, schedule_if.data.wid, schedule_if.data.tmask, schedule_if.data.uuid))

    // Icache Request
    
    wire ibuf_ready = ~pending_ibuf_full[schedule_isw];
    assign icache_req_valid = schedule_if.valid && ibuf_ready;
    assign icache_req_addr  = schedule_if.data.PC[`MEM_ADDR_WIDTH-1:2];
    assign icache_req_tag   = {schedule_if.data.uuid, req_tag};
    assign schedule_if.ready = icache_req_ready && ibuf_ready;

    wire req_buf_out_valid, req_buf_out_ready;
    assign req_buf_out_ready = icache_bus_if.req_ready & !squashing_in_progress;

    VX_elastic_buffer #(
        .DATAW   (ICACHE_ADDR_WIDTH + ICACHE_TAG_WIDTH),
        .SIZE    (2),
        .OUT_REG (1) // external bus should be registered
    ) req_buf (
        .clk       (clk),
        .reset     (reset | (|branch_mispredict_flush)),
        .valid_in  (icache_req_valid),
        .ready_in  (icache_req_ready),
        .data_in   ({icache_req_addr, icache_req_tag}),
        .data_out  ({icache_bus_if.req_data.addr, icache_bus_if.req_data.tag}),
        .valid_out (req_buf_out_valid),
        .ready_out (req_buf_out_ready)
    );

    assign icache_bus_if.req_valid       = req_buf_out_valid & !squashing_in_progress;
    assign icache_bus_if.req_data.rw     = 0;
    assign icache_bus_if.req_data.byteen = 4'b1111;
    assign icache_bus_if.req_data.data   = '0;    

    // Icache Response

    assign fetch_if.valid = icache_bus_if.rsp_valid & !squashing_in_progress;
    assign fetch_if.data.tmask = rsp_tmask;
    assign fetch_if.data.wid   = rsp_tag[WARP_CNT_WIDTH-1:0];
    assign fetch_if.data.PC    = rsp_PC;
    assign fetch_if.data.instr = icache_bus_if.rsp_data.data;
    assign fetch_if.data.uuid  = rsp_uuid;
    assign icache_bus_if.rsp_ready = fetch_if.ready;

    // Squash Icache responses
    //
    // Below logic squashes icache responses. This is required when there has
    // been a mispredict in the pipeline and we need to flush speculatively
    // scheduled instructions. When we flush pipeline, it is possible that
    // a fetch request was already sent to the icache which was not required. Since
    // there is no way to stop a fetch once sent to Icache, we just squash the
    // response once it comes back from Icache.
		
    assign icache_response_squashed_successfully = icache_bus_if.rsp_valid & squashing_in_progress;
    assign sent_icache_requests_n = sent_icache_requests + IBUF_SIZE_WIDTH'(icache_bus_if.req_valid && icache_bus_if.req_ready) - IBUF_SIZE_WIDTH'(icache_bus_if.rsp_valid);
	
    always@ (posedge clk) begin
        if (reset) begin
            squashing_in_progress <= 0;
        end
        else begin
            // If squashing in progress then continue till pending reads become zero
            // else keep waiting for flush signal to start squashing
            squashing_in_progress <= squashing_in_progress ? (sent_icache_requests != 0) : (|branch_mispredict_flush);
        end
    end

    // track the number of icache requests in progress (i.e. the number of 
    // instructions requested but not received)
    always@(posedge clk) begin
        if (reset)
            sent_icache_requests <= 0;
        else
            sent_icache_requests <= sent_icache_requests_n;
    end

`ifdef DBG_SCOPE_FETCH
    if (CORE_ID == 0) begin
    `ifdef SCOPE
        wire schedule_fire = schedule_if.valid && schedule_if.ready;
        wire icache_rsp_fire = icache_bus_if.rsp_valid && icache_bus_if.rsp_ready;
        VX_scope_tap #(
            .SCOPE_ID (1),
            .TRIGGERW (4),
            .PROBEW   (3*`UUID_WIDTH + 108)
        ) scope_tap (
            .clk(clk),
            .reset(scope_reset),
            .start(1'b0),
            .stop(1'b0),
            .triggers({
                reset,
                schedule_fire,
                icache_req_fire,
                icache_rsp_fire
            }),
            .probes({
                schedule_if.data.uuid, schedule_if.data.wid, schedule_if.data.tmask, schedule_if.data.PC,
                icache_bus_if.req_data.tag, icache_bus_if.req_data.byteen, icache_bus_if.req_data.addr,
                icache_bus_if.rsp_data.data, icache_bus_if.rsp_data.tag
            }),
            .bus_in(scope_bus_in),
            .bus_out(scope_bus_out)
        );
    `endif
    `ifdef CHIPSCOPE
        ila_fetch ila_fetch_inst (
            .clk    (clk),
            .probe0 ({reset, schedule_if.data.uuid, schedule_if.data.wid, schedule_if.data.tmask, schedule_if.data.PC, schedule_if.ready, schedule_if.valid}),        
            .probe1 ({icache_bus_if.req_data.tag, icache_bus_if.req_data.byteen, icache_bus_if.req_data.addr, icache_bus_if.req_ready, icache_bus_if.req_valid}),
            .probe2 ({icache_bus_if.rsp_data.data, icache_bus_if.rsp_data.tag, icache_bus_if.rsp_ready, icache_bus_if.rsp_valid})
        );
    `endif
    end
`else
    `SCOPE_IO_UNUSED()
`endif

`ifdef DBG_TRACE_CORE_ICACHE
    wire schedule_fire = schedule_if.valid && schedule_if.ready;
    wire fetch_fire = fetch_if.valid && fetch_if.ready;
    always @(posedge clk) begin
        if (schedule_fire) begin
            `TRACE(1, ("%d: I$%0d req: wid=%0d, PC=0x%0h, tmask=%b (#%0d)\n", $time, CORE_ID, schedule_if.data.wid, schedule_if.data.PC, schedule_if.data.tmask, schedule_if.data.uuid));
        end
        if (fetch_fire) begin
            `TRACE(1, ("%d: I$%0d rsp: wid=%0d, PC=0x%0h, tmask=%b, instr=0x%0h (#%0d)\n", $time, CORE_ID, fetch_if.data.wid, fetch_if.data.PC, fetch_if.data.tmask, fetch_if.data.instr, fetch_if.data.uuid));
        end
    end
`endif

endmodule
