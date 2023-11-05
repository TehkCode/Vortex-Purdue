// Guillaume Hu - hu724@purdue.edu

// `include "local_mem.vh"
`include "include/VX_define.vh"
`include "Vortex_mem_slave.vh"

// `include "local_mem.vh"
`include "Vortex_mem_slave.vh"
// `include "VX_define.vh"

`timescale 1 ns / 1 ns

// parameter PC_reset_val = 32'h8000_0000; // binaries are stuck with start addr 0x8000_0000
parameter PC_reset_val = 32'hF000_0000; // updated binaries

module VX_local_mem_tb; 

    parameter PERIOD = 2;
    parameter RSP_DELAY = 2 * PERIOD; 
    logic clk = 0;
    logic reset;
    logic nRST; 

    // parameters
    // parameter WORD_W = 32;
    // parameter DRAM_SIZE = 64;

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

    // Generic Bus Protocol Interface
    bus_protocol_if                      bpif(); 

    Vortex DUT(.clk(clk),
               .reset(reset), 
               .PC_reset_val(PC_reset_val),
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

    // local_mem MEM(.clk(clk), 
    //               .reset(reset), 
    //               .mem_req_valid(tb_mem_req_valid), 
    //               .mem_req_rw(tb_mem_req_rw), 
    //               .mem_req_byteen(tb_mem_req_byteen),
    //               .mem_req_addr(tb_mem_req_addr), 
    //               .mem_req_data(tb_mem_req_data), 
    //               .mem_req_tag(tb_mem_req_tag), 
    //               .mem_req_ready(tb_mem_req_ready), 
    //               .mem_rsp_valid(tb_mem_rsp_valid), 
    //               .mem_rsp_data(tb_mem_rsp_data), 
    //               .mem_rsp_tag(tb_mem_rsp_tag), 
    //               .mem_rsp_ready(tb_mem_rsp_ready), 
    //               .busy(tb_busy), 
    //               .tb_addr_out_of_bounds(tb_addr_out_of_bounds)
    // ); 

    Vortex_mem_slave #(
        .VORTEX_MEM_SLAVE_AHB_BASE_ADDR(PC_reset_val)
    ) MEM (
        .clk(clk), 
        .nRST(nRST), 
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
        .busy(busy), 
        .bpif(bpif)
    ); 

    // assign tb_mem_rsp_ready = mem_rsp_ready; 

    // initial begin 
    //     mem_req_ready = 1'b0; 
    //     mem_rsp_valid = 1'b0; 
    //     mem_rsp_data = '0; 
    //     mem_rsp_tag = '0; 

    //     tb_mem_req_valid = 1'b0; 
    //     tb_mem_req_rw = '0; 
    //     tb_mem_req_byteen = '0; 
    //     tb_mem_req_addr = '0; 
    //     tb_mem_req_data = '0; 
    //     tb_mem_req_tag = '0; 
        
    //     reset = 1'b1; 
    //     // Reset
    //     #(PERIOD * 13); 
    //     reset = 1'b0; 

    //     // Handshake to GPU
    //     mem_req_ready = 1'b1; 

    //     forever begin 
    //         // Buffer the correct values for the rsp 
    //         @(posedge mem_req_valid); 
    //         tb_mem_rsp_tag = mem_req_tag;
    //         tb_mem_req_addr = mem_req_addr; 
    //         tb_mem_req_byteen = mem_req_byteen; 
    //         tb_mem_req_rw = mem_req_rw; 
    //         tb_mem_req_data = mem_req_data; 
    //         #(RSP_DELAY);

    //         // Response to Vortex's request
    //         tb_mem_req_valid = 1'b1; // Trigger the local_mem
    //         mem_rsp_valid = 1'b1; 
    //         mem_rsp_data = tb_mem_rsp_data; 
    //         mem_rsp_tag = tb_mem_req_tag; 
    //         #(PERIOD); 
    //         mem_rsp_valid = 1'b0; 
    //     end 

    //     //$stop; 

    // end

    // delay count
    int delay;

    // tasks
    task automatic dump_memory();
        string filename = "tb/hex_files/mem_dump.hex";
        int memfd;

        // syif.tbCTRL = 1;
        // syif.addr = 0;
        // syif.WEN = 0;
        // syif.REN = 0;

        memfd = $fopen(filename,"w");
        if (memfd)
        $display("Starting memory dump.");
        else
        begin $display("Failed to open %s.",filename); $finish; end

        for (int unsigned i = 0; memfd && i < 16384; i++)
        begin
            int chksum = 0;
            bit [7:0][7:0] values;
            string ihex;

            // syif.addr = i << 2;
            // syif.REN = 1;
            bpif.addr = i << 2;
            bpif.ren = 1'b1;

            repeat (4) @(posedge clk);
            // if (syif.load === 0)
            if (bpif.rdata === '0)
                continue;
            // values = {8'h04,16'(i),8'h00,syif.load};
            values = {8'h04, 16'(i), 8'h00, bpif.rdata};
            foreach (values[j])
                chksum += values[j];
            chksum = 16'h100 - chksum;
            // ihex = $sformatf(":04%h00%h%h",16'(i),syif.load,8'(chksum));
            ihex = $sformatf(":04%h00%h%h", 16'(i), bpif.rdata, 8'(chksum));
            $fdisplay(memfd,"%s",ihex.toupper());
        end //for
        if (memfd)
        begin
            // syif.tbCTRL = 0;
            // syif.REN = 0;
            bpif.ren = 1'b0;
            $fdisplay(memfd,":00000001FF");
            $fclose(memfd);
            $display("Finished memory dump.");
        end
    endtask

    // Force end of sim
    initial begin 

        // Reset
        reset = 1'b1; 
        nRST = 1'b0;
        #(PERIOD * 13); 
        reset = 1'b0; 
        nRST = 1'b1;

        fork 
            // check for busy low
            begin
                @(negedge busy);
                $display("SUCCESS: got busy low");
            end

            // check if never finishes
            begin
                delay = 100000;
                #(delay); 
                $display("ERROR: never finished %d delay", delay);
            end
        join_any

        disable fork;

        // // delay before repeated program run
        // delay = 1000;
        // $display("delay %d before repeated program run", delay);
        // #(delay);
        
        // // Reset
        // reset = 1'b1; 
        // nRST = 1'b0;
        // #(PERIOD * 13); 
        // reset = 1'b0; 
        // nRST = 1'b1;

        // fork 
        //     // check for busy low
        //     begin
        //         @(negedge busy);
        //         $display("SUCCESS: got busy low");
        //     end

        //     // check if never finishes
        //     begin
        //         delay = 30000;
        //         #(delay); 
        //         $display("ERROR: never finished %d delay", delay);
        //     end
        // join_any

        // disable fork;

        // // delay before mem dump
        // delay = 1000;
        // $display("delay %d before mem dump", delay);
        // #(delay);

        // // mem dump
        // $display("begin mem dump");
        // dump_memory();

        // delay before end of sim
        delay = 1000;
        $display("delay %d before end of sim", delay);
        #(delay);

        // end of sim
        $display("end of sim");
        $stop();
    end 


endmodule 