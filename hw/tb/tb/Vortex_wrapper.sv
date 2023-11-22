// Zach Lagpacan - zlagpaca@purdue.edu
//
// wrapper combining Vortex_wrapper_no_Vortex and Vortex 

// `include "local_mem.vh"
`include "VX_define.vh"
// `include "Vortex_mem_slave.vh"

module Vortex_wrapper 
#( 
    // wrapper parameters
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    // parameter MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000;
    parameter MEM_SLAVE_AHB_BASE_ADDR = 32'h8000_0000, // testing address, where old binaries expect
    parameter BUSY_REG_AHB_BASE_ADDR = 32'hF000_8000,
    parameter START_REG_AHB_BASE_ADDR = 32'hF000_8004,
    parameter PC_RESET_VAL_REG_AHB_BASE_ADDR = 32'hF000_8008,
    // parameter PC_RESET_VAL_RESET_VAL = MEM_SLAVE_AHB_BASE_ADDR;
    parameter PC_RESET_VAL_RESET_VAL = 32'hF000_0000, // testing PC reset val switch 0xF -> 0x8
    parameter MEM_SLAVE_ADDR_SPACE_BITS = 15,
    parameter BUFFER_WIDTH = 1
)(

    /////////////////
    // Sequential: //
    /////////////////
    input clk, nRST,

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if.peripheral_vital        mem_slave_bpif,
        // // Vital signals
        // logic wen; // request is a data write
        // logic ren; // request is a data read
        // logic request_stall; // High when protocol should insert wait states in transaction
        // logic [ADDR_WIDTH-1 : 0] addr; // *offset* address of request TODO: Is this good for general use?
        // logic error; // Indicate error condition to bus
        // logic [(DATA_WIDTH/8)-1 : 0] strobe; // byte enable for writes
        // logic [DATA_WIDTH-1 : 0] wdata, rdata; // data lines -- from perspective of bus master. rdata should be data read from peripheral.

        // modport peripheral_vital (
        //     input wen, ren, addr, wdata, strobe,
        //     output rdata, error, request_stall
        // );

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if.peripheral_vital        ctrl_status_bpif,
        // // Vital signals
        // logic wen; // request is a data write
        // logic ren; // request is a data read
        // logic request_stall; // High when protocol should insert wait states in transaction
        // logic [ADDR_WIDTH-1 : 0] addr; // *offset* address of request TODO: Is this good for general use?
        // logic error; // Indicate error condition to bus
        // logic [(DATA_WIDTH/8)-1 : 0] strobe; // byte enable for writes
        // logic [DATA_WIDTH-1 : 0] wdata, rdata; // data lines -- from perspective of bus master. rdata should be data read from peripheral.

        // modport peripheral_vital (
        //     input wen, ren, addr, wdata, strobe,
        //     output rdata, error, request_stall
        // );

    //////////////////////////////////
    // AHB Manager for Vortex_... : //
    //////////////////////////////////

    ahb_if.manager ahb_manager_ahbif
        // logic HSEL;
        // logic HREADY;
        // logic HREADYOUT;
        // logic HWRITE;
        // logic HMASTLOCK;
        // logic HRESP;
        // logic [1:0] HTRANS;
        // logic [2:0] HBURST;
        // logic [2:0] HSIZE;
        // logic [ADDR_WIDTH - 1:0] HADDR;
        // logic [DATA_WIDTH - 1:0] HWDATA;
        // logic [DATA_WIDTH - 1:0] HRDATA;
        // logic [(DATA_WIDTH/8) - 1:0] HWSTRB;

        // assign HREADY = HREADYOUT;

        // modport manager(
        //     input HCLK, HRESETn,
        //     input HREADY, HRESP, HRDATA,
        //     output HWRITE, HMASTLOCK, HTRANS,
        //     HBURST, HSIZE, HADDR, HWDATA, HWSTRB, HSEL
        // );

);

    logic                               Vortex_mem_req_valid;
    logic                               Vortex_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    Vortex_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]      Vortex_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]      Vortex_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       Vortex_mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    logic                               Vortex_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               Vortex_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      Vortex_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       Vortex_mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    logic                               Vortex_mem_rsp_ready;

    /////////////////////////////////
    // CTRL/STATUS to/from Vortex: //
    /////////////////////////////////

    logic Vortex_busy;
    logic Vortex_reset;
    logic [32-1:0] Vortex_PC_reset_val;

    //////////////////////////////////////
    // Vortex_wrapper_no_Vortex module: //
    //////////////////////////////////////

    Vortex_wrapper_no_Vortex #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_SLAVE_AHB_BASE_ADDR(MEM_SLAVE_AHB_BASE_ADDR),
        .BUSY_REG_AHB_BASE_ADDR(BUSY_REG_AHB_BASE_ADDR),
        .START_REG_AHB_BASE_ADDR(START_REG_AHB_BASE_ADDR),
        .PC_RESET_VAL_REG_AHB_BASE_ADDR(PC_RESET_VAL_REG_AHB_BASE_ADDR),
        .PC_RESET_VAL_RESET_VAL(PC_RESET_VAL_RESET_VAL),
        .MEM_SLAVE_ADDR_SPACE_BITS(MEM_SLAVE_ADDR_SPACE_BITS),
        .BUFFER_WIDTH(BUFFER_WIDTH)
    ) Vortex_wrapper_no_Vortex_Instance (.*);

    ////////////////////
    // Vortex module: //
    ////////////////////

    Vortex Vortex_Instance(
        .clk(clk),
        .reset(Vortex_reset), 
        .PC_reset_val(Vortex_PC_reset_val),
        .mem_req_valid(Vortex_mem_req_valid), 
        .mem_req_rw(Vortex_mem_req_rw), 
        .mem_req_byteen(Vortex_mem_req_byteen),
        .mem_req_addr(Vortex_mem_req_addr), 
        .mem_req_data(Vortex_mem_req_data), 
        .mem_req_tag(Vortex_mem_req_tag), 
        .mem_req_ready(Vortex_mem_req_ready), 
        .mem_rsp_valid(Vortex_mem_rsp_valid), 
        .mem_rsp_data(Vortex_mem_rsp_data), 
        .mem_rsp_tag(Vortex_mem_rsp_tag), 
        .mem_rsp_ready(Vortex_mem_rsp_ready), 
        .busy(Vortex_busy)
    );



endmodule