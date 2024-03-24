//**************************************************************************
// Hardware Interrput Controller for thread transfer from Vector to Scalar
//**************************************************************************

`include "VX_define.vh"

module VX_interrupt_ctl //import VX_gpu_pkg::*;
(
    input wire              clk,
    input wire              reset,
    
    // I/O
    VX_interrupt_ctl_if.hw_int    interrupt_ctl_if
);   

    typedef enum logic [2:0] {
        IDLE, 
        WAIT, 
        PC_SWAP, 
        WAIT_IRQ, 
        REVERT_WARP
    } hw_int_state_t;

    data_t nextRegisters;
    hw_int_state_t nextState, currState; 


    always @(posedge clk)
    begin 
        if(reset)
        begin 
            interrupt_ctl_if.registers  <= '0;
            currState                   <= IDLE;
        end
        else 
        begin 
            interrupt_ctl_if.registers <= nextRegisters;
            currState                  <= nextState;
        end
    end

    //**************************************************************************
    // Interrupt Controller Next State Logic
    //**************************************************************************
    always @(*)
    begin 
        nextState = currState; 
        casez(currState)
        IDLE: 
        begin 
            if(interrupt_ctl_if.registers.S2V) 
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
            if(~interrupt_ctl_if.registers.S2V)
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
        nextRegisters               = interrupt_ctl_if.registers;
        interrupt_ctl_if.controls   = '0;
        interrupt_ctl_if.scalarLoad = '0;
        interrupt_ctl_if.vectorLoad = '0;


        //********************************************************************
        // REGISTER SW READING/WRITING LOGIC 
        // Both cores do not need 
        // SW read/write access for every 
        // register, but I temporarily kept it
        // for now
        // writing priority: FSM writes > Vector SW writes > Scalar SW Writes
        //********************************************************************
        casez(interrupt_ctl_if.scalarAddr)
        32'h00000000: 
        begin 
            interrupt_ctl_if.scalarLoad[0]   = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.accel : '0;
            nextRegisters.accel              = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore[0]  : interrupt_ctl_if.registers.accel;
        end
        32'h00000004:
        begin
            interrupt_ctl_if.scalarLoad      = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.IPC   : '0; 
            nextRegisters.IPC                = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore     : interrupt_ctl_if.registers.IPC;
        end
        32'h00000008: 
        begin
            interrupt_ctl_if.scalarLoad[0]   = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.error : '0; 
            nextRegisters.error              = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore[0]  : interrupt_ctl_if.registers.error;
        end
        32'h0000000C: 
        begin 
            interrupt_ctl_if.scalarLoad[0]   = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.S2V    : '0; 
            nextRegisters.S2V                = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore[0]   : interrupt_ctl_if.registers.S2V;
        end
        32'h00000010: 
        begin
            interrupt_ctl_if.scalarLoad[3:0] = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.TID    : '0;  
            nextRegisters.TID                = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore[3:0] : interrupt_ctl_if.registers.TID;
        end
        32'h00000014: 
        begin
            interrupt_ctl_if.scalarLoad      = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.IRQ    : '0; 
            nextRegisters.IRQ                = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : interrupt_ctl_if.registers.IRQ;
        end
        32'h00000018: 
        begin
            interrupt_ctl_if.scalarLoad      = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.SP    : '0; 
            nextRegisters.SP                 = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore      : interrupt_ctl_if.registers.SP;
        end
        default:
        begin 
            interrupt_ctl_if.scalarLoad[0]   = (interrupt_ctl_if.scalarRd) ? interrupt_ctl_if.registers.accel : '0;
            nextRegisters.accel              = (interrupt_ctl_if.scalarWr) ? interrupt_ctl_if.scalarStore[0]  : interrupt_ctl_if.registers.accel;
        end
        endcase

        casez(interrupt_ctl_if.vectorAddr)
        32'h00000000: 
        begin 
            interrupt_ctl_if.vectorLoad[0]   = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.accel : '0;
            nextRegisters.accel              = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore[0]  : interrupt_ctl_if.registers.accel;
        end
        32'h00000004:
        begin
            interrupt_ctl_if.vectorLoad      = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.IPC   : '0; 
            nextRegisters.IPC                = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore     : interrupt_ctl_if.registers.IPC;
        end
        32'h00000008: 
        begin
            interrupt_ctl_if.vectorLoad[0]   = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.error : '0; 
            nextRegisters.error              = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore[0]  : interrupt_ctl_if.registers.error;
        end
        32'h0000000C: 
        begin 
            interrupt_ctl_if.vectorLoad[0]   = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.S2V    : '0; 
            nextRegisters.S2V                = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore[0]   : interrupt_ctl_if.registers.S2V;
        end
        32'h00000010: 
        begin
            interrupt_ctl_if.vectorLoad[3:0] = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.TID    : '0;  
            nextRegisters.TID                = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore[3:0] : interrupt_ctl_if.registers.TID;
        end
        32'h00000014: 
        begin
            interrupt_ctl_if.vectorLoad      = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.IRQ    : '0; 
            nextRegisters.IRQ                = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore      : interrupt_ctl_if.registers.IRQ;
        end
        32'h00000018: 
        begin
            interrupt_ctl_if.vectorLoad      = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.SP     : '0; 
            nextRegisters.SP                 = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore      : interrupt_ctl_if.registers.SP;
        end
        default:
        begin
            interrupt_ctl_if.vectorLoad[0]   = (interrupt_ctl_if.vectorRd) ? interrupt_ctl_if.registers.accel : '0;
            nextRegisters.accel              = (interrupt_ctl_if.vectorWr) ? interrupt_ctl_if.vectorStore[0]  : interrupt_ctl_if.registers.accel;
        end
        endcase


        //*******************************
        // FSM OUTPUT LOGIC 
        //*******************************
        casez(currState)
        IDLE: 
        begin 
            if(interrupt_ctl_if.registers.S2V) 
                nextRegisters.error = 0; // clear error 
        end
        WAIT: 
        begin 
            interrupt_ctl_if.controls.maskActWarp = 1; 
            interrupt_ctl_if.controls.hwInt       = 1; // let vecCore know hw interrupt is happening
            if(interrupt_ctl_if.err)
            begin 
                nextRegisters.error = 1; 
                nextRegisters.S2V   = 0; // ack failed interrupt req from scalar
            end
        end
        PC_SWAP: 
        begin 
            nextRegisters.IPC                     = interrupt_ctl_if.PC; // save thread's interrupted PC
            interrupt_ctl_if.controls.hwInt       = 1; 
            interrupt_ctl_if.controls.maskThreads = 1;
            interrupt_ctl_if.controls.swapPC      = 1; // force vector core's PC to take IRQ
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
