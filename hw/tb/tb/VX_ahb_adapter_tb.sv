`include "VX_define.vh"

`timescale 1 ns / 1 ns

localparam PERIOD = 10;
localparam AHB_DATA_WIDTH = 32;
localparam AHB_ADDR_WIDTH = 32;
localparam TRANS_PER_BLOCK = `VX_MEM_DATA_WIDTH/AHB_DATA_WIDTH;

module VX_ahb_adapter_tb;
    logic CLK = 0;

    always #(PERIOD/2) CLK = ~CLK; 

    ahb_if #(
        .DATA_WIDTH(AHB_DATA_WIDTH),
        .ADDR_WIDTH(AHB_ADDR_WIDTH)
    ) ahbif (.HCLK(CLK), .HRESETn(nRST));

    VX_mem_req_if #(
        .DATA_WIDTH(`VX_MEM_DATA_WIDTH),
        .ADDR_WIDTH(`VX_MEM_ADDR_WIDTH),
        .TAG_WIDTH(`VX_MEM_TAG_WIDTH)
    ) mreqif ();

    VX_mem_rsp_if #(
        .DATA_WIDTH(`VX_MEM_DATA_WIDTH),
        .TAG_WIDTH(`VX_MEM_TAG_WIDTH)
    ) mrspif ();

    VX_ahb_adapter DUT(CLK, nRST, ahbif, mreqif, mrspif);

    test prog(CLK, nRST, ahbif, mreqif, mrspif);
endmodule

