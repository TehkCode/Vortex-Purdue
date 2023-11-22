`include "VX_define.vh"

module VX_ahb_adapter #(
    parameter VX_DATA_WIDTH    = 512, 
    parameter VX_ADDR_WIDTH    = (32 - $clog2(VX_DATA_WIDTH/8)), //26           
    parameter VX_TAG_WIDTH     = 8,
    parameter AHB_DATA_WIDTH   = (VX_DATA_WIDTH / 16), 
    parameter AHB_ADDR_WIDTH   = 32,
    //parameter AHB_TID_WIDTH    = VX_TAG_WIDTH,
    parameter VX_BYTEEN_WIDTH  = (VX_DATA_WIDTH / 8),
    parameter AHB_STROBE_WIDTH = 4
) (
    input  logic                         clk,
    input  logic                         nRST,

    // Vortex request
    input logic                          mem_req_valid,
    input logic                          mem_req_rw,
    input logic [VX_BYTEEN_WIDTH-1:0]    mem_req_byteen,
    input logic [VX_ADDR_WIDTH-1:0]      mem_req_addr,
    input logic [VX_DATA_WIDTH-1:0]      mem_req_data,
    input logic [55:0]       mem_req_tag,

    // Vortex response
    input logic                          mem_rsp_ready,
    output logic                         mem_rsp_valid,        
    output logic [VX_DATA_WIDTH-1:0]     mem_rsp_data,
    output logic [55:0]      mem_rsp_tag,
    output logic                         mem_req_ready,

    //AHB signals
    // input logic ahb.HREADY, ahb.HRESP,
    // input logic [31:0] ahb.HRDATA,
    // output logic ahb.HWRITE,
    // output logic [1:0] ahb.HTRANS,
    // output logic [2:0] ahb.HBURST,
    // output logic [2:0] ahb.HSIZE,
    // output logic [31:0] ahb.HADDR,
    // output logic [31:0] ahb.HWDATA,
    // output logic [3:0] ahb.HWSTRB,
    // output logic ahb.HSEL

    ahb_if.manager ahb
    // VX_mem_req_if.slave req,
    // VX_mem_rsp_if.master rsp
    
    //to do: add burst
);

    logic [3:0] count;
    //localparam size = $clog2(VX_DATA_WIDTH/8);
    //localparam num_cycles = (512/VX_DATA_WIDTH);

    typedef enum logic [2:0] {IDLE, DATA, START, COMPLETE, ERROR} states;

    states state, nxt_state;
    
    logic [15:0] [31:0] data_read;
    logic [15:0] [31:0] nxt_data_read;
    logic rollover_flag;


    logic [31:0] full_addr;

    logic [511:0] nxt_data, data;
    logic [55:0] nxt_tag, tag;
    logic nxt_rw, rw, clear, count_en;
    logic [31:0] nxt_addr, addr;
    logic [63:0] nxt_byteen, byteen;
    
    always_ff @(posedge clk, negedge nRST) begin : STATE_TRANSITIONS
        if (~nRST) begin
            state <= IDLE;
            data <= '0;
            addr <= '0;
            rw <= '0;
            data_read <= '0;
            tag <= '0;
            byteen <= '0;
        end
        else begin
            data_read <= nxt_data_read;
            state <= nxt_state;
            data <= nxt_data;
            addr <= nxt_addr;
            tag <= nxt_tag;
            rw <= nxt_rw;
            byteen <= nxt_byteen;
        end
    end

    assign full_addr = {mem_req_addr, 6'd0};

    always_comb begin : STATES_CTRL
        nxt_state = state;
        
        case(state)

            IDLE: nxt_state = (mem_req_valid) ? START : IDLE;

            START: nxt_state = DATA;

            DATA: begin
                if ((ahb.HREADY == 1) && (rollover_flag)) begin
                    nxt_state = COMPLETE;
                end
                else if (ahb.HRESP == 1)
                    nxt_state = ERROR;
                else begin
                    nxt_state = DATA;
                end
            end

            ERROR: begin
                nxt_state = IDLE;
            end

            COMPLETE: begin
                if (mem_rsp_ready == 1)
                    nxt_state = IDLE;
                else
                    nxt_state = COMPLETE;
            end
        endcase
    end

    always_comb begin : OUTPUTS
        ahb.HSEL = 0;
        ahb.HSIZE = '0;
        ahb.HTRANS = '0;
        ahb.HWRITE = 0;
        ahb.HADDR = '0;
        ahb.HWDATA = '0;
        ahb.HWSTRB = '0;
        nxt_addr = addr;
        nxt_rw = rw;
        nxt_data = data;
        nxt_data_read = data_read;
        nxt_byteen = byteen;
        nxt_tag = tag;
        count_en = 0;
        clear = 0;
        mem_rsp_valid = 0;
        mem_req_ready = 0;
        mem_rsp_tag = '0;

        case(state)
            IDLE: begin
                mem_req_ready = 1;
                if (mem_req_valid == 1) begin
                    nxt_data = mem_req_data;
                    nxt_addr = full_addr;
                    nxt_rw = mem_req_rw;
                    nxt_tag = mem_req_tag;
                    nxt_byteen = mem_req_byteen;
                    clear = 1;
                end
            end

            START: begin
                ahb.HSEL = 1;
                ahb.HSIZE = 3'b010;
                ahb.HTRANS = 2'b10;
                ahb.HWRITE = rw;
                ahb.HADDR = addr;
                nxt_addr = addr + 4;
            end

            DATA: begin 
                if ((ahb.HREADY == 1)) begin
                    count_en = 1;
                    ahb.HSEL = 1;
                    ahb.HSIZE = 3'b010;
                    ahb.HTRANS = 2'b10;
                    ahb.HWRITE = rw;
                    ahb.HADDR = addr;
                    nxt_addr = addr + 4;
                    case (count)
                        4'd0: begin
                            nxt_data_read[0] = ahb.HRDATA;
                            ahb.HWDATA = data[31:0];
                            ahb.HWSTRB = byteen[3:0];
                        end
                        4'd1: begin
                            nxt_data_read[1] = ahb.HRDATA;
                            ahb.HWDATA = data[63:32];
                            ahb.HWSTRB = byteen[7:4];
                        end
                        4'd2: begin
                            nxt_data_read[2] = ahb.HRDATA;
                            ahb.HWDATA = data[95:64];
                            ahb.HWSTRB = byteen[11:8];
                        end
                        4'd3: begin
                            nxt_data_read[3] = ahb.HRDATA;
                            ahb.HWDATA = data[127:96];
                            ahb.HWSTRB = byteen[15:12];
                        end
                        4'd4: begin
                            nxt_data_read[4] = ahb.HRDATA;
                            ahb.HWDATA = data[159:128];
                            ahb.HWSTRB = byteen[19:16];
                        end
                        4'd5: begin
                            nxt_data_read[5] = ahb.HRDATA;
                            ahb.HWDATA = data[191:160];
                            ahb.HWSTRB = byteen[23:20];
                        end
                        4'd6: begin
                            nxt_data_read[6] = ahb.HRDATA;
                            ahb.HWDATA = data[223:192];
                            ahb.HWSTRB = byteen[27:24];
                        end
                        4'd7: begin
                            nxt_data_read[7] = ahb.HRDATA;
                            ahb.HWDATA = data[255:224];
                            ahb.HWSTRB = byteen[31:28];
                        end
                        4'd8: begin
                            nxt_data_read[8] = ahb.HRDATA;
                            ahb.HWDATA = data[287:256];
                            ahb.HWSTRB = byteen[35:32];
                        end
                        4'd9: begin
                            nxt_data_read[9] = ahb.HRDATA;
                            ahb.HWDATA = data[319:288];
                            ahb.HWSTRB = byteen[39:36];
                        end
                        4'd10: begin
                            nxt_data_read[10] = ahb.HRDATA;
                            ahb.HWDATA = data[351:320];
                            ahb.HWSTRB = byteen[43:40];
                        end
                        4'd11: begin
                            nxt_data_read[11] = ahb.HRDATA;
                            ahb.HWDATA = data[383:352];
                            ahb.HWSTRB = byteen[47:44];
                        end
                        4'd12: begin
                            nxt_data_read[12] = ahb.HRDATA;
                            ahb.HWDATA = data[415:384];
                            ahb.HWSTRB = byteen[51:48];
                        end
                        4'd13: begin
                            nxt_data_read[13] = ahb.HRDATA;
                            ahb.HWDATA = data[447:416];
                            ahb.HWSTRB = byteen[55:52];
                        end
                        4'd14: begin
                            nxt_data_read[14] = ahb.HRDATA;
                            ahb.HWDATA = data[479:448];
                            ahb.HWSTRB = byteen[59:56];
                        end
                        4'd15: begin
                            nxt_data_read[15] = ahb.HRDATA;
                            ahb.HWDATA = data[511:480];
                            ahb.HWSTRB = byteen[63:60];
                        end
                    endcase
                end
                else
                begin
                    count_en = 0;
                    ahb.HSEL = 1;
                    ahb.HSIZE = 3'b010;
                    ahb.HTRANS = 2'b10;
                    ahb.HWRITE = rw;
                    ahb.HADDR = addr;
                    case (count)
                        4'd0: begin
                            ahb.HWDATA = data[31:0];
                            ahb.HWSTRB = byteen[3:0];
                        end
                        4'd1: begin
                            ahb.HWDATA = data[63:32];
                            ahb.HWSTRB = byteen[7:4];
                        end
                        4'd2: begin
                            ahb.HWDATA = data[95:64];
                            ahb.HWSTRB = byteen[11:8];
                        end
                        4'd3: begin
                            ahb.HWDATA = data[127:96];
                            ahb.HWSTRB = byteen[15:12];
                        end
                        4'd4: begin
                            ahb.HWDATA = data[159:128];
                            ahb.HWSTRB = byteen[19:16];
                        end
                        4'd5: begin
                            ahb.HWDATA = data[191:160];
                            ahb.HWSTRB = byteen[23:20];
                        end
                        4'd6: begin
                            ahb.HWDATA = data[223:192];
                            ahb.HWSTRB = byteen[27:24];
                        end
                        4'd7: begin
                            ahb.HWDATA = data[255:224];
                            ahb.HWSTRB = byteen[31:28];
                        end
                        4'd8: begin
                            ahb.HWDATA = data[287:256];
                            ahb.HWSTRB = byteen[35:32];
                        end
                        4'd9: begin
                            ahb.HWDATA = data[319:288];
                            ahb.HWSTRB = byteen[39:36];
                        end
                        4'd10: begin
                            ahb.HWDATA = data[351:320];
                            ahb.HWSTRB = byteen[43:40];
                        end
                        4'd11: begin 
                            ahb.HWDATA = data[383:352];
                            ahb.HWSTRB = byteen[47:44];
                        end
                        4'd12: begin
                            ahb.HWDATA = data[415:384];
                            ahb.HWSTRB = byteen[51:48];
                        end
                        4'd13: begin
                            ahb.HWDATA = data[447:416];
                            ahb.HWSTRB = byteen[55:52];
                        end
                        4'd14: begin
                            ahb.HWDATA = data[479:448];
                            ahb.HWSTRB = byteen[59:56];
                        end
                        4'd15: begin
                            ahb.HWDATA = data[511:480];
                            ahb.HWSTRB = byteen[63:60];
                        end
                    endcase
                end
            end

            COMPLETE: begin
                mem_rsp_valid = 1;
                mem_rsp_tag = tag;
            end  
        endcase
    end

    assign mem_rsp_data = data_read;

    wrapper_counter
    SIXTEEN(
        .clk(clk),
        .nRST(nRST),
        .clear(clear),
        .count_enable(count_en),
        .rollover_val(4'd15),
        .rollover_flag(rollover_flag),
        .count_out(count)
    );

endmodule
