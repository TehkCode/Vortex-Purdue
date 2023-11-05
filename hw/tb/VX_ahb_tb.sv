//`include "VX_define.vh"

module VX_ahb_tb; 

    parameter PERIOD = 10; 
    logic CLK = 0;
    logic nRST; // Active high  

    always #(PERIOD/2) CLK = ~CLK; 

    ahb_if ahbif(.HCLK(CLK), .HRESETn(nRST)); 

    VX_ahb DUT(CLK, ~nRST, ahbif); 

    task check_hrdata; 
        assert(ahbif.HRDATA == DUT.mem_rsp_data) $display("Data sent and received correctly: %h", ahbif.HRDATA); 
        else $warning("Incorrect data received. Sent: %h, Received: %h", ahbif.HRDATA, DUT.mem_rsp_data);
    endtask 

    // Assume same clock
    initial begin 
        nRST = 1'b0; 
        #(PERIOD); 
        nRST = 1'b1; 

        for (int i = 0; i < 10; i++)begin 
            ahbif.HREADY = 1'b0; 
            ahbif.HRESP = 2'b0; 
            ahbif.HRDATA = 32'b0; 
            
            @(posedge CLK);  
            ahbif.HREADY = 1'b1; 
            ahbif.HRESP = 2'b0; 
            assert(randomize(ahbif.HRDATA));
            #2; 
            check_hrdata();
            @(posedge CLK);  
        end        
        $stop(); 
    end 

endmodule 