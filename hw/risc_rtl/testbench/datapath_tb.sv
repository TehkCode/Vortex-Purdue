/*
  datapath test bench
*/

// mapped needs this
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module datapath_tb; 

  parameter PERIOD = 10;
  logic CLK = 0, nRST;
  // clock
  always #(PERIOD/2) CLK++;
 
  // interface
  datapath_cache_if dpif();
  // test program
  test PROG (CLK, nRST, dpif);
  
  // DUT
`ifndef MAPPED
  datapath DUT(CLK, nRST, dpif);
`else
  datapath DUT(
    .\dpif.ihit  (dpif.ihit),
    .\dpif.imemload (dpif.imemload),
    .\dpif.dhit (dpif.dhit),
    .\dpif.dmemload  (dpif.dmemload),
    .\dpif.halt (dpif.halt),
    .\dpif.imemREN (dpif.imemREN),
    .\dpif.imemaddr (dpif.imemaddr),
    .\dpif.dmemREN (dpif.dmemREN),
    .\dpif.dmemWEN (dpif.dmemWEN),
    .\dpif.datomic (dpif.datomic),
    .\dpif.dmemstore (dpif.dmemstore),
    .\dpif.dmemaddr (dpif.dmemaddr),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

// input   ihit, imemload, dhit, dmemload,
// output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic, dmemstore, dmemaddr

program test(input logic CLK, input logic nRST, datapath_cache_if dpif);

parameter PERIOD = 10; 
r_t r_type_ins;

initial begin

// nRST = '0;
// #PERIOD;
// nRST = '1;

// SLL
r_type_ins.opcode = RTYPE;
r_type_ins.rs = 1;
r_type_ins.rt = 2;
r_type_ins.rd = 3;
r_type_ins.shamt = '0;
r_type_ins.funct = SLLV; 

dpif.imemload = r_type_ins;
dpif.dmemload = '0;

dpif.ihit = 1'b1;
dpif.dhit = 1'b1;

#PERIOD;

$display("SLL : Ins: %x",dpif.imemload);
display_stats();

$finish;
end

function void display_stats();
  $display("halt: %d | imemREN: %b | imemaddr: %x ", dpif.halt, dpif.imemREN, dpif.imemaddr);
  $display("dmemREN: %b | dmemWEN: %b| dmemstore: %x | dmemaddr: %x | datomic: %b", dpif.dmemREN, dpif.dmemWEN, dpif.dmemstore, dpif.dmemaddr, dpif.datomic);
  
endfunction : display_stats

endprogram
