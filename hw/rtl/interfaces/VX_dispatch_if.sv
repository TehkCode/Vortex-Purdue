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

interface VX_dispatch_if import VX_gpu_pkg::*; #(parameter THREAD_CNT = `NUM_THREADS)();
    // NEED TO TAKE ONE GIANT LOOK AT THE DISPATCH UNIT. 
    // warning: this layout should not be modified without updating VX_dispatch_unit!!!
    typedef struct packed {
        logic [`UUID_WIDTH-1:0]             uuid;
        logic [ISSUE_WIS_W-1:0]             wis;
        logic [THREAD_CNT-1:0]            tmask;
        logic [`INST_ALU_BITS-1:0]          op_type;
        logic [`INST_MOD_BITS-1:0]          op_mod;
        logic                               wb;
        logic                               use_PC;
        logic                               use_imm;
        logic [`XLEN-1:0]                   PC;
        logic [`XLEN-1:0]                   imm;
        logic [`NR_BITS-1:0]                rd;
        logic [`NT_WIDTH-1:0]               tid;
        logic [THREAD_CNT-1:0][`XLEN-1:0] rs1_data;
        logic [THREAD_CNT-1:0][`XLEN-1:0] rs2_data;
        logic [THREAD_CNT-1:0][`XLEN-1:0] rs3_data;
    } data_t;

    logic  valid;
    data_t data;
    logic  ready;

    modport master (
        output valid,
        output data,
        input  ready
    );

    modport slave (
        input  valid,
        input  data,
        output ready
    );

endinterface
