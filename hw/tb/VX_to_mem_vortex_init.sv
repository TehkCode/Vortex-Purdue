//socet 33: Raghul Prakash (prakasr)
`define MEM_ADDR_START 0xfffe //w only
`define MEM_ADDR_STATUS 0xffff //r only
module VX_to_mem_vortex_init(input wire clk, input wire reset, input wire [31:0] ext_addr, input wire [31:0] data, input wire rw);
  //ext_addr and data are slave interfaces of AHB
  wire vx_mem_req_valid, 
  wire vx_mem_req_ready; 
  wire vx_mem_req_rw; 
  wire vx_mem_req_addr; 
  wire vx_mem_req_tag; 
  wire vx_mem_req_data; 
  wire vx_mem_rsp_valid; 
  wire vx_mem_rsp_data; 
  wire vx_mem_rsp_tag;
  wire vx_mem_rsp_ready;
  
  reg [31:0] status; //status of GPU .register `MEM_ADDR_STATUS read only
  reg [31:0] vx_start; //start the GPU .register `MEM_ADDR_START write only
  
  //ff for register
  always_ff @ (posedge clk, negedge reset) begin
    if (reset) begin
        vx_start <= 32'b0;
        status <= 32'b0;
    end
    else begin
        status <= busy; //always wired to busy signal
        vx_start <= n_vx_start; 
    end
  end
  
  //next state of registers
  always_comb begin
      n_vx_start = 32'b0;
      n_status = 32'b0;
    if (~rw) begin //write
      case (ahb_addr) 
          `MEM_ADDR_START: n_vx_start = data;
      endcase
    end
  end
  
  Vortex vortex(.clk            (clk),
                .reset          (reset | vx_start),

                .mem_req_valid  (vx_mem_req_valid),
                .mem_req_rw     (vx_mem_req_rw),
                .mem_req_byteen (vx_mem_req_byteen),
                .mem_req_addr   (vx_mem_req_addr),
                .mem_req_data   (vx_mem_req_data),
                .mem_req_tag    (vx_mem_req_tag),
                .mem_req_ready  (vx_mem_req_ready),

                .mem_rsp_valid  (vx_mem_rsp_valid),
                .mem_rsp_data   (vx_mem_rsp_data),
                .mem_rsp_tag    (vx_mem_rsp_tag),
                .mem_rsp_ready  (vx_mem_rsp_ready),

                .busy           (busy));
  
  VX_to_mem_bypass RAM( .clk(clk), 
                        .reset(reset), 
                        .mem_req_valid  (vx_mem_req_valid),
                        .mem_req_rw     (vx_mem_req_rw),
                        .mem_req_byteen (vx_mem_req_byteen),
                        .mem_req_addr   (vx_mem_req_addr),
                        .mem_req_data   (vx_mem_req_data),
                        .mem_req_tag    (vx_mem_req_tag),
                        .mem_req_ready  (vx_mem_req_ready),

                        .mem_rsp_valid  (vx_mem_rsp_valid),
                        .mem_rsp_data   (vx_mem_rsp_data),
                        .mem_rsp_tag    (vx_mem_rsp_tag),
                        .mem_rsp_ready  (vx_mem_rsp_ready));


  
endmodule
