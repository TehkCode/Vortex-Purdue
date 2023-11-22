`include "VX_define.vh"
//VX local ram and vortex instantiated, synthesizable.

module VX_vortex_to_local_mem (
    // seq
    input clk, reset
);
    // Memory Request:
    // vortex outputs
    wire                             mem_req_valid;
    wire                             mem_req_rw;
    wire [`VX_MEM_BYTEEN_WIDTH-1:0]  mem_req_byteen; // 64 (512 / 8)
    wire [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_addr;   // 26
    wire [`VX_MEM_DATA_WIDTH-1:0]    mem_req_data;   // 512
    wire [`VX_MEM_TAG_WIDTH-1:0]     mem_req_tag;    // 56 (55 for SM disabled)
    // vortex inputs
    wire                            mem_req_ready;

    // Memory response:
    // vortex inputs
    wire                            mem_rsp_valid;        
    wire [`VX_MEM_DATA_WIDTH-1:0]   mem_rsp_data;   // 512
    wire [`VX_MEM_TAG_WIDTH-1:0]    mem_rsp_tag;    // 56 (55 for SM disabled)
    // vortex outputs
    wire                             mem_rsp_ready;

    // Status:
    // vortex outputs
    wire                             busy;

    // tb:
    wire                            tb_addr_out_of_bounds;


    //vortex
    Vortex vortex(
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

        //.tb_addr_out_of_bounds (tb_addr_out_of_bounds)
	);
    
    //local ram
    local_mem RAM (
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

        .tb_addr_out_of_bounds (tb_addr_out_of_bounds)
	);


endmodule
