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

module VX_execute import VX_gpu_pkg::*; #(
    parameter CORE_ID = 0,
    parameter THREAD_CNT = `NUM_THREADS,
    parameter WARP_CNT = `NUM_WARPS,
    parameter WARP_CNT_WIDTH = `LOG2UP(WARP_CNT),
    parameter ISSUE_CNT = `MIN(WARP_CNT, 4),
    parameter NUM_ALU_BLOCKS = `UP(ISSUE_CNT/1)
) (
    `SCOPE_IO_DECL

    input wire              clk, 
    input wire              reset,    

    input base_dcrs_t       base_dcrs,

    // Dcache interface
    VX_mem_bus_if.master    dcache_bus_if [DCACHE_NUM_REQS],

    // commit interface
    VX_commit_csr_if.slave  commit_csr_if,

    // fetch interface
    VX_sched_csr_if.slave   sched_csr_if,

`ifdef PERF_ENABLE
    VX_mem_perf_if.slave    mem_perf_if,
    VX_pipeline_perf_if.slave pipeline_perf_if,
`endif

`ifdef EXT_F_ENABLE
    VX_dispatch_if.slave    fpu_dispatch_if [ISSUE_CNT],
    VX_commit_if.master     fpu_commit_if [ISSUE_CNT],
`endif

`ifdef EXT_TEX_ENABLE
    VX_tex_bus_if.master    tex_bus_if,
`ifdef PERF_ENABLE
    VX_tex_perf_if.slave    perf_tex_if,
    VX_cache_perf_if.slave  perf_tcache_if,
`endif
`endif

`ifdef EXT_RASTER_ENABLE        
    VX_raster_bus_if.slave  raster_bus_if,
`ifdef PERF_ENABLE
    VX_raster_perf_if.slave perf_raster_if,
    VX_cache_perf_if.slave  perf_rcache_if,
`endif
`endif

`ifdef EXT_ROP_ENABLE        
    VX_rop_bus_if.master    rop_bus_if,
`ifdef PERF_ENABLE
    VX_rop_perf_if.slave    perf_rop_if,
    VX_cache_perf_if.slave  perf_ocache_if,
`endif
`endif    
  
    VX_dispatch_if.slave    alu_dispatch_if [ISSUE_CNT],
    VX_commit_if.master     alu_commit_if [ISSUE_CNT],
    VX_branch_ctl_if.master branch_ctl_if [NUM_ALU_BLOCKS],
    
    VX_dispatch_if.slave    lsu_dispatch_if [ISSUE_CNT],  
    VX_commit_if.master     lsu_commit_if [ISSUE_CNT],
    
    VX_dispatch_if.slave    sfu_dispatch_if [ISSUE_CNT], 
    VX_commit_if.master     sfu_commit_if [ISSUE_CNT],
    VX_warp_ctl_if.master   warp_ctl_if,
    VX_sfu_csr_if.master    hw_itr_ctrl_if,
    VX_execute_hw_itr_if.slave execute_hw_itr_if,

    // simulation helper signals
    output wire             sim_ebreak
);
    localparam NUM_FPU_BLOCKS = `UP(ISSUE_CNT / 1);

`ifdef EXT_F_ENABLE
    VX_fpu_to_csr_if #(.WARP_CNT(WARP_CNT)) fpu_to_csr_if[NUM_FPU_BLOCKS]();
