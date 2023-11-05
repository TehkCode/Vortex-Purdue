`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forward_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic[1:0]     Forward_A, Forward_B;
  logic       ex_mem_RegWr, mem_wr_RegWr;
  regbits_t   ex_mem_dest_reg, id_ex_rs2, id_ex_rs1, mem_wr_dest_reg; 

  modport fwd (
    input   ex_mem_dest_reg, id_ex_rs1, id_ex_rs2, mem_wr_dest_reg, ex_mem_RegWr, mem_wr_RegWr,
    output  Forward_A, Forward_B
  );
endinterface

`endif //FORWARD_UNIT_IF_VH
