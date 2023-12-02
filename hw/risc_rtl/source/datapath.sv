// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "hazard_unit_if.vh"
`include "forward_unit_if.vh"
`include "pipeline_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
  import pipeline_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  register_file_if rf();
  alu_if alu();
  control_unit_if ctrlunt();
  hazard_unit_if hzrd();
  forward_unit_if fwd();

  control_unit CTRLUNT(ctrlunt);
  register_file RF(CLK, nRST, rf);
  alu ALU(alu);
  hazard_unit HZRD(hzrd);
  forward_unit FWD(fwd);

  if_id if_id_intf ;
  id_ex id_ex_intf ;
  ex_mem ex_mem_intf;
  mem_wr mem_wr_intf;
  
  word_t extended_imm, PC, PC_nxt, PC_incr, sw_fwd_rdat2_id_ex, alu_output_wt_LUI;
  regbits_t ex_mem_dest_reg;
  i_t i_type_ins_ex, i_type_ins_wb;
  s_t s_type_ins_mem;
  logic is_branch_taken, halt_ff;
 
/* FETCH STAGE */
  assign PC_incr = PC + 4;
  assign dpif.imemaddr = PC;
  
/* DECODE STAGE */     
  assign ctrlunt.ins = if_id_intf.ins;
  assign rf.rsel1 = ctrlunt.rs1;
  assign rf.rsel2 = ctrlunt.rs2;

