/*
    socet115 / zlagpaca@purdue.edu

    testbench for vortex, simulating axi interface
*/

`include "VX_define.vh"

`timescale 1 ns / 1 ps

module VX_axi_tb ();

    // testbench signals
    parameter PERIOD = 1;
    logic clk = 0, reset;

    // clock gen
    always #(PERIOD/2) CLK++;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// axi interfacing signals:

    // Clock
    // vortex inputs
    logic                           clk;
    logic                           reset;

    // AXI write request address channel   
    // vortex outputs 
    logic [AXI_TID_WIDTH-1:0]       m_axi_awid;
    logic [AXI_ADDR_WIDTH-1:0]      m_axi_awaddr;
    logic [7:0]                     m_axi_awlen;
    logic [2:0]                     m_axi_awsize;
    logic [1:0]                     m_axi_awburst;  
    logic                           m_axi_awlock;   
    logic [3:0]                     m_axi_awcache;
    logic [2:0]                     m_axi_awprot;        
    logic [3:0]                     m_axi_awqos;
    logic                           m_axi_awvalid;
    // vortex inputs
    logic                           m_axi_awready;

    // AXI write request data channel
    // vortex outputs     
    logic [AXI_DATA_WIDTH-1:0]      m_axi_wdata;
    logic [AXI_STROBE_WIDTH-1:0]    m_axi_wstrb;    
    logic                           m_axi_wlast;  
    logic                           m_axi_wvalid; 
    // vortex inputs
    logic                           m_axi_wready;

    // AXI write response channel
    // vortex inputs
    logic [AXI_TID_WIDTH-1:0]       m_axi_bid;
    logic [1:0]                     m_axi_bresp;
    logic                           m_axi_bvalid;
    // vortex outputs
    logic                           m_axi_bready;
    
    // AXI read request channel
    // vortex outputs
    logic [AXI_TID_WIDTH-1:0]       m_axi_arid;
    logic [AXI_ADDR_WIDTH-1:0]      m_axi_araddr;
    logic [7:0]                     m_axi_arlen;
    logic [2:0]                     m_axi_arsize;
    logic [1:0]                     m_axi_arburst;            
    logic                           m_axi_arlock;    
    logic [3:0]                     m_axi_arcache;
    logic [2:0]                     m_axi_arprot;        
    logic [3:0]                     m_axi_arqos;
    logic                           m_axi_arvalid;
    // vortex inputs
    logic                           m_axi_arready;
    
    // AXI read response channel
    // vortex inputs
    logic [AXI_TID_WIDTH-1:0]       m_axi_rid;
    logic [AXI_DATA_WIDTH-1:0]      m_axi_rdata;  
    logic [1:0]                     m_axi_rresp;
    logic                           m_axi_rlast;
    logic                           m_axi_rvalid;
    // vortex ouputs
    logic                           m_axi_rready;

    // Status
    // vortex outputs
    logic                           busy;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    // test program
	test #(.PERIOD(PERIOD)) PROG (
        // Clock
        .clk            (clk),
        .reset          (reset),
        
        // AXI write request address channel 
        .m_axi_awid     (m_axi_awid),
        .m_axi_awaddr   (m_axi_awaddr),
        .m_axi_awlen    (m_axi_awlen),
        .m_axi_awsize   (m_axi_awsize),
        .m_axi_awburst  (m_axi_awburst),  
        .m_axi_awlock   (m_axi_awlock),    
        .m_axi_awcache  (m_axi_awcache),
        .m_axi_awprot   (m_axi_awprot),        
        .m_axi_awqos    (m_axi_awqos),  
        .m_axi_awvalid  (m_axi_awvalid),
        .m_axi_awready  (m_axi_awready),

        // AXI write request data channel
        .m_axi_wdata    (m_axi_wdata),
        .m_axi_wstrb    (m_axi_wstrb),
        .m_axi_wlast    (m_axi_wlast),
        .m_axi_wvalid   (m_axi_wvalid),
        .m_axi_wready   (m_axi_wready),

        // AXI write response channel
        .m_axi_bid      (m_axi_bid),
        .m_axi_bresp    (m_axi_bresp),
        .m_axi_bvalid   (m_axi_bvalid),
        .m_axi_bready   (m_axi_bready),
        
        // AXI read request channel
        .m_axi_arid     (m_axi_arid),
        .m_axi_araddr   (m_axi_araddr),
        .m_axi_arlen    (m_axi_arlen),
        .m_axi_arsize   (m_axi_arsize),
        .m_axi_arburst  (m_axi_arburst), 
        .m_axi_arlock   (m_axi_arlock),    
        .m_axi_arcache  (m_axi_arcache),
        .m_axi_arprot   (m_axi_arprot),        
        .m_axi_arqos    (m_axi_arqos),
        .m_axi_arvalid  (m_axi_arvalid),
        .m_axi_arready  (m_axi_arready),
        
        // AXI read response channel
        .m_axi_rid      (m_axi_rid),
        .m_axi_rdata    (m_axi_rdata),
        .m_axi_rresp    (m_axi_rresp),
        .m_axi_rlast    (m_axi_rlast),
        .m_axi_rvalid   (m_axi_rvalid),
        .m_axi_rready   (m_axi_rready),

        // Status
        .busy           (busy)
	);
	
	// DUT
	Vortex_axi DUT (
        // Clock
        .clk            (clk),
        .reset          (reset),
        
        // AXI write request address channel 
        .m_axi_awid     (m_axi_awid),
        .m_axi_awaddr   (m_axi_awaddr),
        .m_axi_awlen    (m_axi_awlen),
        .m_axi_awsize   (m_axi_awsize),
        .m_axi_awburst  (m_axi_awburst),  
        .m_axi_awlock   (m_axi_awlock),    
        .m_axi_awcache  (m_axi_awcache),
        .m_axi_awprot   (m_axi_awprot),        
        .m_axi_awqos    (m_axi_awqos),  
        .m_axi_awvalid  (m_axi_awvalid),
        .m_axi_awready  (m_axi_awready),

        // AXI write request data channel
        .m_axi_wdata    (m_axi_wdata),
        .m_axi_wstrb    (m_axi_wstrb),
        .m_axi_wlast    (m_axi_wlast),
        .m_axi_wvalid   (m_axi_wvalid),
        .m_axi_wready   (m_axi_wready),

        // AXI write response channel
        .m_axi_bid      (m_axi_bid),
        .m_axi_bresp    (m_axi_bresp),
        .m_axi_bvalid   (m_axi_bvalid),
        .m_axi_bready   (m_axi_bready),
        
        // AXI read request channel
        .m_axi_arid     (m_axi_arid),
        .m_axi_araddr   (m_axi_araddr),
        .m_axi_arlen    (m_axi_arlen),
        .m_axi_arsize   (m_axi_arsize),
        .m_axi_arburst  (m_axi_arburst), 
        .m_axi_arlock   (m_axi_arlock),    
        .m_axi_arcache  (m_axi_arcache),
        .m_axi_arprot   (m_axi_arprot),        
        .m_axi_arqos    (m_axi_arqos),
        .m_axi_arvalid  (m_axi_arvalid),
        .m_axi_arready  (m_axi_arready),
        
        // AXI read response channel
        .m_axi_rid      (m_axi_rid),
        .m_axi_rdata    (m_axi_rdata),
        .m_axi_rresp    (m_axi_rresp),
        .m_axi_rlast    (m_axi_rlast),
        .m_axi_rvalid   (m_axi_rvalid),
        .m_axi_rready   (m_axi_rready),

        // Status
        .busy           (busy)
    );
    
