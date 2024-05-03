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

module VX_execute_scalar import VX_gpu_pkg::*; #(
    parameter CORE_ID = 0,
    parameter THREAD_CNT = `NUM_THREADS,
    parameter WARP_CNT = `NUM_WARPS,
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
    VX_commit_scalar_if.master     fpu_commit_if [ISSUE_CNT],
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
    VX_commit_scalar_if.master     alu_commit_if [ISSUE_CNT],
    VX_branch_ctl_if.master branch_ctl_if [NUM_ALU_BLOCKS],
    
    VX_dispatch_if.slave    lsu_dispatch_if [ISSUE_CNT],  
    VX_commit_scalar_if.master     lsu_commit_if [ISSUE_CNT],
    
    VX_dispatch_if.slave    sfu_dispatch_if [ISSUE_CNT], 
    VX_commit_scalar_if.master     sfu_commit_if [ISSUE_CNT],
    VX_warp_ctl_if.master   warp_ctl_if,
    VX_sfu_csr_if.master    hw_itr_ctrl_if,
    VX_execute_hw_itr_if.slave execute_hw_itr_if,

    // flush mispredicts
    output [ISSUE_CNT-1:0] branch_mispredict_flush,

    // simulation helper signals
    output wire             sim_ebreak
);
    localparam NUM_FPU_BLOCKS = `UP(ISSUE_CNT / 1);

`ifdef EXT_F_ENABLE
    VX_fpu_to_csr_if #(.WARP_CNT(WARP_CNT)) fpu_to_csr_if[NUM_FPU_BLOCKS]();
`endif

    `RESET_RELAY (alu_reset, reset);
    `RESET_RELAY (lsu_reset, reset);
    `RESET_RELAY (sfu_reset, reset);

    VX_branch_ctl_if #(.WARP_CNT(WARP_CNT)) branch_ctl_tmp_if[NUM_ALU_BLOCKS]();
    
    VX_alu_unit_scalar #(
        .CORE_ID (CORE_ID),
        .THREAD_CNT(THREAD_CNT),
        .WARP_CNT(WARP_CNT),
        .ISSUE_CNT(ISSUE_CNT)
    ) alu_unit (
        .clk            (clk),
        .reset          (alu_reset),
        .dispatch_if    (alu_dispatch_if),
        .branch_ctl_if  (branch_ctl_tmp_if),
        .commit_if      (alu_commit_if)
    );

    `SCOPE_IO_SWITCH (1)

    VX_lsu_unit_scalar #(
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

    VX_fpu_unit_scalar #(
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

    VX_sfu_unit_scalar #(
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

    // Overload WSPAWN
    // 1. check for WSPAWN and PC to be 0.
    // 2. start the counter
    // 3. wait for counter to be 2
    // 4. Check for rd to be 0 from sfu
    // 5. send the PC+4
    logic [1:0] time_elapsed_since_wspawn, time_elapsed_since_wspawn_n;

    always @(posedge clk) begin
        if (reset)
            time_elapsed_since_wspawn <= 0;
        else
            time_elapsed_since_wspawn <= time_elapsed_since_wspawn_n;
    end

    always @(*) begin
        if (warp_ctl_if.valid && warp_ctl_if.wspawn.valid && (warp_ctl_if.wspawn.pc == '0) && !(|warp_ctl_if.wspawn.wmask))
            time_elapsed_since_wspawn_n = 1;
        else if ((time_elapsed_since_wspawn == 2'd2) && sfu_commit_if[0].valid && sfu_commit_if[0].ready)
            time_elapsed_since_wspawn_n = 0;
        else  if (time_elapsed_since_wspawn == 2'd2)
            time_elapsed_since_wspawn_n = time_elapsed_since_wspawn;
        else
            time_elapsed_since_wspawn_n = time_elapsed_since_wspawn + 1;
    end

    assign execute_hw_itr_if.WspawnPCplus4 = sfu_commit_if[0].data.PC + 4;
    assign execute_hw_itr_if.writeWspawnPCplus4 = ((time_elapsed_since_wspawn == 2'd2) && sfu_commit_if[0].valid && sfu_commit_if[0].ready);

    // Overload Jump to 0
    logic overload_JUMP[NUM_ALU_BLOCKS-1:0];

    for (genvar i = 0; i < ISSUE_CNT; ++i) begin    
        assign overload_JUMP[i] = branch_ctl_tmp_if[i].valid & branch_ctl_tmp_if[i].taken & (branch_ctl_tmp_if[i].dest == 0);
        assign branch_ctl_if[i].valid = branch_ctl_tmp_if[i].valid;
        assign branch_ctl_if[i].taken = branch_ctl_tmp_if[i].taken;
        assign branch_ctl_if[i].wid = branch_ctl_tmp_if[i].wid;
        assign branch_ctl_if[i].dest = overload_JUMP[i] ? execute_hw_itr_if.IPC : branch_ctl_tmp_if[i].dest;
    end

    assign execute_hw_itr_if.RAS      = alu_commit_if[0].data.PC + 4;
    assign execute_hw_itr_if.writeRAS = overload_JUMP[0];


    // flush operation
    // flush only when branch taken or thread mask is set to 0
    for (genvar i = 0; i < ISSUE_CNT; ++i) begin    
        assign branch_mispredict_flush[i] = (branch_ctl_if[i].valid & branch_ctl_if[i].taken) 
            | (warp_ctl_if.valid & warp_ctl_if.tmc.valid & !(|warp_ctl_if.tmc.tmask[THREAD_CNT-1:0]));
    end


    // simulation helper signal to get RISC-V tests Pass/Fail status
    assign sim_ebreak = alu_dispatch_if[0].valid && alu_dispatch_if[0].ready 
                     && alu_dispatch_if[0].data.wis == 0
                     && `INST_ALU_IS_BR(alu_dispatch_if[0].data.op_mod)
                     && (`INST_BR_BITS'(alu_dispatch_if[0].data.op_type) == `INST_BR_EBREAK
                      || `INST_BR_BITS'(alu_dispatch_if[0].data.op_type) == `INST_BR_ECALL);

endmodule
