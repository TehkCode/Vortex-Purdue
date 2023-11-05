

`include "register_file_if.vh"
// `include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

module register_file (
  input logic CLK, nRST,
  register_file_if.rf rfif
);

word_t register_bank[31:0];

assign rfif.rdat1 = register_bank[rfif.rsel1];
assign rfif.rdat2 = register_bank[rfif.rsel2];

always_ff @(negedge CLK, negedge nRST)
begin
  if (!nRST)
  begin
    register_bank <='{default:'0};
  end
  else if(rfif.WEN )
  begin
    if(rfif.wsel == '0) register_bank[rfif.wsel] <= '0;
    else register_bank[rfif.wsel] <= rfif.wdat;
  end
end

endmodule