/*
    socet115 / zlagpaca@purdue.edu
    Zach Lagpacan

    module for on-chip RAM fake register file with AFTx07 AHB slave interface (at generic bus interface) 
    and Vortex memory interface 

    assumptions:
        AHB only references word addresses

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

module Vortex_mem_slave_condensed #(
    /////////////////
    // parameters: //
    /////////////////

    // parameter VORTEX_START_PC_ADDR = 32'h80000000,
    parameter VORTEX_MEM_SLAVE_AHB_BASE_ADDR = 32'hF000_0000,
    // parameter LOCAL_MEM_SIZE = 12
	parameter LOCAL_MEM_SIZE = 15
)(
    /////////////////
    // Sequential: //
    /////////////////
    input clk, nRST,

    ///////////////////////
    // Memory Interface: //
    ///////////////////////

    // Memory Request:
    // vortex outputs
    input logic                             mem_req_valid,
    input logic                             mem_req_rw,
    input logic [`VX_MEM_BYTEEN_WIDTH-1:0]  mem_req_byteen, // 64 (512 / 8)
    input logic [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_addr,   // 26
    input logic [`VX_MEM_DATA_WIDTH-1:0]    mem_req_data,   // 512
    input logic [`VX_MEM_TAG_WIDTH-1:0]     mem_req_tag,    // 56 (55 for SM disabled)
    // vortex inputs
    output logic                            mem_req_ready,

    // Memory response:
    // vortex inputs
    output logic                            mem_rsp_valid,        
    output logic [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data,   // 512
    output logic [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag,    // 56 (55 for SM disabled)
    // vortex outputs
    input logic                             mem_rsp_ready,

    // Status:
    // vortex outputs
    input logic                             busy,

    //////////////////////////////////
    // Generic Bus Interface (AHB): //
    //////////////////////////////////

    bus_protocol_if.peripheral_vital        bpif
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

    //-------------------------------------------------------------------------------------------//

    ///////////////////////
    // internal signals: //
    ///////////////////////

    // bad address signals
    logic Vortex_bad_address;
    logic AHB_bad_address;

    // buffered Vortex memory interface signals
    logic                           next_mem_rsp_valid;
    logic [`VX_MEM_DATA_WIDTH-1:0]  next_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]   next_mem_rsp_tag;

    // reg file signals:

    // reg file with 512-bit chunk granularity
    logic [(2**(LOCAL_MEM_SIZE-6))-1 : 0] [511:0] reg_file, next_reg_file;

    // reg file read port enable
    logic reg_file_chunk_read_en;

    // 512-bit reg file read port
    logic [511:0] reg_file_chunk_read_val;

    // reg file write port enable
    logic reg_file_chunk_write_en;

    // 512-bit reg file write port
    logic [511:0] reg_file_chunk_write_val;

    // select which 512-bit chunk to read and/or write (shared address)
    logic [LOCAL_MEM_SIZE-6 : 0] reg_file_chunk_addr;

    // type for selecting word in 512-bit chunk
    typedef logic [15:0] [31:0] word_in_512_t;

    // type for selecting byte in 512-bit chunk
    typedef logic [63:0] [7:0] byte_in_512_t;

    // type for selecting byte in word/32-bit chunk
    typedef logic [3:0] [7:0] byte_in_32_t;

    // intermediate signal to select out word from 512-bit chunk
    word_in_512_t wordwise_512_reg_file_read;

    // intermediate signal to select out byte in 512-bit chunk
    byte_in_512_t bytewise_512_reg_file_write, bytewise_512_reg_file_read, bytewise_512_mem_req_data;

    // intermediate signal to select out byte in word/32-bit chunk
    byte_in_32_t bytewise_32_bpif_wdata;

    //-------------------------------------------------------------------------------------------//

    ////////////////
    // registers: //
    ////////////////

    // output buffer registers
    always_ff @ (posedge clk, negedge nRST) begin : VORTEX_MEM_INTERFACE_OUTPUT_BUFFER_FF_LOGIC
        if (~nRST)
        begin
            mem_rsp_valid <= 1'b0;
            mem_rsp_data <= 512'd0;
            mem_rsp_tag <= 26'd0;
        end
        else
        begin
            mem_rsp_valid <= next_mem_rsp_valid;
            mem_rsp_data <= next_mem_rsp_data;
            mem_rsp_tag <= next_mem_rsp_tag;
        end
    end

    // reg file instance
    always_ff @ (posedge clk, negedge nRST) begin : REG_FILE_FF_LOGIC
        if (~nRST)
        begin
            // LOAD_ZEROS
            reg_file <= '{default:0};
        end
        else
        begin
            reg_file <= next_reg_file;
        end
    end

    //-------------------------------------------------------------------------------------------//

    /////////////////
    // comb logic: //
    /////////////////

    // reg file read and write logic
    always_comb begin : REG_FILE_READ_WRITE_COMB_LOGIC

        ////////////////////////
        // hardwired outputs: //
        ////////////////////////

        // translate 512-bit write chunk to bytewise
        reg_file_chunk_write_val = bytewise_512_reg_file_write;

        //////////////////////
        // default outputs: //
        //////////////////////

        // hold mem
        next_reg_file = reg_file;

        // read nothing
        reg_file_chunk_read_val = 512'h0;

        ////////////////////////
        // non-default logic: //
        //////////////////////// 

        // check for reg file write
        if (reg_file_chunk_write_en)
        begin
            // read from addr
            reg_file_chunk_read_val = reg_file[reg_file_chunk_addr];

            // write to addr
            next_reg_file[reg_file_chunk_addr] = reg_file_chunk_write_val;
        end
        else if (reg_file_chunk_read_en)
        begin
            // read from addr
            reg_file_chunk_read_val = reg_file[reg_file_chunk_addr];
        end
    end

    // read/write selection logic
    always_comb begin : READ_WRITE_SELECT_COMB_LOGIC

        ////////////////////////
        // hardwired signals: //
        ////////////////////////

        // Vortex side data in
        bytewise_512_mem_req_data = mem_req_data;
        bytewise_512_reg_file_read = reg_file_chunk_read_val;

        // AHB side data in
        bytewise_32_bpif_wdata = bpif.wdata;
        wordwise_512_reg_file_read = reg_file_chunk_read_val;

        //////////////////////
        // default outputs: //
        //////////////////////

        // don't read or write
        reg_file_chunk_read_en = 1'b0;
        reg_file_chunk_write_en = 1'b0;

        // addr takes Vortex side
        reg_file_chunk_addr = mem_req_addr[LOCAL_MEM_SIZE-6 : 0];

        // intermediate byte write value zeroed
        bytewise_512_reg_file_write = 512'h0;

        // don't stall AHB
        bpif.request_stall = 1'b0;

        // read zero
        next_mem_rsp_data = 512'h0;
        bpif.rdata = 32'h0;

        ////////////////////////
        // non-default logic: //
        //////////////////////// 

        // check for Vortex write
        if (mem_req_valid & mem_req_rw) 
        begin
            // enable chunk read and write
            reg_file_chunk_read_en = 1'b1;
            reg_file_chunk_write_en = 1'b1;

            // set chunk write to mem req data, following byte enables:
            for (int i = 0; i < 64; i++)
            begin
                if (mem_req_byteen[i])
                begin
                    bytewise_512_reg_file_write[i] = bytewise_512_mem_req_data[i];
                end
                else
                begin
                    bytewise_512_reg_file_write[i] = bytewise_512_reg_file_read[i];
                end
            end

            // set chunk addr following mem req addr
            reg_file_chunk_addr = mem_req_addr[LOCAL_MEM_SIZE-6 : 0];

            // stall AHB
            bpif.request_stall = 1'b1;
        end

        // check for Vortex read
        else if (mem_req_valid & ~mem_req_rw)
        begin
            // enable chunk read
            reg_file_chunk_read_en = 1'b1;

            // connect read port to Vortex side
            next_mem_rsp_data = reg_file_chunk_read_val;

            // set chunk addr following mem req addr
            reg_file_chunk_addr = mem_req_addr[LOCAL_MEM_SIZE-6 : 0];

            // stall AHB
            bpif.request_stall = 1'b1;
        end

        // check for AHB write
        else if (bpif.wen)
        begin
            // enable chunk read and write
            reg_file_chunk_read_en = 1'b1;
            reg_file_chunk_write_en = 1'b1;

            // set chunk write to mem req data, following byte enables:
            for (int i = 0; i < 64; i++)
            begin
                if (i[5:2] == bpif.addr[5:2] & bpif.strobe[i[1:0]])
                begin
                    bytewise_512_reg_file_write[i] = bytewise_32_bpif_wdata[i[1:0]];
                end
                else
                begin
                    bytewise_512_reg_file_write[i] = bytewise_512_reg_file_read[i];
                end
            end

            // set chunk addr following AHB addr
            reg_file_chunk_addr = bpif.addr[LOCAL_MEM_SIZE : 6];
        end

        // check for AHB read
        else if (bpif.ren)
        begin
            // enable chunk read
            reg_file_chunk_read_en = 1'b1;

            // connect read port to AHB side
            bpif.rdata = wordwise_512_reg_file_read[bpif.addr[5:2]];

            // set chunk addr following AHB addr
            reg_file_chunk_addr = bpif.addr[LOCAL_MEM_SIZE : 6];
        end
    end

    // Vortex side rsp logic
    always_comb begin : VORTEX_SIDE_COMB_LOGIC

        //////////////////////
        // hardwired logic: //
        //////////////////////

        // always ready for request
        mem_req_ready = 1'b1;

        // respond on reads next cycle
        next_mem_rsp_valid = mem_req_valid & ~mem_req_rw;

        // register tag for next cycle
        next_mem_rsp_tag = mem_req_tag;

    end

    // bad address logic
    always_comb begin : BAD_ADDR_COMB_LOGIC
        //////////////////
        // bad address: //
        //////////////////

        // Vortex bad address
        // if (mem_req_addr[25:8] != 18'b100000000000000000)
        if (mem_req_addr[32-6-1 : LOCAL_MEM_SIZE-6] != VORTEX_MEM_SLAVE_AHB_BASE_ADDR[32-1 : LOCAL_MEM_SIZE])
        begin
            Vortex_bad_address = 1'b1;
        end
        else
        begin
            Vortex_bad_address = 1'b0;
        end

        // AHB bad address
        // if (gbif.addr[31:14] != 18'b101100000000000000)
        if (bpif.addr[32-1 : LOCAL_MEM_SIZE] != 32'h0000_0000) // bpif takes care of 0xF offset
        begin
            AHB_bad_address = 1'b1;
            bpif.error = 1'b1;
        end
        else
        begin
            AHB_bad_address = 1'b0;
            bpif.error = 1'b0;
        end
    end

endmodule