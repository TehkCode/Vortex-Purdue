//**************************************************************************
// Hardware Interrput Controller for thread transfer from SIMT to Scalar
//**************************************************************************

`include "VX_define.vh"
`include "VX_types.vh"

module VX_interrupt_ctl import VX_gpu_pkg::*;
#(
    parameter SIMT_CORE_ID   = 0,
    parameter SCALAR_CORE_ID = 1
)
(
    input wire              clk,
    input wire              reset,
    
    // I/O
    // Overloading JAL instr in SIMT execute
    VX_execute_hw_itr_if.master execute_hw_itr_if[2],
    // thread transfer unit controls
    VX_interrupt_ctl_ttu_if.master    interrupt_ctl_ttu_if,
    // read/write bus
    VX_sfu_csr_if.slave           simt_bus_if, 
    VX_sfu_csr_if.slave           scalar_bus_if       
);   
    
    hw_int_data_t nextRegisters, registers; 
    hw_int_state_t nextState, currState; 
    logic [5:0]    counter, nextCounter; 
    logic [17:0]   timer,   nextTimer;

    logic [11:0] simtAddr;        // 12 bit csr address
    logic [11:0] scalarAddr;      // 12 bit csr address
    logic [1:0]  whichSimtThrd;   // which SIMT thread is doing a write?
    logic [1:0]  whichScalarThrd; // which Scalar thread is doing a write?

    always @(posedge clk)
    begin 
        if(reset)
        begin 
            registers                   <= '0;
            currState                   <= IRQC_IDLE;
            counter                     <= '0;
            timer                       <= '0;
        end
        else 
        begin 
            registers                  <= nextRegisters;
            currState                  <= nextState;
            counter                    <= nextCounter;
            timer                      <= nextTimer;
        end
    end

    assign simtAddr   = (simt_bus_if.write_enable)   ? simt_bus_if.write_addr   : simt_bus_if.read_addr;
    assign scalarAddr = (scalar_bus_if.write_enable) ? scalar_bus_if.write_addr : scalar_bus_if.read_addr;
    always @(*)
    begin 
        whichSimtThrd               = 2'b00; // default to thread 0
        whichScalarThrd             = 2'b00; // default to thread 0
        nextRegisters = registers;
        nextCounter   = counter;
        nextTimer     = timer + 1;


        if(simt_bus_if.write_tmask[0])
            whichSimtThrd = 0; 
        else if(simt_bus_if.write_tmask[1])
            whichSimtThrd = 1;
        else if(simt_bus_if.write_tmask[2])
            whichSimtThrd = 2;
        else if(simt_bus_if.write_tmask[3])
            whichSimtThrd = 3;

        if(scalar_bus_if.write_tmask[0])
            whichScalarThrd = 0; 
        else if(scalar_bus_if.write_tmask[1])
            whichScalarThrd = 1;
        else if(scalar_bus_if.write_tmask[2])
            whichScalarThrd = 2;
        else if(scalar_bus_if.write_tmask[3])
            whichScalarThrd = 3;

        casez(simtAddr)
            `VX_HW_ITR_S2V: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.S2V}} : '0;
                nextRegisters.S2V = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.S2V;
            end
            `VX_HW_ITR_V2S: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.V2S}} : '0;
                nextRegisters.V2S = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.V2S;
            end
            `VX_HW_ITR_TID: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.TID}} : '0;
                nextRegisters.TID = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.TID;
            end
            `VX_HW_ITR_IPC: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.IPC}} : '0;
                nextRegisters.IPC = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.IPC;
            end
            `VX_HW_ITR_IRQ: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.IRQ}} : '0;
                nextRegisters.IRQ = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.IRQ;
            end
            `VX_HW_ITR_ACC: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.ACC}} : '0;
                nextRegisters.ACC = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.ACC;
            end
            `VX_HW_ITR_ERR: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.ERR}} : '0;
                nextRegisters.ERR = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.ERR;
            end
            `VX_HW_ITR_JALOL: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.JALOL}} : '0;
                nextRegisters.JALOL = (simt_bus_if.write_enable) ? (registers.JALOL | (simt_bus_if.write_data[whichSimtThrd] << simt_bus_if.write_wid))
                                                                    : registers.JALOL;
                // set only the Nth bit at a time. N is the wid.
            end
            `VX_HW_ITR_RHA: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.RHA}} : '0;
                nextRegisters.RHA = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.RHA;
            end
            `VX_HW_ITR_ACCEND: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.ACCEND}} : '0;
                nextRegisters.ACCEND = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.ACCEND;
            end
            `VX_HW_ITR_RAV: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.RAV}} : '0;
                nextRegisters.RAV = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.RAV;
            end
            `VX_HW_ITR_RAS: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.RAS}} : '0;
                nextRegisters.RAS = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.RAS;
            end
            `VX_HW_ITR_SSP: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.SSP}} : '0;
                nextRegisters.SSP = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.SSP;
            end
            `VX_HW_ITR_RAVW0: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.RAVW0}} : '0;
                nextRegisters.RAVW0 = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.RAVW0;
            end
            `VX_HW_ITR_LTID: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.LTID}} : '0;
                nextRegisters.LTID = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.LTID;
            end
            `VX_HW_ITR_LWID: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.LWID}} : '0;
                nextRegisters.LWID = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.LWID;
            end
            `VX_HW_ITR_R1: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[0]}} : '0;
                nextRegisters.R[0] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[0];
            end
            `VX_HW_ITR_R2: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[1]}} : '0;
                nextRegisters.R[1] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[1];
            end
            `VX_HW_ITR_R3: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[2]}} : '0;
                nextRegisters.R[2] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[2];
            end
            `VX_HW_ITR_R4: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[3]}} : '0;
                nextRegisters.R[3] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[3];
            end
            `VX_HW_ITR_R5: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[4]}} : '0;
                nextRegisters.R[4] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[4];
            end
            `VX_HW_ITR_R6: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[5]}} : '0;
                nextRegisters.R[5] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[5];
            end
            `VX_HW_ITR_R7: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[6]}} : '0;
                nextRegisters.R[6] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[6];
            end
            `VX_HW_ITR_R8: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[7]}} : '0;
                nextRegisters.R[7] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[7];
            end
            `VX_HW_ITR_R9: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[8]}} : '0;
                nextRegisters.R[8] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[8];
            end
            `VX_HW_ITR_R10: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[9]}} : '0;
                nextRegisters.R[9] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[9];
            end
            `VX_HW_ITR_R11: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[10]}} : '0;
                nextRegisters.R[10] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[10];
            end
            `VX_HW_ITR_R12: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[11]}} : '0;
                nextRegisters.R[11] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[11];
            end
            `VX_HW_ITR_R13: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[12]}} : '0;
                nextRegisters.R[12] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[12];
            end
            `VX_HW_ITR_R14: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[13]}} : '0;
                nextRegisters.R[13] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[13];
            end
            `VX_HW_ITR_R15: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[14]}} : '0;
                nextRegisters.R[14] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[14];
            end
            `VX_HW_ITR_R16: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[15]}} : '0;
                nextRegisters.R[15] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[15];
            end
            `VX_HW_ITR_R17: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[16]}} : '0;
                nextRegisters.R[16] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[16];
            end
            `VX_HW_ITR_R18: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[17]}} : '0;
                nextRegisters.R[17] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[17];
            end
            `VX_HW_ITR_R19: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[18]}} : '0;
                nextRegisters.R[18] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[18];
            end
            `VX_HW_ITR_R20: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[19]}} : '0;
                nextRegisters.R[19] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[19];
            end
            `VX_HW_ITR_R21: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[20]}} : '0;
                nextRegisters.R[20] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[20];
            end
            `VX_HW_ITR_R22: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[21]}} : '0;
                nextRegisters.R[21] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[21];
            end
            `VX_HW_ITR_R23: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[22]}} : '0;
                nextRegisters.R[22] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[22];
            end
            `VX_HW_ITR_R24: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[23]}} : '0;
                nextRegisters.R[23] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[23];
            end
            `VX_HW_ITR_R25: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[24]}} : '0;
                nextRegisters.R[24] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[24];
            end
            `VX_HW_ITR_R26: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[25]}} : '0;
                nextRegisters.R[25] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[25];
            end
            `VX_HW_ITR_R27: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[26]}} : '0;
                nextRegisters.R[26] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[26];
            end
            `VX_HW_ITR_R28: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[27]}} : '0;
                nextRegisters.R[27] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[27];
            end
            `VX_HW_ITR_R29: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[28]}} : '0;
                nextRegisters.R[28] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[28];
            end
            `VX_HW_ITR_R30: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[29]}} : '0;
                nextRegisters.R[29] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[29];
            end
            `VX_HW_ITR_R31: 
            begin 
                simt_bus_if.read_data = (simt_bus_if.read_enable) ? {4{registers.R[30]}} : '0;
                nextRegisters.R[30] = (simt_bus_if.write_enable) ? simt_bus_if.write_data[whichSimtThrd] : registers.R[30];
            end
            default:
            begin 

            end
        endcase

        casez(scalarAddr)
            `VX_HW_ITR_S2V: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.S2V}} : '0;
                nextRegisters.S2V = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.S2V;
            end
            `VX_HW_ITR_V2S: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.V2S}} : '0;
                nextRegisters.V2S = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.V2S;
            end
            `VX_HW_ITR_TID: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.TID}} : '0;
                nextRegisters.TID = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.TID;
            end
            `VX_HW_ITR_IPC: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.IPC}} : '0;
                nextRegisters.IPC = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.IPC;
            end
            `VX_HW_ITR_IRQ: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.IRQ}} : '0;
                nextRegisters.IRQ = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.IRQ;
            end
            `VX_HW_ITR_ACC: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.ACC}} : '0;
                nextRegisters.ACC = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.ACC;
            end
            `VX_HW_ITR_ERR: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.ERR}} : '0;
                nextRegisters.ERR = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.ERR;
            end
            `VX_HW_ITR_JALOL: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.JALOL}} : '0;
                nextRegisters.JALOL = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.JALOL;
            end
            `VX_HW_ITR_RHA: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.RHA}} : '0;
                nextRegisters.RHA = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.RHA;
            end
            `VX_HW_ITR_ACCEND: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.ACCEND}} : '0;
                nextRegisters.ACCEND = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.ACCEND;
            end
            `VX_HW_ITR_RAV: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.RAV}} : '0;
                nextRegisters.RAV = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.RAV;
            end
            `VX_HW_ITR_RAS: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.RAS}} : '0;
                nextRegisters.RAS = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.RAS;
            end
            `VX_HW_ITR_SSP: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.SSP}} : '0;
                nextRegisters.SSP = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.SSP;
            end
            `VX_HW_ITR_RAVW0: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.RAVW0}} : '0;
                nextRegisters.RAVW0 = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.RAVW0;
            end
            `VX_HW_ITR_LTID: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.LTID}} : '0;
                nextRegisters.LTID = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.LTID;
            end
            `VX_HW_ITR_LWID: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.LWID}} : '0;
                nextRegisters.LWID = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.LWID;
            end
            `VX_HW_ITR_R1: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[0]}} : '0;
                nextRegisters.R[0] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[0];
            end
            `VX_HW_ITR_R2: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[1]}} : '0;
                nextRegisters.R[1] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[1];
            end
            `VX_HW_ITR_R3: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[2]}} : '0;
                nextRegisters.R[2] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[2];
            end
            `VX_HW_ITR_R4: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[3]}} : '0;
                nextRegisters.R[3] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[3];
            end
            `VX_HW_ITR_R5: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[4]}} : '0;
                nextRegisters.R[4] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[4];
            end
            `VX_HW_ITR_R6: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[5]}} : '0;
                nextRegisters.R[5] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[5];
            end
            `VX_HW_ITR_R7: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[6]}} : '0;
                nextRegisters.R[6] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[6];
            end
            `VX_HW_ITR_R8: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[7]}} : '0;
                nextRegisters.R[7] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[7];
            end
            `VX_HW_ITR_R9: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[8]}} : '0;
                nextRegisters.R[8] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[8];
            end
            `VX_HW_ITR_R10: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[9]}} : '0;
                nextRegisters.R[9] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[9];
            end
            `VX_HW_ITR_R11: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[10]}} : '0;
                nextRegisters.R[10] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[10];
            end
            `VX_HW_ITR_R12: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[11]}} : '0;
                nextRegisters.R[11] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[11];
            end
            `VX_HW_ITR_R13: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[12]}} : '0;
                nextRegisters.R[12] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[12];
            end
            `VX_HW_ITR_R14: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[13]}} : '0;
                nextRegisters.R[13] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[13];
            end
            `VX_HW_ITR_R15: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[14]}} : '0;
                nextRegisters.R[14] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[14];
            end
            `VX_HW_ITR_R16: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[15]}} : '0;
                nextRegisters.R[15] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[15];
            end
            `VX_HW_ITR_R17: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[16]}} : '0;
                nextRegisters.R[16] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[16];
            end
            `VX_HW_ITR_R18: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[17]}} : '0;
                nextRegisters.R[17] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[17];
            end
            `VX_HW_ITR_R19: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[18]}} : '0;
                nextRegisters.R[18] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[18];
            end
            `VX_HW_ITR_R20: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[19]}} : '0;
                nextRegisters.R[19] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[19];
            end
            `VX_HW_ITR_R21: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[20]}} : '0;
                nextRegisters.R[20] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[20];
            end
            `VX_HW_ITR_R22: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[21]}} : '0;
                nextRegisters.R[21] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[21];
            end
            `VX_HW_ITR_R23: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[22]}} : '0;
                nextRegisters.R[22] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[22];
            end
            `VX_HW_ITR_R24: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[23]}} : '0;
                nextRegisters.R[23] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[23];
            end
            `VX_HW_ITR_R25: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[24]}} : '0;
                nextRegisters.R[24] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[24];
            end
            `VX_HW_ITR_R26: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[25]}} : '0;
                nextRegisters.R[25] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[25];
            end
            `VX_HW_ITR_R27: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[26]}} : '0;
                nextRegisters.R[26] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[26];
            end
            `VX_HW_ITR_R28: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[27]}} : '0;
                nextRegisters.R[27] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[27];
            end
            `VX_HW_ITR_R29: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[28]}} : '0;
                nextRegisters.R[28] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[28];
            end
            `VX_HW_ITR_R30: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[29]}} : '0;
                nextRegisters.R[29] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[29];
            end
            `VX_HW_ITR_R31: 
            begin 
                scalar_bus_if.read_data = (scalar_bus_if.read_enable) ? {4{registers.R[30]}} : '0;
                nextRegisters.R[30] = (scalar_bus_if.write_enable) ? scalar_bus_if.write_data[whichScalarThrd] : registers.R[30];
            end
            default:
            begin 

            end
        endcase

        casez(currState)
        IRQC_IDLE: 
        begin 
            if(registers.S2V == 32'd0) // scalar has acknowledged error
            begin 
                nextRegisters.V2S = 0; 
                nextRegisters.ERR = 0; 
            end
        end
        IRQC_WAIT: 
        begin 
            if(interrupt_ctl_ttu_if.pipeline_drained & ~interrupt_ctl_ttu_if.thread_found) // bad thread req
            begin 
                nextRegisters.ERR = 1;
                nextRegisters.V2S = 1;
            end
            else if (interrupt_ctl_ttu_if.pipeline_drained)
            begin 
                nextRegisters.TMASK = 32'(interrupt_ctl_ttu_if.current_thread_mask) ;
                nextRegisters.WMASK = 32'(interrupt_ctl_ttu_if.current_active_warps); 
                nextRegisters.IPC   = 32'(interrupt_ctl_ttu_if.current_PC);
            end
        end
        IRQC_PC_SWAP: 
        begin
            // DO NOTHING
        end
        IRQC_WAIT_ISR: 
        begin 
            // DO NOTHING
        end
        IRQC_REVERT_WARP: 
        begin
            nextRegisters.V2S = 1; // Let scalar core load thread.
            if(registers.S2V == 0) // scalar done loading thread.  
            begin
                nextRegisters.V2S = 0; 
                nextRegisters.ERR = 0; 
            end
        end
        default: 
        begin 

        end
        endcase

        // Responses from execute unit 
        if(execute_hw_itr_if[SIMT_CORE_ID].commitSIMTSchedulerRetPCw0) // Save warp0's true return address for return to SIMT kernel scheduler later
        begin 
            nextRegisters.RAVW0 = execute_hw_itr_if[SIMT_CORE_ID].SIMTSchedulerRetPCw0;
        end
        if(execute_hw_itr_if[SIMT_CORE_ID].commitSIMTSchedulerRetPC) // Save other warps true return addresses for return to SIMT kernel scheduler later
        begin 
            nextRegisters.RAV   = execute_hw_itr_if[SIMT_CORE_ID].SIMTSchedulerRetPC;
        end
        if(|execute_hw_itr_if[SIMT_CORE_ID].warp_hits) // All warps have seen their JALs and are in the kernel. Stop overloading JAL instr. Also start counting to 64 to turn on accel
        begin 
            nextRegisters.JALOL = (nextRegisters.JALOL & (~(32'(execute_hw_itr_if[SIMT_CORE_ID].warp_hits))) ); // deassert bit for only those warps which were hit
        end

        if(execute_hw_itr_if[SCALAR_CORE_ID].writeWspawnPCplus4)
        begin 
            nextRegisters.RAS = execute_hw_itr_if[SCALAR_CORE_ID].WspawnPCplus4;
        end

        if(counter != 0)
        begin 
            nextCounter = counter + 1;
        end
        if(&execute_hw_itr_if[SIMT_CORE_ID].warp_hits[`ISSUE_WIDTH-1:0] & (|registers.JALOL))
        begin // set ACC to 1 only aftr warps jump into kernel.
            nextRegisters.ACC = 1;
            nextCounter = counter + 1; // initiate the counter
        end

        if (execute_hw_itr_if[SIMT_CORE_ID].writeRAS) begin
            nextRegisters.RAS = execute_hw_itr_if[SIMT_CORE_ID].RAS;
        end
    end
    // RUNTIME_ASSERT((!(counter == 63)), ("***caught you mf************"))
    // RUNTIME_ASSERT((!(&timer)), ("***caught you mf timer************"))



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
        IRQC_IDLE: 
        begin 
            if((registers.S2V == 32'd1) && (registers.ERR == 32'd0) && (registers.V2S == 32'd0))
                nextState = IRQC_WAIT; 
        end
        IRQC_WAIT: 
        begin 
            if(interrupt_ctl_ttu_if.pipeline_drained & interrupt_ctl_ttu_if.thread_found)
                nextState = IRQC_PC_SWAP; 
            else if(interrupt_ctl_ttu_if.pipeline_drained)
                nextState = IRQC_IDLE;
        end
        IRQC_PC_SWAP: 
        begin 
            nextState = IRQC_WAIT_ISR;
        end
        IRQC_WAIT_ISR: 
        begin 
            if(interrupt_ctl_ttu_if.ISR_done)
                nextState = IRQC_REVERT_WARP;
        end
        IRQC_REVERT_WARP: 
        begin
            if(registers.S2V == 0) // scalar done loading thread
            begin 
                nextState = IRQC_IDLE; 
            end
        end
        default: 
        begin 
        end
        endcase
    end

    // To thread transfer unit
    assign interrupt_ctl_ttu_if.state = currState;
    assign interrupt_ctl_ttu_if.wid = registers.TID[`NT_WIDTH+`NW_WIDTH-1 : `NT_WIDTH];
    assign interrupt_ctl_ttu_if.tid = registers.TID[`NT_WIDTH-1 : 0];
    assign interrupt_ctl_ttu_if.load_tmask = registers.TMASK[`NUM_THREADS-1:0];
    assign interrupt_ctl_ttu_if.load_PC = (currState == IRQC_PC_SWAP) ? registers.IRQ : registers.IPC;
    assign interrupt_ctl_ttu_if.load_wmask = registers.WMASK[`NUM_WARPS-1:0];

    // To execute stage for overloading jump and link instruction
    assign execute_hw_itr_if[SIMT_CORE_ID].overload_JAL = registers.JALOL; // option to overload JAL instruction to change link register commit.
    assign execute_hw_itr_if[SIMT_CORE_ID].retHandlerAddress = registers.RHA;        // overload it by setting link reg to this

    assign execute_hw_itr_if[SCALAR_CORE_ID].IPC = registers.IPC;
endmodule