`endif

    VX_commit_if #(.WARP_CNT(WARP_CNT)) alu_commit_tmp_if[ISSUE_CNT]();

    `RESET_RELAY (alu_reset, reset);
    `RESET_RELAY (lsu_reset, reset);
    `RESET_RELAY (sfu_reset, reset);
    
    VX_alu_unit #(
        .CORE_ID (CORE_ID),
        .THREAD_CNT(THREAD_CNT),
        .WARP_CNT(WARP_CNT),
        .ISSUE_CNT(ISSUE_CNT)
    ) alu_unit (
        .clk            (clk),
        .reset          (alu_reset),
        .dispatch_if    (alu_dispatch_if),
        .branch_ctl_if  (branch_ctl_if),
        .commit_if      (alu_commit_tmp_if)
    );

    `SCOPE_IO_SWITCH (1)

    VX_lsu_unit #(
        .CORE_ID (CORE_ID),
        .THREAD_CNT(THREAD_CNT),
        .WARP_CNT(WARP_CNT),
        .ISSUE_CNT(ISSUE_CNT)
    ) lsu_unit (
        `SCOPE_IO_BIND  (0)
        .clk            (clk),
        .reset          (lsu_reset),
        .cache_bus_if   (dcache_bus_if),
        .dispatch_if    (lsu_dispatch_if),
        .commit_if      (lsu_commit_if)
    );

`ifdef EXT_F_ENABLE
    `RESET_RELAY (fpu_reset, reset);

    VX_fpu_unit #(
        .CORE_ID (CORE_ID),
        .THREAD_CNT(THREAD_CNT),
        .WARP_CNT(WARP_CNT),
        .ISSUE_CNT(ISSUE_CNT)
    ) fpu_unit (
        .clk            (clk),
        .reset          (fpu_reset),    
        .dispatch_if    (fpu_dispatch_if), 
        .fpu_to_csr_if  (fpu_to_csr_if),
        .commit_if      (fpu_commit_if)
    );
