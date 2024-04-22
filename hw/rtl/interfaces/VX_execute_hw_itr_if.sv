`include "VX_define.vh"

interface VX_execute_hw_itr_if import VX_gpu_pkg::*; ();

    logic [`XLEN-1:0] SIMTSchedulerRetPC;
    logic [`XLEN-1:0] SIMTSchedulerRetPCw0;
    logic [`XLEN-1:0] retHandlerAddress;
    logic [`XLEN-1:0] WspawnPCplus4;
    logic overload_JAL;
    logic commitSIMTSchedulerRetPC;
    logic commitSIMTSchedulerRetPCw0;
    logic allHit;
    logic writeWspawnPCplus4;

    modport master (
            output retHandlerAddress,
            output overload_JAL,
            input commitSIMTSchedulerRetPC,
            input commitSIMTSchedulerRetPCw0,
            input SIMTSchedulerRetPC,
            input SIMTSchedulerRetPCw0,
            input allHit,
            input writeWspawnPCplus4,
            input WspawnPCplus4
    );

    modport slave (
            input retHandlerAddress,
            input overload_JAL,
            output commitSIMTSchedulerRetPC,
            output commitSIMTSchedulerRetPCw0,
            output SIMTSchedulerRetPC,
            output SIMTSchedulerRetPCw0,
            output allHit,
            output writeWspawnPCplus4,
            output WspawnPCplus4
    );
endinterface
