`include "VX_define.vh"

typedef struct packed {
        logic [31:0] accel; 
        logic [31:0] error; 
        logic [31:0] IPC; 
        logic [31:0] SP;
        logic [31:0] S2V; 
        logic [31:0] TID; 
        logic [31:0] IRQ;
        logic [31:0] SPACER; // so we can make it even and divisible by 8
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

    // scalar ld/str
    logic [31:0] scalarAddr; 
    logic [31:0] scalarStore; 
    logic        scalarRd; 
    logic        scalarWr; 
    logic [31:0] scalarLoad; 

    // simt ld/str
    logic [31:0] simtAddr; 
    logic [31:0] simtStore; 
    logic        simtRd; 
    logic        simtWr; 
    logic [31:0] simtLoad;

    // modport hw_int (
    //     input  err, 
    //     input  pipe_clean, 
    //     input  PC, 
    //     input scalarAddr, 
    //     input scalarStore, 
    //     input scalarRd, 
    //     input scalarWr, 
    //     input vectorAddr, 
    //     input vectorStore, 
    //     input vectorRd, 
    //     input vectorWr,
    //     output registers,
    //     output controls,
    //     output scalarLoad, 
    //     output vectorLoad
    // );

    modport hw_int (
        input err, 
        input pipe_clean, 
        input PC, 
        // add LSQ empty 
        input  scalarAddr, 
        input  scalarStore, 
        input  scalarRd, 
        input  scalarWr, 
        input  simtAddr, 
        input  simtStore, 
        input  simtRd, 
        input  simtWr, 
        output controls,
        output scalarLoad, 
        output simtLoad
    );

    

endinterface
