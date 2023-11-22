// Guillaume Hu - hu724@purdue.edu

// `include "local_mem.vh"
`include "include/VX_define.vh"
`include "Vortex_mem_slave.vh"

// `include "local_mem.vh"
`include "Vortex_mem_slave.vh"
// `include "VX_define.vh"

`timescale 1 ns / 1 ns

parameter PC_reset_val = 32'h8000_0000; // binaries are stuck with start addr 0x8000_0000
// parameter PC_reset_val = 32'hF000_0000; // updated binaries

// hang detection parameters
parameter DISPLAY_DELAY = 1000; // arbitrary, customizable
parameter MEM_REQ_DELAY = 1000; // arbitrary, customizable
parameter DELAY = 1000000; // arbitrary, customizable

module VX_local_mem_tb; 

    parameter PERIOD = 2;
    logic clk = 1'b0;
    logic reset;
    logic nRST; 
    int half_cycle_counter = 0;

    // clock gen and cycle count
    always #(PERIOD/2) begin
        half_cycle_counter++;
        clk = ~clk;
    end

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

    Vortex DUT(
        .clk(clk),
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

    // delay count
    int delay;
    int display_delay;

    // hang detection signals
    int mem_req_delay;
    int last_mem_req_cycle;
    logic bad_address = 1'b0;
    logic hang_detected = 1'b0;

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

        $display("\nRESET: end of reset\n");

        // reset half cycle counter (started counting during reset)
        half_cycle_counter = 2;

        fork 
            // check for busy low
            begin
                @(negedge busy);
                $display("\nSUCCESS: got busy low after %d cycles", half_cycle_counter >> 1);
            end

            // cyclewise checks
            begin
                display_delay = DISPLAY_DELAY; // arbitrary, customizable
                mem_req_delay = MEM_REQ_DELAY; // arbitrary, customizable
                delay = DELAY; // arbitrary, customizable

                while (1)
                begin
                    // check for display cycle
                    if ((half_cycle_counter >> 1) % display_delay == 0)
                    begin
                        $display("DISPLAY: cycle %d", half_cycle_counter >> 1);
                    end

                    // check if should check recent mem req 
                    if ((half_cycle_counter >> 1) % mem_req_delay == 0)
                    begin
                        // check if recent mem req
                        if ((half_cycle_counter >> 1) - last_mem_req_cycle > mem_req_delay)
                        begin
                            $display("\nHANG: last mem req was %d cycles ago", (half_cycle_counter>>1) - last_mem_req_cycle);
                            break;
                        end
                    end

                    // check for program timeout
                    if ((half_cycle_counter >> 1) % delay == 0)
                    begin
                        $display("\nDELAY: busy not low after %d cycles", delay);
                        break;
                    end

                    // increment cycle
                    #(PERIOD);
                end
            end

            // check for mem request outside of expected range and save last mem req
            begin
                // save time since last mem req
                last_mem_req_cycle = half_cycle_counter >> 1;

                // loop until get bad mem req
                while (1)
                begin
                    // wait til next mem req
                    @(posedge mem_req_valid);

                    // save time since last mem req
                    last_mem_req_cycle = half_cycle_counter >> 1;

                    // check for bad mem req
                    if (mem_req_addr[25:22] != PC_reset_val[31:28])
                    begin
                        $display("ERROR: mem req outside of expected address space");
                        $display("ERROR:     expected upper bits: %h", PC_reset_val[31:28]);
                        $display("ERROR:     upper bits received: %h", mem_req_addr[25:22]);
                        break;
                    end
                end
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
        delay = 2;
            // works if get bad address, end of sim captures the bad address req only in VX_top_traces.txt
        $display("\nEND OF SIM: delay %d cycles before end of sim", delay);
        #(delay * PERIOD);

        // end of sim
        $display("END OF SIM: done\n");
        $stop();
    end 


endmodule 