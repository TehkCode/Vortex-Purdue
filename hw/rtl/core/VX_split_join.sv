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

module VX_split_join import VX_gpu_pkg::*; #(
    parameter CORE_ID = 0,
    parameter THREAD_CNT = `NUM_THREADS,
    parameter WARP_CNT = `NUM_WARPS,
    parameter WARP_CNT_WIDTH = `LOG2UP(WARP_CNT)
) (
    input  wire                     clk,
    input  wire                     reset,
    input  wire                     valid,
    input  wire [WARP_CNT_WIDTH-1:0]     wid,
    input  split_t                  split,
    input  join_t                   sjoin,
    output wire                     join_valid,
    output wire                     join_is_dvg,
    output wire                     join_is_else,
    output wire [WARP_CNT_WIDTH-1:0]     join_wid,
    output wire [THREAD_CNT-1:0]  join_tmask,
    output wire [`XLEN-1:0]         join_pc,
    output wire [WARP_CNT-1:0] ipdom_empty
);
    `UNUSED_PARAM (CORE_ID)
    
    wire [(`XLEN+THREAD_CNT)-1:0] ipdom_data [WARP_CNT-1:0];
    wire ipdom_set [WARP_CNT-1:0];

    wire [(`XLEN+THREAD_CNT)-1:0] ipdom_q0 = {split.then_tmask[THREAD_CNT-1:0] | split.else_tmask[THREAD_CNT-1:0], `XLEN'(0)};
    wire [(`XLEN+THREAD_CNT)-1:0] ipdom_q1 = {split.else_tmask[THREAD_CNT-1:0], split.next_pc};

    wire ipdom_push = valid && split.valid && split.is_dvg;
    wire ipdom_pop = valid && sjoin.valid && sjoin.is_dvg;

    for (genvar i = 0; i < WARP_CNT; ++i) begin

        `RESET_RELAY (ipdom_reset, reset);

        VX_ipdom_stack #(
            .WIDTH (`XLEN+THREAD_CNT), 
            .DEPTH (`UP(THREAD_CNT-1))
        ) ipdom_stack (
            .clk   (clk),
            .reset (ipdom_reset),
            .push  (ipdom_push && (i == wid)),
            .pop   (ipdom_pop && (i == wid)),
            .q0    (ipdom_q0),
            .q1    (ipdom_q1),
            .d     (ipdom_data[i]),
            .d_set (ipdom_set[i]),
            .empty (ipdom_empty[i]),
            `UNUSED_PIN (full)
        );
    end


    `RUNTIME_ASSERT(!(ipdom_empty[0] & ipdom_pop && (0 == wid)), ("**********caught u mf0************"))
if (WARP_CNT == 4) begin
    `RUNTIME_ASSERT(!(ipdom_empty[1] & ipdom_pop && (1 == wid)), ("**********caught u mf1************"))
    `RUNTIME_ASSERT(!(ipdom_empty[2] & ipdom_pop && (2 == wid)), ("**********caught u mf2************"))
    `RUNTIME_ASSERT(!(ipdom_empty[3] & ipdom_pop && (3 == wid)), ("**********caught u mf3************"))
end

    VX_pipe_register #(
        .DATAW  (1 + 1 + WARP_CNT_WIDTH + 1 + `XLEN + THREAD_CNT),
        .DEPTH  (1),
        .RESETW (1)
    ) pipe_reg (
        .clk      (clk),
        .reset    (reset),
        .enable   (1'b1),
        .data_in  ({valid && sjoin.valid, sjoin.is_dvg, ipdom_set[wid], wid, ipdom_data[wid]}),
        .data_out ({join_valid, join_is_dvg, join_is_else, join_wid, join_tmask, join_pc})
    );

endmodule
