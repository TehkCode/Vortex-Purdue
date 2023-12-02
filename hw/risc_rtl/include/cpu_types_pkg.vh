`ifndef CPU_TYPES_PKG_VH
`define CPU_TYPES_PKG_VH
package cpu_types_pkg;

  // word width and size
  parameter WORD_W    = 32;
  parameter WBYTES    = WORD_W/8;

  // instruction format widths
  parameter OP_W      = 7;
  parameter REG_W     = 5;

  parameter FUNC7_W    = 7;
  parameter FUNC3_W    = 3;
  
  parameter IMM_W     = 12;
  parameter ADDR_W    = 26;

  // alu op width
  parameter AOP_W     = 4;

// opcodes
  // opcode type
  typedef enum logic [OP_W-1:0] {
    
    // Rtype - use funct
    RTYPE   = 7'b0110011,

    // Itype
    ITYPE   = 7'b0010011,

    // Stype
    LW      = 7'b0000011,
    SW      = 7'b0100011,

    // SBtype
    SBTYPE  = 7'b1100011,

    // UJtype
    JAL     = 7'b1101111,
    JALR    = 7'b1100111,

    // Utype
    LUI     = 7'b0110111,
    AUIPC   = 7'b0010111,

    //CSR
    CSR     = 7'b1110011,
    
    HALT    = 7'b111111

  } opcode_t;

  // r/i type funct funct3 
  typedef enum logic [FUNC3_W-1:0] {
    ADD  = 3'b000,
    XOR  = 3'b100,
    OR   = 3'b110,
    AND  = 3'b111,
    SLL  = 3'b001,
    SRL  = 3'b101,
    SLT  = 3'b010
  } funct3_t;

// sb type funct funct3 
  typedef enum logic [FUNC3_W-1:0] {
    BEQ  = 3'b000,
    BNE  = 3'b001,
    BLT  = 3'b100,
    BGE  = 3'b101
  } b_funct3_t;

  // alu op type
  typedef enum logic [AOP_W-1:0] {
    ALU_SLL     = 4'b0000,
    ALU_SRL     = 4'b0001,
    ALU_ADD     = 4'b0010,
    ALU_SUB     = 4'b0011,
    ALU_AND     = 4'b0100,
    ALU_OR      = 4'b0101,
    ALU_XOR     = 4'b0110,
    ALU_NOR     = 4'b0111,
    ALU_SLT     = 4'b1010,
    ALU_SLTU    = 4'b1011,
    ALU_SRA     = 4'b1100 //RISC_R
  } aluop_t;


// instruction format types
  // register bits types
  typedef logic [REG_W-1:0] regbits_t;

  // r type
  typedef struct packed {
    logic [6:0]         funct7;
    regbits_t           rs2;
    regbits_t           rs1;
    funct3_t            funct3;
    regbits_t           rd;
    opcode_t            opcode;
  } r_t;

    // i type
  typedef struct packed {
    logic [IMM_W-1:0]   imm;
    regbits_t           rs1;
    funct3_t            funct3;
    regbits_t           rd;    
    opcode_t            opcode;
  } i_t;

  // s type
  typedef struct packed {
    logic [6:0]         imm_1;
    regbits_t           rs2;
    regbits_t           rs1;
    funct3_t            funct3;
    logic [4:0]         imm_0;
    opcode_t            opcode;
  } s_t;

  // U type
  typedef struct packed {
    logic [19:0]        imm;
    regbits_t           rd;    
    opcode_t            opcode;
  } u_t;

// word_t
  typedef logic [WORD_W-1:0] word_t;

// memory state
  // ramstate
  typedef enum logic [1:0] {
    FREE,
    BUSY,
    ACCESS,
    ERROR
  } ramstate_t;

endpackage
`endif //CPU_TYPES_PKG_VH
