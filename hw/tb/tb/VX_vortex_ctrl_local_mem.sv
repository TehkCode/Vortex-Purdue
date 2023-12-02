`include "../include/VX_define.vh"
//Author: Raghul Prakash, socet33, prakasr
//VX local ram, ctrl and vortex instantiated.

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

module VX_vortex_ctrl_local_mem #()(
    // seq
    input clk, reset, 
    //////////////////////////////////
    // Generic Bus Interface (AHB): //
    //////////////////////////////////

    generic_bus_if.generic_bus              gbif
)
    // Memory Request:
    // vortex outputs
    logic                             mem_req_valid,;
    logic                             mem_req_rw;
	logic [`VX_MEM_BYTEEN_WIDTH-1:0]  mem_req_byteen; // 64 (512 / 8)
	logic [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_addr;   // 26
	logic [`VX_MEM_DATA_WIDTH-1:0]    mem_req_data;   // 512
	logic [`VX_MEM_TAG_WIDTH-1:0]     mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    logic                            mem_req_ready;

    // Memory response:
    // vortex inputs
    logic                            mem_rsp_valid;        
	logic [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data;   // 512
	logic [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    logic                             mem_rsp_ready;

    // Status:
    // vortex outputs
    logic                             busy;

    // tb:
    logic                            tb_addr_out_of_bounds;

    logic start;	
	
    //vortex control slave
    Vortex_ctrl_slave vortex_ctrl_slave(clk, reset, busy, start, gbif);

    //vortex top
    VX_vortex Vortex(
        .clk            (clk),
	    .reset          (reset | start),

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

        .busy           (busy),

	    .tb_addr_out_of_bounds (tb_addr_out_of_bounds)
	);
    
    //local ram
    local_memory #(.PERIOD(PERIOD)) RAM (
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

        .busy           (busy),

	    .tb_addr_out_of_bounds (tb_addr_out_of_bounds),
	.gbif(gbif)
	);


endmodule
