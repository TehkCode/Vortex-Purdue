`include "hazard_unit_if.vh"

module hazard_unit (hazard_unit_if.hzrd hzrd);
import cpu_types_pkg::*;

always_comb begin
 
hzrd.flush = 1'b0;
hzrd.stall = 1'b0;

if(hzrd.ihit && hzrd.is_branch_taken) hzrd.flush = 1'b1;
else if (hzrd.ex_mem_halt) hzrd.flush = 1'b1;
else hzrd.flush = 1'b0;

if(!hzrd.dhit && hzrd.ex_mem_dmemREN && (hzrd.ex_mem_dest_reg == hzrd.id_ex_rs1 || hzrd.ex_mem_dest_reg == hzrd.id_ex_rs2))
begin
  hzrd.stall = 1'b1;
end
else 
begin
  hzrd.stall = 1'b0;
end

//always nop is added when dhit is 1 and stalled untill ihit is recieved => takes care of load hazard | therefore always stall = 1'b0

end
endmodule