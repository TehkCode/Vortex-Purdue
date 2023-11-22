module counter
#(
    parameter NUM_CNT_BITS = 4
)
(
    input logic clk,n_rst,clear,count_enable,
    input logic [NUM_CNT_BITS-1:0] rollover_val,
    output reg rollover_flag,
    output reg [NUM_CNT_BITS-1:0] count_out
);
    reg [NUM_CNT_BITS-1:0] nxt_count;
    reg roll_f;

    always_ff @ (negedge n_rst, posedge clk) begin : REG_LOGIC
        if (~n_rst)
        begin
            count_out <= 'b0;
            rollover_flag <= 'b0;
        end
        else
        begin
            count_out <= nxt_count;
            rollover_flag <= roll_f;
        end
    end

    always_comb begin : NXT_LOGIC
        roll_f = 1'b0;
        nxt_count = count_out;
        if (clear == 1'b1)
            nxt_count = 'b0;
        else if (count_enable)
        begin
            if (rollover_flag)
                nxt_count = 1;
            else
                nxt_count = count_out + 1;
        end
        else
            nxt_count = count_out;

        if (nxt_count == rollover_val)
            roll_f = 1'b1;
        else
            roll_f = 1'b0;
    end
endmodule