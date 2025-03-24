// Code your design here
module rptr_handler #(parameter WIDTH=8) (
  input rclk, r_en, rrst_n, 
  input logic [WIDTH:0] g_wptr_sync, 
  output logic[WIDTH:0] g_rptr, b_rptr, 
  output logic empty
);
  
  logic [WIDTH-1:0] b_rptr_next;
  logic[WIDTH-1:0] g_rptr_next;
  logic rempty;
  
  assign b_rptr_next = b_rptr+(r_en & !empty);
  assign g_rptr_next = (b_rptr_next>>1)^b_rptr_next;
  assign rempty=(g_wptr_sync == g_rptr_next);
  
  always_ff @(posedge rclk) begin
    if(rrst_n) begin
      g_rptr<=0;
      b_rptr<=0;
    end
    else begin
      g_rptr<=g_rptr_next;
      b_rptr<=b_rptr_next;
    end
  end
  
  always_ff @(posedge rclk) begin
    if(rrst_n) begin
      empty<=1;
    end
    else begin
      empty<=rempty;
    end
  end
    
endmodule 
