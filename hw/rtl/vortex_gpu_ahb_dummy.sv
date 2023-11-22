
module vortex_gpu_ahb_dummy (
    input logic VX_clk, VX_reset, 
    ahb_if.manager manager, 
    ahb_if.subordinate subordinate
); 

    Vortex VX_inst (
        .clk(VX_clk), 
        .reset(VX_reset)
    ); 
endmodule 