/* EXECUTE STAGE */ 
  assign i_type_ins_ex = id_ex_intf.ins;
  assign alu.aluop = id_ex_intf.ALUOp;
  assign alu_output_wt_LUI = (i_type_ins_ex.opcode == LUI)? {i_type_ins_ex.imm,16'h0000} : 
                             (i_type_ins_ex.opcode == AUIPC)? id_ex_intf.PC + {i_type_ins_ex.imm,16'h0000} : alu.output_port; // to forward this needs to be calculated now

  //ALU I/P MUX for forwarded signals
  always_comb
  begin
    if(fwd.Forward_A == 2'b01) alu.port_A = rf.wdat;
    else if(fwd.Forward_A == 2'b10) alu.port_A = ex_mem_intf.alu_output;
    else alu.port_A = id_ex_intf.rdat1;

    if(fwd.Forward_B == 2'b01) alu.port_B = rf.wdat ;
    else if(fwd.Forward_B == 2'b10) alu.port_B = ex_mem_intf.alu_output;
    else alu.port_B = (id_ex_intf.ALUSrc)? id_ex_intf.imm : id_ex_intf.rdat2;

    if(id_ex_intf.MemWr && fwd.Forward_B == 2'b01) sw_fwd_rdat2_id_ex = rf.wdat;
    else if(id_ex_intf.MemWr && fwd.Forward_B == 2'b10) sw_fwd_rdat2_id_ex = ex_mem_intf.alu_output;
    else if(mem_wr_intf.RegWr && fwd.Forward_B == 2'b01) sw_fwd_rdat2_id_ex = alu.port_B;
    else sw_fwd_rdat2_id_ex = id_ex_intf.rdat2; 
  end

/* MEMORY ACCESS STAGE*/
  assign dpif.dmemstore = ex_mem_intf.rdat2;
  assign dpif.dmemaddr = ex_mem_intf.alu_output;
  assign dpif.imemREN = '1;
  assign dpif.dmemREN = ex_mem_intf.dmemREN;
  assign dpif.dmemWEN = ex_mem_intf.MemWr;
  
//BRANCH RESOLUTION
  assign s_type_ins_mem = ex_mem_intf.ins;
  
  always_comb
  begin 
  casez (s_type_ins_mem.opcode)
    BEQ: if(ex_mem_intf.alu_zero == 1'b1) {PC_nxt, is_branch_taken} = {ex_mem_intf.extended_imm << 1 + ex_mem_intf.PC, 1'b1};
    BNE: if(ex_mem_intf.alu_zero == 1'b0) {PC_nxt, is_branch_taken} = {ex_mem_intf.extended_imm << 1 + ex_mem_intf.PC, 1'b1};
    BLT: if(ex_mem_intf.alu_zero == 1'b0) {PC_nxt, is_branch_taken} = {ex_mem_intf.extended_imm << 1 + ex_mem_intf.PC, 1'b1};
    BGE: if(ex_mem_intf.alu_zero == 1'b1) {PC_nxt, is_branch_taken} = {ex_mem_intf.extended_imm << 1 + ex_mem_intf.PC, 1'b1};
    JAL: {PC_nxt, is_branch_taken} = {ex_mem_intf.extended_imm << 1 + ex_mem_intf.PC, 1'b1};
    JALR: {PC_nxt, is_branch_taken} = {ex_mem_intf.alu_output, 1'b1};
    default: {PC_nxt, is_branch_taken} = {PC_incr, 1'b0};
  endcase
  end

/* REGISTER WRITEBACK STAGE */
  assign i_type_ins_wb = mem_wr_intf.ins; 
  assign rf.wsel  = mem_wr_intf.rd;
  assign rf.WEN   = mem_wr_intf.RegWr;// && ( dpif.ihit || dpif.dhit); //or else fails for JAL without pipeline
  assign rf.wdat  = (i_type_ins_wb.opcode == JAL || i_type_ins_wb.opcode == JALR)? mem_wr_intf.PC+4: 
                    (mem_wr_intf.MemtoReg? mem_wr_intf.dmemload : mem_wr_intf.alu_output);

//FORWARDING
  assign fwd.ex_mem_dest_reg = ex_mem_intf.rd;
  assign fwd.id_ex_rs1 = id_ex_intf.rs1; 
  assign fwd.id_ex_rs2 = id_ex_intf.rs2; 
  assign fwd.mem_wr_dest_reg = mem_wr_intf.rd;
  assign fwd.ex_mem_RegWr = ex_mem_intf.RegWr;
  assign fwd.mem_wr_RegWr = mem_wr_intf.RegWr;

//HAZARD
  assign hzrd.is_branch_taken = is_branch_taken;
  assign hzrd.dhit = dpif.dhit;
  assign hzrd.ihit = dpif.ihit;
  assign hzrd.ex_mem_dmemREN = ex_mem_intf.dmemREN;
  assign hzrd.ex_mem_dest_reg = ex_mem_dest_reg;
  assign hzrd.id_ex_rs1 = id_ex_intf.rs1;
  assign hzrd.id_ex_rs2 = id_ex_intf.rs2;
  assign hzrd.ex_mem_halt = ex_mem_intf.halt;

//HALT
assign dpif.halt = halt_ff;

//PC_LATCH
always_ff @(posedge CLK or negedge nRST)
begin
  if(!nRST) PC <= PC_INIT;
  else if(dpif.ihit && !hzrd.stall && !halt_ff) PC <= PC_nxt;
end

//PIPELINE LATCHES
always_ff @(posedge CLK or negedge nRST)
begin
  if(!nRST)
  begin 
    if_id_intf    <=   '0;
    id_ex_intf    <=   '0;
    ex_mem_intf   <=   '0;
    mem_wr_intf   <=   '0;
    halt_ff       <=   '0;
  end
  else 
  begin
    if(ex_mem_intf.halt == 1'b1) halt_ff  <=  1'b1;
    if (hzrd.flush || halt_ff) 
    begin
      if_id_intf <= '0;
      id_ex_intf <= '0;
      ex_mem_intf <= '0; 
    end
    else if(dpif.ihit)
    begin
      if_id_intf.PC_nxt  <=  PC_incr; //assume branch not taken or no branch ins
      if_id_intf.PC      <=  PC; 
      if_id_intf.ins     <=  dpif.imemload;
    
      id_ex_intf.imm         <=   ctrlunt.imm;
      id_ex_intf.RegWr       <=   ctrlunt.RegWr;
      id_ex_intf.ALUSrc      <=   ctrlunt.ALUSrc;
      id_ex_intf.MemWr       <=   ctrlunt.MemWr;
      id_ex_intf.MemtoReg    <=   ctrlunt.MemtoReg;
      id_ex_intf.dmemREN     <=   ctrlunt.dmemREN;
      id_ex_intf.halt        <=   ctrlunt.halt;
      id_ex_intf.rs1         <=   ctrlunt.rs1;
      id_ex_intf.rs2         <=   ctrlunt.rs2;
      id_ex_intf.rd          <=   ctrlunt.rd;
      id_ex_intf.ALUOp       <=   ctrlunt.ALUOp;
      id_ex_intf.rdat1       <=   rf.rdat1;
      id_ex_intf.rdat2       <=   rf.rdat2;
      id_ex_intf.ins         <=   if_id_intf.ins;
      id_ex_intf.PC_nxt      <=   if_id_intf.PC_nxt;
      id_ex_intf.PC          <=   if_id_intf.PC;

      ex_mem_intf.RegWr         <=   id_ex_intf.RegWr;
      ex_mem_intf.MemWr         <=   id_ex_intf.MemWr;
      ex_mem_intf.MemtoReg      <=   id_ex_intf.MemtoReg;
      ex_mem_intf.dmemREN       <=   id_ex_intf.dmemREN;
      ex_mem_intf.halt          <=   id_ex_intf.halt;
      ex_mem_intf.alu_zero      <=   alu.zero;
      ex_mem_intf.rs1           <=   id_ex_intf.rs1;
      ex_mem_intf.rs2           <=   id_ex_intf.rs2;
      ex_mem_intf.rd            <=   id_ex_intf.rd;
      ex_mem_intf.extended_imm  <=   id_ex_intf.imm ;
      ex_mem_intf.rdat1         <=   id_ex_intf.rdat1;
      ex_mem_intf.rdat2         <=   sw_fwd_rdat2_id_ex;
      ex_mem_intf.alu_output    <=   alu_output_wt_LUI;
      ex_mem_intf.ins           <=   id_ex_intf.ins;
      ex_mem_intf.PC_nxt        <=   id_ex_intf.PC_nxt;
      ex_mem_intf.PC            <=   id_ex_intf.PC;
    end
    else if(dpif.dhit) 
    begin
      //update the forwarded value when stalled
      id_ex_intf.rdat1  <=   alu.port_A; 
      id_ex_intf.rdat2  <=   sw_fwd_rdat2_id_ex;

      // deassert dmemREN/WEN when dhit is 1, place a Nop instead which helps for load/store hazard
      ex_mem_intf       <=   '0;
    end

    if(dpif.ihit | dpif.dhit)
    begin
      mem_wr_intf.RegWr      <=   ex_mem_intf.RegWr;
      mem_wr_intf.MemtoReg   <=   ex_mem_intf.MemtoReg;
      mem_wr_intf.rs1         <=   ex_mem_intf.rs1;
      mem_wr_intf.rs2         <=   ex_mem_intf.rs2;
      mem_wr_intf.rd          <=   ex_mem_intf.rd;
      mem_wr_intf.halt       <=   ex_mem_intf.halt;
      mem_wr_intf.dmemload   <=   dpif.dmemload;
      mem_wr_intf.alu_output <=   ex_mem_intf.alu_output;
      mem_wr_intf.ins        <=   ex_mem_intf.ins;
      mem_wr_intf.PC_nxt     <=   ex_mem_intf.PC_nxt;  
      mem_wr_intf.PC         <=   ex_mem_intf.PC;
    end
  end
end

endmodule