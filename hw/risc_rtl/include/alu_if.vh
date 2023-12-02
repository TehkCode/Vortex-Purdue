/*
  alu interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  logic     negative, overflow, zero;
  word_t    port_A, port_B, output_port;
  aluop_t   aluop; 

  // alu ports
  modport alu (
    input   port_A, port_B, aluop,
    output  output_port, negative, overflow, zero
  );
  // alu tb
  modport tb (
    input   output_port, negative, overflow, zero,
    output  port_A, port_B, aluop
  );
endinterface

`endif //ALU_IF_VH
