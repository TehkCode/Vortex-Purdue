`include "forward_unit_if.vh"

module forward_unit (forward_unit_if.fwd fwd);
import cpu_types_pkg::*;

always_comb 
begin 
  fwd.Forward_A = 2'b00;
  fwd.Forward_B = 2'b00; 
  
  if(fwd.ex_mem_RegWr && fwd.ex_mem_dest_reg != '0 &&  fwd.ex_mem_dest_reg == fwd.id_ex_rs1) fwd.Forward_A = 2'b10;
  else if(fwd.mem_wr_RegWr && fwd.mem_wr_dest_reg != '0 &&  fwd.mem_wr_dest_reg == fwd.id_ex_rs2) fwd.Forward_A = 2'b01;

  if(fwd.ex_mem_RegWr && fwd.ex_mem_dest_reg != '0 &&  fwd.ex_mem_dest_reg == fwd.id_ex_rs2) fwd.Forward_B = 2'b10;  
  else if (fwd.mem_wr_RegWr && fwd.mem_wr_dest_reg != '0 &&  fwd.mem_wr_dest_reg == fwd.id_ex_rs2) fwd.Forward_B = 2'b01;
end
endmodule