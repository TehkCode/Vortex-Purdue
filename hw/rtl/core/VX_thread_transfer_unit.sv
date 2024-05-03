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
// March 2024
// 
// Thread Transfer Unit (TTU)
// Controls scheduling to facilitate thread transfer to scalar core.
//
// TTU is part of the tightly coupled SIMT-Scalar core architecture.
// In this arch, a scalar core (SC) exists alongside a SIMT core.
// TTU is present inside SIMT core's scheduler and controls the
// scheduler when interrupt from the SC is received. TTU acts as the 
// backend for Interrupt Controller (IRQC).
// 
// TTU acts based upon the state of IRQC. The major functions of TTU
// are
// 1. Stop warps/thread scheduling after interrupt is recieved.
// 2. Ensures pipeline is drained/clean before transferring the thread.
// 3. Runs interrupt service routine which transfers the thread context
// 4. Updates the thread/warp masks to indicate the transferred thread
//    is inactive.

`include "VX_define.vh"

module VX_thread_transfer_unit import VX_gpu_pkg::*; #(
	parameter THREAD_CNT = `NUM_THREADS,
	parameter WARP_CNT = `NUM_WARPS,
    parameter WARP_CNT_WIDTH = `LOG2UP(WARP_CNT),
	parameter ISSUE_CNT = `MIN(WARP_CNT, 4),
	parameter NUM_ALU_BLOCKS = ISSUE_CNT
) (

	// from scheduler
	input wire no_pending_instr,
	input wire [WARP_CNT-1:0] ipdom_stack_empty,
	input wire [WARP_CNT-1:0] barrier_stalls,
	input wire [WARP_CNT-1:0] active_warps,
	input wire [WARP_CNT-1:0][THREAD_CNT-1:0] thread_masks,
	input wire [WARP_CNT-1:0][`XLEN-1:0] 		warp_pcs,
	input wire [NUM_ALU_BLOCKS-1:0]                  branch_valid,
	input wire [NUM_ALU_BLOCKS-1:0][WARP_CNT_WIDTH-1:0]   branch_wid,
	input wire [NUM_ALU_BLOCKS-1:0]                  branch_taken,
	input wire [NUM_ALU_BLOCKS-1:0][`XLEN-1:0]       branch_dest,
	VX_interrupt_ctl_ttu_if.slave interrupt_ctl_ttu_if,
	
	// to scheduler
	output [WARP_CNT-1:0] paused_warps,
	output [`XLEN-1:0] load_PC,
	output [THREAD_CNT-1:0] load_tmask,
	output [WARP_CNT-1:0] load_wmask,
	output [WARP_CNT_WIDTH-1:0] load_wid,
	output swap_schedule_data,
	output reg [WARP_CNT-1:0][THREAD_CNT-1:0] ttu_tid_mask 
);

	reg pause_scheduling;
	reg jump_valid;
	reg [`XLEN-1:0] jump_PC;
	reg [WARP_CNT-1:0][THREAD_CNT-1:0] pulled_thread_mask;

	// store pulled threads mask
	always_ff @(posedge clk) begin : blockName
        if(reset) begin
            ttu_tid_mask <= '1;
        end
        else begin
            ttu_tid_mask <= ~pulled_thread_mask ;
        end
    end

	always_comb begin
		pulled_thread_mask = ~ttu_tid_mask;

		if (interrupt_ctl_ttu_if.state == IRQC_PC_SWAP) begin
			for (int i=0; i<WARP_CNT; i++) begin
				if (load_wmask[i])
					pulled_thread_mask[i] = pulled_thread_mask[i] | load_tmask;
			end
		end
	end

	// detect a jump to the first instruction of the ISR
	always@(*) begin

		jump_valid = '0;
		jump_PC    = 'x;

	    for (integer i = 0; i < WARP_CNT; ++i) begin
            if (branch_valid[i] && branch_taken[i]) begin
				if ((branch_wid[i] == interrupt_ctl_ttu_if.wid) && (branch_dest[i] == interrupt_ctl_ttu_if.load_PC)) begin
            	    jump_PC = branch_dest[i];
					jump_valid = '1;
                end
            end
        end //for
	
	end //always

	// set interrupt_ctl_ttu_if signals
	always@(*) begin
		case(interrupt_ctl_ttu_if.state)
			IRQC_IDLE: begin
				interrupt_ctl_ttu_if.pipeline_drained = '0;
				interrupt_ctl_ttu_if.thread_found = '0;
				interrupt_ctl_ttu_if.current_thread_mask = 'x; // set to don't care as it helps in synthesis and PD stages
				interrupt_ctl_ttu_if.current_PC = 'x;
				interrupt_ctl_ttu_if.current_active_warps = 'x;
				interrupt_ctl_ttu_if.ISR_done = '0;
			end

			IRQC_WAIT: begin
				// pipeline is drained only after no warps are barriered, ipdom stack
				// is empty and (fetch, decode, issue, execute, commit) stages
				// are empty
				interrupt_ctl_ttu_if.pipeline_drained = no_pending_instr & ~(|barrier_stalls) & (ipdom_stack_empty[interrupt_ctl_ttu_if.wid]);
				interrupt_ctl_ttu_if.thread_found = active_warps[interrupt_ctl_ttu_if.wid] & thread_masks[interrupt_ctl_ttu_if.wid][interrupt_ctl_ttu_if.tid];
				interrupt_ctl_ttu_if.current_thread_mask = thread_masks[interrupt_ctl_ttu_if.wid];
				interrupt_ctl_ttu_if.current_PC = warp_pcs[interrupt_ctl_ttu_if.wid];
				interrupt_ctl_ttu_if.current_active_warps = active_warps;
				interrupt_ctl_ttu_if.ISR_done = '0;	
			end

			IRQC_PC_SWAP: begin
				interrupt_ctl_ttu_if.pipeline_drained = '1;
				interrupt_ctl_ttu_if.thread_found = '1;
				interrupt_ctl_ttu_if.current_thread_mask = 'x; 
				interrupt_ctl_ttu_if.current_PC = 'x;
				interrupt_ctl_ttu_if.current_active_warps = 'x;
				interrupt_ctl_ttu_if.ISR_done = '0;
			end

			IRQC_WAIT_ISR: begin
				interrupt_ctl_ttu_if.pipeline_drained = '1;
				interrupt_ctl_ttu_if.thread_found = '1;
				interrupt_ctl_ttu_if.current_thread_mask = 'x; 
				interrupt_ctl_ttu_if.current_PC = 'x;
				interrupt_ctl_ttu_if.current_active_warps = 'x;
				interrupt_ctl_ttu_if.ISR_done = jump_valid;
				// ISR is done when we encounter a jump instruction that jumps
				// back to the start address of the ISR
			end
			
			IRQC_REVERT_WARP: begin
				interrupt_ctl_ttu_if.pipeline_drained = '1;
				interrupt_ctl_ttu_if.thread_found = '1;
				interrupt_ctl_ttu_if.current_thread_mask = 'x; 
				interrupt_ctl_ttu_if.current_PC = 'x;
				interrupt_ctl_ttu_if.current_active_warps = 'x;
				interrupt_ctl_ttu_if.ISR_done = '1;
			end

			default: begin
				interrupt_ctl_ttu_if.pipeline_drained = '0;
				interrupt_ctl_ttu_if.thread_found = '0;
				interrupt_ctl_ttu_if.current_thread_mask = 'x;
				interrupt_ctl_ttu_if.current_PC = 'x;
				interrupt_ctl_ttu_if.current_active_warps = 'x;
				interrupt_ctl_ttu_if.ISR_done = '0;
			end
		endcase

	end

	// set scheduler control signals
	always@(*) begin
		case(interrupt_ctl_ttu_if.state)
			IRQC_IDLE: begin
				pause_scheduling = '0;
				load_PC = 'x; // set to don't care as it helps in synthesis and PD stages
				load_tmask = 'x;
				load_wmask = '0;
				load_wid   = 'x;
				swap_schedule_data   = '0;
			end

			IRQC_WAIT: begin
				pause_scheduling = ~(|barrier_stalls) & ipdom_stack_empty[interrupt_ctl_ttu_if.wid];
				load_PC = 'x;
				load_tmask = 'x;
				load_wmask = '0;
				load_wid   = 'x;
				swap_schedule_data   = '0;
			end

			IRQC_PC_SWAP: begin
				pause_scheduling = '1;
				load_PC    = interrupt_ctl_ttu_if.load_PC;
				load_tmask = (1'b1 << interrupt_ctl_ttu_if.tid);
				load_wmask = (1'b1 << interrupt_ctl_ttu_if.wid);
				load_wid   = interrupt_ctl_ttu_if.wid;
				swap_schedule_data   = '1;
			end

			IRQC_WAIT_ISR: begin
				pause_scheduling = '0;
				load_PC    = 'x;
				load_tmask = 'x; 
				load_wmask = '0;
				load_wid   = 'x;
				swap_schedule_data   = '0;
			end	

			IRQC_REVERT_WARP: begin
				pause_scheduling = '1; // pause scheduling as we are swapping warp PC
				load_PC    = interrupt_ctl_ttu_if.load_PC;

				// load back old thread mask except the thread that was
				// transfered
				load_tmask = interrupt_ctl_ttu_if.load_tmask & ~( `NUM_THREADS'b1 << interrupt_ctl_ttu_if.tid);

				// load back the old aactive warps. if all threads in the warp
				// are inactive then disable the warp
				load_wmask = (|load_tmask) ? interrupt_ctl_ttu_if.load_wmask
							 : interrupt_ctl_ttu_if.load_wmask & ~( WARP_CNT'(1) << interrupt_ctl_ttu_if.wid);

				load_wid   = interrupt_ctl_ttu_if.wid;
				swap_schedule_data   = '1;
			end	

			default: begin
				pause_scheduling = '0;
				load_PC = 'x;
				load_tmask = 'x;
				load_wmask = 'x;
				load_wid   = 'x;
				swap_schedule_data   = '0;
			end
		endcase

	end

	assign paused_warps = {WARP_CNT{pause_scheduling}};

endmodule
