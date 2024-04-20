`include "VX_define.vh"

typedef struct packed {
    logic [31:0] S2V; 
    logic [31:0] V2S;
    logic [31:0] TID;
    logic [31:0] IPC;
    logic [31:0] IRQ;
    logic [31:0] ACC;
    logic [31:0] ERR;
    logic [30:0] [31:0] R; // 31 registers for moving thread context
} data_t;

typedef struct packed {
        logic       maskActWarp; 
        logic       hwInt; 
        logic       maskThreads; 
        logic       swapPC; 
    } warp_ctls_t;

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
