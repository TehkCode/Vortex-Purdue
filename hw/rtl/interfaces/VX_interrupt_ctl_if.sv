`include "VX_define.vh"

typedef struct packed {
        logic        accel; 
        logic        error; 
        logic [31:0] IPC; 
        logic [31:0] SP;
        logic        S2V; 
        logic [3:0]  TID; 
        logic [31:0] IRQ;
    } data_t;

typedef struct packed {
        logic       maskActWarp; 
        logic       hwInt; 
        logic       maskThreads; 
        logic       swapPC; 
    } warp_ctls_t;

interface VX_interrupt_ctl_if;

    data_t      registers;
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

    // vector ld/str
    logic [31:0] vectorAddr; 
    logic [31:0] vectorStore; 
    logic        vectorRd; 
    logic        vectorWr; 
    logic [31:0] vectorLoad;

    // modport master (
    //     output  err, 
    //     output  pipe_clean, 
    //     output  PC, 
    //     output scalarAddr, 
    //     output scalarStore, 
    //     output scalarRd, 
    //     output scalarWr, 
    //     output vectorAddr, 
    //     output vectorStore, 
    //     output vectorRd, 
    //     output vectorWr,
    //     input registers,
    //     input controls,
    //     input scalarLoad, 
    //     input vectorLoad
    // );

    modport sclr_cr (
        output scalarAddr, 
        output scalarStore, 
        output scalarRd, 
        output scalarWr, 
        input registers, 
        input scalarLoad
    );

    modport vctr_cr (
        output err, 
        output pipe_clean,
        output PC, 
        output vectorAddr, 
        output vectorStore, 
        output vectorRd, 
        output vectorWr, 
        input registers,
        input controls, 
        input vectorLoad
    );

    modport hw_int (
        input  err, 
        input  pipe_clean, 
        input  PC, 
        input scalarAddr, 
        input scalarStore, 
        input scalarRd, 
        input scalarWr, 
        input vectorAddr, 
        input vectorStore, 
        input vectorRd, 
        input vectorWr,
        output registers,
        output controls,
        output scalarLoad, 
        output vectorLoad
    );

    

endinterface
