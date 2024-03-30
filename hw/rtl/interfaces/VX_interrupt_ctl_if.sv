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

	import VX_gpu_pkg::hw_int_state_t;

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

	// Thread Transfer Unit
	hw_int_state_t 		state; 					// current state of the IC
	logic [`XLEN-1:0]	ISR_PC;					// PC to be substituted
	logic [`NW_WIDTH-1:0]				wid;    // warp id of the thread to be transferred
	logic [`NT_WIDTH-1:0]				tid;    // thread id (within the warp) to be transferred
	logic 				pipeline_drained;		// to signify transition out of WAIT state
	logic				thread_found;			// to signify whether thread found or out. qualified by (only valid if) pipeline_drained
	logic [`NUM_THREADS-1:0]	current_thread_mask; 
	logic [`XLEN-1:0]			current_PC;			 
	logic [`NUM_WARPS-1:0]      current_active_warps; 
	logic 						ISR_done;			 // execution of ISR is done
	logic [`NUM_THREADS-1:0]	load_tmask; 
	logic [`XLEN-1:0]			load_PC;			 
	logic [`NUM_WARPS-1:0]		load_wmask;
	
	modport ttu_master (
			output state,
			output ISR_PC,
			output wid,
			output tid,
			input  pipeline_drained,
			input  thread_found,
			input  current_thread_mask,
			input  current_PC,
			input  current_active_warps,
			input  ISR_done,
			output load_tmask,
			output load_PC,
			output load_wmask
	);

	modport ttu_slave (
			input  state,
			input  ISR_PC,
			input  wid,
			input  tid,
			output pipeline_drained,
			output thread_found,
			output current_thread_mask,
			output current_PC,
			output current_active_warps,
			output ISR_done,
			input  load_tmask,
			input  load_PC,
			input  load_wmask
	);

endinterface