program test(
    input logic CLK,
    output logic nRST,
    ahb_if.subordinate ahbif,
    VX_mem_req_if.master mreqif,
    VX_mem_rsp_if.slave mrspif
);
    // Signals for keeping track of failures
    integer tests = 0;
    integer fails = 0;

    // Navigation signals
    integer test_num = 0;
    string test_case = "Init";

    // AHB side outputs
    logic                                 expected_HSEL;
    logic                                 expected_HWRITE;
    logic                                 expected_HMASTLOCK;
    logic [1:0]                           expected_HTRANS;
    logic [2:0]                           expected_HBURST;
    logic [2:0]                           expected_HSIZE;
    logic [AHB_ADDR_WIDTH-1:0]            expected_HADDR;
    logic [AHB_DATA_WIDTH-1:0]            expected_HWDATA;
    logic [(AHB_DATA_WIDTH/8) - 1:0]      expected_HWSTRB;

    // Vortex side outputs
    logic                                 expected_req_ready;
    logic                                 expected_rsp_valid;
    logic [`VX_MEM_DATA_WIDTH-1:0]        expected_rsp_data;

    // Buffer to hold data to send via AHB
    logic [`VX_MEM_DATA_WIDTH-1:0]        ahb_buffer;

    // Stall pattern
    typedef integer stall_pattern_t [0:TRANS_PER_BLOCK-1];
    stall_pattern_t stall_pattern;

    function stall_pattern_t rand_stalls();
        stall_pattern_t rv;
        for (int i=0; i<TRANS_PER_BLOCK; ++i) begin
            rv[i] = $urandom_range(2);
        end
        return rv;
    endfunction

    task reset_inputs;
        mreqif.valid  = '0;
        mreqif.rw     = '0;
        mreqif.byteen = '1;
        mreqif.addr   = '0;
        mreqif.data   = '0;
        mreqif.tag    = '0;
        mrspif.ready  = '1;

        ahbif.HREADYOUT  = '1;
        ahbif.HRESP   = '0;
        ahbif.HRDATA  = '0;

        expected_HSEL = '0;
        expected_HWRITE = '0;
        expected_HSIZE = '0;
        expected_HADDR = '0;
        expected_HWDATA = '0;
        expected_HWSTRB = '1;
        expected_req_ready = '1;
        expected_rsp_valid = '0;
        expected_rsp_data = '0;

        for (int i=0; i<TRANS_PER_BLOCK; ++i) begin
            ahb_buffer[i*AHB_DATA_WIDTH +: AHB_DATA_WIDTH] = $urandom();
        end
    endtask

    task check_vx_outputs(input bit check_data_signals = 0);
        tests += 1;
        assert (mreqif.ready == expected_req_ready)
            else begin
                $error("Expected req_ready = %1.d, got %1.d",
                        expected_req_ready, mreqif.ready);
                fails += 1;
            end

        tests += 1;
        assert (mrspif.valid == expected_rsp_valid)
            else begin
                $error("Expected rsp_valid = %1.d, got %1.d",
                        expected_rsp_valid, mrspif.valid);
                fails += 1;
            end

        if (check_data_signals) begin
            tests += 1;
            assert (mrspif.data == expected_rsp_data)
                else begin
                    $error("Expected rsp_data = %128.x, got %128.x",
                            expected_rsp_data, mrspif.data);
                    fails += 1;
                end
        end
    endtask

    task check_ahb_outputs(input bit check_write_signals = 0);
        tests += 1;
        assert (ahbif.HSEL == expected_HSEL)
            else begin
                $error("Expected HSEL = %1.d, got %1.d",
                        expected_HSEL, ahbif.HSEL);
                fails += 1;
            end
        
        tests += 1;
        assert (ahbif.HWRITE == expected_HWRITE)
            else begin
                $error("Expected HWRITE = %1.d, got %1.d",
                        expected_HWRITE, ahbif.HWRITE);
                fails += 1;
            end
        
        /* NOT CHECKED TO ALLOW FLEXIBILITY OF IMPLEMENTATION
        tests += 1;
        assert (ahbif.HTRANS == expected_HTRANS)
            else begin
                $error("Expected HTRANS = %1.d, got %1.d",
                        expected_HTRANS, ahbif.HTRANS);
                fails += 1;
            end

        tests += 1;
        assert (ahbif.HBURST == expected_HBURST)
            else begin
                $error("Expected HBURST = %1.d, got %1.d",
                        expected_HBURST, ahbif.HBURST);
                fails += 1;
            end
        */

        tests += 1;
        assert (ahbif.HSIZE == expected_HSIZE)
            else begin
                $error("Expected HSIZE = %1.d, got %1.d",
                        expected_HSIZE, ahbif.HSIZE);
                fails += 1;
            end

        tests += 1;
        assert (ahbif.HADDR == expected_HADDR)
            else begin
                $error("Expected HADDR = %8.x, got %8.x",
                        expected_HADDR, ahbif.HADDR);
                fails += 1;
            end

        if (check_write_signals) begin
            tests += 1;
            assert (ahbif.HWDATA == expected_HWDATA)
                else begin
                    $error("Expected HWDATA = %8.x, got %8.x",
                            expected_HWDATA, ahbif.HWDATA);
                    fails += 1;
                end

            tests += 1;
            assert (ahbif.HWSTRB == expected_HWSTRB)
                else begin
                    $error("Expected HWSTRB = %4.b, got %4.b",
                            expected_HWSTRB, ahbif.HWSTRB);
                    fails += 1;
                end
        end
    endtask

    // Task to stream data from the AHB buffer to the AHB adapter
    // in case of a read by Vortex. Should be called after the posedge
    // following the read request, and before the negedge following that.
    task check_receive_data(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] addr,
        input logic [`VX_MEM_DATA_WIDTH-1:0] data,
        input integer stalls [0:TRANS_PER_BLOCK-1],
        input logic [(`VX_MEM_DATA_WIDTH/8)-1:0] strb
    );
        expected_HSEL = 1'b1;
        expected_HWRITE = 1'b0;
        expected_HSIZE = $clog2(AHB_DATA_WIDTH/8);
        expected_HADDR = addr << (AHB_ADDR_WIDTH - `VX_MEM_ADDR_WIDTH);

        @(negedge CLK);
        check_ahb_outputs();

        for (integer i = 0; i < TRANS_PER_BLOCK; ++i) begin
            @(posedge CLK);
            expected_HADDR += AHB_DATA_WIDTH/8;
            expected_HWSTRB = strb[i*AHB_DATA_WIDTH/8 +: AHB_DATA_WIDTH/8];
            while (stalls[i] > 0) begin
                ahbif.HREADYOUT = 1'b0;
                @(negedge CLK);
                check_ahb_outputs();
                @(posedge CLK);
                stalls[i] -= 1;
            end
            ahbif.HREADYOUT = 1'b1;
            ahbif.HRDATA = data[i*AHB_DATA_WIDTH +: AHB_DATA_WIDTH];
            if (i < TRANS_PER_BLOCK - 1) begin
                @(negedge CLK);
                check_ahb_outputs();
            end
        end

        @(negedge CLK);
    endtask

    // Task to stream data to the AHB buffer from the AHB adapter
    // in case of a write by Vortex. Should be called after the posedge
    // following the write request, and before the negedge following that.
    task check_send_data(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] addr,
        input logic [`VX_MEM_DATA_WIDTH-1:0] data,
        input integer stalls [0:TRANS_PER_BLOCK-1],
        input logic [(`VX_MEM_DATA_WIDTH/8)-1:0] strb
    );
        expected_HSEL = 1'b1;
        expected_HWRITE = 1'b1;
        expected_HSIZE = $clog2(AHB_DATA_WIDTH/8);
        expected_HADDR = addr << (AHB_ADDR_WIDTH - `VX_MEM_ADDR_WIDTH);

        @(negedge CLK);
        check_ahb_outputs();

        for (integer i = 0; i < TRANS_PER_BLOCK; ++i) begin
            @(posedge CLK);
            expected_HWDATA = data[i*AHB_DATA_WIDTH +: AHB_DATA_WIDTH];
            expected_HWSTRB = strb[i*AHB_DATA_WIDTH/8 +: AHB_DATA_WIDTH/8];
            expected_HADDR += AHB_DATA_WIDTH/8;
            while (stalls[i] > 0) begin
                ahbif.HREADYOUT = 1'b0;
                @(negedge CLK);
                check_ahb_outputs();
                @(posedge CLK);
                stalls[i] -= 1;
            end
            ahbif.HREADYOUT = 1'b1;
            if (i < TRANS_PER_BLOCK - 1) begin
                @(negedge CLK);
                check_ahb_outputs(1);
            end
        end

        @(negedge CLK);
    endtask

    task ahb_transaction(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] addr,
        input logic [`VX_MEM_DATA_WIDTH-1:0] data,
        input logic write,
        input bit nodelay,
        input integer stalls [0:TRANS_PER_BLOCK-1],
        input logic [(`VX_MEM_DATA_WIDTH/8)-1:0] strb
    );
        // Set up request at the Vortex side
        mreqif.valid = 1'b1;
        mreqif.rw = write;
        mreqif.byteen = strb;
        mreqif.addr = addr;
        mrspif.ready = 1'b0;
        if (write) begin
            mreqif.data = data;
        end

        @(posedge CLK);
        mreqif.valid = 1'b0;

        // req_ready should go low in the next cycle to prevent another
        // transaction from being queued
        #(0.25*PERIOD);
        expected_req_ready = 1'b0;
        check_vx_outputs();

        // Stream the AHB transactions
        if (write) begin
            check_send_data(addr, data, stalls, strb);
        end else begin
            check_receive_data(addr, data, stalls, strb);
        end

        // Check that the value correctly gets passed to Vortex
        @(negedge CLK);
        expected_req_ready = '0;
        expected_rsp_valid = '1;
        if (!write) begin
            expected_rsp_data = ahb_buffer;
        end
        check_vx_outputs(!write);

        // Check that the AHB signals get deasserted
        expected_HSEL = '0;
        expected_HWRITE = '0;
        expected_HSIZE = '0;
        expected_HADDR = '0;
        expected_HWDATA = '0;
        expected_HWSTRB = '1;
        check_ahb_outputs();

        // The Vortex side outputs should be held until acknowledged
        if (!nodelay) begin
            repeat(2) @(negedge CLK);
            check_vx_outputs(!write);
        end

        mrspif.ready = 1'b1;

        // After acknowledgement, should go back to ready state
        @(negedge CLK);
        expected_req_ready = '1;
        expected_rsp_valid = '0;
        check_vx_outputs();
    endtask

    task ahb_read(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] addr,
        input logic [`VX_MEM_DATA_WIDTH-1:0] data,
        input bit nodelay = 0,
        input integer stalls [0:TRANS_PER_BLOCK-1] = '{default: 0},
        input logic [(`VX_MEM_DATA_WIDTH/8)-1:0] strb = '1
    );
        ahb_transaction(addr, data, 0, nodelay, stalls, strb);
    endtask
    
    task ahb_write(
        input logic [`VX_MEM_ADDR_WIDTH-1:0] addr,
        input logic [`VX_MEM_DATA_WIDTH-1:0] data,
        input bit nodelay = 0,
        input integer stalls [0:TRANS_PER_BLOCK-1] = '{default: 0},
        input logic [(`VX_MEM_DATA_WIDTH/8)-1:0] strb = '1
    );
        ahb_transaction(addr, data, 1, nodelay, stalls, strb);
    endtask

    initial begin
        stall_pattern = {
            1, 1, 0, 2,
            0, 0, 0, 1,
            1, 2, 0, 2,
            0, 3, 1, 2
        };

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Power-on reset
        ////////////////////////////////////////////////////////////////////////
        @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Power-on reset";
        $display("Running test %2.d: %s", test_num, test_case);

        nRST = 1'b1;
        @(negedge CLK);
        nRST = 1'b0;
        @(negedge CLK);
        nRST = 1'b1;
        check_ahb_outputs();
        check_vx_outputs();

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone read
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone read";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read(26'h2345678, ahb_buffer);
        
        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone write
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone write";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_write(26'h4000000, ahb_buffer);

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Back to back regular transactions
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Back to back regular transactions";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read(26'h1200000, ahb_buffer, 1); reset_inputs();
        ahb_read(26'h1200001, ahb_buffer, 1); reset_inputs();
        ahb_write(26'h6000000, ahb_buffer, 1); reset_inputs();
        ahb_read(26'h1200002, ahb_buffer, 1); reset_inputs();
        ahb_write(26'h6000001, ahb_buffer, 1); reset_inputs();
        ahb_write(26'h6000002, ahb_buffer, 1); reset_inputs();

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone read with stalls
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone read with stalls";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read($urandom(), ahb_buffer, 0, stall_pattern);
        
        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone write with stalls
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone write with stalls";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_write($urandom(), ahb_buffer, 0, stall_pattern);

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Back to back transactions with stalls
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Back to back transactions with stalls";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();
        ahb_read($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();
        ahb_read($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls()); reset_inputs();

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone read with incomplete byteens
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone read with incomplete byteens";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read($urandom(), ahb_buffer, 0, rand_stalls(), 64'hBADCAFE0FEEDBEE5);
        
        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Standalone write with incomplete byteens
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Standalone write with incomplete byteens";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_write($urandom(), ahb_buffer, 0, rand_stalls(), 64'hBADCAFE0FEEDBEE5);

        ////////////////////////////////////////////////////////////////////////
        // TEST CASE: Back to back transactions with incomplete byteens
        ////////////////////////////////////////////////////////////////////////
        repeat(3) @(negedge CLK);
        reset_inputs();
        test_num += 1;
        test_case = "Back to back transactions with incomplete byteens";
        $display("Running test %2.d: %s", test_num, test_case);

        ahb_read($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();
        ahb_read($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();
        ahb_read($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();
        ahb_write($urandom(), ahb_buffer, 1, rand_stalls(), {$urandom(), $urandom()}); reset_inputs();

        repeat(3) @(negedge CLK);
        if (fails) begin
            $display("%0.d/%0.d CHECKS FAILED", fails, tests);
        end else begin
            $display("ALL %0.d CHECKS PASSED", tests);
        end

        $finish;
    end    
endprogram
