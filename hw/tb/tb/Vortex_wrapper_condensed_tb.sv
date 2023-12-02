// Zach Lagpacan - zlagpaca@purdue.edu
//
// EXPECT simple.hex (or any program that terminates/busy goes low) in Vortex_mem_slave 

// `include "local_mem.vh"
`include "include/VX_define.vh"
`include "Vortex_mem_slave.vh"

`timescale 1 ns / 1 ns

// testbench parameters
parameter SET_PC_RESET_VAL = 0;
parameter RUN_TWICE = 0;
parameter USE_WRAPPER = 1;

// wrapper parameters
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000;
// parameter MEM_SLAVE_AHB_BASE_ADDR = 32'h8000_0000; // testing address, where old binaries expect
parameter BUSY_REG_AHB_BASE_ADDR = 32'hF000_8000;
parameter START_REG_AHB_BASE_ADDR = 32'hF000_8004;
parameter PC_RESET_VAL_REG_AHB_BASE_ADDR = 32'hF000_8008;
// parameter PC_RESET_VAL_RESET_VAL = MEM_SLAVE_AHB_BASE_ADDR;
parameter PC_RESET_VAL_RESET_VAL = 32'hF000_0000; // testing PC reset val switch 0xF -> 0x8
parameter MEM_SLAVE_ADDR_SPACE_BITS = 15;
parameter BUFFER_WIDTH = 1;

module Vortex_wrapper_condensed_tb; 

    logic clk = 0, nRST;

    logic                             Vortex_mem_req_valid;
    logic                             Vortex_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]  Vortex_mem_req_byteen; // 64 (512 / 8)
    logic [`VX_MEM_ADDR_WIDTH-1:0]    Vortex_mem_req_addr;   // 26
    logic [`VX_MEM_DATA_WIDTH-1:0]    Vortex_mem_req_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]     Vortex_mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    logic                            Vortex_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                            Vortex_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]   Vortex_mem_rsp_data;   // 512
    logic [`VX_MEM_TAG_WIDTH-1:0]    Vortex_mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    logic                             Vortex_mem_rsp_ready;

    ///////////////////////////////////////////
    // AHB Subordinate for Vortex_mem_slave: //
    ///////////////////////////////////////////

    bus_protocol_if        mem_slave_bpif();
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

    bus_protocol_if        ctrl_status_bpif();
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

    ahb_if #(
        // .DATA_WIDTH(AHB_DATA_WIDTH),
        .DATA_WIDTH(32),
        // .ADDR_WIDTH(AHB_ADDR_WIDTH)
        .ADDR_WIDTH(32)
    ) ahb_manager_ahbif (.HCLK(clk), .HRESETn(nRST));
        // logic HSEL;
        // logic HREADY; // UNUSED?
        // logic HREADYOUT; // UNUSED?
        // logic HWRITE;
        // logic HMASTLOCK; // UNUSED
        // logic HRESP;
        // logic [1:0] HTRANS;
        // logic [2:0] HBURST; // UNUSED
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

    logic Vortex_busy;
    logic Vortex_reset;
    logic [32-1:0] Vortex_PC_reset_val;

    // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
    if (!USE_WRAPPER) begin

    //////////////////////////////////////
    // Vortex_wrapper_no_Vortex module: //
    //////////////////////////////////////

    Vortex_wrapper_no_Vortex_condensed #(
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

    end

    // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
    else begin

    Vortex_wrapper_condensed #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_SLAVE_AHB_BASE_ADDR(MEM_SLAVE_AHB_BASE_ADDR),
        .BUSY_REG_AHB_BASE_ADDR(BUSY_REG_AHB_BASE_ADDR),
        .START_REG_AHB_BASE_ADDR(START_REG_AHB_BASE_ADDR),
        .PC_RESET_VAL_REG_AHB_BASE_ADDR(PC_RESET_VAL_REG_AHB_BASE_ADDR),
        .PC_RESET_VAL_RESET_VAL(PC_RESET_VAL_RESET_VAL),
        .MEM_SLAVE_ADDR_SPACE_BITS(MEM_SLAVE_ADDR_SPACE_BITS),
        .BUFFER_WIDTH(BUFFER_WIDTH)
    ) Vortex_wrapper_Instance (
        .clk(clk),
        .nRST(nRST),
        .mem_slave_bpif(mem_slave_bpif),
        .ctrl_status_bpif(ctrl_status_bpif),
        .ahb_manager_ahbif(ahb_manager_ahbif)
    );

    end
    // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //

    /////////////////////////////
    // Testbench Info Signals: //
    /////////////////////////////

    // testbench info signal declarations
    string test_case;
    string sub_test_case;
    int num_errors;
    localparam PERIOD = 20;

    int delay;
    int cycle_count;
    int poll_period;
    logic program_terminated;

    /////////////////////////////////
    // Testbench Expected Signals: //
    /////////////////////////////////

    // Vortex req wrapper outputs
    logic expected_Vortex_mem_req_ready;

    // Vortex rsp wrapper outputs
    logic expected_Vortex_mem_rsp_valid; 
    logic [`VX_MEM_DATA_WIDTH-1:0] expected_Vortex_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0] expected_Vortex_mem_rsp_tag;

    // Vortex_mem_slave bpif outputs
    logic [DATA_WIDTH-1:0] expected_mem_slave_bpif_rdata;
    logic expected_mem_slave_bpif_error;
    logic expected_mem_slave_bpif_request_stall;

    // CTRL/Status reg bpif outputs
    logic [DATA_WIDTH-1:0] expected_ctrl_status_bpif_rdata;
    logic expected_ctrl_status_bpif_error;
    logic expected_ctrl_status_bpif_request_stall;

    // CTRL/Status outputs
    logic expected_Vortex_reset;
    logic [32-1:0] expected_Vortex_PC_reset_val;

    // VX_ahb_manager ahbif outputs
    logic expected_ahb_manager_ahbif_HWRITE;
    // logic expected_ahb_manager_ahbif_HMASTLOCK; // UNUSED
    logic [1:0] expected_ahb_manager_ahbif_HTRANS;
    // logic [2:0] expected_ahb_manager_ahbif_HBURST; // UNUSED
    logic [2:0] expected_ahb_manager_ahbif_HSIZE;
    logic [ADDR_WIDTH-1:0] expected_ahb_manager_ahbif_HADDR;
    logic [DATA_WIDTH-1:0] expected_ahb_manager_ahbif_HWDATA;
    logic [(DATA_WIDTH/8)-1:0] expected_ahb_manager_ahbif_HWSTRB;
    logic expected_ahb_manager_ahbif_HSEL;

    ///////////////
    // tb tasks: //
    ///////////////

    task set_default_inputs();
    begin
        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = 32'h0;
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        // VX_ahb_manager ahbif inputs
        ahb_manager_ahbif.HRESP = 1'b0;
        ahb_manager_ahbif.HRDATA = 32'h0;
        ahb_manager_ahbif.HREADYOUT = 1;
    end
    endtask

    localparam MAX_WIDTH = 32;
    task check_signal(
        string signal_name,
        logic [MAX_WIDTH-1:0] real_val, 
        logic [MAX_WIDTH-1:0] expected_val
    );
    begin
        assert(real_val === expected_val) 
        begin
            // fill in?
        end
        else
        begin
            $display($sformatf("\t\tTB ERROR: incorrect output for %s = 0x%h | expect 0x%h",
                signal_name,
                real_val,
                expected_val
            ));
            num_errors++;
        end
    end
    endtask

    task check_Vortex_data(
        string signal_name,
        logic [512-1:0] real_val, 
        logic [512-1:0] expected_val
    );
    begin
        assert(real_val === expected_val) 
        begin
            // fill in?
        end
        else
        begin
            $display($sformatf("\t\tTB ERROR: incorrect 512-bit data output for %s", signal_name));

            // iterate through 16 words
            for (int i = 15; i >= 0; i--) 
            begin
                $display($sformatf("\t\t\tword %h: output = %h | expected = %h", 4'(i), 32'(real_val>>(32*i)), 32'(expected_val>>(32*i))));
            end
            
            num_errors++;
        end
    end
    endtask

    task check_Vortex_tag(
        string signal_name,
        logic [56-1:0] real_val, 
        logic [56-1:0] expected_val
    );
    begin
        assert(real_val === expected_val) 
        begin
            // fill in?
        end
        else
        begin
            $display($sformatf("\t\tTB ERROR: incorrect 56-bit tag output for %s", signal_name));

            // iterate through 7 bytes
            for (int i = 6; i >= 0; i--) 
            begin
                $display($sformatf("\t\t\toutput = %h | expected = %h", 8'(real_val>>(8*i)), 8'(expected_val>>(8*i))));
            end

            num_errors++;
        end
    end
    endtask
    
    task check_Vortex_wrapper_req_outputs();
    begin
        // Vortex req wrapper outputs
        check_signal("Vortex_mem_req_ready", Vortex_mem_req_ready, expected_Vortex_mem_req_ready);
    end
    endtask

    task check_Vortex_wrapper_rsp_outputs();
    begin
        // Vortex rsp wrapper outputs
        check_signal("Vortex_mem_rsp_valid", Vortex_mem_rsp_valid, expected_Vortex_mem_rsp_valid);
        check_Vortex_data("Vortex_mem_rsp_data", Vortex_mem_rsp_data, expected_Vortex_mem_rsp_data);
        check_Vortex_tag("Vortex_mem_rsp_tag", Vortex_mem_rsp_tag, expected_Vortex_mem_rsp_tag);
    end
    endtask

    task check_Vortex_mem_slave_bpif_outputs();
    begin
        // Vortex_mem_slave bpif outputs
        check_signal("mem_slave_bpif.rdata", mem_slave_bpif.rdata, expected_mem_slave_bpif_rdata);
        check_signal("mem_slave_bpif.error", mem_slave_bpif.error, expected_mem_slave_bpif_error);
        check_signal("mem_slave_bpif.request_stall", mem_slave_bpif.request_stall, expected_mem_slave_bpif_request_stall);
    end
    endtask

    task check_ctrl_status_reg_bpif_outputs();
    begin
        // CTRL/Status reg bpif outputs
        check_signal("ctrl_status_bpif.rdata", ctrl_status_bpif.rdata, expected_ctrl_status_bpif_rdata);
        check_signal("ctrl_status_bpif.error", ctrl_status_bpif.error, expected_ctrl_status_bpif_error);
        check_signal("ctrl_status_bpif.request_stall", ctrl_status_bpif.request_stall, expected_ctrl_status_bpif_request_stall);
    end
    endtask

    task check_Vortex_wrapper_ctrl_status_outputs();
    begin
        // CTRL/Status outputs
        check_signal("Vortex_reset", Vortex_reset, expected_Vortex_reset);
        check_signal("Vortex_PC_reset_val", Vortex_PC_reset_val, expected_Vortex_PC_reset_val);
    end
    endtask

    task check_ahb_manager_ahbif_outputs();
    begin
        // VX_ahb_manager ahbif outputs
        check_signal("ahb_manager_ahbif.HWRITE", ahb_manager_ahbif.HWRITE, expected_ahb_manager_ahbif_HWRITE);
        // check_signal("ahb_manager_ahbif.HMASTLOCK", ahb_manager_ahbif.HMASTLOCK, expected_ahb_manager_ahbif_HMASTLOCK); // UNUSED
        check_signal("ahb_manager_ahbif.HTRANS", ahb_manager_ahbif.HTRANS, expected_ahb_manager_ahbif_HTRANS);
        // check_signal("ahb_manager_ahbif.HBURST", ahb_manager_ahbif.HBURST, expected_ahb_manager_ahbif_HBURST); // UNUSED
        check_signal("ahb_manager_ahbif.HSIZE", ahb_manager_ahbif.HSIZE, expected_ahb_manager_ahbif_HSIZE);
        check_signal("ahb_manager_ahbif.HADDR", ahb_manager_ahbif.HADDR, expected_ahb_manager_ahbif_HADDR);
        check_signal("ahb_manager_ahbif.HWDATA", ahb_manager_ahbif.HWDATA, expected_ahb_manager_ahbif_HWDATA);
        check_signal("ahb_manager_ahbif.HWSTRB", ahb_manager_ahbif.HWSTRB, expected_ahb_manager_ahbif_HWSTRB);
        check_signal("ahb_manager_ahbif.HSEL", ahb_manager_ahbif.HSEL, expected_ahb_manager_ahbif_HSEL);
    end
    endtask

    task check_outputs();
    begin
        // // Vortex req wrapper outputs
        // check_signal("Vortex_mem_req_ready", Vortex_mem_req_ready, expected_Vortex_mem_req_ready);
        // check_Vortex_wrapper_req_outputs();

        // // Vortex rsp wrapper outputs
        // check_signal("Vortex_mem_rsp_valid", Vortex_mem_rsp_valid, expected_Vortex_mem_rsp_valid);
        // check_signal("Vortex_mem_rsp_data", Vortex_mem_rsp_data, expected_Vortex_mem_rsp_data);
        // check_signal("Vortex_mem_rsp_tag", Vortex_mem_rsp_tag, expected_Vortex_mem_rsp_tag);
        // check_Vortex_wrapper_rsp_outputs();

        // // Vortex_mem_slave bpif outputs
        // check_signal("mem_slave_bpif.rdata", mem_slave_bpif.rdata, expected_mem_slave_bpif_rdata);
        // check_signal("mem_slave_bpif.error", mem_slave_bpif.error, expected_mem_slave_bpif_error);
        // check_signal("mem_slave_bpif.request_stall", mem_slave_bpif.request_stall, expected_mem_slave_bpif_request_stall);
        check_Vortex_mem_slave_bpif_outputs();

        // // CTRL/Status reg bpif outputs
        // check_signal("ctrl_status_bpif.rdata", ctrl_status_bpif.rdata, expected_ctrl_status_bpif_rdata);
        // check_signal("ctrl_status_bpif.error", ctrl_status_bpif.error, expected_ctrl_status_bpif_error);
        // check_signal("ctrl_status_bpif.request_stall", ctrl_status_bpif.request_stall, expected_ctrl_status_bpif_request_stall);
        check_ctrl_status_reg_bpif_outputs();

        // // CTRL/Status outputs
        // check_signal("Vortex_reset", Vortex_reset, expected_Vortex_reset);
        // check_signal("Vortex_PC_reset_val", Vortex_PC_reset_val, expected_Vortex_PC_reset_val);
        
        // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
        if (!USE_WRAPPER) begin
        check_Vortex_wrapper_ctrl_status_outputs();
        end
        // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //

        // // VX_ahb_manager ahbif outputs
        // check_signal("ahb_manager_ahbif.HWRITE", ahb_manager_ahbif.HWRITE, expected_ahb_manager_ahbif_HWRITE);
        // // check_signal("ahb_manager_ahbif.HMASTLOCK", ahb_manager_ahbif.HMASTLOCK, expected_ahb_manager_ahbif_HMASTLOCK); // UNUSED
        // check_signal("ahb_manager_ahbif.HTRANS", ahb_manager_ahbif.HTRANS, expected_ahb_manager_ahbif_HTRANS);
        // // check_signal("ahb_manager_ahbif.HBURST", ahb_manager_ahbif.HBURST, expected_ahb_manager_ahbif_HBURST); // UNUSED
        // check_signal("ahb_manager_ahbif.HSIZE", ahb_manager_ahbif.HSIZE, expected_ahb_manager_ahbif_HSIZE);
        // check_signal("ahb_manager_ahbif.HADDR", ahb_manager_ahbif.HADDR, expected_ahb_manager_ahbif_HADDR);
        // check_signal("ahb_manager_ahbif.HWDATA", ahb_manager_ahbif.HWDATA, expected_ahb_manager_ahbif_HWDATA);
        // check_signal("ahb_manager_ahbif.HWSTRB", ahb_manager_ahbif.HWSTRB, expected_ahb_manager_ahbif_HWSTRB);
        // check_signal("ahb_manager_ahbif.HSEL", ahb_manager_ahbif.HSEL, expected_ahb_manager_ahbif_HSEL);
        check_ahb_manager_ahbif_outputs();
    end
    endtask

    task set_default_outputs();
    begin
        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'hFC10_2573; // default for simple.hex
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0;
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;

        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL;

        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b0;
        // expected_ahb_manager_ahbif_HMASTLOCK = 1'b0; // UNUSED
        expected_ahb_manager_ahbif_HTRANS = 2'h0;
        // expected_ahb_manager_ahbif_HBURST = 3'h0; // UNUSED
        expected_ahb_manager_ahbif_HSIZE = 3'h0;
        expected_ahb_manager_ahbif_HADDR = 32'h0;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HWSTRB = 4'b0;
        expected_ahb_manager_ahbif_HSEL = 1'b0;
    end
    endtask

    task poll_busy_reg (
        logic expected_busy_val
    );
    begin
        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        // Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 1):
        sub_test_case = "check AHB rsp busy reg = 1";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0;
        // expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL; // previous val is correct
        // check_outputs();

        // only check ctrl/status

        // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
        if (!USE_WRAPPER) begin
        check_Vortex_wrapper_ctrl_status_outputs();
        end
        // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
        
        check_ctrl_status_reg_bpif_outputs();
        check_ahb_manager_ahbif_outputs();
    end
    endtask

    /////////////
    // clkgen: //
    /////////////

    always #(PERIOD/2) clk++;

    ////////////////////////////
    // Simulation Time Block: //
    ////////////////////////////

    initial begin 

        /* --------------------------------------------------------------------------------------------- */
        // Reset Testing
        $display();
        test_case = "Reset Testing";
        $display("test_case: ", test_case);

        // default wrapper inputs:
        set_default_inputs();

        nRST = 1'b0;
        sub_test_case = "reset asserted";
        $display("\tsub_test_case: ", sub_test_case);
        #(4*PERIOD); // long enough reset for Vortex
        #(PERIOD/2);

        sub_test_case = "checking values during reset";
        $display("\tsub_test_case: ", sub_test_case);

        // default wrapper outputs:
        set_default_outputs();

        // do checks
        check_outputs();

        #(PERIOD/2);

        nRST = 1'b1;
        sub_test_case = "reset deasserted";
        $display("\tsub_test_case: ", sub_test_case);

        #(PERIOD/2);

        sub_test_case = "checking values after reset";
        $display("\tsub_test_case: ", sub_test_case);

        // do checks
        check_outputs();

        #(PERIOD/2);
        
        /* --------------------------------------------------------------------------------------------- */
        // Vortex Idle
        $display();
        test_case = "Vortex Reset";
        $display("test_case: ", test_case);

        #(PERIOD * 10);
        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Vortex Prelim Checks
        $display();
        test_case = "Vortex Prelim Checks";
        $display("test_case: ", test_case);

        #(PERIOD/2);

        ////////////////////
        // read busy low: //
        //////////////////// 

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        // Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL;
        check_outputs();

        /////////////////////////////////////
        // delay before start reg val set: //
        /////////////////////////////////////

        sub_test_case = "delay before start reg val set";
        $display("\tsub_test_case: ", sub_test_case);

        #(20 * PERIOD);
        @(posedge clk);

        ////////////////////
        // read busy low: //
        //////////////////// 

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        // Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL;
        check_outputs();
        
        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Set Vortex PC Reset Val
        $display();
        test_case = "Set Vortex PC Reset Val";
        $display("test_case: ", test_case);

        if (SET_PC_RESET_VAL) begin

        //////////////////////////
        // set PC register val: //
        //////////////////////////

        #(PERIOD/2);

        // make AHB side write req to PC reg:
        sub_test_case = "AHB write to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = MEM_SLAVE_AHB_BASE_ADDR; // write val
        ctrl_status_bpif.strobe = 4'b1111;

        // wait for write to occur
        #(PERIOD);
        #(PERIOD/2);

        // make AHB side read req to PC reg:
        sub_test_case = "AHB read to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read PC reg = MEM_SLAVE_AHB_BASE_ADDR):
        sub_test_case = "check AHB rsp PC reg = MEM_SLAVE_AHB_BASE_ADDR";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = MEM_SLAVE_AHB_BASE_ADDR; // PC reg = MEM_SLAVE_AHB_BASE_ADDR
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = MEM_SLAVE_AHB_BASE_ADDR;
        check_outputs();

        @(posedge clk);

        end

        /* --------------------------------------------------------------------------------------------- */
        // Vortex Start
        $display();
        test_case = "Vortex Start";
        $display("test_case: ", test_case);

        ////////////////////////
        // set start reg val: //
        ////////////////////////

        #(PERIOD/2);

        // make AHB side write req to start reg:
        sub_test_case = "AHB write to start reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h4; // 0xF000_8004 truncated -> 0x4
        ctrl_status_bpif.wdata = 32'h1; // write val
        ctrl_status_bpif.strobe = 4'b0001; // write mask (expect 00000001)

        // wait for write to occur
        #(PERIOD);

        // deassert write

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0; 
        ctrl_status_bpif.wdata = 32'h0; 
        ctrl_status_bpif.strobe = 4'b0; 

        #(PERIOD/2);

        // check Vortex reset = 0
        sub_test_case = "check Vortex reset = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // defaulting to read busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0; // reset should go low since wrote to start reg, busy high
        // expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL; // previous val set to is desired val

        check_outputs();

        #(PERIOD/2);

        /* --------------------------------------------------------------------------------------------- */
        // Vortex Running
        $display();
        test_case = "Vortex Running";
        $display("test_case: ", test_case);

        cycle_count = 0;
        delay = 10000;
        poll_period = delay / 10; // poll at most 10 times
        program_terminated = 0;

        fork 
            // check for busy low
            // begin
            //     // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
            //     if (!USE_WRAPPER) begin
            //     @(negedge Vortex_busy);
            //     end
            //     // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //
            //     else
            //     begin
            //     @(negedge Vortex_wrapper_Instance.Vortex_busy);
            //     end
            //     // o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o o //

            //     $display();
            //     $display("SUCCESS: program finished after %d cycles, got busy low", cycle_count);

            //     program_terminated = 1;
            // end

            // check if never finishes
            begin
                #(PERIOD * delay);

                $display();
                $display("ERROR: program never finished, stopped at %d cycles", cycle_count);
                num_errors++;
            end

            // iterate cycle count
            begin
                while (1) begin
                    #(PERIOD/2);
                    cycle_count++;
                    #(PERIOD/2);
                end
            end

            // periodically poll
            begin
                while (1) begin
                    @(posedge clk);

                    #(PERIOD * poll_period);

                    poll_busy_reg(1'b0);
                end
            end
        join_any

        disable fork;

        @(posedge clk);

        if (program_terminated) begin

        /* --------------------------------------------------------------------------------------------- */
        // Check Busy Reg = 0
        $display();
        test_case = "Check Busy Reg = 0";
        $display("test_case: ", test_case);
        
        ////////////////////
        // read busy low: //
        //////////////////// 

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        // Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        // expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL; // previous val is desired val
        check_outputs();

        @(posedge clk);

        end

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        if (RUN_TWICE) begin

        /* --------------------------------------------------------------------------------------------- */
        // Delay Between Runs
        $display();
        test_case = "Delay Between Runs";
        $display("test_case: ", test_case);
        #(PERIOD);

        /* --------------------------------------------------------------------------------------------- */
        // Vortex Start
        $display();
        test_case = "Vortex Start (run 2)";
        $display("test_case: ", test_case);

        //////////////////////////
        // set PC register val: //
        //////////////////////////

        #(PERIOD/2);

        // make AHB side write req to PC reg:
        sub_test_case = "AHB write to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'hC000_0000; // VX_ahb_adapter address space
        ctrl_status_bpif.strobe = 4'b1111;

        // wait for write to occur
        #(PERIOD);

        // make AHB side read req to PC reg:
        sub_test_case = "AHB read to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read PC reg = MEM_SLAVE_AHB_BASE_ADDR):
        sub_test_case = "check AHB rsp PC reg = MEM_SLAVE_AHB_BASE_ADDR";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hC000_0000; // VX_ahb_adapter address space
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hC000_0000; // VX_ahb_adapter address space
        check_outputs();

        @(posedge clk);

        ////////////////////////
        // set start reg val: //
        ////////////////////////

        #(PERIOD/2);

        // make AHB side write req to start reg:
        sub_test_case = "AHB write to start reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h4; // 0xF000_8004 truncated -> 0x4
        ctrl_status_bpif.wdata = 32'h1; // write val
        ctrl_status_bpif.strobe = 4'b0001; // write mask (expect 00000001)

        // wait for write to occur
        #(PERIOD);

        // deassert write

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0; 
        ctrl_status_bpif.wdata = 32'h0; 
        ctrl_status_bpif.strobe = 4'b0; 

        #(PERIOD);

        // check Vortex reset = 0
        sub_test_case = "check Vortex reset = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // defaulting to read busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0; // reset should go low since wrote to start reg, busy high
        // expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL; // previous val set to is desired val

        check_outputs();

        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Vortex Running
        $display();
        test_case = "Vortex Running (run 2)";
        $display("test_case: ", test_case);

        cycle_count = 0;
        delay = 10000;
        poll_period = delay / 10; // poll at most 10 times
        program_terminated = 0;

        fork 
            // check for busy low
            begin
                
                @(negedge Vortex_busy);
                $display();
                $display("SUCCESS: program finished after %d cycles, got busy low", cycle_count);

                program_terminated = 1;
            end

            // check if never finishes
            begin
                #(PERIOD * delay);

                $display();
                $display("ERROR: program never finished, stopped at %d cycles", cycle_count);
                num_errors++;
            end

            // iterate cycle count
            begin
                while (1) begin
                    #(PERIOD/2);
                    cycle_count++;
                    #(PERIOD/2);
                end
            end

            // periodically poll
            begin
                @(posedge clk);

                while (1) begin
                    #(PERIOD * poll_period);

                    poll_busy_reg(1'b0);
                end
            end

            // take care of responses to 
            begin
                while (1) begin

                    
                end
            end
        join_any

        disable fork;

        @(posedge clk);

        if (program_terminated) begin

        /* --------------------------------------------------------------------------------------------- */
        // Check Busy Reg = 0
        $display();
        test_case = "Check Busy Reg = 0 (run 2)";
        $display("test_case: ", test_case);
        
        ////////////////////
        // read busy low: //
        //////////////////// 

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        // Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        // expected_Vortex_PC_reset_val = PC_RESET_VAL_RESET_VAL; // previous val is desired val
        check_outputs();

        @(posedge clk);

        end

        end

        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////////////////////////////

        /* --------------------------------------------------------------------------------------------- */
        // End of Testbench
        $display();
        test_case = "End of Testbench";
        $display("test_case: ", test_case);
        #(PERIOD);

        // check for errors
        if (num_errors)
        begin
            $display($sformatf("\nERROR: %d Errors in Testbench", num_errors));
        end
        else
        begin
            $display("\nSUCCESS: No Errors in Testbench");
        end

        // finish
        $display();
        // $finish();
        $stop();
    end 


endmodule 