//socet33 : Raghul Prakash
`include "VX_define.vh"
//mem req and resp adherent ram to store code and data and by pass axi/ahb bridge
`define ceilLog2(x) ( \
(x) > 2**30 ? 31 : \
(x) > 2**29 ? 30 : \
(x) > 2**28 ? 29 : \
(x) > 2**27 ? 28 : \
(x) > 2**26 ? 27 : \
(x) > 2**25 ? 26 : \
(x) > 2**24 ? 25 : \
(x) > 2**23 ? 24 : \
(x) > 2**22 ? 23 : \
(x) > 2**21 ? 22 : \
(x) > 2**20 ? 21 : \
(x) > 2**19 ? 20 : \
(x) > 2**18 ? 19 : \
(x) > 2**17 ? 18 : \
(x) > 2**16 ? 17 : \
(x) > 2**15 ? 16 : \
(x) > 2**14 ? 15 : \
(x) > 2**13 ? 14 : \
(x) > 2**12 ? 13 : \
(x) > 2**11 ? 12 : \
(x) > 2**10 ? 11 : \
(x) > 2**9 ? 10 : \
(x) > 2**8 ? 9 : \
(x) > 2**7 ? 8 : \
(x) > 2**6 ? 7 : \
(x) > 2**5 ? 6 : \
(x) > 2**4 ? 5 : \
(x) > 2**3 ? 4 : \
(x) > 2**2 ? 3 : \
(x) > 2**1 ? 2 : \
(x) > 2**0 ? 1 : 0)

module VX_to_mem_bypass (
  input         clk,
  input         reset,

  input                       mem_req_valid,
  output                      mem_req_ready,
  input                       mem_req_rw,
  input [`VX_MEM_ADDR_WIDTH-1:0]  mem_req_addr,
  input [`VX_MEM_TAG_WIDTH-1:0]   mem_req_tag,

  input [`VX_MEM_DATA_WIDTH-1:0]  mem_req_data,

  output reg                  mem_rsp_valid,
  output reg [`VX_MEM_DATA_WIDTH-1:0] mem_rsp_data,
  output reg [`VX_MEM_TAG_WIDTH-1:0] mem_rsp_tag,
  input                       mem_rsp_ready
);

  localparam DATA_CYCLES = 8;
  localparam MAX_SIZE = 2*1024*1024;

  reg [`ceilLog2(DATA_CYCLES)-1:0] cnt; //count number of cycles for variable latency ram
  reg [`VX_MEM_TAG_WIDTH-1:0] tag;
  reg state_busy, state_rw;  //state of ram (read/write or busy)
  reg [`VX_MEM_ADDR_WIDTH-1:0] addr; //address

  reg [31:0] ram [MAX_SIZE-1:0]; //ram instance
  wire [`ceilLog2(MAX_SIZE)-1:0] ram_addr = state_busy  ?         {addr[`ceilLog2(MAX_SIZE/DATA_CYCLES)-1:0], cnt}
                                                     : {mem_req_addr[`ceilLog2(MAX_SIZE/DATA_CYCLES)-1:0], cnt}; //if state busy addr is 
  wire do_read = mem_req_valid && mem_req_ready && !mem_req_rw || state_busy && !state_rw; //do read of ram if mem_req is valid and 
  wire do_write = mem_req_valid;

  //initialize ram to zero
  initial
  begin : zero
    integer i;
    for (i = 0; i < MAX_SIZE; i = i+1)
      ram[i] = 32'b0;
  end
  //FSM for RAM (state_busy or do r/w)
  always @(posedge clk, negedge reset)
  begin
    if (reset)
      state_busy <= 1'b0;
    else if ((do_read || do_write) && cnt == DATA_CYCLES-1)
      state_busy <= 1'b0; //read or write and cycles have completed for variable latency
    else if (mem_req_valid && mem_req_ready)
      state_busy <= 1'b1; //if mem_req is valid and ready then fire the ram with busy signal, this means handshake has been done and ram can fetch data

    //if not busy and req is valid from memory
    if (!state_busy && mem_req_valid)
    begin
      state_rw <= mem_req_rw;
      tag <= mem_req_tag;
      addr <= mem_req_addr;
    end

    //reset clock count to zero
    if (reset) begin
      cnt <= 1'b0;
    end
    else if(do_read || do_write) begin
      cnt <= cnt + 1'b1;
    end
    
    //if write, ram_addr[] is mem_req_data else read 
    if (do_write) begin
        ram[ram_addr][31:0] <= mem_req_data;
    end
    else begin
        mem_rsp_data <= ram[ram_addr][31:0];
    end
    //mem_rsp
    if (reset)
      mem_rsp_valid <= 1'b0;
    else
      mem_rsp_valid <= do_read;

    mem_rsp_tag <= state_busy ? tag : mem_req_tag;
  end
  
  //if state not busy
  assign mem_req_ready = !state_busy; //
  assign mem_rsp_ready = state_busy && state_rw; //response from ram is ready if state_busy and r/w

endmodule
