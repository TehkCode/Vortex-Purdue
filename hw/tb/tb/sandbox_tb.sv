// Guillaume Hu - hu724@purdue.edu

// `include "local_mem.vh"
`include "VX_define.vh"

`include "local_mem.vh"
`include "VX_define.vh"

`timescale 1 ps / 1 ps

module VX_local_mem_tb; 

    parameter PERIOD = 2;
    parameter RSP_DELAY = 2 * PERIOD; 
    logic clk = 0;
    logic reset; 

    // parameters
    parameter WORD_W = 32;
    parameter DRAM_SIZE = 64;

    // clock gen
    always #(PERIOD/2) clk = ~clk;

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

    // tb
    // tb signals
    logic                               tb_mem_req_valid;
    logic                               tb_mem_req_rw;    
    logic [`VX_MEM_BYTEEN_WIDTH-1:0]    tb_mem_req_byteen;    
    logic [`VX_MEM_ADDR_WIDTH-1:0]      tb_mem_req_addr;
    logic [`VX_MEM_DATA_WIDTH-1:0]      tb_mem_req_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       tb_mem_req_tag;
    // vortex inputs
    logic                               tb_mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                               tb_mem_rsp_valid;        
    logic [`VX_MEM_DATA_WIDTH-1:0]      tb_mem_rsp_data;
    logic [`VX_MEM_TAG_WIDTH-1:0]       tb_mem_rsp_tag;
    // vortex outputs
    logic                               tb_mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                               tb_busy;

    logic                             tb_addr_out_of_bounds; 

    generic_bus_if gbif(); 

    Vortex DUT(.clk(clk),
               .reset(reset), 
               .mem_req_valid(mem_req_valid), 
               .mem_req_rw(mem_req_rw), 
               .mem_req_byteen(mem_req_byteen),
               .mem_req_addr(mem_req_addr), 
               .mem_req_data(mem_req_data), 
               .mem_req_tag(mem_req_tag), 
               .mem_req_ready(mem_req_ready), 
               .mem_rsp_valid(mem_rsp_valid), 
               .mem_rsp_data(mem_rsp_data), 
               .mem_rsp_tag(mem_rsp_tag), 
               .mem_rsp_ready(mem_rsp_ready), 
               .busy(busy)
               );
    //local_mem MEM(.*); 

    Vortex_mem_slave MEM(.clk(clk), 
                  .reset(reset), 
                  .mem_req_valid(tb_mem_req_valid), 
                  .mem_req_rw(tb_mem_req_rw), 
                  .mem_req_byteen(tb_mem_req_byteen),
                  .mem_req_addr(tb_mem_req_addr), 
                  .mem_req_data(tb_mem_req_data), 
                  .mem_req_tag(tb_mem_req_tag), 
                  .mem_req_ready(tb_mem_req_ready), 
                  .mem_rsp_valid(tb_mem_rsp_valid), 
                  .mem_rsp_data(tb_mem_rsp_data), 
                  .mem_rsp_tag(tb_mem_rsp_tag), 
                  .mem_rsp_ready(tb_mem_rsp_ready), 
                  .busy(tb_busy), 
                  .gbif(gbif)
                  //.tb_addr_out_of_bounds(tb_addr_out_of_bounds)
    ); 

    assign tb_mem_rsp_ready = mem_rsp_ready; 

    initial begin 
        mem_req_ready = 1'b0; 
        mem_rsp_valid = 1'b0; 
        mem_rsp_data = '0; 
        mem_rsp_tag = '0; 

        tb_mem_req_valid = 1'b0; 
        tb_mem_req_rw = '0; 
        tb_mem_req_byteen = '0; 
        tb_mem_req_addr = '0; 
        tb_mem_req_data = '0; 
        tb_mem_req_tag = '0; 
        
        reset = 1'b1; 
        // Reset
        #(PERIOD * 13); 
        reset = 1'b0; 

        // Handshake to GPU
        mem_req_ready = 1'b1; 

        forever begin 
            // Buffer the correct values for the rsp 
            @(posedge mem_req_valid); 
            //$display("VX request at addr %h, @%0t", mem_req_addr, $time); 
            tb_mem_req_tag = mem_req_tag;
            tb_mem_req_addr = mem_req_addr; 
            tb_mem_req_byteen = mem_req_byteen; 
            tb_mem_req_rw = mem_req_rw; 
            tb_mem_req_data = mem_req_data; 
            #(RSP_DELAY);

            // Response to Vortex's request
            tb_mem_req_valid = 1'b1; // Trigger the local_mem
            if (~tb_mem_req_rw) begin // RSP only on read requests 
                mem_rsp_valid = 1'b1; 
                mem_rsp_data = tb_mem_rsp_data; 
                mem_rsp_tag = tb_mem_req_tag; 
            end
            #(PERIOD); 
            mem_rsp_valid = 1'b0; 
        end 

        //$stop; 

    end

    // Force end of sim
    initial begin 
        #30000; 
        $stop(); 
    end 


endmodule 