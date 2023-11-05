`ifdef SV_TRACE_EN

`ifndef VX_TRACE_INSTR
`define VX_TRACE_INSTR

`include "VX_define.vh"

task sv_trace_ex_type (
    input [`EX_BITS-1:0] ex_type, 
    input int fp
);
    case (ex_type)
        `EX_ALU: `SV_TRACE("ALU", fp)     
        `EX_LSU: `SV_TRACE("LSU", fp)
        `EX_CSR: `SV_TRACE("CSR", fp)
        `EX_FPU: `SV_TRACE("FPU", fp)
        `EX_GPU: `SV_TRACE("GPU", fp)
        default: `SV_TRACE("NOP", fp)
    endcase  
endtask

task sv_trace_ex_op (
  input [`EX_BITS-1:0] ex_type,
  input [`INST_OP_BITS-1:0] op_type,
  input [`INST_MOD_BITS-1:0] op_mod,
  input int fp
);

    case (ex_type)        
    `EX_ALU: begin
        if (`INST_ALU_IS_BR(op_mod)) begin
            case (`INST_BR_BITS'(op_type))
                `INST_BR_EQ:    `SV_TRACE("BEQ", fp)
                `INST_BR_NE:    `SV_TRACE("BNE", fp)
                `INST_BR_LT:    `SV_TRACE("BLT", fp)
                `INST_BR_GE:    `SV_TRACE("BGE", fp)
                `INST_BR_LTU:   `SV_TRACE("BLTU", fp)
                `INST_BR_GEU:   `SV_TRACE("BGEU", fp)           
                `INST_BR_JAL:   `SV_TRACE("JAL", fp)
                `INST_BR_JALR:  `SV_TRACE("JALR", fp)
                `INST_BR_ECALL: `SV_TRACE("ECALL", fp)
                `INST_BR_EBREAK:`SV_TRACE("EBREAK", fp)    
                `INST_BR_URET:  `SV_TRACE("URET", fp)    
                `INST_BR_SRET:  `SV_TRACE("SRET", fp)    
                `INST_BR_MRET:  `SV_TRACE("MRET", fp)    
                default:   `SV_TRACE("ALU BR OP Undefined?", fp)
            endcase                
        end else if (`INST_ALU_IS_MUL(op_mod)) begin
            case (`INST_MUL_BITS'(op_type))
                `INST_MUL_MUL:   `SV_TRACE("MUL", fp)
                `INST_MUL_MULH:  `SV_TRACE("MULH", fp)
                `INST_MUL_MULHSU:`SV_TRACE("MULHSU", fp)
                `INST_MUL_MULHU: `SV_TRACE("MULHU", fp)
                `INST_MUL_DIV:   `SV_TRACE("DIV", fp)
                `INST_MUL_DIVU:  `SV_TRACE("DIVU", fp)
                `INST_MUL_REM:   `SV_TRACE("REM", fp)
                `INST_MUL_REMU:  `SV_TRACE("REMU", fp)
                default:    `SV_TRACE("ALU MUL OP Undefined?", fp)
            endcase
        end else begin
            case (`INST_ALU_BITS'(op_type))
                `INST_ALU_ADD:   `SV_TRACE("ADD", fp)
                `INST_ALU_SUB:   `SV_TRACE("SUB", fp)
                `INST_ALU_SLL:   `SV_TRACE("SLL", fp)
                `INST_ALU_SRL:   `SV_TRACE("SRL", fp)
                `INST_ALU_SRA:   `SV_TRACE("SRA", fp)
                `INST_ALU_SLT:   `SV_TRACE("SLT", fp)
                `INST_ALU_SLTU:  `SV_TRACE("SLTU", fp)
                `INST_ALU_XOR:   `SV_TRACE("XOR", fp)
                `INST_ALU_OR:    `SV_TRACE("OR", fp)
                `INST_ALU_AND:   `SV_TRACE("AND", fp)
                `INST_ALU_LUI:   `SV_TRACE("LUI", fp)
                `INST_ALU_AUIPC: `SV_TRACE("AUIPC", fp)
                default:    `SV_TRACE("ALU OP Undefined?", fp)
            endcase         
        end
    end
    `EX_LSU: begin
        if (op_mod == 0) begin
            case (`INST_LSU_BITS'(op_type))
                `INST_LSU_LB: `SV_TRACE("LB", fp)
                `INST_LSU_LH: `SV_TRACE("LH", fp)
                `INST_LSU_LW: `SV_TRACE("LW", fp)
                `INST_LSU_LBU:`SV_TRACE("LBU", fp)
                `INST_LSU_LHU:`SV_TRACE("LHU", fp)
                `INST_LSU_SB: `SV_TRACE("SB", fp)
                `INST_LSU_SH: `SV_TRACE("SH", fp)
                `INST_LSU_SW: `SV_TRACE("SW", fp)
                default: `SV_TRACE("LSU OP Undefined?", fp)
            endcase
        end else if (op_mod == 1) begin
            case (`INST_FENCE_BITS'(op_type))
                `INST_FENCE_D: `SV_TRACE("DFENCE", fp)
                `INST_FENCE_I: `SV_TRACE("IFENCE", fp)
                default: `SV_TRACE("FENCE OP Undefined?", fp)
            endcase
        end
    end
    `EX_CSR: begin
        case (`INST_CSR_BITS'(op_type))
            `INST_CSR_RW: `SV_TRACE("CSRW", fp)
            `INST_CSR_RS: `SV_TRACE("CSRS", fp)
            `INST_CSR_RC: `SV_TRACE("CSRC", fp)
            default: `SV_TRACE("CSR OP Undefined?", fp)
        endcase
    end
    `EX_FPU: begin
        case (`INST_FPU_BITS'(op_type))
            `INST_FPU_ADD:   `SV_TRACE("ADD", fp)
            `INST_FPU_SUB:   `SV_TRACE("SUB", fp)
            `INST_FPU_MUL:   `SV_TRACE("MUL", fp)
            `INST_FPU_DIV:   `SV_TRACE("DIV", fp)
            `INST_FPU_SQRT:  `SV_TRACE("SQRT", fp)
            `INST_FPU_MADD:  `SV_TRACE("MADD", fp)
            `INST_FPU_NMSUB: `SV_TRACE("NMSUB", fp)
            `INST_FPU_NMADD: `SV_TRACE("NMADD", fp)                
            `INST_FPU_CVTWS: `SV_TRACE("CVTWS", fp)
            `INST_FPU_CVTWUS:`SV_TRACE("CVTWUS", fp)
            `INST_FPU_CVTSW: `SV_TRACE("CVTSW", fp)
            `INST_FPU_CVTSWU:`SV_TRACE("CVTSWU", fp)
            `INST_FPU_CLASS: `SV_TRACE("CLASS", fp)
            `INST_FPU_CMP:   `SV_TRACE("CMP", fp)
            `INST_FPU_MISC: begin
                case (op_mod)
                0: `SV_TRACE("SGNJ", fp)   
                1: `SV_TRACE("SGNJN", fp)
                2: `SV_TRACE("SGNJX", fp)
                3: `SV_TRACE("MIN", fp)
                4: `SV_TRACE("MAX", fp)
                5: `SV_TRACE("MVXW", fp)
                6: `SV_TRACE("MVWX", fp)
                endcase
            end 
            default:    `SV_TRACE("FPU OP Undefined?", fp)
        endcase
    end
    `EX_GPU: begin
        case (`INST_GPU_BITS'(op_type))
            `INST_GPU_TMC:   `SV_TRACE("TMC", fp)
            `INST_GPU_WSPAWN:`SV_TRACE("WSPAWN", fp)
            `INST_GPU_SPLIT: `SV_TRACE("SPLIT", fp)
            `INST_GPU_JOIN:  `SV_TRACE("JOIN", fp)
            `INST_GPU_BAR:   `SV_TRACE("BAR", fp)
            `INST_GPU_PRED:  `SV_TRACE("PRED", fp)
            `INST_GPU_TEX:   `SV_TRACE("TEX", fp)
            default:    `SV_TRACE("GPU OP Undefined?", fp)
        endcase
    end    
    default: `SV_TRACE("EX TYPE Undefined?", fp)
    endcase 
endtask

`endif
`endif