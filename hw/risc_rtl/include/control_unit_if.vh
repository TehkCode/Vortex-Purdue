`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic     RegWr, ALUSrc, MemWr, MemtoReg, PCSrc, dmemREN, imemREN, halt;
  regbits_t rs1, rs2, rd;
  word_t    ins, imm;
  aluop_t   ALUOp;
  
  // control_unit ports
  modport ctrlunt (
    input   ins,
    output  imm, RegWr, ALUSrc, MemWr, MemtoReg, rs1, rs2, rd, ALUOp, PCSrc, dmemREN, imemREN, halt
  );
  
endinterface

`endif //CONTROL_UNIT_IF_VH
