`include "VX_define.vh"

interface VX_interrupt_ctl_ttu_if import VX_gpu_pkg::*; ();

    // Thread Transfer Unit
	hw_int_state_t 		state; 					// current state of the IC
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

	modport master (
			output state,
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

	modport slave (
			input  state,
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
