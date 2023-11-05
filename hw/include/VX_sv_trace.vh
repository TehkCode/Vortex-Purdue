/*

Guillaume Hu - hu724@purdue.edu


Description: Header file for function definition intended for Vortex tracing in SystemVerilog. 

*/

`ifdef SV_TRACE_EN

`ifndef VX_SV_TRACE
`define VX_SV_TRACE


`define SV_TRACE(ARG1, ARG2)                     \
   $fwrite(ARG2, ARG1);                          


`define SV_TRACE_ARRAY1D(a, m, fp)                     \
    `SV_TRACE("{", fp);                             \
    for (integer i = (m-1); i >= 0; --i) begin  \
        if (i != (m-1)) `SV_TRACE(", ", fp);        \
        `SV_TRACE($sformatf("0x%0h", a[i]), fp);               \
    end                                         \
    `SV_TRACE("}", fp);                             

`define SV_TRACE_ARRAY2D(a, m, n, fp)                  \
    `SV_TRACE("{", fp);                             \
    for (integer i = n-1; i >= 0; --i) begin    \
        if (i != (n-1)) `SV_TRACE(", ", fp);        \
        `SV_TRACE("{", fp);                         \
        for (integer j = (m-1); j >= 0; --j) begin \
            if (j != (m-1)) `SV_TRACE(", ", fp);    \
            `SV_TRACE($sformatf("0x%0h", a[i][j]), fp);        \
        end                                     \
        `SV_TRACE("}", fp);                         \
    end                                         

`endif

`endif