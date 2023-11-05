
`include "alu_if.vh"

import cpu_types_pkg::*;

module alu (alu_if.alu alu_if);

assign alu_if.negative = (alu_if.output_port[31] == 1'b1);
assign alu_if.zero = (alu_if.output_port == '0);

always_comb
begin
    alu_if.overflow = 1'b0;
    alu_if.output_port = 32'd0;
    
    casez (alu_if.aluop)
        ALU_SLL  : alu_if.output_port = alu_if.port_A << alu_if.port_B[4:0];
        ALU_SRL  : alu_if.output_port = alu_if.port_A >> alu_if.port_B[4:0];
        ALU_ADD  : 
            begin
                alu_if.output_port = $signed(alu_if.port_A) + $signed(alu_if.port_B);  
                alu_if.overflow = (alu_if.port_A[31] == alu_if.port_B[31]) && (alu_if.port_A[31] != alu_if.output_port[31]);   
            end
        ALU_SUB  : 
            begin
                alu_if.output_port = $signed(alu_if.port_A) - $signed(alu_if.port_B);  
                alu_if.overflow = (alu_if.port_A[31] != alu_if.port_B[31]) && (alu_if.port_A[31] != alu_if.output_port[31]);   
            end
        ALU_AND  : alu_if.output_port = alu_if.port_A & alu_if.port_B;
        ALU_OR   : alu_if.output_port = alu_if.port_A | alu_if.port_B;
        ALU_XOR  : alu_if.output_port = alu_if.port_A ^ alu_if.port_B;
        ALU_NOR  : alu_if.output_port = ~(alu_if.port_A | alu_if.port_B);
        ALU_SLT  : alu_if.output_port = $signed(alu_if.port_A) < $signed(alu_if.port_B);
        ALU_SLTU : alu_if.output_port = alu_if.port_A < alu_if.port_B;
        ALU_SRA  : alu_if.output_port = $signed(alu_if.port_A) >>> alu_if.port_B[4:0];
        default  :  alu_if.output_port = 32'd0;
    endcase
end

endmodule