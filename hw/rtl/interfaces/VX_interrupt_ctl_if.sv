`include "VX_define.vh"



// typedef struct packed {
//         logic       maskActWarp; 
//         logic       hwInt; 
//         logic       maskThreads; 
//         logic       swapPC; 
//     } warp_ctls_t;

interface VX_interrupt_ctl_if;

    //data_t      registers;
    warp_ctls_t controls;
    logic        err; 
    logic        pipe_clean; 
    logic [31:0] PC; 

    modport hw_int (
        input err, 
        input pipe_clean, 
        input PC, 
        // add LSQ empty 
        output controls
    );

    

endinterface
