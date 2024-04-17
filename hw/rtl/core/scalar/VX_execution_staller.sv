// Copyright Â© 2019-2023
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



// Developed by Purdue University's SoCET team based on Georgia Tech's work
// April 2024
// 
// Execution Staller
// Stalls instructions going into the execute stage if a branch/jump is being
// currently being executed. Also, ensures the instructions before branch/jump
// are committed before sending the branch/jump to the execute stage.

`include "VX_define.vh"

module VX_execution_staller import VX_gpu_pkg::*; #(
	parameter MAX_INFLIGHT = 64,
    parameter INFLIGHT_BITS = `CLOG2(MAX_INFLIGHT)
) (
    input clk,
    input reset,

    input branch_mispredict_flush,
    input valid_in,
    input decr,
    input incr,
    input fu_buffer_ready,
    input is_branch,

    output ready_in
);
    // FSM states
    typedef enum logic [1:0] { 
        IDLE,
        DRAIN,
        FIRE,
        WAIT
    } state_t;

    reg ready;
    state_t state_p, state_n;

    always@( posedge clk ) begin
        if (reset | branch_mispredict_flush)
            state_p <= IDLE;
        else
            state_p <= state_n;
    end

    // Next state logic
    always@(*) begin
        state_n = state_p;

        case (state_p)
            IDLE: begin
                if (valid_in && (is_branch) ) // wait for branch/jump instruction. directly fire it if execute stage is empty or go to drain state
                    state_n = !(|inflight_counter) ? FIRE : DRAIN;
                else
                    state_n = IDLE;
            end
            DRAIN: begin // wait for the execute to be empty
                if (!(|inflight_counter))
                    state_n = FIRE;
                else
                    state_n = DRAIN;
            end
            FIRE: begin // send in the branch/jump
                if (valid_in && fu_buffer_ready)
                    state_n = WAIT;
                else
                    state_n = IDLE;
            end
            WAIT: begin //wait for branch/jump to come out
                if (!(|inflight_counter))
                    state_n = IDLE;
                else
                    state_n = WAIT;
            end
            default:
                state_n = IDLE;
        endcase
    end

    // output logic
    always@(*) begin
        ready = 0;

        case (state_p)
            IDLE : ready = fu_buffer_ready && ( ((is_branch) & !valid_in) | !(is_branch) );
            DRAIN: ready = 0;
            FIRE : ready = fu_buffer_ready;
            WAIT : ready = 0;
            default: ready = 0;
        endcase
    end

    assign ready_in = ready;


    // - Below is a counter to track number of instructions currently in execute stage
    // - Not sure, what would be the max value, assuming (2^6 - 1) for now.
    // - Assertions present to catch overflow/underflow
    // - TODO - Optimize counter width to reduce power/area
    reg [INFLIGHT_BITS-1:0] inflight_counter;
    wire [INFLIGHT_BITS-1:0] inflight_counter_n;

    assign inflight_counter_n = inflight_counter + INFLIGHT_BITS'(incr) - INFLIGHT_BITS'(decr); 

    always@(posedge clk) begin
        if (reset)
            inflight_counter <= '0;
        else
            inflight_counter <= inflight_counter_n;
    end

    `RUNTIME_ASSERT( !((incr & !decr) && (inflight_counter == '1)), ("Inflight Counter Overflow"))
    `RUNTIME_ASSERT( !(decr & (inflight_counter == '0)), ("Illegal Counter decrement"))
endmodule
