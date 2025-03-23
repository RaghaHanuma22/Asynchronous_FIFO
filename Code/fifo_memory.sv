module fifo_mem #(parameter DATA_WIDTH = 8, DEPTH = 72) (
    input logic wclk,rclk,w_en,r_en,full,empty,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic [6:0] b_rptr,b_wptr,
    output logic [DATA_WIDTH-1:0] data_out
);

logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

always_ff @(posedge wclk) begin
    if(w_en && !full) begin
        mem[b_wptr] <= data_in;
    end
end

assign data_out = (r_en && ~empty)? mem[b_rptr]:mem[b_rptr-1];

endmodule