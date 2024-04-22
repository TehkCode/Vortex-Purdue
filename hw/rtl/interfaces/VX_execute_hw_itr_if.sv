`include "VX_define.vh"

interface VX_execute_hw_itr_if import VX_gpu_pkg::*; ();

    logic [`XLEN-1:0] SIMTSchedulerRetPC;
    logic [`XLEN-1:0] retHandlerAddress;
    logic overload_JAL;
    logic commitSIMTSchedulerRetPC;
    logic allHit;

    modport master (
            output retHandlerAddress,
            output overload_JAL,
            input commitSIMTSchedulerRetPC,
            input SIMTSchedulerRetPC,
            input allHit
    );

    modport slave (
            input retHandlerAddress,
            input overload_JAL,
            output commitSIMTSchedulerRetPC,
            output SIMTSchedulerRetPC,
            output allHit
    );
endinterface
