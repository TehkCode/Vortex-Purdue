`ifndef VX_MEM_RSP_IF
`define VX_MEM_RSP_IF

`include "../cache/VX_cache_define.vh"

interface VX_mem_rsp_if #(
    parameter DATA_WIDTH = 512,
    parameter TAG_WIDTH  = 8
) ();

    logic                    valid;    
    logic [DATA_WIDTH-1:0]   data;
    logic [TAG_WIDTH-1:0]    tag;  
    logic                    ready;  

    modport master (
        output valid,
        output data,
        output tag,
        input  ready
    );

    modport slave (
        input  valid,
        input  data,
        input  tag,
        output ready
    );    

endinterface

`endif