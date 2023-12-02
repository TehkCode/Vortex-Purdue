/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

// cache outputs  
  assign ccif.iwait[0] = ( ccif.iREN[0] && 
                      ~( ccif.dREN[0] || ccif.dWEN[0]) &&  
                      (ccif.ramstate == ACCESS))? '0:'1;

  assign ccif.dwait[0] = ((ccif.dREN[0] || ccif.dWEN[0]) && 
                       (ccif.ramstate == ACCESS))? '0:'1;
  
  assign ccif.iload = (ccif.iREN[0])? ccif.ramload :'0; 
  assign ccif.dload = ccif.ramload; //always given priority
  
  // assign ccif.iload = (ccif.iREN[0] && (ccif.ramstate == ACCESS) && (ccif.dREN == 1'b0) && (ccif.dWEN == 1'b0))? ccif.ramload: ccif.iload;
  // assign ccif.dload = (ccif.dREN[0] && (ccif.ramstate == ACCESS))? ccif.ramload: ccif.dload;
  
// ram outputs
  assign ccif.ramstore = ccif.dstore; 
  assign ccif.ramaddr = (ccif.dWEN[0] || ccif.dREN[0])? ccif.daddr : ccif.iaddr;
  assign ccif.ramWEN = ccif.dWEN[0];
  assign ccif.ramREN = (ccif.dREN[0] || ccif.iREN[0]) &&  ~ccif.dWEN[0];


endmodule
