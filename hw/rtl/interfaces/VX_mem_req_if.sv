`ifndef VX_MEM_REQ_IF
`define VX_MEM_REQ_IF

`include "../cache/VX_cache_define.vh"

interface VX_mem_req_if #(
    parameter DATA_WIDTH = 512,
    parameter ADDR_WIDTH = 26,
    parameter TAG_WIDTH  = 8,
    parameter DATA_SIZE  = DATA_WIDTH / 8
) ();

    logic                    valid;    
    logic                    rw;    
    logic [DATA_SIZE-1:0]    byteen;
    logic [ADDR_WIDTH-1:0]   addr;
    logic [DATA_WIDTH-1:0]   data;  
    logic [TAG_WIDTH-1:0]    tag;  
    logic                    ready;

    modport master (
        output valid,    
        output rw,
        output byteen,
        output addr,
        output data,
        output tag,
        input  ready
    );

    modport slave (
        input  valid,   
        input  rw,
        input  byteen,
        input  addr,
        input  data,
        input  tag,
        output ready
    );

endinterface

`endif