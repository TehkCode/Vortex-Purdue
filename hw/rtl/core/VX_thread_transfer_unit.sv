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
// 
// Thread Transfer Unit
// Stalls the warp scheduler until the priority thread transfer is complete.
//
// This unit is part of the tightly coupled SIMT-Scalar core architecture.
// Scalar core (SC) exists alongside a SIMT core. SC executes threads pulled
// from the SIMT core. TTU is present inside SIMT core's scheduler and
// controls the scheduler when interrupt from the SC is received.
// 
// TTU is controlled by the interrupt controller (IC) . As soon the
// interruptcarrives, IC goes out of IDLE and TTU gets into action. TTU
// pauses the next warp beinh scheduled and lets the pipeline drain out any
// warps that are currenlty being executed. After the pipeline is empty, the
// IRQ handler's PC is scheduled next. After the IRQ handler program is done
// executing, the paused warps PC is inserted back and the paused warps are
// executed again.


`include "VX_define.vh"

module VX_thread_transfer_unit #(
	parameter TEST_MODE = 0,
	parameter PAUSE_CYCLES  = 1022,
	parameter BIT_WIDTH = $clog2(PAUSE_CYCLES)
) (
	input wire clk,
	input wire reset,

	// from interrupt controller
	VX_interrupt_ctl.ttu_slave interrupt_ctl_if,

	// from scheduler
	input wire no_pending_instructions,
	input wire [`NUM_WARPS-1:0] warp_ipdom_stack_empty,
	input wire [`NUM_WARPS-1:0] barriered_warps,
	
	// to scheduler
	output pause_scheduling
);

	always@(*) begin
		case(state)
			IDLE: begin
				pause_scheduling = '0;
				interrupt_ctl_if.pipeline_drained = '0;
				interrupt_ctl_if.thread_found = '0;
				interrupt_ctl_if.current_thread_mask = 'x;
				interrupt_ctl_if.current_PC = 'x;
				interrupt_ctl_if.ISR_done = '0;
			end

			WAIT: begin

			end

			default: begin
				pause_scheduling = '0;
				interrupt_ctl_if.pipeline_drained = '0;
				interrupt_ctl_if.thread_found = '0;
				interrupt_ctl_if.current_thread_mask = 'x;
				interrupt_ctl_if.current_PC = 'x;
				interrupt_ctl_if.ISR_done = '0;
			end
		endcase
	end
/*
reg [BIT_WIDTH-1:0] counter;
	reg op;
	reg [1:0] c;

	always @(posedge clk) begin
		if (reset) begin
			op <= 1;
		end
		else begin
          op <= (&c) ? op : ( counter == ({BIT_WIDTH{1'b1}}) ) ? ~op : op;
		end
	end

	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1;
		end
	end

  always @(posedge clk) begin
		if (reset) begin
			c <= 0;
		end
        else begin
			if (&c)
				c <= c;
			else
              c <= c + (op & (&counter) ? 1 : 0);
		end
	end

	assign pause_scheduling = ~(&c) ? op : 0;
	*/
endmodule
