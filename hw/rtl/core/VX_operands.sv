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

module VX_operands import VX_gpu_pkg::*; #(
    parameter CORE_ID = 0,
    parameter CACHE_ENABLE = 0,
    parameter THREAD_CNT = `NUM_THREADS
) (
    input wire              clk,
    input wire              reset,

    VX_writeback_if.slave   writeback_if [`ISSUE_WIDTH],
    VX_ibuffer_if.slave     scoreboard_if [`ISSUE_WIDTH],
    VX_operands_if.master   operands_if [`ISSUE_WIDTH]
);
    `UNUSED_PARAM (CORE_ID)
    localparam DATAW = `UUID_WIDTH + ISSUE_WIS_W + THREAD_CNT + `XLEN + 1 + `EX_BITS + `INST_OP_BITS + `INST_MOD_BITS + 1 + 1 + `XLEN + `NR_BITS;

    localparam STATE_IDLE   = 2'd0;
    localparam STATE_FETCH1 = 2'd1;
    localparam STATE_FETCH2 = 2'd2;
    localparam STATE_FETCH3 = 2'd3;
    localparam STATE_BITS   = 2;

    for (genvar i = 0; i < `ISSUE_WIDTH; ++i) begin
        wire [THREAD_CNT-1:0][`XLEN-1:0] gpr_rd_data;
        reg [`NR_BITS-1:0] gpr_rd_rid, gpr_rd_rid_n;
        reg [ISSUE_WIS_W-1:0] gpr_rd_wis, gpr_rd_wis_n;

        reg [ISSUE_RATIO-1:0][THREAD_CNT-1:0][`XLEN-1:0] cache_data, cache_data_n;
        reg [ISSUE_RATIO-1:0][`NR_BITS-1:0] cache_reg, cache_reg_n;
        reg [ISSUE_RATIO-1:0][THREAD_CNT-1:0] cache_tmask, cache_tmask_n;
        reg [ISSUE_RATIO-1:0] cache_eop, cache_eop_n;

        reg [THREAD_CNT-1:0][`XLEN-1:0] rs1_data, rs1_data_n;
        reg [THREAD_CNT-1:0][`XLEN-1:0] rs2_data, rs2_data_n;
        reg [THREAD_CNT-1:0][`XLEN-1:0] rs3_data, rs3_data_n;   

        reg [STATE_BITS-1:0] state, state_n;
        reg [`NR_BITS-1:0] rs2, rs2_n;
        reg [`NR_BITS-1:0] rs3, rs3_n;
        reg rs2_ready, rs2_ready_n;
        reg rs3_ready, rs3_ready_n;
        reg data_ready, data_ready_n;

        wire is_rs1_zero = (scoreboard_if[i].data.rs1 == 0);
        wire is_rs2_zero = (scoreboard_if[i].data.rs2 == 0);
        wire is_rs3_zero = (scoreboard_if[i].data.rs3 == 0);        

        VX_operands_if#(.THREAD_CNT (THREAD_CNT)) staging_if();

        always @(*) begin
            state_n      = state;
            rs2_n        = rs2;
            rs3_n        = rs3;
            rs2_ready_n  = rs2_ready;
            rs3_ready_n  = rs3_ready;
            rs1_data_n   = rs1_data;
            rs2_data_n   = rs2_data;
            rs3_data_n   = rs3_data;
            cache_data_n = cache_data;
            cache_reg_n  = cache_reg;
            cache_tmask_n= cache_tmask;
            cache_eop_n  = cache_eop;
            gpr_rd_rid_n = gpr_rd_rid;
            gpr_rd_wis_n = gpr_rd_wis;
            data_ready_n = data_ready;

            case (state)
            STATE_IDLE: begin
                if (staging_if.valid && staging_if.ready) begin
                    data_ready_n = 0;
                end
                if (scoreboard_if[i].valid && data_ready_n == 0) begin
                    data_ready_n = 1;
                    if (is_rs3_zero || (CACHE_ENABLE != 0 && 
                                        scoreboard_if[i].data.rs3 == cache_reg[scoreboard_if[i].data.wis] && 
                                        (scoreboard_if[i].data.tmask & cache_tmask[scoreboard_if[i].data.wis]) == scoreboard_if[i].data.tmask)) begin
                        rs3_data_n   = (is_rs3_zero || CACHE_ENABLE == 0) ? '0 : cache_data[scoreboard_if[i].data.wis];
                        rs3_ready_n  = 1;
                    end else begin
                        rs3_ready_n  = 0;
                        gpr_rd_rid_n = scoreboard_if[i].data.rs3;
                        data_ready_n = 0;
                        state_n      = STATE_FETCH3;
                    end
                    if (is_rs2_zero || (CACHE_ENABLE != 0 && 
                                        scoreboard_if[i].data.rs2 == cache_reg[scoreboard_if[i].data.wis] && 
                                        (scoreboard_if[i].data.tmask & cache_tmask[scoreboard_if[i].data.wis]) == scoreboard_if[i].data.tmask)) begin
                        rs2_data_n   = (is_rs2_zero || CACHE_ENABLE == 0) ? '0 : cache_data[scoreboard_if[i].data.wis];
                        rs2_ready_n  = 1;
                    end else begin
                        rs2_ready_n  = 0;
                        gpr_rd_rid_n = scoreboard_if[i].data.rs2;
                        data_ready_n = 0;
                        state_n      = STATE_FETCH2;
                    end
                    if (is_rs1_zero || (CACHE_ENABLE != 0 && 
                                        scoreboard_if[i].data.rs1 == cache_reg[scoreboard_if[i].data.wis] && 
                                        (scoreboard_if[i].data.tmask & cache_tmask[scoreboard_if[i].data.wis]) == scoreboard_if[i].data.tmask)) begin
                        rs1_data_n   = (is_rs1_zero || CACHE_ENABLE == 0) ? '0 : cache_data[scoreboard_if[i].data.wis];
                    end else begin
                        gpr_rd_rid_n = scoreboard_if[i].data.rs1;
                        data_ready_n = 0;
                        state_n      = STATE_FETCH1;
                    end
                end
                gpr_rd_wis_n = scoreboard_if[i].data.wis;
                rs2_n = scoreboard_if[i].data.rs2;
                rs3_n = scoreboard_if[i].data.rs3;
            end
            STATE_FETCH1: begin
                rs1_data_n = gpr_rd_data;
                if (~rs2_ready) begin
                    gpr_rd_rid_n = rs2;
                    state_n = STATE_FETCH2;
                end else if (~rs3_ready) begin
                    gpr_rd_rid_n = rs3;
                    state_n = STATE_FETCH3;
                end else begin
                    data_ready_n = 1;
                    state_n = STATE_IDLE;
                end
            end
            STATE_FETCH2: begin
                rs2_data_n = gpr_rd_data;
                if (~rs3_ready) begin
                    gpr_rd_rid_n = rs3;
                    state_n = STATE_FETCH3;
                end else begin
                    data_ready_n = 1;
                    state_n = STATE_IDLE;
                end
            end
            STATE_FETCH3: begin
                rs3_data_n = gpr_rd_data;
                data_ready_n = 1;
                state_n = STATE_IDLE;
            end
            endcase
            
            if (CACHE_ENABLE != 0 && writeback_if[i].valid) begin
                if ((cache_reg[writeback_if[i].data.wis] == writeback_if[i].data.rd) 
                 || (cache_eop[writeback_if[i].data.wis] && writeback_if[i].data.sop)) begin
                    for (integer j = 0; j < THREAD_CNT; ++j) begin
                        if (writeback_if[i].data.tmask[j]) begin
                            cache_data_n[writeback_if[i].data.wis][j] = writeback_if[i].data.data[j];
                        end
                    end
                    cache_reg_n[writeback_if[i].data.wis] = writeback_if[i].data.rd;
                    cache_eop_n[writeback_if[i].data.wis] = writeback_if[i].data.eop;
                    if (writeback_if[i].data.sop) begin
                        cache_tmask_n[writeback_if[i].data.wis] = writeback_if[i].data.tmask;
                    end else begin
                        cache_tmask_n[writeback_if[i].data.wis] |= writeback_if[i].data.tmask;
                    end                
                end
            end
        end

        always @(posedge clk)  begin
            if (reset) begin
                state       <= STATE_IDLE;
                gpr_rd_rid  <= '0;
                gpr_rd_wis  <= '0;
                cache_eop   <= {ISSUE_RATIO{1'b1}};
                cache_reg   <= '0;
                data_ready  <= 0;
            end else begin
                state       <= state_n;
                rs2         <= rs2_n;
                rs3         <= rs3_n;
                rs2_ready   <= rs2_ready_n;
                rs3_ready   <= rs3_ready_n;
                rs1_data    <= rs1_data_n;
                rs2_data    <= rs2_data_n;
                rs3_data    <= rs3_data_n;
                gpr_rd_rid  <= gpr_rd_rid_n;
                gpr_rd_wis  <= gpr_rd_wis_n;
                cache_data  <= cache_data_n;
                cache_reg   <= cache_reg_n;
                cache_tmask <= cache_tmask_n;
                cache_eop   <= cache_eop_n;
                data_ready  <= data_ready_n;
            end
        end

        // GPR banks

    `ifdef GPR_RESET
        reg wr_enabled = 0;
        always @(posedge clk) begin
            if (reset) begin
                wr_enabled <= 1;
            end
        end
    `else
        wire wr_enabled = 1;
    `endif
        
        for (genvar j = 0; j < THREAD_CNT; ++j) begin
            VX_dp_ram #(
                .DATAW (`XLEN),
                .SIZE (`NUM_REGS * ISSUE_RATIO),
            `ifdef GPR_RESET
                .INIT_ENABLE (1),
                .INIT_VALUE (0),
            `endif
                .NO_RWCHECK (1)
            ) gpr_ram (
                .clk   (clk),
                .read  (1'b1),
                `UNUSED_PIN (wren),
                .write (wr_enabled && writeback_if[i].valid && writeback_if[i].data.tmask[j]),                
                .waddr (wis_to_addr(writeback_if[i].data.rd, writeback_if[i].data.wis)),
                .wdata (writeback_if[i].data.data[j]),
                .raddr (wis_to_addr(gpr_rd_rid, gpr_rd_wis)),
                .rdata (gpr_rd_data[j])
            );
        end

        // staging buffer

        `RESET_RELAY (stg_buf_reset, reset);
        
        VX_elastic_buffer #(
            .DATAW (DATAW)
        ) stg_buf (
            .clk      (clk),
            .reset    (stg_buf_reset),
            .valid_in (scoreboard_if[i].valid),
            .ready_in (scoreboard_if[i].ready),
            .data_in  ({
                scoreboard_if[i].data.uuid,
                scoreboard_if[i].data.wis,
                scoreboard_if[i].data.tmask,
                scoreboard_if[i].data.PC, 
                scoreboard_if[i].data.wb,
                scoreboard_if[i].data.ex_type,
                scoreboard_if[i].data.op_type,
                scoreboard_if[i].data.op_mod,
                scoreboard_if[i].data.use_PC,
                scoreboard_if[i].data.use_imm,
                scoreboard_if[i].data.imm,
                scoreboard_if[i].data.rd}),
            .data_out ({
                staging_if.data.uuid,
                staging_if.data.wis,
                staging_if.data.tmask,
                staging_if.data.PC, 
                staging_if.data.wb,
                staging_if.data.ex_type,
                staging_if.data.op_type,
                staging_if.data.op_mod,
                staging_if.data.use_PC,
                staging_if.data.use_imm,
                staging_if.data.imm,
                staging_if.data.rd}),                                               
            .valid_out (staging_if.valid),
            .ready_out (staging_if.ready)
        );

        assign staging_if.data.rs1_data = rs1_data;
        assign staging_if.data.rs2_data = rs2_data;
        assign staging_if.data.rs3_data = rs3_data;

        // output buffer

        wire valid_stg, ready_stg;
        assign valid_stg = staging_if.valid && data_ready;
        assign staging_if.ready = ready_stg && data_ready;

        `RESET_RELAY (out_buf_reset, reset);

        VX_elastic_buffer #(
            .DATAW   (DATAW + (3 * THREAD_CNT * `XLEN)),
            .SIZE    (2),
            .OUT_REG (2)
        ) out_buf (
            .clk       (clk),
            .reset     (out_buf_reset),
            .valid_in  (valid_stg),
            .ready_in  (ready_stg),
            .data_in   (staging_if.data),
            .data_out  (operands_if[i].data),
            .valid_out (operands_if[i].valid),
            .ready_out (operands_if[i].ready)
        );
    end    

endmodule
