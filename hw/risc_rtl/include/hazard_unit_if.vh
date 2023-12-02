`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic     is_branch_taken, flush, stall, dhit, ihit, ex_mem_halt, ex_mem_dmemREN;
  regbits_t ex_mem_dest_reg, id_ex_rs1, id_ex_rs2;

  modport hzrd (
    input   is_branch_taken, dhit, ihit, ex_mem_halt, ex_mem_dmemREN, ex_mem_dest_reg, id_ex_rs1, id_ex_rs2,
    output  flush, stall
  );
  
endinterface

`endif //HAZARD_UNIT_IF_VH