endmodule

program test
(
    // Clock
    input                               clk,
    output logic                        reset,

    // AXI write request address channel    
    // vortex outputs, tb inputs
    input logic [AXI_TID_WIDTH-1:0]     m_axi_awid,
    input logic [AXI_ADDR_WIDTH-1:0]    m_axi_awaddr,
    input logic [7:0]                   m_axi_awlen,
    input logic [2:0]                   m_axi_awsize,
    input logic [1:0]                   m_axi_awburst,  
    input logic                         m_axi_awlock,    
    input logic [3:0]                   m_axi_awcache,
    input logic [2:0]                   m_axi_awprot,        
    input logic [3:0]                   m_axi_awqos,
    input logic                         m_axi_awvalid,
    // vortex inputs, tb outputs
    output logic                        m_axi_awready,

    // AXI write request data channel   
    // vortex outputs, tb inputs  
    input logic [AXI_DATA_WIDTH-1:0]    m_axi_wdata,
    input logic [AXI_STROBE_WIDTH-1:0]  m_axi_wstrb,    
    input logic                         m_axi_wlast,  
    input logic                         m_axi_wvalid, 
    // vortex inputs, tb outputs
    output logic                        m_axi_wready,

    // AXI write response channel
    // vortex inputs, tb outputs
    output logic [AXI_TID_WIDTH-1:0]    m_axi_bid,
    output logic [1:0]                  m_axi_bresp,
    output logic                        m_axi_bvalid,
    // vortex outputs, tb inputs 
    input logic                         m_axi_bready,
    
    // AXI read request channel
    // vortex outputs, tb inputs 
    input logic [AXI_TID_WIDTH-1:0]     m_axi_arid,
    input logic [AXI_ADDR_WIDTH-1:0]    m_axi_araddr,
    input logic [7:0]                   m_axi_arlen,
    input logic [2:0]                   m_axi_arsize,
    input logic [1:0]                   m_axi_arburst,            
    input logic                         m_axi_arlock,    
    input logic [3:0]                   m_axi_arcache,
    input logic [2:0]                   m_axi_arprot,        
    input logic [3:0]                   m_axi_arqos, 
    input logic                         m_axi_arvalid,
    // vortex inputs, tb outputs
    output logic                        m_axi_arready,
    
    // AXI read response channel
    // vortex inputs, tb outputs
    output logic [AXI_TID_WIDTH-1:0]    m_axi_rid,
    output logic [AXI_DATA_WIDTH-1:0]   m_axi_rdata,  
    output logic [1:0]                  m_axi_rresp,
    output logic                        m_axi_rlast,
    output logic                        m_axi_rvalid,
    // vortex outputs, tb inputs 
    input logic                         m_axi_rready,

    // Status
    // vortex outputs, tb inputs
    input logic                         busy
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
    // AXI write request address channel   
    // vortex outputs 
    logic [AXI_TID_WIDTH-1:0]       expected_m_axi_awid;
    logic [AXI_ADDR_WIDTH-1:0]      expected_m_axi_awaddr;
    logic [7:0]                     expected_m_axi_awlen;
    logic [2:0]                     expected_m_axi_awsize;
    logic [1:0]                     expected_m_axi_awburst;  
    logic                           expected_m_axi_awlock;   
    logic [3:0]                     expected_m_axi_awcache;
    logic [2:0]                     expected_m_axi_awprot;        
    logic [3:0]                     expected_m_axi_awqos;
    logic                           expected_m_axi_awvalid;
    // // vortex inputs
    // logic                           m_axi_awready;

    // AXI write request data channel
    // vortex outputs     
    logic [AXI_DATA_WIDTH-1:0]      expected_m_axi_wdata;
    logic [AXI_STROBE_WIDTH-1:0]    expected_m_axi_wstrb;    
    logic                           expected_m_axi_wlast;  
    logic                           expected_m_axi_wvalid; 
    // // vortex inputs
    // logic                           m_axi_wready;

    // AXI write response channel
    // // vortex inputs
    // logic [AXI_TID_WIDTH-1:0]       m_axi_bid;
    // logic [1:0]                     m_axi_bresp;
    // logic                           m_axi_bvalid;
    // vortex outputs
    logic                           expected_m_axi_bready;
    
    // AXI read request channel
    // vortex outputs
    logic [AXI_TID_WIDTH-1:0]       expected_m_axi_arid;
    logic [AXI_ADDR_WIDTH-1:0]      expected_m_axi_araddr;
    logic [7:0]                     expected_m_axi_arlen;
    logic [2:0]                     expected_m_axi_arsize;
    logic [1:0]                     expected_m_axi_arburst;            
    logic                           expected_m_axi_arlock;    
    logic [3:0]                     expected_m_axi_arcache;
    logic [2:0]                     expected_m_axi_arprot;        
    logic [3:0]                     expected_m_axi_arqos;
    logic                           expected_m_axi_arvalid;
    // // vortex inputs
    // logic                           m_axi_arready;
    
    // AXI read response channel
    // // vortex inputs
    // logic [AXI_TID_WIDTH-1:0]       m_axi_rid;
    // logic [AXI_DATA_WIDTH-1:0]      m_axi_rdata;  
    // logic [1:0]                     m_axi_rresp;
    // logic                           m_axi_rlast;
    // logic                           m_axi_rvalid;
    // vortex ouputs
    logic                           expected_m_axi_rready;

    // Status
    // vortex outputs
    logic                           expected_busy;

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
	// tasks:
	///////////////////////////////////////////////////////////////////////////////////////////////////////

    task check_outputs;
    begin
        testing = 1'b1;

        // check for good output
		assert (
                // AXI write request address channel  
                m_axi_awid === expected_m_axi_awid &
                m_axi_awaddr === expected_m_axi_awaddr &
                m_axi_awlen === expected_m_axi_awlen &
                m_ax_awsize === expected_m_axi_awsize &
                m_axi_awburst === expected_m_axi_awburst &  
                m_axi_awlock === expected_m_axi_awlock &   
                m_axi_awcache === expected_m_axi_awcache &
                m_axi_awprot === expected_m_axi_awprot &        
                m_axi_awqos === expected_m_axi_awqos &
                m_axi_awvalid === expected_m_axi_awvalid & 
                // AXI write request data channel 
                m_axi_wdata === expected_m_axi_wdata &
                m_axi_wstrb === expected_m_axi_wstrb &    
                m_axi_wlast === expected_m_axi_wlast &  
                m_axi_wvalid === expected_m_axi_wvalid & 
                // AXI write response channel
                m_axi_bready === expected_m_axi_bready &
                // AXI read request channel
                m_axi_arid === expected_m_axi_arid &
                m_axi_araddr === expected_m_axi_araddr &
                m_axi_arlen === expected_m_axi_arlen &
                m_axi_arsize === expected_m_axi_arsize &
                m_axi_arburst === expected_m_axi_arburst &            
                m_axi_arlock === expected_m_axi_arlock &    
                m_axi_arcache === expected_m_axi_arcache &
                m_axi_arprot === expected_m_axi_arprot &        
                m_axi_arqos === expected_m_axi_arqos &
                m_axi_arvalid === expected_m_axi_arvalid &
                // AXI read response channel
                m_axi_rready === expected_m_axi_rready &
                // Status
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
            if (m_axi_awid !== expected_m_axi_awid)
            begin
                num_errors++;
                $display("\tm_axi_awid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awid, m_axi_awid);
            end

            // check for specific errors:
            if (m_axi_awaddr !== expected_m_axi_awaddr)
            begin
                num_errors++;
                $display("\tm_axi_awaddr:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awaddr, m_axi_awaddr);
            end

            // check for specific errors:
            if (m_axi_awlen !== expected_m_axi_awlen)
            begin
                num_errors++;
                $display("\tm_axi_awlen:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awlen, m_axi_awlen);
            end

            // check for specific errors:
            if (m_axi_awsize !== expected_m_axi_awsize)
            begin
                num_errors++;
                $display("\tm_axi_awsize:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awsize, m_axi_awsize);
            end

            // check for specific errors:
            if (m_axi_awburst !== expected_m_axi_awburst)
            begin
                num_errors++;
                $display("\tm_axi_awburst:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awburst, m_axi_awburst);
            end

            // check for specific errors:
            if (m_axi_awlock !== expected_m_axi_awlock)
            begin
                num_errors++;
                $display("\tm_axi_awlock:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awlock, m_axi_awlock);
            end

            // check for specific errors:
            if (m_axi_awcache !== expected_m_axi_awcache)
            begin
                num_errors++;
                $display("\tm_axi_awcache:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awcache, m_axi_awcache);
            end

            // check for specific errors:
            if (m_axi_awprot !== expected_m_axi_awprot)
            begin
                num_errors++;
                $display("\tm_axi_awprot:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awprot, m_axi_awprot);
            end

            // check for specific errors:
            if (m_axi_awqos !== expected_m_axi_awqos)
            begin
                num_errors++;
                $display("\tm_axi_awqos:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awqos, m_axi_awqos);
            end

            // check for specific errors:
            if (m_axi_awvalid !== expected_m_axi_awvalid)
            begin
                num_errors++;
                $display("\tm_axi_awvalid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_awvalid, m_axi_awvalid);
            end

            // check for specific errors:
            if (m_axi_wdata !== expected_m_axi_wdata)
            begin
                num_errors++;
                $display("\tm_axi_wdata:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_wdata, m_axi_wdata);
            end

            // check for specific errors:
            if (m_axi_wstrb !== expected_m_axi_wstrb)
            begin
                num_errors++;
                $display("\tm_axi_wstrb:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_wstrb, m_axi_wstrb);
            end

            // check for specific errors:
            if (m_axi_wlast !== expected_m_axi_wlast)
            begin
                num_errors++;
                $display("\tm_axi_wlast:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_wlast, m_axi_wlast);
            end

            // check for specific errors:
            if (m_axi_wvalid !== expected_m_axi_wvalid)
            begin
                num_errors++;
                $display("\tm_axi_wvalid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_wvalid, m_axi_wvalid);
            end

            // check for specific errors:
            if (m_axi_bready !== expected_m_axi_bready)
            begin
                num_errors++;
                $display("\tm_axi_bready:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_bready, m_axi_bready);
            end

            // check for specific errors:
            if (m_axi_arid !== expected_m_axi_arid)
            begin
                num_errors++;
                $display("\tm_axi_arid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arid, m_axi_arid);
            end

            // check for specific errors:
            if (m_axi_araddr !== expected_m_axi_araddr)
            begin
                num_errors++;
                $display("\tm_axi_araddr:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_araddr, m_axi_araddr);
            end

            // check for specific errors:
            if (m_axi_arlen !== expected_m_axi_arlen)
            begin
                num_errors++;
                $display("\tm_axi_arlen:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arlen, m_axi_arlen);
            end

            // check for specific errors:
            if (m_axi_arsize !== expected_m_axi_arsize)
            begin
                num_errors++;
                $display("\tm_axi_arsize:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arsize, m_axi_arsize);
            end

            // check for specific errors:
            if (m_axi_arburst !== expected_m_axi_arburst)
            begin
                num_errors++;
                $display("\tm_axi_arburst:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arburst, m_axi_arburst);
            end

            // check for specific errors:
            if (m_axi_arlock !== expected_m_axi_arlock)
            begin
                num_errors++;
                $display("\tm_axi_arlock:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arlock, m_axi_arlock);
            end

            // check for specific errors:
            if (m_axi_arcache !== expected_m_axi_arcache)
            begin
                num_errors++;
                $display("\tm_axi_arcache:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arcache, m_axi_arcache);
            end

            // check for specific errors:
            if (m_axi_arprot !== expected_m_axi_arprot)
            begin
                num_errors++;
                $display("\tm_axi_arprot:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arprot, m_axi_arprot);
            end

            // check for specific errors:
            if (m_axi_arqos !== expected_m_axi_arqos)
            begin
                num_errors++;
                $display("\tm_axi_arqos:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arqos, m_axi_arqos);
            end

            // check for specific errors:
            if (m_axi_arvalid !== expected_m_axi_arvalid)
            begin
                num_errors++;
                $display("\tm_axi_arvalid:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_arvalid, m_axi_arvalid);
            end

            // check for specific errors:
            if (m_axi_rready !== expected_m_axi_rready)
            begin
                num_errors++;
                $display("\tm_axi_rready:");
                $display("\texpected: 0x%h\n\t  output: 0x%h", 
                expected_m_axi_rready, m_axi_rready);
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
            expected_mem_req_valid;
            expected_mem_req_rw;
            expected_mem_req_byteen;  
            expected_mem_req_addr;
            expected_mem_req_data;
            expected_mem_req_tag;
            expected_mem_rsp_ready;
            expected_busy;
            
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
            expected_mem_req_valid;
            expected_mem_req_rw;
            expected_mem_req_byteen;  
            expected_mem_req_addr;
            expected_mem_req_data;
            expected_mem_req_tag;
            expected_mem_rsp_ready;
            expected_busy;
            
            check_outputs();
		end
        $display("");

        

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
