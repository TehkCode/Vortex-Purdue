`ifndef PIPELINE_PKG_VH
`define PIPELINE_PKG_VH

`include "cpu_types_pkg.vh"

package pipeline_pkg;
  
  import cpu_types_pkg::*;
  
  typedef struct packed {
    word_t    ins;
    word_t    PC_nxt;
    word_t    PC; 
  } if_id;

  typedef struct packed {
    word_t      imm;
    logic       RegWr;
    logic       MemWr;
    logic       MemtoReg;
    logic       dmemREN;
    logic       halt;
    logic       ALUSrc;
    regbits_t   rs1;
    regbits_t   rs2;
    regbits_t   rd;
    aluop_t     ALUOp;
    word_t      rdat1;
    word_t      rdat2;
    word_t      ins;
    word_t      PC_nxt;
    word_t      PC;
  } id_ex;
  
  typedef struct packed {
    logic       RegWr;
    logic       MemWr;
    logic       MemtoReg;
    logic       dmemREN;
    logic       halt;
    logic       alu_zero; 
    regbits_t   rs1;
    regbits_t   rs2;
    regbits_t   rd;
    word_t      extended_imm; 
    word_t      rdat1; 
    word_t      rdat2;
    word_t      alu_output;
    word_t      ins;
    word_t      PC_nxt;
    word_t      PC;
  } ex_mem;

  typedef struct packed {
    logic       RegWr;
    logic       MemtoReg;
    logic       halt;
    regbits_t   rs1;
    regbits_t   rs2;
    regbits_t   rd;
    word_t      dmemload;
    word_t      alu_output;
    word_t      ins;
    word_t      PC_nxt;
    word_t      PC;
  } mem_wr;
  

endpackage
`endif //PIPELINE_PKG_VH
