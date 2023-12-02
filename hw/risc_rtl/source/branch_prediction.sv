`include "branch_prediction_if.vh"
import cpu_types_pkg::*;

module branch_prediction(
    input logic CLK, nRST,
    branch_prediction_if.br_pd br_pd
);

parameter BTB_SIZE = 16; //BTB length
parameter INDEX_SIZE = $clog2(BTB_SIZE); //log2(BTB_SIZE) 4 bits

logic [INDEX_SIZE-1:0] btb_index;
logic [INDEX_SIZE-1:0] btb_index_wr;

word_t btb_tag[0:BTB_SIZE-1]; //current_PC
word_t btb_target[0:BTB_SIZE-1]; //target_PC
logic [1:0] counter[0:BTB_SIZE-1]; // 2-bit saturating counter 

// 2 bit counter | BTB_tag (PC_index) | Branch target addr  

//Read BTB
assign btb_index = br_pd.current_PC[INDEX_SIZE+1:2];
always_comb 
begin
if (btb_tag[btb_index] == br_pd.current_PC) // Check if the BTB has a valid entry for the current PC
begin
    if (counter[btb_index] == 2'b11 || counter[btb_index] == 2'b10) br_pd.predicted_PC = btb_target[btb_index];// Use the BTB data if the counter is strongly taken or weakly taken
    else br_pd.predicted_PC = br_pd.current_PC + 4; // Otherwise, use not taken
end
else 
begin // If the BTB does not have a valid entry, use not taken
    br_pd.predicted_PC = br_pd.current_PC + 4;
end
end

// update the cntr
// 11 : strong taken
// 10 : weak taken
// 01 : weak not taken
// 00 : strong not taken

//Write BTB
assign btb_index_wr = br_pd.update_PC[INDEX_SIZE+1:2];
always_ff @(posedge CLK or negedge nRST)
begin
    if (!nRST) 
    begin
        for (int i = 0; i < BTB_SIZE; i++) begin
            counter[i] <= 32'h00000000;
            btb_tag[i] <= 32'h00000000;
            btb_target[i] <= 32'h00000000;
        end     
    end 
    else 
    begin
        if(br_pd.Wr_enable)
        begin
        if(btb_tag[btb_index_wr] == br_pd.update_PC)  // Check if the BTB has a valid entry for the current PC
        begin
            casez (counter[btb_index_wr])
                2'b00: if (br_pd.is_taken) counter[btb_index_wr] <= 2'b01;
                    else counter[btb_index_wr] <= 2'b00;
                2'b01: if (br_pd.is_taken){counter[btb_index_wr], btb_target[btb_index_wr]} <= {2'b10, br_pd.update_target_PC};
                    else counter[btb_index_wr] <= 2'b00;
                2'b10: if (br_pd.is_taken) counter[btb_index_wr] <= 2'b11;
                    else {counter[btb_index_wr], btb_target[btb_index_wr]} <= {2'b01, br_pd.update_target_PC};
                2'b11: if (br_pd.is_taken) counter[btb_index_wr] <= 2'b11;                        
                    else counter[btb_index_wr] <= 2'b10;
            endcase              
        end
        else //fill the BTB 
        begin
            btb_tag[btb_index_wr] <= br_pd.update_PC;
            btb_target[btb_index_wr] <= br_pd.update_target_PC;
            if (br_pd.is_taken) counter[btb_index_wr] <= 2'b11;
            else counter[btb_index_wr] <= 2'b00;
        end
        end
    end
end


endmodule
