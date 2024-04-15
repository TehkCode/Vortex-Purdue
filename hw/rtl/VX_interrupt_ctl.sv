//**************************************************************************
// Hardware Interrput Controller for thread transfer from SIMT to Scalar
//**************************************************************************

`include "VX_define.vh"

module VX_interrupt_ctl import VX_gpu_pkg::*;
(
    input wire              clk,
    input wire              reset,
    
    // I/O

    // controls
    VX_interrupt_ctl_if.hw_int    interrupt_ctl_if,
    // read/write bus
    VX_sfu_csr_if.slave           simt_bus_if, 
    VX_sfu_csr_if.slave           scalar_bus_if       
);   

    typedef enum logic [2:0] {
        IDLE, 
        WAIT, 
        PC_SWAP, 
        WAIT_IRQ, 
        REVERT_WARP
    } hw_int_state_t;

    parameter INTREG_CNT = 8;

    


    // 32 data_t structs. Each data_t struct contains the eight 32-bit interrupt registers (8 words) -> 8*32 = 256 words 4 words
    data_t [(256 / INTREG_CNT) - 1:0] nextRegisters, registers; 
    hw_int_state_t nextState, currState; 




    always @(posedge clk)
    begin 
        if(reset)
        begin 
            registers                   <= '{default:256'd0};
            currState                   <= IDLE;
        end
        else 
        begin 
            registers                  <= nextRegisters;
            currState                  <= nextState;
        end
    end

    //**************************************************************************
    // Interrupt Controller Next State Logic
    // Currently, there is only 1 state machine to support one SIMT/SCALAR 
    // pair. Later on, this should be parameterized to work with up to 32 
    // SIMT/SCALAR pairs by generating 32 FSMs.
    //**************************************************************************
    always @(*)
    begin 
        nextState = currState; 
        casez(currState)
        IDLE: 
        begin 
            if(registers[0].S2V == 32'd1)  // hard-code to 0 for now since only 1 SIMT/SCALAR pair
                nextState = WAIT; 
        end
        WAIT: 
        begin 
            if(interrupt_ctl_if.err)
                nextState = IDLE; 
            else if(interrupt_ctl_if.pipe_clean)
                nextState = WAIT;
        end
        PC_SWAP: 
        begin 
            nextState = WAIT_IRQ;
        end
        WAIT_IRQ: 
        begin 
            if(registers[0].S2V == 32'd0)
                nextState = REVERT_WARP;
        end
        REVERT_WARP: 
        begin
            nextState = IDLE; 
        end
        default: 
        begin 
        end
        endcase
    end


    //**************************************************************************
    // Interrupt Controller Output Logic
    //**************************************************************************
    //always @(*)
    always_comb
    begin 
        nextRegisters               = registers;
        interrupt_ctl_if.controls   = '0;
        interrupt_ctl_if.scalarLoad = '0;
        interrupt_ctl_if.simtLoad   = '0;


        //********************************************************************
        // REGISTER SW READING/WRITING LOGIC 
        // Both cores do not need 
        // SW read/write access for every 
        // register, but I temporarily kept it
        // for now
        // writing priority: FSM writes > SIMT SW writes > Scalar SW Writes
        //********************************************************************
        casez(interrupt_ctl_if.scalarAddr % 32)
        32'h00000000: 
        begin 
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].accel  : '0;
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].accel  = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].accel;
        end
        32'h00000004:
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].IPC    : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].IPC    = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].IPC;
        end
        32'h00000008: 
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].error  : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].error  = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].error;
        end
        32'h0000000C: 
        begin 
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].S2V    : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].S2V    = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].S2V;
        end
        32'h00000010: 
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].TID    : '0;  
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].TID    = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].TID;
        end
        32'h00000014: 
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].IRQ    : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].IRQ    = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].IRQ;
        end
        32'h00000018: 
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].SP     : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].SP     = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].SP;
        end
        32'h0000001c: 
        begin
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].SPACER : '0; 
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].SPACER = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].SPACER;
        end
        default:
        begin 
            interrupt_ctl_if.scalarLoad                            = (interrupt_ctl_if.scalarRd) ? registers[interrupt_ctl_if.scalarAddr >> 5].accel  : '0;
            nextRegisters[interrupt_ctl_if.scalarAddr >> 5].accel  = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : registers[interrupt_ctl_if.scalarAddr >> 5].accel;
        end
        endcase

        casez(interrupt_ctl_if.simtAddr % 32)
        32'h00000000: 
        begin 
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].accel    : '0;
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].accel    = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].accel;
        end
        32'h00000004:
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].IPC      : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].IPC      = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].IPC;
        end
        32'h00000008: 
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].error    : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].error    = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].error;
        end
        32'h0000000C: 
        begin 
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].S2V      : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].S2V      = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].S2V;
        end
        32'h00000010: 
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].TID      : '0;  
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].TID      = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].TID;
        end
        32'h00000014: 
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].IRQ      : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].IRQ      = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].IRQ;
        end
        32'h00000018: 
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].SP       : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].SP       = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].SP;
        end
        32'h0000001c: 
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].SPACER   : '0; 
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].SPACER   = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].SPACER;
        end
        default:
        begin
            interrupt_ctl_if.simtLoad                              = (interrupt_ctl_if.simtRd)   ? registers[interrupt_ctl_if.simtAddr >> 5].accel    : '0;
            nextRegisters[interrupt_ctl_if.simtAddr >> 5].accel    = (interrupt_ctl_if.simtWr)   ? interrupt_ctl_if.simtStore        : registers[interrupt_ctl_if.simtAddr >> 5].accel;
        end
        endcase


        //*******************************
        // FSM OUTPUT LOGIC 
        //*******************************
        casez(currState)
        IDLE: 
        begin 
            if(registers[0].S2V == 32'd1) 
                nextRegisters[0].error = 0; // clear error 
        end
        WAIT: 
        begin 
            interrupt_ctl_if.controls.maskActWarp = 1; 
            interrupt_ctl_if.controls.hwInt       = 1; // let vecCore know hw interrupt is happening
            if(interrupt_ctl_if.err)
            begin 
                nextRegisters[0].error = 1; 
                nextRegisters[0].S2V   = 0; // ack failed interrupt req from scalar
            end
        end
        PC_SWAP: 
        begin 
            nextRegisters[0].IPC                     = interrupt_ctl_if.PC; // save thread's interrupted PC
            interrupt_ctl_if.controls.hwInt       = 1; 
            interrupt_ctl_if.controls.maskThreads = 1;
            interrupt_ctl_if.controls.swapPC      = 1; // force simt core's PC to take IRQ
        end
        WAIT_IRQ: 
        begin 
            interrupt_ctl_if.controls.hwInt       = 1; 
            interrupt_ctl_if.controls.maskThreads = 1;
        end
        REVERT_WARP: 
        begin
            // Let RTI instruction do its thing..?
            // mask off warp again 
            // place IPC into warp's PC 
            // mask off the thread we just moved (TID)
            // unmask the other three threads and let them continue
        end
        default: 
        begin 

        end
        endcase
    end
endmodule
