`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module control_unit (
  control_unit_if.ctrlunt ctrlunt
);
 
logic [11:0] alu_imm;

r_t r_ins; 
i_t i_ins; 
s_t s_ins; 
u_t u_ins; 

logic [11:0] s_imm   ;
logic [12:0] b_imm   ;
logic [20:0] jal_imm ;

assign i_ins = i_t'(ctrlunt.ins);
assign r_ins = r_t'(ctrlunt.ins);
assign s_ins = s_t'(ctrlunt.ins);
assign u_ins = u_t'(ctrlunt.ins);

assign s_imm   = {s_ins.imm_1, s_ins.imm_0};
assign b_imm   = {ctrlunt.ins[31], ctrlunt.ins[7], ctrlunt.ins[30:25], ctrlunt.ins[11:8], 1'b0};
assign jal_imm = {ctrlunt.ins[31], ctrlunt.ins[19:12], ctrlunt.ins[20], ctrlunt.ins[30:21], 1'b0};

always_comb 
begin


ctrlunt.RegWr = 1'b1;
ctrlunt.ALUSrc = 1'b0;
ctrlunt.MemWr = 1'b0;
ctrlunt.MemtoReg = 1'b0;
ctrlunt.rs1 = 5'b0;
ctrlunt.rs2 = 5'b0;
ctrlunt.rd  = 5'b0;
ctrlunt.ALUOp = ALU_ADD;
ctrlunt.PCSrc = 1'b0;
ctrlunt.dmemREN = 1'b0;
ctrlunt.imemREN = 1'b1;
ctrlunt.halt = 1'b0;
ctrlunt.imm = 32'b0;

casez (r_ins.opcode)

RTYPE:
begin
  ctrlunt.rs1 = r_ins.rs1;
  ctrlunt.rs2 = r_ins.rs2;
  ctrlunt.rd = r_ins.rd;

  casez (r_ins.funct3)
    ADD: ctrlunt.ALUOp = (r_ins.funct7[5]) ? ALU_SUB : ALU_ADD; 
    XOR: ctrlunt.ALUOp = ALU_XOR;
    OR : ctrlunt.ALUOp = ALU_OR; 
    AND: ctrlunt.ALUOp = ALU_AND;
    SLL: ctrlunt.ALUOp = ALU_SLL;
    SRL:  ctrlunt.ALUOp = (r_ins.funct7[5]) ? ALU_SRA : ALU_SRL;
    SLT: ctrlunt.ALUOp = ALU_SLT;
    default: ctrlunt.ALUOp = ALU_ADD;
  endcase
end

ITYPE:
begin
  ctrlunt.ALUSrc = 1'b1;
  ctrlunt.rs1 = i_ins.rs1;
  ctrlunt.rd  = i_ins.rd;

  alu_imm   = (i_ins.funct3[0] && ~i_ins.funct3[1]) ? {{7{1'b0}}, r_ins.rs2} : i_ins.imm;
  ctrlunt.imm  = {{20{alu_imm[11]}}, alu_imm};

  casez (i_ins.funct3)
    ADD: ctrlunt.ALUOp = ALU_ADD; 
    XOR: { ctrlunt.ALUOp, ctrlunt.imm } = { ALU_XOR, {20'(0), alu_imm} };
    OR : { ctrlunt.ALUOp, ctrlunt.imm } = { ALU_OR , {20'(0), alu_imm} };
    AND: { ctrlunt.ALUOp, ctrlunt.imm } = { ALU_AND, {20'(0), alu_imm} };
    SLL: ctrlunt.ALUOp = ALU_SLL;
    SRL:  ctrlunt.ALUOp = (r_ins.funct7[5]) ? ALU_SRA : ALU_SRL;
    default: ctrlunt.ALUOp = ALU_ADD;
  endcase
end

LW    :
begin
  ctrlunt.rs1 = i_ins.rs1;
  ctrlunt.rd  = i_ins.rd;

  ctrlunt.ALUSrc = 1'b1;
  ctrlunt.ALUOp = ALU_ADD;
  ctrlunt.MemtoReg = 1'b1;
  ctrlunt.dmemREN = 1'b1;
  ctrlunt.imm  = {{20{i_ins.imm[11]}}, i_ins.imm};
end

SW    :
begin
  ctrlunt.rs1 = s_ins.rs1;
  ctrlunt.rs2 = s_ins.rs2;

  ctrlunt.ALUSrc = 1'b1;
  ctrlunt.ALUOp = ALU_ADD;
  ctrlunt.RegWr = 1'b0;
  ctrlunt.MemWr = 1'b1;
  ctrlunt.imm  = {{20{s_imm[11]}}, s_imm};
end

SBTYPE:
begin
  ctrlunt.ALUSrc = 1'b0;
  ctrlunt.rs1 = s_ins.rs1;
  ctrlunt.rs2 = s_ins.rs2;
  ctrlunt.imm = {{19{b_imm[12]}}, b_imm};
  ctrlunt.PCSrc = 1'b1;
  ctrlunt.RegWr = 1'b0;

  casez (b_funct3_t'(s_ins.funct3))
    BEQ: ctrlunt.ALUOp = ALU_SUB;
    BNE: ctrlunt.ALUOp = ALU_SUB; 
    BLT: ctrlunt.ALUOp = ALU_SLT;
    BGE: ctrlunt.ALUOp = ALU_SLT;
  endcase
end

JAL:
begin
  ctrlunt.PCSrc = 1'b1;
  ctrlunt.rd = u_ins.rd;
  ctrlunt.imm  = {{11{jal_imm[20]}}, jal_imm};
end

JALR:
begin
  ctrlunt.PCSrc = 1'b1;
  ctrlunt.rd = i_ins.rd;
  ctrlunt.rs1 = i_ins.rs1;
  ctrlunt.imm  = {{20{i_ins.imm[11]}}, i_ins.imm};
  ctrlunt.ALUOp = ALU_ADD;
  ctrlunt.ALUSrc = 1'b1;

end

LUI:
begin
  ctrlunt.rd = u_ins.rd;
  ctrlunt.ALUSrc = 1'b1;
  ctrlunt.imm  = {u_ins.imm, 12'(0)};
end

AUIPC:
begin
  ctrlunt.rd = u_ins.rd;
  ctrlunt.ALUSrc = 1'b1;
  ctrlunt.imm  = {u_ins.imm, 12'(0)};
end

HALT: 
begin
  ctrlunt.RegWr = 1'b0;
  ctrlunt.halt = 1'b1;
end

// CSR:
endcase
end

endmodule