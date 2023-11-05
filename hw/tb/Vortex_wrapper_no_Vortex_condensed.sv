/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    module for integrating on-chip SRAM/AHB subordinate, AHB manager, and control/status register
    logic to serve as interface between AFTx07 and Vortex

    assumptions:
        Vortex wrapper is on AFTx07 clock/reset domain --> async, active low nRST
        AHB only references word addresses
        mem_slave and ahb_manager can respond in same cycle but will not respond in successive cycles
        it is safe to use reset as start/stop for Vortex
        it is safe to feed PC reset value into Vortex

    THIS IS THE CONDENSED VERSION OF Vortex_mem_slave.sv

        Vortex_mem_slave.sv can be produced from a GPU program hex file, where the hex is stored in the
        resets of the registers, but is not good for synthesis
            - reg file access width is 1 byte/8-bit
            - is able to load in hex files with load_Vortex_mem_slave.py script

        Vortex_mem_slave_condensed.sv is better suited for synthesis
            - reg file access width is 1 word
            - register reset always 0's
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

module Vortex_wrapper_no_Vortex_condensed
#(
    /////////////////
    // parameters: //
    /////////////////

    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000,
    parameter BUSY_REG_AHB_BASE_ADDR = 32'hF000_8000,
    parameter START_REG_AHB_BASE_ADDR = 32'hF000_8004,
    parameter PC_RESET_VAL_REG_AHB_BASE_ADDR = 32'hF000_8008,
    parameter PC_RESET_VAL_RESET_VAL = 32'hF000_0000,
    parameter MEM_SLAVE_ADDR_SPACE_BITS = 14,
    parameter BUFFER_WIDTH = 1
)(
    /////////////////
    // Sequential: //
    /////////////////
    input clk, nRST,

    //////////////////////////////
    // Vortex Memory Interface: //
    //////////////////////////////

    // Memory Request:
    // vortex outputs
    input logic                             Vortex_mem_req_valid,
    input logic                             Vortex_mem_req_rw,
    input logic [`VX_MEM_BYTEEN_WIDTH-1:0]  Vortex_mem_req_byteen, // 64 (512 / 8)
    input logic [`VX_MEM_ADDR_WIDTH-1:0]    Vortex_mem_req_addr,   // 26
    input logic [`VX_MEM_DATA_WIDTH-1:0]    Vortex_mem_req_data,   // 512
    input logic [`VX_MEM_TAG_WIDTH-1:0]     Vortex_mem_req_tag,    // 56 (55 for SM disabled)
    // vortex inputs
    output logic                            Vortex_mem_req_ready,

    // Memory response:
    // vortex inputs
    output logic                            Vortex_mem_rsp_valid,        
    output logic [`VX_MEM_DATA_WIDTH-1:0]   Vortex_mem_rsp_data,   // 512
    output logic [`VX_MEM_TAG_WIDTH-1:0]    Vortex_mem_rsp_tag,    // 56 (55 for SM disabled)
    // vortex outputs
    input logic                             Vortex_mem_rsp_ready,

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

    ////////////////////////////////////////////
    // AHB Subordinate for CTRL/Status Reg's: //
    ////////////////////////////////////////////

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

    ahb_if.manager ahb_manager_ahbif,
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

    /////////////////////////////////
    // CTRL/STATUS to/from Vortex: //
    /////////////////////////////////

    input logic Vortex_busy,
    output logic Vortex_reset,
    output logic [32-1:0] Vortex_PC_reset_val
);

    ////////////////
    // constants: //
    ////////////////

    // default mem req
    localparam DEF_MEM_REQ_VALID = 1'b0;
    localparam DEF_MEM_REQ_RW = 1'b0;
    localparam DEF_MEM_REQ_BYTEEN = 64'h0;
    localparam DEF_MEM_REQ_ADDR = 26'h0;
    localparam DEF_MEM_REQ_DATA = 512'h0;
    localparam DEF_MEM_REQ_TAG = 56'h0;
    localparam DEF_MEM_REQ_READY = 1'b1;

    // default mem rsp
    localparam DEF_MEM_RSP_VALID = 1'b0;
    localparam DEF_MEM_RSP_DATA = 512'h0;
    localparam DEF_MEM_RSP_TAG = 56'h0;
    localparam DEF_MEM_RSP_READY = 1'b1;

    // instantiation flag for Vortex_mem_slave
    localparam VORTEX_MEM_SLAVE_INSTANTIATED = MEM_SLAVE_ADDR_SPACE_BITS >= 6; // check for too small Vortex_mem_slave

    ///////////////////////
    // internal signals: //
    ///////////////////////

    // req/rsp to/from mem slave

    // Memory Request:
    logic                               mem_slave_mem_req_valid;
    logic                               mem_slave_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    mem_slave_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]      mem_slave_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_slave_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_slave_mem_req_tag;    // 56 (55 for SM disabled)
    logic                               mem_slave_mem_req_ready;
    // Memory response:
    logic                               mem_slave_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_slave_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_slave_mem_rsp_tag;    // 56 (55 for SM disabled)
    logic                               mem_slave_mem_rsp_ready;

    // req/rsp to/from ahb manager

    // Memory Request:
    logic                               ahb_manager_mem_req_valid;
    logic                               ahb_manager_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    ahb_manager_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]      ahb_manager_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]      ahb_manager_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       ahb_manager_mem_req_tag;    // 56 (55 for SM disabled)
    logic                               ahb_manager_mem_req_ready;
    // Memory response:
    logic                               ahb_manager_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      ahb_manager_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       ahb_manager_mem_rsp_tag;    // 56 (55 for SM disabled)
    logic                               ahb_manager_mem_rsp_ready;

    // rsp buffer
    logic                               mem_rsp_valid_buffer, next_mem_rsp_valid_buffer;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_rsp_data_buffer, next_mem_rsp_data_buffer;      // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_rsp_tag_buffer, next_mem_rsp_tag_buffer;        // 56 (55 for SM disabled)
    logic double_mem_rsp;

    // ctrl/status reg
    logic ctrl_status_busy, next_ctrl_status_busy;  // busy reg
    logic ctrl_status_start_triggered;              // detector for start write, will allow FSM transition
    logic [32-1:0] ctrl_status_PC_reset_val, next_ctrl_status_PC_reset_val;  // PC reset val reg
    logic ctrl_status_reset_state, next_ctrl_status_reset_state;    // FSM state
    logic next_Vortex_reset; // reset value before register to go to Vortex (output of OR gate for timing)

    ///////////////////
    // info signals: //
    ///////////////////

    logic inside_Vortex_mem_slave_space;
    logic inside_VX_ahb_adapter_space;
    logic between_Vortex_mem_slave_VX_ahb_adapter_space;

    /////////////////////
    // instantiations: //
    /////////////////////

    generate
    if (VORTEX_MEM_SLAVE_INSTANTIATED)
    begin
        // mem_slave
        Vortex_mem_slave_condensed #(
            .VORTEX_MEM_SLAVE_AHB_BASE_ADDR(MEM_SLAVE_AHB_BASE_ADDR),
            .LOCAL_MEM_SIZE(MEM_SLAVE_ADDR_SPACE_BITS) // 14-bits for 32 KB local mem
        ) mem_slave (
        
            /////////////////
            // Sequential: //
            /////////////////
            .clk(clk), 
            .nRST(nRST),

            ///////////////////////
            // Memory Interface: //
            ///////////////////////

            // Memory Request:
            // vortex outputs
            .mem_req_valid(mem_slave_mem_req_valid),
            .mem_req_rw(mem_slave_mem_req_rw),
            .mem_req_byteen(mem_slave_mem_req_byteen),  // 64 (512 / 8)
            .mem_req_addr(mem_slave_mem_req_addr),      // 26
            .mem_req_data(mem_slave_mem_req_data),      // 512
            .mem_req_tag(mem_slave_mem_req_tag),        // 56 (55 for SM disabled)
            // vortex inputs
            .mem_req_ready(mem_slave_mem_req_ready),

            // Memory response:
            // vortex inputs
            .mem_rsp_valid(mem_slave_mem_rsp_valid),        
            .mem_rsp_data(mem_slave_mem_rsp_data),      // 512
            .mem_rsp_tag(mem_slave_mem_rsp_tag),        // 56 (55 for SM disabled)
            // vortex outputs
            .mem_rsp_ready(mem_slave_mem_rsp_ready),

            // Status:
            // vortex outputs
            // input logic                             busy,
            .busy(Vortex_busy),

            //////////////////////////////////
            // Generic Bus Interface (AHB): //
            //////////////////////////////////

            .bpif(mem_slave_bpif)
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
        );
    end
    
    // otherwise, don't instantiate mem slave
    else
    begin
        $info("Vortex_mem_slave not instantiated");

        // fake mem slave (safe, inactive outputs)
        assign mem_slave_mem_req_ready = 1'b1;
        assign mem_slave_mem_rsp_valid = 1'b0;
        assign mem_slave_mem_rsp_data = 512'h0;
        assign mem_slave_mem_rsp_tag = 56'h0;
        assign mem_slave_bpif.rdata = 32'h0;
        assign mem_slave_bpif.error = 1'b0;
        assign mem_slave_bpif.request_stall = 1'b0;
    end
    endgenerate

    // ahb_manager
    VX_ahb_adapter #(
        .VX_BYTEEN_WIDTH(64),
        .AHB_STROBE_WIDTH(4)
    ) ahb_manager (

        /////////////////
        // Sequential: //
        /////////////////
        .clk(clk),
        .nRST(nRST),

        ///////////////////////
        // Memory Interface: //
        ///////////////////////

        // Memory Request:
        // vortex outputs
        .mem_req_valid(ahb_manager_mem_req_valid),
        .mem_req_rw(ahb_manager_mem_req_rw),
        .mem_req_byteen(ahb_manager_mem_req_byteen),  // 64 (512 / 8)
        .mem_req_addr(ahb_manager_mem_req_addr),      // 26
        .mem_req_data(ahb_manager_mem_req_data),      // 512
        .mem_req_tag(ahb_manager_mem_req_tag),        // 56 (55 for SM disabled)
        // vortex inputs
        .mem_req_ready(ahb_manager_mem_req_ready),

        // Memory response:
        // vortex inputs
        .mem_rsp_valid(ahb_manager_mem_rsp_valid),        
        .mem_rsp_data(ahb_manager_mem_rsp_data),      // 512
        .mem_rsp_tag(ahb_manager_mem_rsp_tag),        // 56 (55 for SM disabled)
        // vortex outputs
        .mem_rsp_ready(ahb_manager_mem_rsp_ready),

        // Status:
        // vortex outputs
        // input logic                             busy,

        //////////////////////////////////
        // AHB Interface (AHB manager): //
        //////////////////////////////////

        .ahb(ahb_manager_ahbif)
    );

    ////////////////////////////
    // mem_req_arbiter logic: //
    ////////////////////////////

    generate
    if (VORTEX_MEM_SLAVE_INSTANTIATED)
    begin
        always_comb begin : mem_req_arbiter_comb_logic
            
            // only need to mux valid signal based on address
            mem_slave_mem_req_valid = 1'b0;
            ahb_manager_mem_req_valid = 1'b0;

            // info signals
            inside_Vortex_mem_slave_space = 1'b0;
            inside_VX_ahb_adapter_space = 1'b0;
            between_Vortex_mem_slave_VX_ahb_adapter_space = 1'b0;

            if (Vortex_mem_req_valid)
            begin
                // check for inside Vortex_mem_slave addr space
                if (Vortex_mem_req_addr[32-6-1:MEM_SLAVE_ADDR_SPACE_BITS-6] == 
                    MEM_SLAVE_AHB_BASE_ADDR[32-1:MEM_SLAVE_ADDR_SPACE_BITS])
                begin
                    mem_slave_mem_req_valid = 1'b1;

                    // info signals
                    inside_Vortex_mem_slave_space = 1'b1;
                end
                // check for top 17 bits != top 17 bits of 32'hF000_0000 -> inside VX_ahb_adapter addr space
                else if (Vortex_mem_req_addr[32-6-1:32-6-17] != MEM_SLAVE_AHB_BASE_ADDR[32-1:32-17])
                begin
                    ahb_manager_mem_req_valid = 1'b1;

                    // info signals
                    inside_VX_ahb_adapter_space = 1'b1;
                end
                // otherwise, in between spaces
                else
                begin
                    // info signals
                    between_Vortex_mem_slave_VX_ahb_adapter_space = 1'b1;
                end
            end

            // ready if both mem_slave and ahb_manager ready
            Vortex_mem_req_ready = mem_slave_mem_req_ready & ahb_manager_mem_req_ready;

            // hardwire all other signals
            mem_slave_mem_req_rw = Vortex_mem_req_rw;
            mem_slave_mem_req_byteen = Vortex_mem_req_byteen;       // 64 (512 / 8)
            mem_slave_mem_req_addr = Vortex_mem_req_addr;           // 26
            mem_slave_mem_req_data = Vortex_mem_req_data;           // 512
            mem_slave_mem_req_tag = Vortex_mem_req_tag;             // 56 (55 for SM disabled)

            ahb_manager_mem_req_rw = Vortex_mem_req_rw; 
            ahb_manager_mem_req_byteen = Vortex_mem_req_byteen;     // 64 (512 / 8)
            ahb_manager_mem_req_addr = Vortex_mem_req_addr;         // 26
            ahb_manager_mem_req_data = Vortex_mem_req_data;         // 512
            ahb_manager_mem_req_tag = Vortex_mem_req_tag;           // 56 (55 for SM disabled) 
        end
    end

    // arbiter always chooses ahb_manager if mem_slave not instantiated
    else
    begin
        always_comb begin : mem_req_arbiter_no_mem_slave_comb_logic

            // all req's valid for ahb_manager
            ahb_manager_mem_req_valid = Vortex_mem_req_valid;
            mem_slave_mem_req_valid = 1'b0;

            // ready if ahb_manager ready
            Vortex_mem_req_ready = ahb_manager_mem_req_ready;

            // hardwire all other signals

            // ready if both mem_slave and ahb_manager ready
            Vortex_mem_req_ready = ahb_manager_mem_req_ready;

            mem_slave_mem_req_rw = Vortex_mem_req_rw;
            mem_slave_mem_req_byteen = Vortex_mem_req_byteen;       // 64 (512 / 8)
            mem_slave_mem_req_addr = Vortex_mem_req_addr;           // 26
            mem_slave_mem_req_data = Vortex_mem_req_data;           // 512
            mem_slave_mem_req_tag = Vortex_mem_req_tag;             // 56 (55 for SM disabled)

            ahb_manager_mem_req_rw = Vortex_mem_req_rw; 
            ahb_manager_mem_req_byteen = Vortex_mem_req_byteen;     // 64 (512 / 8)
            ahb_manager_mem_req_addr = Vortex_mem_req_addr;         // 26
            ahb_manager_mem_req_data = Vortex_mem_req_data;         // 512
            ahb_manager_mem_req_tag = Vortex_mem_req_tag;           // 56 (55 for SM disabled)
        end
    end
    endgenerate

    ///////////////////////////
    // mem_rsp_buffer logic: //
    ///////////////////////////

    always_ff @ (posedge clk, negedge nRST) begin : mem_rsp_buffer_reg_logic
        if (~nRST)
        begin
            mem_rsp_valid_buffer <= DEF_MEM_RSP_VALID;
            mem_rsp_data_buffer <= DEF_MEM_RSP_DATA;
            mem_rsp_tag_buffer <= DEF_MEM_RSP_TAG;
        end
        else
        begin
            mem_rsp_valid_buffer <= next_mem_rsp_valid_buffer;
            mem_rsp_data_buffer <= next_mem_rsp_data_buffer;
            mem_rsp_tag_buffer <= next_mem_rsp_tag_buffer;
        end
    end

    always_comb begin : mem_rsp_buffer_comb_logic

        double_mem_rsp = 1'b0;

        // default buffer
        next_mem_rsp_valid_buffer = DEF_MEM_RSP_VALID;
        next_mem_rsp_data_buffer = DEF_MEM_RSP_DATA;
        next_mem_rsp_tag_buffer = DEF_MEM_RSP_TAG;

        // check for mem_slave and ahb_manager both responding at once
        if (mem_slave_mem_rsp_valid & ahb_manager_mem_rsp_valid)
        begin
            double_mem_rsp = 1'b1;

            // take mem_slave response
            Vortex_mem_rsp_valid = mem_slave_mem_rsp_valid;
            Vortex_mem_rsp_data = mem_slave_mem_rsp_data;
            Vortex_mem_rsp_tag = mem_slave_mem_rsp_tag;

            // buffer ahb_manager response
            next_mem_rsp_valid_buffer = ahb_manager_mem_rsp_valid;
            next_mem_rsp_data_buffer = ahb_manager_mem_rsp_data;
            next_mem_rsp_tag_buffer = ahb_manager_mem_rsp_tag;
        end
        else if (mem_slave_mem_rsp_valid)
        begin
            // take mem_slave response
            Vortex_mem_rsp_valid = mem_slave_mem_rsp_valid;
            Vortex_mem_rsp_data = mem_slave_mem_rsp_data;
            Vortex_mem_rsp_tag = mem_slave_mem_rsp_tag;
        end
        else if (ahb_manager_mem_rsp_valid)
        begin
            // take ahb_manager response
            Vortex_mem_rsp_valid = ahb_manager_mem_rsp_valid;
            Vortex_mem_rsp_data = ahb_manager_mem_rsp_data;
            Vortex_mem_rsp_tag = ahb_manager_mem_rsp_tag;
        end
        else
        begin
            // take buffer response
            Vortex_mem_rsp_valid = mem_rsp_valid_buffer;
            Vortex_mem_rsp_data = mem_rsp_data_buffer;
            Vortex_mem_rsp_tag = mem_rsp_tag_buffer;
        end

        // give response ready to both
        mem_slave_mem_rsp_ready = Vortex_mem_rsp_ready;
        ahb_manager_mem_rsp_ready = Vortex_mem_rsp_ready;

    end

    ////////////////////////////
    // ctrl_status_FSM logic: //
    ////////////////////////////

    always_ff @ (posedge clk, negedge nRST) begin : ctrl_status_FSM_reg_logic
        if (~nRST)
        begin
            ctrl_status_reset_state <= 1'b1;
            ctrl_status_busy <= 1'b0;
            ctrl_status_PC_reset_val <= PC_RESET_VAL_RESET_VAL;
            Vortex_reset <= 1'b1;
        end
        else
        begin
            ctrl_status_reset_state <= next_ctrl_status_reset_state;
            ctrl_status_busy <= next_ctrl_status_busy;
            ctrl_status_PC_reset_val <= next_ctrl_status_PC_reset_val;
            Vortex_reset <= next_Vortex_reset;
        end
    end

    always_comb begin : ctrl_status_FSM_comb_logic

        // state transition logic
        case (ctrl_status_reset_state) 
            
            // reset state (Vortex idle)
            1'b1:
            begin
                next_ctrl_status_reset_state = 1'b1;

                // check for start triggered
                if (ctrl_status_start_triggered)
                begin
                    next_ctrl_status_reset_state = 1'b0;
                end
            end

            // no reset state (Vortex running)
            1'b0:
            begin
                next_ctrl_status_reset_state = 1'b0;

                // check for busy transition low
                if (~next_ctrl_status_busy & ctrl_status_busy)
                begin
                    next_ctrl_status_reset_state = 1'b1;
                end
            end

        endcase

        // output logic
        next_Vortex_reset = ~nRST | ctrl_status_reset_state; // reset follows register reset val OR logic reset
    end

    always_comb begin : ctrl_status_ahb_subordinate_comb_logic

        // hardwired vals
        ctrl_status_bpif.request_stall = 1'b0;
        ctrl_status_bpif.error = 1'b0;

        // default vals
        ctrl_status_bpif.rdata = 32'h0;
        ctrl_status_start_triggered = 1'b0;
        next_ctrl_status_PC_reset_val = ctrl_status_PC_reset_val;

        // AHB read logic: 
            // match addr if lower 14:2 bits match

        // busy reg read
        if (ctrl_status_bpif.addr[14:2] == BUSY_REG_AHB_BASE_ADDR[14:2])
        begin
            // ctrl_status_bpif.rdata = {31'h0, ctrl_status_busy};
            ctrl_status_bpif.rdata = {31'h0, ~ctrl_status_reset_state}; 
                // actually want this since busy high when Vortex resetting
        end

        // start reg read --> default/0
    
        // PC reg read
        else if (ctrl_status_bpif.addr[14:2] == PC_RESET_VAL_REG_AHB_BASE_ADDR[14:2])
        begin
            ctrl_status_bpif.rdata = ctrl_status_PC_reset_val;
        end

        // AHB write logic:
            // match addr if lower 14:2 bits match

        // only care about writes to start reg and PC reg
        if (ctrl_status_bpif.wen)
        begin
            // busy reg write --> no good

            // start reg write 1
            if (ctrl_status_bpif.strobe[0] & 
                ctrl_status_bpif.addr[14:2] == START_REG_AHB_BASE_ADDR[14:2] &
                ctrl_status_bpif.wdata[0])
            begin
                ctrl_status_start_triggered = 1'b1;
            end

            // PC reg write
            if (ctrl_status_bpif.addr[14:2] == PC_RESET_VAL_REG_AHB_BASE_ADDR[14:2])
            begin
                if (ctrl_status_bpif.strobe[0]) next_ctrl_status_PC_reset_val[7:0] = ctrl_status_bpif.wdata[7:0];
                if (ctrl_status_bpif.strobe[1]) next_ctrl_status_PC_reset_val[15:8] = ctrl_status_bpif.wdata[15:8];
                if (ctrl_status_bpif.strobe[2]) next_ctrl_status_PC_reset_val[23:16] = ctrl_status_bpif.wdata[23:16];
                if (ctrl_status_bpif.strobe[3]) next_ctrl_status_PC_reset_val[31:24] = ctrl_status_bpif.wdata[31:24]; 
            end
        end
    end

    always_comb begin : Vortex_ctrl_status_connections_comb_logic

        // hardwire busy to reg
        next_ctrl_status_busy = Vortex_busy;

        // hardwire PC reset val from reg
        Vortex_PC_reset_val = ctrl_status_PC_reset_val;
    end

endmodule