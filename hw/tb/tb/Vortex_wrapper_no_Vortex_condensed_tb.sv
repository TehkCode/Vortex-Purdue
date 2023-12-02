/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    testbench for Vortex_mem_slave, simulating memory interface and AHB generic bus interface
*/

// temporary include to have defined vals
`include "Vortex_mem_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"

`timescale 1 ns / 1 ns

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000;
parameter BUSY_REG_AHB_BASE_ADDR = 32'hF000_8000;
parameter START_REG_AHB_BASE_ADDR = 32'hF000_8004;
parameter PC_RESET_VAL_REG_AHB_BASE_ADDR = 32'hF000_8008;
parameter PC_RESET_VAL_RESET_VAL = MEM_SLAVE_AHB_BASE_ADDR;
parameter MEM_SLAVE_ADDR_SPACE_BITS = 14;
parameter BUFFER_WIDTH = 1;

module Vortex_wrapper_no_Vortex_condensed_tb ();

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

    ////////////////////////////////////////////////
    // Vortex_wrapper_no_Vortex_condensed module: //
    ////////////////////////////////////////////////

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
    ) DUT (.*);

    /////////////////////////////
    // Testbench Info Signals: //
    /////////////////////////////

    // testbench info signal declarations
    string test_case;
    string sub_test_case;
    int num_errors;
    localparam PERIOD = 20;

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

    /////////////
    // clkgen: //
    /////////////

    always #(PERIOD/2) clk++;

    //////////////////////
    // Testbench tasks: //
    //////////////////////

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
        check_Vortex_wrapper_req_outputs();

        // // Vortex rsp wrapper outputs
        // check_signal("Vortex_mem_rsp_valid", Vortex_mem_rsp_valid, expected_Vortex_mem_rsp_valid);
        // check_signal("Vortex_mem_rsp_data", Vortex_mem_rsp_data, expected_Vortex_mem_rsp_data);
        // check_signal("Vortex_mem_rsp_tag", Vortex_mem_rsp_tag, expected_Vortex_mem_rsp_tag);
        check_Vortex_wrapper_rsp_outputs();

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
        check_Vortex_wrapper_ctrl_status_outputs();

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
    endtask;

    task set_default_inputs();
    begin
        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b0;
        Vortex_mem_req_rw = 1'b0;
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0000;
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0;

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

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

        // CTRL/Status inputs
        Vortex_busy = 1'b0;

        // VX_ahb_manager ahbif inputs
        ahb_manager_ahbif.HRESP = 1'b0;
        ahb_manager_ahbif.HRDATA = 32'h0;
        ahb_manager_ahbif.HREADYOUT = 1;
    end
    endtask

    task gen_ahb_trans(
    input rw, 
    input logic [63:0] byte_en,
    input logic [25:0] addr,
    input logic [511:0] req_data,
    input logic [55:0] req_tag,
    input logic vx_ready_for_rsp
    );
    begin
        Vortex_mem_req_valid = 1'b1;
        Vortex_mem_req_rw = rw;
        Vortex_mem_req_byteen = byte_en;
        Vortex_mem_req_addr = addr;
        Vortex_mem_req_data = req_data;
        Vortex_mem_req_tag = req_tag;
        Vortex_mem_rsp_ready = vx_ready_for_rsp;
        #(PERIOD);
        Vortex_mem_req_valid = 1'b0;
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
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0;
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;

        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hF000_0000;

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

    function logic [31:0] calculate_min_32_addr_Vortex_mem_slave();
    begin
        return 32'h0; // bpif takes care of address offset
    end
    endfunction
    
    function logic [31:0] calculate_max_32_addr_Vortex_mem_slave();
    begin
        if (MEM_SLAVE_ADDR_SPACE_BITS < 6) return 32'h0;
        else return (1 << MEM_SLAVE_ADDR_SPACE_BITS) - 4;
    end
    endfunction

    function logic [25:0] calculate_min_26_addr_Vortex_mem_slave();
    begin
        return (MEM_SLAVE_AHB_BASE_ADDR >> 6);
    end
    endfunction

    function logic [25:0] calculate_max_26_addr_Vortex_mem_slave();
    begin
        // return (MEM_SLAVE_AHB_BASE_ADDR[32-1:32-26] + (1 << (MEM_SLAVE_ADDR_SPACE_BITS - 6)) - 1);
        if (MEM_SLAVE_ADDR_SPACE_BITS < 6) return 26'h0;
        else return calculate_min_26_addr_Vortex_mem_slave() + (1 << (MEM_SLAVE_ADDR_SPACE_BITS - 6)) - 1;
    end
    endfunction

    function logic [25:0] calculate_min_26_addr_VX_ahb_adapter();
    begin
        // return BUSY_REG_AHB_BASE_ADDR[32-1:32-26];
        return BUSY_REG_AHB_BASE_ADDR >> 6;
    end
    endfunction

    function logic [25:0] calculate_min_26_addr_between();
    begin
        if (MEM_SLAVE_ADDR_SPACE_BITS < 6) return calculate_min_26_addr_Vortex_mem_slave();
        else return calculate_max_26_addr_Vortex_mem_slave() + 1;
    end
    endfunction

    function logic [25:0] calculate_max_26_addr_between();
    begin
        return (BUSY_REG_AHB_BASE_ADDR >> 6) - 1;
    end
    endfunction

    //////////////////////////////
    // Testbench initial block: //
    //////////////////////////////

    initial begin

        $display();
        $display("Testing with MEM_SLAVE_ADDR_SPACE_BITS = ", MEM_SLAVE_ADDR_SPACE_BITS);

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
        // FSM, Mem-Mapped Reg Testing
        @(posedge clk);
        $display();
        test_case = "FSM, Mem-Mapped Reg Testing";
        $display("test_case: ", test_case);

        ////////////////////////////////////
        // check ctrl/status reset state: //
        ////////////////////////////////////
        
        // make AHB side read req to busy reg:
        sub_test_case = "AHB req to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        check_outputs();

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

        // check rsp (read PC reg = 0xF000_0000):
        sub_test_case = "check AHB rsp PC reg = 0xF000_0000";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hF000_0000; // PC reg = 0xF000_0000
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        check_outputs();

        #(PERIOD/2);

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
        ctrl_status_bpif.wdata = 32'hABCD3210; // write val
        ctrl_status_bpif.strobe = 4'b1101; // write mask (expect ABCD0010)

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

        // check rsp (read PC reg = 0xABCD_0010):
        sub_test_case = "check AHB rsp PC reg = 0xABCD_0010";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hABCD_0010; // PC reg = 0xABCD_0010
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hABCD_0010;
        check_outputs();

        #(PERIOD/2);

        /////////////////////
        // read busy high: //
        ///////////////////// 

        #(PERIOD/2);

        // set busy high
        sub_test_case = "set busy high";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        Vortex_busy = 1'b1;

        // wait for busy to propagate
        #(PERIOD);

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
        Vortex_busy = 1'b1;

        #(PERIOD/2);

        // check rsp (read busy reg = 1):
        sub_test_case = "check AHB rsp busy reg = 1";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        // expected_ctrl_status_bpif_rdata = 32'h1; // busy reg = 1
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 0, reliant on state now (based on busy going low or setting reg high)
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hABCD_0010;
        check_outputs();

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

        // check Vortex reset = 1
        sub_test_case = "check Vortex reset = 1 (before propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // defaulting to read busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1; // reset should go low since wrote to start reg, busy high
        expected_Vortex_PC_reset_val = 32'hABCD_0010;
        check_outputs();

        // ACCOUNT FOR REGISTERED Vortex_reset
        #(PERIOD);

        // check Vortex reset = 0
        sub_test_case = "check Vortex reset = 0 (after propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // defaulting to read busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0; // reset should go low since wrote to start reg, busy high
        expected_Vortex_PC_reset_val = 32'hABCD_0010;
        check_outputs();

        #(PERIOD/2);

        /* --------------------------------------------------------------------------------------------- */
        // Vortex_mem_slave Vortex Side Testing
        @(posedge clk);
        $display();
        test_case = "Vortex_mem_slave Vortex Side Testing";
        $display("test_case: ", test_case);if (!calculate_max_32_addr_Vortex_mem_slave()) begin
            $display();
            $display("\tVortex_mem_slave not instantiated, skipping");
        end

        else begin

        $display();
        $display($sformatf("\tminimum Vortex_mem_slave Vortex side 26-bit address: %h", calculate_min_26_addr_Vortex_mem_slave()));
        $display($sformatf("\tmaximum Vortex_mem_slave Vortex side 26-bit address: %h", calculate_max_26_addr_Vortex_mem_slave()));
        $display();

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);
        #(PERIOD/2);

        ///////////////////////////////////
        // check read from min addr = 0: //
        ///////////////////////////////////

        sub_test_case = "read req to min addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_min_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'habc; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to min addr req = 0";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = 512'h0; // expect read = 0
        expected_Vortex_mem_rsp_tag = 56'habc;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////
        // check read from max addr = 0: //
        ///////////////////////////////////

        sub_test_case = "read req to max addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'hed5608; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to max addr req = 0";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = 512'h0; // expect read = 0
        expected_Vortex_mem_rsp_tag = 56'hed5608;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        ////////////////////////
        // write to min addr: //
        ////////////////////////

        sub_test_case = "write req to min addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'hf0f0f0f0f0f0f0f0; // skip some bytes
        Vortex_mem_req_addr = calculate_min_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = {8 
            {
                32'h01234567,
                32'h89abcdef
            }};
        Vortex_mem_req_tag = 56'h4d5f; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        ////////////////////////
        // write to max addr: //
        ////////////////////////

        sub_test_case = "write req to max addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'h0f0f0f0f0f0f0f0f; // skip some bytes
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = {8 
            {
                32'h01234567,
                32'h89abcdef
            }};
        Vortex_mem_req_tag = 56'h00123; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        /////////////////////////////////////////
        // check read from min addr = written: //
        /////////////////////////////////////////

        sub_test_case = "read req to min addr after write";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_min_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h327c; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to min addr req = 8{0x0123456700000000}";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = {8 
            {
                32'h01234567,
                32'h0
            }};
        expected_Vortex_mem_rsp_tag = 56'h327c;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        /////////////////////////////////////////
        // check read from max addr = written: //
        /////////////////////////////////////////

        sub_test_case = "read req to max addr after write";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h204; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to max addr req = 8{0x0000000089abcdef}";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = {8 
            {
                32'h0,
                32'h89abcdef
            }};
        expected_Vortex_mem_rsp_tag = 56'h204;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        end

        /* --------------------------------------------------------------------------------------------- */
        // Vortex_mem_slave AHB Side Testing
        @(posedge clk);
        $display();
        test_case = "Vortex_mem_slave AHB Side Testing";
        $display("test_case: ", test_case);

        if (!calculate_max_32_addr_Vortex_mem_slave()) begin
            $display();
            $display("\tVortex_mem_slave not instantiated, skipping");
        end

        else begin

        $display();
        $display($sformatf("\tminimum Vortex_mem_slave AHB side 32-bit address: %h", calculate_min_32_addr_Vortex_mem_slave()));
        $display($sformatf("\tmaximum Vortex_mem_slave AHB side 32-bit address: %h", calculate_max_32_addr_Vortex_mem_slave()));
        $display();

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);
        
        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);
        #(PERIOD/2);

        ///////////////////////////////////
        // check read from min addr = 0: //
        ///////////////////////////////////

        sub_test_case = "check read from min addr = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b1; // read
        mem_slave_bpif.addr = calculate_min_32_addr_Vortex_mem_slave(); // min addr
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0; // expect all zeros
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////
        // check read from max addr = 0: //
        ///////////////////////////////////

        sub_test_case = "check read from max addr = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b1; // read
        mem_slave_bpif.addr = calculate_max_32_addr_Vortex_mem_slave(); // max addr
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0; // expect all zeros
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////////////
        // check write to min addr = 0x76543210: //
        ///////////////////////////////////////////

        sub_test_case = "check write to min addr = 0x76543210";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b1; // write
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = calculate_min_32_addr_Vortex_mem_slave(); // min addr
        mem_slave_bpif.wdata = 32'h76543210;
        mem_slave_bpif.strobe = 4'b1111;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////////////
        // check write to max addr = 0xfedcba98: //
        ///////////////////////////////////////////

        sub_test_case = "check write to max addr = 0xfedcba98";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b1; // write
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = calculate_max_32_addr_Vortex_mem_slave(); // max addr
        mem_slave_bpif.wdata = 32'hfedcba98;
        mem_slave_bpif.strobe = 4'b1111;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////
        // check read from min addr = 0: //
        ///////////////////////////////////

        sub_test_case = "check read from min addr = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b1; // read
        mem_slave_bpif.addr = calculate_min_32_addr_Vortex_mem_slave(); // min addr
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h76543210; // expect val written
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////
        // check read from max addr = 0: //
        ///////////////////////////////////

        sub_test_case = "check read from max addr = 0";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b0;
        mem_slave_bpif.ren = 1'b1; // read
        mem_slave_bpif.addr = calculate_max_32_addr_Vortex_mem_slave(); // max addr
        mem_slave_bpif.wdata = 32'h0;
        mem_slave_bpif.strobe = 4'b0;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'hfedcba98; // expect written val
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        end

        /* --------------------------------------------------------------------------------------------- */
        // Vortex_mem_slave Mix Vortex/AHB Side Testing
        @(posedge clk);
        $display();
        test_case = "Vortex_mem_slave Mix Vortex/AHB Side Testing";
        $display("test_case: ", test_case);if (!calculate_max_32_addr_Vortex_mem_slave()) begin
            $display();
            $display("\tVortex_mem_slave not instantiated, skipping");
        end

        else begin

        $display();
        $display($sformatf("\tminimum Vortex_mem_slave Vortex side 26-bit address: %h", calculate_min_26_addr_Vortex_mem_slave()));
        $display($sformatf("\tmaximum Vortex_mem_slave Vortex side 26-bit address: %h", calculate_max_26_addr_Vortex_mem_slave()));
        $display($sformatf("\tminimum Vortex_mem_slave AHB side 32-bit address: %h", calculate_min_32_addr_Vortex_mem_slave()));
        $display($sformatf("\tmaximum Vortex_mem_slave AHB side 32-bit address: %h", calculate_max_32_addr_Vortex_mem_slave()));
        $display();

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);
        #(PERIOD/2);

        //////////////////////////////////////////////
        // AHB side write to min addr = 0xaaaa5555: //
        //////////////////////////////////////////////

        sub_test_case = "AHB side write to min addr = 0xaaaa5555";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b1; // write
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = calculate_min_32_addr_Vortex_mem_slave(); // min addr
        mem_slave_bpif.wdata = 32'haaaa5555;
        mem_slave_bpif.strobe = 4'b1111;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        //////////////////////////////////////////////
        // AHB side write to max addr = 0xcccc3333: //
        //////////////////////////////////////////////

        sub_test_case = "AHB side write to max addr = 0xcccc3333";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex_mem_slave bpif inputs
        mem_slave_bpif.wen = 1'b1; // write
        mem_slave_bpif.ren = 1'b0;
        mem_slave_bpif.addr = calculate_max_32_addr_Vortex_mem_slave(); // max addr
        mem_slave_bpif.wdata = 32'hcccc3333;
        mem_slave_bpif.strobe = 4'b1111;

        @(posedge clk);
        #(PERIOD/2);

        // Vortex_mem_slave bpif outputs
        expected_mem_slave_bpif_rdata = 32'h0;
        expected_mem_slave_bpif_error = 1'b0;
        expected_mem_slave_bpif_request_stall = 1'b0;

        check_outputs();

        @(posedge clk);

        ////////////////////////////////////
        // Vortex side write to min addr: //
        ////////////////////////////////////

        sub_test_case = "Vortex side write req to min addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'hfffffffffffffff5; // skip some bytes
        Vortex_mem_req_addr = calculate_min_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = {16 
            {
                32'h4567cdef
            }};
        Vortex_mem_req_tag = 56'hffffffffffffff; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        ////////////////////////////////////
        // Vortex side write to max addr: //
        ////////////////////////////////////

        sub_test_case = "write req to max addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'hafffffffffffffff; // skip some bytes
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = {16 
            {
                32'h012389ab
            }};
        Vortex_mem_req_tag = 56'h10000000000001; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        ///////////////////////////////////////////////
        // Vortex side read from min addr = written: //
        ///////////////////////////////////////////////

        sub_test_case = "Vortex side read req to min addr after writes";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_min_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h01111111111110; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to min addr req = <mess 1>";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = {
            {15 {
                32'h4567cdef
            }},
            {
                32'haa6755ef
            }};
        expected_Vortex_mem_rsp_tag = 56'h01111111111110;

        expected_mem_slave_bpif_rdata = 32'h0;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        ///////////////////////////////////////////////
        // Vortex side read from max addr = written: //
        ///////////////////////////////////////////////

        sub_test_case = "Vortex side read req to max addr after writes";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'hffff4444; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to max addr req = <mess 2>";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = {
            {
                32'h01cc8933
            },
            {15 {
                32'h012389ab
            }}};
        expected_Vortex_mem_rsp_tag = 56'hffff4444;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        end

        /* --------------------------------------------------------------------------------------------- */
        // Between Address Vortex Side Testing
        @(posedge clk);
        $display();
        test_case = "Between Address Vortex Side Testing";
        $display("test_case: ", test_case);

        if (!calculate_max_32_addr_Vortex_mem_slave()) begin
            $display();
            $display("\tVortex_mem_slave not instantiated, skipping");
        end

        else begin

        $display();
        $display($sformatf("\tminimum between Vortex side 26-bit address: %h", calculate_min_26_addr_between()));
        $display($sformatf("\tmaximum between Vortex side 26-bit address: %h", calculate_max_26_addr_between()));
        $display();

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);
        #(PERIOD/2);

        /////////////////////////////////////////////
        // check read from min addr falls through: //
        /////////////////////////////////////////////

        sub_test_case = "read req to min addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_min_26_addr_between(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'habba; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        #(PERIOD/4);
        assert(DUT.between_Vortex_mem_slave_VX_ahb_adapter_space == 1'b1); // check for arbiter chooses between

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp to min addr req";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; // no valid rsp
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0; // shouldn't get tag

        check_outputs();

        @(posedge clk);

        /////////////////////////////////////////////
        // check read from max addr falls through: //
        /////////////////////////////////////////////

        sub_test_case = "read req to max addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_max_26_addr_between(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'hcddc; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        #(PERIOD/4);
        assert(DUT.between_Vortex_mem_slave_VX_ahb_adapter_space == 1'b1); // check for arbiter chooses between

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp to max addr req";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; // no valid rsp
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0; // shouldn't get tag

        check_outputs();

        @(posedge clk);

        /////////////////////////////////////////////////////////////////////////////////
        // check read from Vortex_mem_slave then read from between addr falls through: //
        /////////////////////////////////////////////////////////////////////////////////

        sub_test_case = "read req to mem slave max addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_max_26_addr_Vortex_mem_slave(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'habc; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check rsp to mem slave max addr req = 0";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = 512'h0; // expect read = 0
        expected_Vortex_mem_rsp_tag = 56'habc;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after mem slave rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        sub_test_case = "read req to between min addr";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = calculate_min_26_addr_between(); // min addr
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'habba; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        #(PERIOD/4);
        assert(DUT.between_Vortex_mem_slave_VX_ahb_adapter_space == 1'b1) // check for arbiter chooses between
        else $display("\tTB ERROR: didn't detect between addr");

        @(posedge clk);
        set_default_inputs();

        sub_test_case = "check no rsp to between min addr req";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; // no valid rsp
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0; // shouldn't get tag

        check_outputs();

        @(posedge clk);

        end

        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Testing AHB adapter

        //////////////////////////
        // testing ahb_adapter: //
        //////////////////////////
        $display();
        test_case = "Testing AHB adapter";
        $display("test_case: ", test_case);

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);

        // make AHB side write req to start reg:
        sub_test_case = "AHB adapter normal read case";
        $display("\tsub_test_case: ", sub_test_case);

        //driving HRDATA:
        gen_ahb_trans(.rw('0), .byte_en(64'hffffffffffffff0f), .addr('hF0800000), .req_data(512'h0), .req_tag(56'h123456789abcde), .vx_ready_for_rsp(1));
        ahb_manager_ahbif.HRDATA = 32'hdeadbeef;
        #(PERIOD);
        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b0;
        expected_ahb_manager_ahbif_HTRANS = 2'b10;
        expected_ahb_manager_ahbif_HSIZE = 3'b010;
        expected_ahb_manager_ahbif_HADDR = 32'h20000000;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;
        expected_ahb_manager_ahbif_HSEL = 1'b1;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000004;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000008;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000000c;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000010;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000014;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000018;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000001c;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000020;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000024;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000028;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000002c;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000030;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000034;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000038;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000003c;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000040;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        
        if ((Vortex_mem_rsp_valid == 1) && (Vortex_mem_rsp_tag == 56'h123456789abcde) && (Vortex_mem_rsp_data == 512'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef))
        begin
            // fill in?
        end
        else
        begin
            $display("wrong response and tag signals from ahb master");
        end
        
        ahb_manager_ahbif.HRDATA = '0;
        #(PERIOD);

        // make AHB side write req to start reg:
        sub_test_case = "AHB adapter normal write case";
        $display("\tsub_test_case: ", sub_test_case);

        //driving HRDATA:
        gen_ahb_trans(.rw('1), .byte_en(64'hffffffffffffff0f), .addr('hF0800000), .req_data(512'h123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678123456781234567812345678deadbeef), .req_tag(56'h123456789abcde), .vx_ready_for_rsp(1));
        ahb_manager_ahbif.HRDATA = 32'hdeadbeef;
        #(PERIOD);
        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b1;
        expected_ahb_manager_ahbif_HTRANS = 2'b10;
        expected_ahb_manager_ahbif_HSIZE = 3'b010;
        expected_ahb_manager_ahbif_HADDR = 32'h20000000;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;
        expected_ahb_manager_ahbif_HSEL = 1'b1;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000004;
        expected_ahb_manager_ahbif_HWDATA = 32'hdeadbeef;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000008;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000000c;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000010;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000014;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000018;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000001c;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000020;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000024;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000028;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000002c;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000030;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000034;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000038;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h2000003c;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        expected_ahb_manager_ahbif_HADDR = 32'h20000040;
        expected_ahb_manager_ahbif_HWDATA = 32'h12345678;
        expected_ahb_manager_ahbif_HWSTRB = 4'hf;
        check_ahb_manager_ahbif_outputs();
        #(PERIOD);
        
        if ((Vortex_mem_rsp_valid == 1) && (Vortex_mem_rsp_tag == 56'h123456789abcde))
        begin
            // fill in?
        end
        else
        begin
            $display("wrong response and tag signals from ahb master");
        end
        
        #(PERIOD);

        /* --------------------------------------------------------------------------------------------- */
        // Program Emulation: Program already in Vortex_mem_slave
        @(posedge clk);
        $display();
        test_case = "Program Emulation: Program already in Vortex_mem_slave";
        $display("test_case: ", test_case);

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);

        /////////////////////////////////
        // set PC register (AHB side): //
        /////////////////////////////////

        #(PERIOD/2);

        // make AHB side write req to PC reg:
        sub_test_case = "AHB write to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'hF000_0100; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

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

        // check rsp (read PC reg = 0xF000_0100):
        sub_test_case = "check AHB rsp PC reg = 0xF000_0100";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hF000_0100; // PC reg = 0xF000_0100
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hF000_0100;
        check_outputs();

        @(posedge clk);

        ////////////////////
        // set start reg: //
        ////////////////////

        #(PERIOD/2);

        // make AHB side write req to start reg:
        sub_test_case = "AHB write to start reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h4; // 0xF000_8004 truncated -> 0x4
        ctrl_status_bpif.wdata = 32'h1; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

        // wait for write to occur
        #(PERIOD);

        // deassert write

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0; 
        ctrl_status_bpif.wdata = 32'h0; 
        ctrl_status_bpif.strobe = 4'b0; 

        // CTRL/Status inputs
        Vortex_busy = 1'b1;

        @(posedge clk);
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
        expected_Vortex_PC_reset_val = 32'hF000_0100;
        check_outputs();

        @(posedge clk);

        //////////////////////////////////////////////////////////////////////////////
        // mimic program mem req's: Vortex_mem_slave req's and rsp's (Vortex side): //
        //////////////////////////////////////////////////////////////////////////////

        sub_test_case = "read req to 0xF000_0100";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0100 >> 6; // 0xF000_0100 in 26-bit
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0102; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check rsp to 0xF000_0100 req = 0";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = 512'h0; // expect read = 0
        expected_Vortex_mem_rsp_tag = 56'h0102;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        sub_test_case = "write req to 0xF000_0100";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'hffffffffffffffff; // skip some bytes
        Vortex_mem_req_addr = 32'hF000_0100 >> 6; // 0xF000_0100 in 26-bit
        for (int i = 0; i<16; i++)
        begin
            Vortex_mem_req_data[32*i +: 31] = i;
        end
        Vortex_mem_req_tag = 56'h4d5f; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        sub_test_case = "read req to 0xF000_0100";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0100 >> 6; // 0xF000_0100 in 26-bit
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0204; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check rsp to 0xF000_0100 req = 0,1,2,3,...";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        for (int i = 0; i<16; i++)
        begin
            expected_Vortex_mem_rsp_data[32*i +: 31] = i;
        end
        expected_Vortex_mem_rsp_tag = 56'h0204;

        check_outputs();

        @(posedge clk);

       sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        /////////////////////////
        // poll busy register: //
        /////////////////////////

        // make AHB side read req to busy reg:
        sub_test_case = "AHB req to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 1):
        sub_test_case = "check AHB rsp busy reg = 1";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        check_outputs();

        @(posedge clk);

        #(PERIOD/2);

        // set busy low
        sub_test_case = "set busy low";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        Vortex_busy = 1'b0;

        // wait for busy to propagate
        #(PERIOD);

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (before propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0;

        check_outputs();

        // ACCOUNT FOR REGISTERED Vortex_reset
        #(PERIOD);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (after propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;

        check_outputs();
        
        // end of program

        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Program Emulation: Write Program to Vortex_mem_slave
        @(posedge clk);
        $display();
        test_case = "Program Emulation: Write Program to Vortex_mem_slave";
        $display("test_case: ", test_case);

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);

        /////////////////////////////////////////////////////////////////////////////////////////
        // mimic AFT load program into mem slave: Vortex_mem_slave req's and rsp's (AHB side): //
        /////////////////////////////////////////////////////////////////////////////////////////

        for (int i = 0; i < 16; i++)
        begin
            sub_test_case = $sformatf("check write to min addr + 1<<6 + 0x%2h = 0x%8h", i<<2, {4{8'(i)}});
            $display("\tsub_test_case: ", sub_test_case);

            // Vortex_mem_slave bpif inputs
            mem_slave_bpif.wen = 1'b1; // write
            mem_slave_bpif.ren = 1'b0;
            mem_slave_bpif.addr = calculate_min_32_addr_Vortex_mem_slave() + (1<<6) + (i<<2); // min addr
            mem_slave_bpif.wdata = {4{8'(i)}};
            mem_slave_bpif.strobe = i;

            @(posedge clk);
            #(PERIOD/2);

            // Vortex_mem_slave bpif outputs
            expected_mem_slave_bpif_rdata = 32'h0;
            expected_mem_slave_bpif_error = 1'b0;
            expected_mem_slave_bpif_request_stall = 1'b0;

            check_outputs();

            set_default_inputs();
            @(posedge clk);
        end

        /////////////////////////////////
        // set PC register (AHB side): //
        /////////////////////////////////

        #(PERIOD/2);

        // make AHB side write req to PC reg:
        sub_test_case = "AHB write to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'hF000_0040; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

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

        // check rsp (read PC reg = 0xF000_1000):
        sub_test_case = "check AHB rsp PC reg = 0xF000_0040";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hF000_0040; // PC reg = 0xF000_0100
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hF000_0040;
        check_outputs();

        @(posedge clk);

        ////////////////////
        // set start reg: //
        ////////////////////

        #(PERIOD/2);

        // make AHB side write req to start reg:
        sub_test_case = "AHB write to start reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h4; // 0xF000_8004 truncated -> 0x4
        ctrl_status_bpif.wdata = 32'h1; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

        // wait for write to occur
        #(PERIOD);

        // deassert write

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0; 
        ctrl_status_bpif.wdata = 32'h0; 
        ctrl_status_bpif.strobe = 4'b0; 

        // CTRL/Status inputs
        Vortex_busy = 1'b1;

        @(posedge clk);
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
        expected_Vortex_PC_reset_val = 32'hF000_0040;
        check_outputs();

        @(posedge clk);

        //////////////////////////////////////////////////////////////////////////////
        // mimic program mem req's: Vortex_mem_slave req's and rsp's (Vortex side): //
        //////////////////////////////////////////////////////////////////////////////

        sub_test_case = "read req to 0xF000_0040";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0040 >> 6; // 0xF000_0400 in 26-bit
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0102; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check rsp to 0xF000_0040 req = 0";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        expected_Vortex_mem_rsp_data = // expect written val
        {
            32'h0f0f0f0f,
            32'h0e0e0e00,
            32'h0d0d000d,
            32'h0c0c0000,
            32'h0b000b0b,
            32'h0a000a00,
            32'h09000009,
            32'h08000000,
            32'h00070707,
            32'h00060600,
            32'h00050005,   
            32'h00040000,   
            32'h00000303,
            32'h00000200,
            32'h00000001,
            32'h00000000  
        };
        expected_Vortex_mem_rsp_tag = 56'h0102;

        check_outputs();

        @(posedge clk);

        sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        sub_test_case = "write req to 0xF000_0080";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b1; // write
        Vortex_mem_req_byteen = 64'hffffffffffffffff; // skip some bytes
        Vortex_mem_req_addr = 32'hF000_0080 >> 6; // 0xF000_0080 in 26-bit
        for (int i = 0; i<16; i++)
        begin
            Vortex_mem_req_data[32*i +: 31] = {4{8'(15-i)}};
        end
        Vortex_mem_req_tag = 56'h974; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check no rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        @(posedge clk);

        sub_test_case = "read req to 0xF000_0080";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1; // valid req
        Vortex_mem_req_rw = 1'b0; // read
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'hF000_0080 >> 6; // 0xF000_0100 in 26-bit
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h5e2; // random tag

        // Vortex rsp wrapper inputs        
        Vortex_mem_rsp_ready = 1'b1;

        @(posedge clk);
        Vortex_mem_req_valid = 1'b0;

        sub_test_case = "check rsp to 0xF000_0080 req = 0f0f0f0f, 0e0e0e0e, ...";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b1; // valid rsp
        for (int i = 0; i<16; i++)
        begin
            expected_Vortex_mem_rsp_data[32*i +: 31] = {4{8'(15-i)}};
        end
        expected_Vortex_mem_rsp_tag = 56'h5e2;

        check_outputs();

        @(posedge clk);

       sub_test_case = "check idle after rsp";
        $display("\tsub_test_case: ", sub_test_case);
        #(PERIOD/2);

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex rsp wrapper outputs
        expected_Vortex_mem_rsp_valid = 1'b0; 
        expected_Vortex_mem_rsp_data = 512'h0;
        expected_Vortex_mem_rsp_tag = 56'h0;

        check_outputs();

        @(posedge clk);

        /////////////////////////
        // poll busy register: //
        /////////////////////////

        // make AHB side read req to busy reg:
        sub_test_case = "AHB req to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 1):
        sub_test_case = "check AHB rsp busy reg = 1";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        check_outputs();

        @(posedge clk);

        #(PERIOD/2);

        // set busy low
        sub_test_case = "set busy low";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        Vortex_busy = 1'b0;

        // wait for busy to propagate
        #(PERIOD);

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (before propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0;

        check_outputs();

        // ACCOUNT FOR REGISTERED Vortex_reset
        #(PERIOD);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (after propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;

        check_outputs();
        
        // end of program

        @(posedge clk);

        /* --------------------------------------------------------------------------------------------- */
        // Program Emulation: Program outside of Vortex_mem_slave, use VX_ahb_adapter
        @(posedge clk);
        $display();
        test_case = "Program Emulation: Program outside of Vortex_mem_slave, use VX_ahb_adapter";
        $display("test_case: ", test_case);

        // reset
        sub_test_case = "reset";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_inputs();
        set_default_outputs();
        #(PERIOD/2);
        nRST = 1'b0;
        #(PERIOD);
        nRST = 1'b1;
        #(PERIOD/2);

        // check reset values
        sub_test_case = "check reset values";
        $display("\tsub_test_case: ", sub_test_case);

        check_outputs();
        @(posedge clk);

        /////////////////////////////////
        // set PC register (AHB side): //
        /////////////////////////////////

        #(PERIOD/2);

        // make AHB side write req to PC reg:
        sub_test_case = "AHB write to PC reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h8; // 0xF000_8008 truncated -> 0x8
        ctrl_status_bpif.wdata = 32'hC000_0000; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

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

        // check rsp (read PC reg = 0xC000_0000):
        sub_test_case = "check AHB rsp PC reg = 0xC000_0000";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'hC000_0000; // PC reg = 0xC000_0000
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;
        expected_Vortex_PC_reset_val = 32'hC000_0000;
        check_outputs();

        @(posedge clk);

        ////////////////////
        // set start reg: //
        ////////////////////

        #(PERIOD/2);

        // make AHB side write req to start reg:
        sub_test_case = "AHB write to start reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b1; // write req
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h4; // 0xF000_8004 truncated -> 0x4
        ctrl_status_bpif.wdata = 32'h1; // write val
        ctrl_status_bpif.strobe = 4'b1111; // write mask

        // wait for write to occur
        #(PERIOD);

        // deassert write

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0; 
        ctrl_status_bpif.wdata = 32'h0; 
        ctrl_status_bpif.strobe = 4'b0; 

        // CTRL/Status inputs
        Vortex_busy = 1'b1;

        @(posedge clk);
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
        expected_Vortex_PC_reset_val = 32'hC000_0000;
        check_outputs();

        @(posedge clk);

        //////////////////////////////////////////////////////////////
        // mimic program mem req's: VX_ahb_adapter req's and rsp's: //
        //////////////////////////////////////////////////////////////

        // #(PERIOD/2);
        @(negedge clk);

        // Vortex side read req outside of Vortex_mem_slave
        sub_test_case = "Vortex side read req outside of Vortex_mem_slave";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b1;
        Vortex_mem_req_rw = 1'b0;
        Vortex_mem_req_byteen = 64'hffffffffffffffff;
        Vortex_mem_req_addr = 32'hC000_0000 >> 6;
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'h0123;

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b1;

        check_outputs();

        // #(PERIOD);
        // @(posedge clk);
        @(negedge clk);

        // check for first AHB read req
        sub_test_case = "check for first AHB read req";
        $display("\tsub_test_case: ", sub_test_case);

        // Vortex req wrapper inputs
        Vortex_mem_req_valid = 1'b0;
        Vortex_mem_req_rw = 1'b0;
        Vortex_mem_req_byteen = 64'h0;
        Vortex_mem_req_addr = 32'h0;
        Vortex_mem_req_data = 512'h0;
        Vortex_mem_req_tag = 56'hdeadbeef;

        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b0;
        expected_ahb_manager_ahbif_HTRANS = 2'b10;
        expected_ahb_manager_ahbif_HSIZE = 3'b010;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HSEL = 1'b1;
        expected_ahb_manager_ahbif_HADDR = 32'hC000_0000;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;

        // Vortex req wrapper outputs
        expected_Vortex_mem_req_ready = 1'b0;

        check_outputs();

        // #(PERIOD);
        // @(posedge clk);
        @(negedge clk);

        // check for 15 overlapping AHB read req/rsp
        sub_test_case = "check for 15 overlapping AHB read req/rsp";
        $display("\tsub_test_case: ", sub_test_case);
        for (int i = 0; i < 16; i++)
        begin
            // $display("\t\ti = ", i);
            ahb_manager_ahbif.HRDATA = {16'(15-i), 16'(i)};
            
            // VX_ahb_manager ahbif outputs
            expected_ahb_manager_ahbif_HADDR = 32'hC000_0000 + 4*(i+1);
            expected_ahb_manager_ahbif_HWSTRB = 4'hf;
            // check_ahb_manager_ahbif_outputs();
            check_outputs();

            // #(PERIOD);
            // @(posedge clk);
            @(negedge clk);
        end

        // check for Vortex rsp (AHB still lingering)
        sub_test_case = "check for Vortex rsp";
        $display("\tsub_test_case: ", sub_test_case);

        // VX_ahb_manager ahbif outputs
        expected_ahb_manager_ahbif_HWRITE = 1'b0;
        expected_ahb_manager_ahbif_HTRANS = 2'b0;
        expected_ahb_manager_ahbif_HSIZE = 3'b0;
        expected_ahb_manager_ahbif_HWDATA = 32'h0;
        expected_ahb_manager_ahbif_HSEL = 1'b0;
        expected_ahb_manager_ahbif_HADDR = 32'h0;
        expected_ahb_manager_ahbif_HWSTRB = 4'h0;

        // AHB transfers finished, check for response to Vortex
        expected_Vortex_mem_rsp_valid = 1'b1;
        for (int i = 0; i < 16; i++)
        begin
            expected_Vortex_mem_rsp_data[32*i +: 15] = 16'(i);
            expected_Vortex_mem_rsp_data[32*i+16 +: 15] = 16'(15-i);
        end
        expected_Vortex_mem_rsp_tag = 56'h0123;
        check_outputs();

        // #(PERIOD);
        // @(posedge clk);
        @(negedge clk);

        @(posedge clk);

        /////////////////////////
        // poll busy register: //
        /////////////////////////

        // make AHB side read req to busy reg:
        sub_test_case = "AHB req to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1; // read req
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 1):
        sub_test_case = "check AHB rsp busy reg = 1";
        $display("\tsub_test_case: ", sub_test_case);

        set_default_outputs();

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h1; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;

        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0;
        expected_Vortex_PC_reset_val = 32'hC000_0000;

        check_outputs();

        @(posedge clk);

        #(PERIOD/2);

        // set busy low
        sub_test_case = "set busy low";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b0;
        ctrl_status_bpif.addr = 32'h0;
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;
        // CTRL/Status inputs
        Vortex_busy = 1'b0;

        // wait for busy to propagate
        #(PERIOD);

        // read busy reg
        sub_test_case = "AHB read to busy reg";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif inputs
        ctrl_status_bpif.wen = 1'b0;
        ctrl_status_bpif.ren = 1'b1;
        ctrl_status_bpif.addr = 32'h0; // 0xF000_8000 truncated -> 0x0
        ctrl_status_bpif.wdata = 32'h0;
        ctrl_status_bpif.strobe = 4'b0;

        #(PERIOD/2);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (before propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b0;

        check_outputs();

        // ACCOUNT FOR REGISTERED Vortex_reset
        #(PERIOD);

        // check rsp (read busy reg = 0):
        sub_test_case = "check AHB rsp busy reg = 0 (after propagated Vortex_reset)";
        $display("\tsub_test_case: ", sub_test_case);

        // CTRL/Status reg bpif outputs
        expected_ctrl_status_bpif_rdata = 32'h0; // busy reg = 1
        expected_ctrl_status_bpif_error = 1'b0;
        expected_ctrl_status_bpif_request_stall = 1'b0;
        // CTRL/Status outputs
        expected_Vortex_reset = 1'b1;

        check_outputs();
        
        // end of program

        @(posedge clk);

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
        $finish();
    end

endmodule
