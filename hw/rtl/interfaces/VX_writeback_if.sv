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

interface VX_writeback_if import VX_gpu_pkg::*; 
#(
    parameter THREAD_CNT = `NUM_THREADS,
    parameter WARP_CNT = `NUM_WARPS,
    parameter ISSUE_CNT = `ISSUE_WIDTH
 );
`IGNORE_WARNINGS_BEGIN
 localparam ISSUE_WIS_W = `LOG2UP(WARP_CNT / ISSUE_CNT);
`IGNORE_WARNINGS_END
    typedef struct packed {
        logic [`UUID_WIDTH-1:0]         uuid;
        logic [ISSUE_WIS_W-1:0]         wis;
        logic [THREAD_CNT-1:0]        tmask;
        logic [`XLEN-1:0]               PC;
        logic [`NR_BITS-1:0]            rd;
        logic [THREAD_CNT-1:0][`XLEN-1:0] data;
        logic                           sop;
        logic                           eop;
    } data_t;

    logic  valid;
    data_t data;

    modport master (
        output valid,
        output data
    );

    modport slave (
        input valid,
        input data
    );

endinterface
