/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    testbench for vortex, simulating memory interface
*/

`include "VX_define.vh"

`timescale 1 ns / 1 ps

module VX_mem_tb ();

    // testbench signals
    parameter PERIOD = 1;
    logic clk = 0, reset;

    // parameters
    parameter WORD_W = 32;
    parameter DRAM_SIZE = 64;

    // clock gen
    always #(PERIOD/2) CLK++;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// memory interfacing signals:

    // Memory request:
    // vortex outputs
    logic                               mem_req_valid;
    logic                               mem_req_rw;    
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    mem_req_byteen;    
    logic [`VX_MEM_ADDR_WIDTH-1:0]      mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_req_tag;
    // vortex inputs
    logic                               mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       mem_rsp_tag;
    // vortex outputs
    logic                               mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                               busy;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// ram fake reg file signals:

    // seq
    // input clk, reset,

    // write handshaking
    logic                   w_req;
    logic [WORD_W-1:0]      w_addr;
    logic [WORD_W-1:0]      w_data_in;
    logic                   w_resp;

    // read handshaking
    logic                   r_req;
    logic [WORD_W-1:0]      r_addr;
    logic [WORD_W-1:0]      r_data_out;
    logic                   r_resp;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// Vortex vs tb control of ram
    logic tb_control_ram;

    // < mux logic for selecting between Vortex or tb to interact with ram >

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    // test program
	test #(.PERIOD(PERIOD)) PROG (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .busy           (busy)

        .w_req          (w_req),
        .w_addr         (w_addr),
        .w_data_in      (w_data_in),
        .w_resp         (w_resp),

        .r_req          (r_req),
        .r_addr         (r_addr),
        .r_data_in      (r_data_in),
        .r_resp         (r_resp),

        .tb_control_ram (tb_control_ram)
	);
	
    /////////////////////////
	// DUT
    /////////////////////////
	Vortex DUT (
        .clk            (clk),
        .reset          (reset),

        .mem_req_valid  (mem_req_valid),
        .mem_req_rw     (mem_req_rw),
        .mem_req_byteen (mem_req_byteen),
        .mem_req_addr   (mem_req_addr),
        .mem_req_data   (mem_req_data),
        .mem_req_tag    (mem_req_tag),
        .mem_req_ready  (mem_req_ready),

        .mem_rsp_valid  (mem_rsp_valid),
        .mem_rsp_data   (mem_rsp_data),
        .mem_rsp_tag    (mem_rsp_tag),
        .mem_rsp_ready  (mem_rsp_ready),

        .busy           (busy)
    );

    ///////////////////////////////////////////////////////////////////////////
    // fake ram connection logic
    ///////////////////////////////////////////////////////////////////////////

    // Vortex <-> mem signals <-> [ AHB interface? ] <-> fake ram 
    
    ///////////////////////////////////////////////////////////////////////////


    /////////////////////////
    // ram fake
    /////////////////////////
    ram_fake_reg_file #(
        .WORD_W         (WORD_W),
        .DRAM_SIZE      (DRAM_SIZE)
    )
    ram_fake (
        .clk            (clk),
        .reset          (reset),
        
        .w_req          (w_req),
        .w_addr         (w_addr),
        .w_data_in      (w_data_in),
        .w_resp         (w_resp),

        .r_req          (r_req),
        .r_addr         (r_addr),
        .r_data_in      (r_data_in),
        .r_resp         (r_resp)
    );
    
endmodule

program test
(
    // seq
    input clk,
    output logic reset,

    // Vortex
    // Memory request
    input logic                             mem_req_valid,
    input logic                             mem_req_rw,    
    input logic [`VX_MEM_BYTEEN_WIDTH-1:0]  mem_req_byteen,    
    input logic [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_addr,
    input logic [`VX_MEM_DATA_WIDTH-1:0]    mem_req_data,
    input logic [`VX_MEM_TAG_WIDTH-1:0]     mem_req_tag,
    output logic                            mem_req_ready,
    // Memory response   
    output logic                            mem_rsp_valid,        
    output logic [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data,
    output logic [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag,
    input logic                             mem_rsp_ready,
    // Status
    input logic                             busy,

    // ram_fake_reg_file
    // write handshaking
    output logic                            w_req,
    output logic [WORD_W-1:0]               w_addr,
    output logic [WORD_W-1:0]               w_data_in,
    input logic                             w_resp,
    // read handshaking
    output logic                            r_req,
    output logic [WORD_W-1:0]               r_addr,
    input logic [WORD_W-1:0]                r_data_out,
    input logic                             r_resp,

    // Vortex vs tb ram control
    output logic                            tb_control_ram
);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// test signals:
	///////////////////////////////////////////////////////////////////////////////////////////////////////

	// import types
    import cpu_types_pkg::*;

	// tb signals
	parameter PERIOD 		= 1;
	integer test_num 		= 0;
	string test_string 		= "start";
	string task_string		= "no task";
	logic testing 			= 1'b0;
	logic error				= 1'b0;
	integer num_errors		= 0;

    // tb expected signals
    // Memory request:
    logic                               expected_mem_req_valid;
    logic                               expected_mem_req_rw;
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    expected_mem_req_byteen;  
    logic [`VX_MEM_ADDR_WIDTH-1:0]      expected_mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      expected_mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       expected_mem_req_tag;
    // Memory response:
    logic                               expected_mem_rsp_ready;
    // Status:
    logic                               expected_busy;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// tasks:
	///////////////////////////////////////////////////////////////////////////////////////////////////////

    task check_outputs;
    begin
        testing = 1'b1;

        // check for good output
		assert (
            mem_req_valid === expected_mem_req_valid &
            mem_req_rw === expected_mem_req_rw &
            mem_req_byteen === expected_mem_req_byteen &
            mem_req_addr === expected_mem_req_addr &
            mem_req_data === expected_mem_req_data &
            mem_req_tag === expected_mem_req_tag &
            mem_rsp_ready === expected_mem_rsp_read &
            busy === expected_busy
            )
		begin
			$display("Correct outputs");
		end
        // otherwise, error
        else
        begin
            error = 1'b1;
            
            // check for specific errors:
            if (mem_req_valid !== expected_mem_req_valid)
            begin
                num_errors++;
                $display("\tmem_req_valid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_valid, mem_req_valid);
            end
            
            // check for specific errors:
            if (mem_req_rw !== expected_mem_req_rw)
            begin
                num_errors++;
                $display("\tmem_req_rw:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_rw, mem_req_rw);
            end

            // check for specific errors:
            if (mem_req_byteen !== expected_mem_req_byteen)
            begin
                num_errors++;
                $display("\tmem_req_byteen:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_byteen, mem_req_byteen);
            end

            // check for specific errors:
            if (mem_req_addr !== expected_mem_req_addr)
            begin
                num_errors++;
                $display("\tmem_req_addr:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_addr, mem_req_addr);
            end

            // check for specific errors:
            if (mem_req_data !== expected_mem_req_data)
            begin
                num_errors++;
                $display("\tmem_req_data:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_data, mem_req_data);
            end

            // check for specific errors:
            if (mem_req_tag !== expected_mem_req_tag)
            begin
                num_errors++;
                $display("\tmem_req_tag:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_tag, mem_req_tag);
            end

            // check for specific errors:
            if (mem_req_read !== expected_mem_req_read)
            begin
                num_errors++;
                $display("\tmem_req_read:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_mem_req_read, mem_req_read);
            end

            // check for specific errors:
            if (busy !== expected_busy)
            begin
                num_errors++;
                $display("\tbusy:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_busy, busy);
            end
        end

        #(0.01);
        testing = 1'b0;
        error = 1'b0;
    end
    endtask

    task load_memory ();
        string mem_load_file;
    begin
        // read in file with instructions and data into fake mem
    end
    endtask

    task dump_memory ();
        string mem_dump_file;
    begin
        // write out fake mem contents to file
    end
    endtask

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// tb:
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	
	initial
	begin
		// init valules
		error = 1'b0;
		num_errors = 0;
		test_num = 0;
		test_string = "";
        task_string = "";
		$display("init");
        $display("");

        ///////////////////////
		// load fake memory: //
		///////////////////////
        load_memory("input_data.hex");

        ////////////////////
		// reset testing: //
		////////////////////
		@(negedge CLK);
        test_num++;
        test_string = "reset testing";
		$display("reset testing");
		begin
            task_string = "assert reset";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_ready   = 1'b0;
            mem_rsp_valid   = 1'b0;
            mem_rsp_data    = '0;
            mem_rsp_tag     = '0;
            mem_rsp_ready   = 1'b0;

            reset = 1'b1;

            // expected outputs:
            expected_mem_req_valid      = '0;
            expected_mem_req_rw         = '0;
            expected_mem_req_byteen     = '0;  
            expected_mem_req_addr       = '0;
            expected_mem_req_data       = '0;
            expected_mem_req_tag        = '0;
            expected_mem_rsp_ready      = '0;
            expected_busy               = '0;
            
            check_outputs();

            #(PERIOD);
            @(negedge CLK);
            task_string = "deassert nRST";
            $display("\n-> testing %s", task_string);

            // input stimuli:
            mem_req_ready   = 1'b0;
            mem_rsp_valid   = 1'b0;
            mem_rsp_data    = '0;
            mem_rsp_tag     = '0;
            mem_rsp_ready   = 1'b0;

            reset = 1'b0;

            // expected outputs:
            expected_mem_req_valid      = '0;
            expected_mem_req_rw         = '0;
            expected_mem_req_byteen     = '0;  
            expected_mem_req_addr       = '0;
            expected_mem_req_data       = '0;
            expected_mem_req_tag        = '0;
            expected_mem_rsp_ready      = '0;
            expected_busy               = '0;
            
            check_outputs();
		end
        $display("");

        ///////////////////////
		// dump fake memory: //
		///////////////////////
        load_memory("output_data.hex");

        //////////////////////
		// testing results: //
		//////////////////////
        @(negedge CLK);
		test_num 			= 0;
		test_string 		= "testing results";
		$display("");
		$display("//////////////////////");
		$display("// testing results: //");
		$display("//////////////////////");
		$display("");
		begin
			#(PERIOD);

			// check for errors
			if (num_errors)
			begin
				$display("UNSUCCESSFUL VERIFICATION\n%d error(s)", num_errors);
			end
			else
			begin
				$display("SUCCESSFUL VERIFICATION\n\tno errors");
			end
		end
		$display("");

        $finish();
    end

endprogram
