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

// Developed by Purdue University's SoCET team based on the work by Georgia Tech
// 
// Thread Transfer Unit
// Stalls the warp scheduler until the priority thread transfer is complete.
//
// This unit is part of the tightly coupled SIMT-Scalar core architecture.
// Scalar core (SC) exists alongside a SIMT core. SC executes threads pulled
// from the SIMT core. This unit is present inside SIMT core and services
// the interrupt from SC.
// 
// As soon the interrupt arrives, this unit pauses the next warp scheduling 
// and lets the pipeline drain out any warps that are currenlty being
// executed. After the pipeline is empty, the IRQ handler's PC is scheduled
// next. After the IRQ handler program is done executing, the paused warps
// PC is inserted back and the paused warps are executed again.

`include "VX_define.vh"

module VX_thread_transfer_unit #(
	parameter PAUSE_CYCLES  = 4,
	parameter BIT_WIDTH = $clog2(PAUSE_CYCLES)
) (
	input clk,
	input reset,
	
	output pause
);
	reg [BIT_WIDTH-1:0] counter;

	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1;
		end
	end

	assign pause = &counter;
endmodule
