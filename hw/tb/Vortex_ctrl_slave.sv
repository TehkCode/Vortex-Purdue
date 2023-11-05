/*
    socet33 / prakasr@purdue.edu
    Raghul Prakash

    module for control registers to interface with Vortex

    START_ADDR
    STATUS_ADDR

    assumptions:
	START_ADDR
    	STATUS_ADDR are hardcoded for now
        AHB only references word addresses
*/

// temporary include to have defined vals
`include "Vortex_ctrl_slave.vh"

// include for Vortex widths
`include "../include/VX_define.vh"


// `define WORD_SIZE 32

//////////////////////////////////
// Generic Bus Interface (AHB): //
//////////////////////////////////

`ifndef GENERIC_BUS_IF_VH
`define GENERIC_BUS_IF_VH



// typedef logic [WORD_SIZE-1:0] word_t;
typedef logic [32-1:0] word_t;

interface generic_bus_if ();
    // import rv32i_types_pkg::*;

    // logic [RAM_ADDR_SIZE-1:0] addr;
    logic [32-1:0] addr;                // RAM_ADDR_SIZE = 32
    word_t wdata;
    word_t rdata;
    logic ren,wen;
    logic busy;
    logic [3:0] byte_en;

    modport generic_bus (
        input addr, ren, wen, wdata, byte_en,
        output rdata, busy
    );

    modport cpu (
        input rdata, busy,
        output addr, ren, wen, wdata, byte_en
    );

endinterface

`endif //GENERIC_BUS_IF_VH

module Vortex_ctrl_slave #(
)(
    /////////////////
    // Sequential: //
    /////////////////
    input clk, reset,

    ///////////////////////
    // Control Interface: //
    ///////////////////////

    // Status:
    // vortex outputs
    input logic                             busy,

    //Start:
    // vortex input reset
    output logic                            start,

    //////////////////////////////////
    // Generic Bus Interface (AHB): //
    //////////////////////////////////

    generic_bus_if.generic_bus              gbif
);
    // internal signals:

    // bad address signals
    logic Vortex_bad_address;
    logic AHB_bad_address;

    // control registers
    logic reg_start;
    logic reg_busy;
    logic next_reg_start;
    logic next_reg_busy;

    // reg file instance
    always_ff @ (posedge clk) begin : REG_FILE_FF_LOGIC
        if (reset)
        begin
	    reg_busy    <= 1'b0;
	    reg_start   <= 1'b0;
        end
        else
        begin
            reg_start <= next_reg_start;
            reg_busy <= next_reg_busy;
        end
    end

    // combinational logic for control interface
    always_comb begin : OTHER_CTRL_COMB_LOGIC

        //////////////////////
        // default outputs: //
        //////////////////////

        // hold start and sample busy
        next_reg_start = reg_start;
	next_reg_busy = busy;

        // Vortex outputs
        start = 1'b0;
        Vortex_bad_address = 1'b0;

        // AHB outputs
        AHB_bad_address = 1'b0;
        gbif.busy = 1'b0;

        //////////////////
        // bad address: //
        //////////////////


        // AHB bad address
        if (gbif.addr != `START_ADDR || gbif.addr != `BUSY_ADDR)
            AHB_bad_address = 1'b1;
        else
            AHB_bad_address = 1'b0;

        /////////////////
        // read logic: //
        /////////////////

        // AHB read logic
	if (gbif.addr == `START_ADDR) begin
        	gbif.rdata[7:0] = {7'b0, reg_start};
	end
	else if (gbif.addr == `BUSY_ADDR) begin
		gbif.rdata[7:0] = {7'b0, reg_busy};
	end
        //////////////////////////////////////////
        // Vortex write logic (first priority): //
        //////////////////////////////////////////



            // ahb busy
            gbif.busy = 1'b1;
        end

        ////////////////////////////////////////
        // AHB write logic (second priority): //
        ////////////////////////////////////////

        // if Vortex not writing, check for write and address in range
        else if (gbif.wen & ~AHB_bad_address)
        begin
	    if (gbif.addr == `START_ADDR) begin
		if (gbif.byte_en[0]) next_reg_start = gbif.wdata[7:0][0];
	    end

        end

	//vortex output
	start = reg_start[0];
    end


endmodule

