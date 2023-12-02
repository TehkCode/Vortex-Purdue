`ifndef BRANCH_PREDICTION_IF_VH
`define BRANCH_PREDICTION_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface branch_prediction_if;
  // import types
  import cpu_types_pkg::*;

  logic     is_taken, Wr_enable;
  word_t    current_PC, update_PC, update_target_PC, predicted_PC;
 
  modport br_pd (
    input   is_taken, Wr_enable, current_PC, update_PC, update_target_PC,
    output  predicted_PC
  );
  
endinterface

`endif //BRANCH_PREDICTION_IF_VH