`endif

    VX_sfu_unit #(
        .CORE_ID (CORE_ID),
        .THREAD_CNT(THREAD_CNT),
        .WARP_CNT(WARP_CNT),
        .ISSUE_CNT(ISSUE_CNT)
    ) sfu_unit (
        .clk            (clk),
        .reset          (sfu_reset),

    `ifdef PERF_ENABLE
        .mem_perf_if    (mem_perf_if),
        .pipeline_perf_if (pipeline_perf_if),
    `endif

        .base_dcrs      (base_dcrs),            

        .dispatch_if    (sfu_dispatch_if),
    
    `ifdef EXT_F_ENABLE
        .fpu_to_csr_if  (fpu_to_csr_if),
    `endif
    
    `ifdef EXT_TEX_ENABLE
        .tex_bus_if     (tex_bus_if),
    `ifdef PERF_ENABLE
        .perf_tex_if    (perf_tex_if),
        .perf_tcache_if (perf_tcache_if),
    `endif
    `endif
    
    `ifdef EXT_RASTER_ENABLE
        .raster_bus_if  (raster_bus_if),
    `ifdef PERF_ENABLE
        .perf_raster_if (perf_raster_if),
        .perf_rcache_if (perf_rcache_if),
    `endif
    `endif

    `ifdef EXT_ROP_ENABLE
        .rop_bus_if     (rop_bus_if),
    `ifdef PERF_ENABLE
        .perf_rop_if    (perf_rop_if),
        .perf_ocache_if (perf_ocache_if),
    `endif
    `endif
    
        .commit_csr_if  (commit_csr_if),
        .sched_csr_if   (sched_csr_if),
        .warp_ctl_if    (warp_ctl_if),
        .commit_if      (sfu_commit_if),
        .hw_itr_ctrl_if (hw_itr_ctrl_if) 
    );

    // overload JAL for thread transfer purposes

    logic [WARP_CNT - 1 : 0] warp_hits;
    logic [WARP_CNT - 1 : 0] warp_hits_n;
    logic [`NW_WIDTH - 1 : 0] warpNum;
    logic [WARP_CNT - 1 : 0] last_jal_before_kernel;
    logic [(`XLEN*THREAD_CNT) - 1 : 0] tmp_data;

    assign warpNum = wmask_to_wid(warp_hits_n); // convert bitmask to decimal number

    // check if each warp has done the JAL out of kernel scheduler. Stop overloading JAL when all warps have done this.
    always @(posedge clk) begin
        if (reset)
            warp_hits <= 0;
        else
            warp_hits <= warp_hits | warp_hits_n;
    end

    // If you are overloading JAL and a JAL comes, mark the warp
    for(genvar i = 0; i < NUM_ALU_BLOCKS; i = i + 1) begin 
        assign warp_hits_n[i] = execute_hw_itr_if.overload_JAL[i] & branch_ctl_if[i].valid & alu_commit_tmp_if[i].valid;
    end
    // double check this is the first time a warp has overloaded JAL before writing the return handler address (RHA register) into the commit stage
    for (genvar i = 0; i < ISSUE_CNT; ++i) begin
        // assign last_jal_before_kernel[i]      = execute_hw_itr_if.overload_JAL[i] & branch_ctl_if[i].valid & (branch_ctl_if[i].wid == WARP_CNT_WIDTH'(i)) & !warp_hits[i] & alu_commit_tmp_if[i].valid;
        for(genvar j = 0; j < THREAD_CNT; ++j) begin 
            assign alu_commit_if[i].data.data[j] = warp_hits_n[i] ? execute_hw_itr_if.retHandlerAddress : alu_commit_tmp_if[i].data.data[j]; // overload link register commit with RHA
        end
        assign alu_commit_if[i].data.uuid     = alu_commit_tmp_if[i].data.uuid;
        assign alu_commit_if[i].data.wid      = alu_commit_tmp_if[i].data.wid;
        assign alu_commit_if[i].data.tmask    = alu_commit_tmp_if[i].data.tmask;
        assign alu_commit_if[i].data.PC       = alu_commit_tmp_if[i].data.PC;
        assign alu_commit_if[i].data.wb       = alu_commit_tmp_if[i].data.wb;
        assign alu_commit_if[i].data.rd       = alu_commit_tmp_if[i].data.rd;
        assign alu_commit_if[i].data.pid      = alu_commit_tmp_if[i].data.pid;
        assign alu_commit_if[i].data.sop      = alu_commit_tmp_if[i].data.sop;
        assign alu_commit_if[i].data.eop      = alu_commit_tmp_if[i].data.eop;
        assign alu_commit_if[i].valid         = alu_commit_tmp_if[i].valid;
        assign alu_commit_tmp_if[i].ready     = alu_commit_if[i].ready;

    end

    // hit signals to tell VX_interrupt_ctl to save the actual return address in a CSR register (RAV and RAVW0)
    assign execute_hw_itr_if.commitSIMTSchedulerRetPC = |warp_hits_n[NUM_ALU_BLOCKS-1:1]; // check for warps other than warp0
    assign execute_hw_itr_if.commitSIMTSchedulerRetPCw0 = warp_hits_n[0]; // warp0 has a special return register to be saved. different from other warps
    // The actual return addresses to be saved in a CSR register
    assign execute_hw_itr_if.SIMTSchedulerRetPC       = tmp_data[warpNum*`XLEN +: `XLEN]; // save the actual return address to RAV CSR register in VX_interrupt_ctl
    assign execute_hw_itr_if.SIMTSchedulerRetPCw0     = tmp_data[31:0]; // save the actual return address to RAVW0 CSR register in VX_interrupt_ctl
    // Tell VX_interrupt_ctl to turn off the JALOL (JAL overloading flag) register
    assign execute_hw_itr_if.warp_hits                = warp_hits;

    // tie to 0
    assign execute_hw_itr_if.writeRAS = 0;

    for (genvar i = 0; i <WARP_CNT; ++i) begin
        assign tmp_data[i*`XLEN +: `XLEN] = alu_commit_tmp_if[i].data.data[0];
    end

    // simulation helper signal to get RISC-V tests Pass/Fail status
    assign sim_ebreak = alu_dispatch_if[0].valid && alu_dispatch_if[0].ready 
                     && alu_dispatch_if[0].data.wis == 0
                     && `INST_ALU_IS_BR(alu_dispatch_if[0].data.op_mod)
                     && (`INST_BR_BITS'(alu_dispatch_if[0].data.op_type) == `INST_BR_EBREAK
                      || `INST_BR_BITS'(alu_dispatch_if[0].data.op_type) == `INST_BR_ECALL);

endmodule
