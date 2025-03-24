module w_ptr (
    input logic wclk, wrst_n,w_en,
    input logic [6:0] g_rptr_sync,
    output logic [6:0] b_wptr, g_wptr,
    output logic full
);

logic [6:0] b_wptr_nxt = 28;
logic [6:0] g_wptr_nxt;
logic [6:0] b_rptr;

logic wfull;

  
  // Calculate next binary pointer with wrap-around within the 28-99 range
  always_comb begin
    if (w_en && !full) begin
      if (b_wptr == 99)
        b_wptr_nxt = 28;  // Wrap around to 28
      else
        b_wptr_nxt = b_wptr + 1;
    end else begin
      b_wptr_nxt = b_wptr;
    end
  end

assign b_rptr = gray_to_bin(g_rptr_sync);

assign g_wptr_nxt = (b_wptr_nxt >>1) ^ b_wptr_nxt;

always_ff @(posedge wclk) begin
    if(wrst_n) begin
      b_wptr <= 0; 
      g_wptr <= 0;
    end
    else begin
      b_wptr <= b_wptr_nxt; 
      g_wptr <= g_wptr_nxt; 
    end
  end

always_ff @(posedge wclk) begin
    if(wrst_n) begin
        full <=0;
    end 
    else begin
        full<=wfull;
    end
end

// Full condition when write pointer + 1 would equal read pointer (considering wrap)
assign wfull = (((b_wptr + 1) % 72) == b_rptr);

  // Gray to binary conversion function
  function logic [6:0] gray_to_bin(input logic [6:0] gray2bin);
    logic [6:0] gray;
    begin
      gray = gray2bin;
      for (int i = 1; i <= 6; i = i + 1) begin
        gray = gray ^ (gray2bin >> i);
      end
      return gray;
    end
  endfunction

endmodule
