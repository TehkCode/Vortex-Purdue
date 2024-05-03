`include "VX_define.vh"

interface VX_execute_hw_itr_if import VX_gpu_pkg::*; ();

    logic [`XLEN-1:0] SIMTSchedulerRetPC;
    logic [`XLEN-1:0] SIMTSchedulerRetPCw0;
    logic [`XLEN-1:0] retHandlerAddress;
    logic [`XLEN-1:0] WspawnPCplus4;
    logic [`XLEN-1:0] overload_JAL;
    logic commitSIMTSchedulerRetPC;
    logic commitSIMTSchedulerRetPCw0;
    logic [`ISSUE_WIDTH-1:0] warp_hits;
    logic writeWspawnPCplus4;
    logic writeRAS;
    logic [`XLEN-1:0] RAS; 
    logic [`XLEN-1:0] IPC; 

    modport master (
            output retHandlerAddress,
            output overload_JAL,
            output IPC,
            input commitSIMTSchedulerRetPC,
            input commitSIMTSchedulerRetPCw0,
            input SIMTSchedulerRetPC,
            input SIMTSchedulerRetPCw0,
            input warp_hits,
            input writeWspawnPCplus4,
            input WspawnPCplus4,
            input RAS,
            input writeRAS
    );

    modport slave (
            input retHandlerAddress,
            input overload_JAL,
            input IPC,
            output commitSIMTSchedulerRetPC,
            output commitSIMTSchedulerRetPCw0,
            output SIMTSchedulerRetPC,
            output SIMTSchedulerRetPCw0,
            output warp_hits,
            output writeWspawnPCplus4,
            output WspawnPCplus4,
            output RAS,
            output writeRAS
    );
endinterface
