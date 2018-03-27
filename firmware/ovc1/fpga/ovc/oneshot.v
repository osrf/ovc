`timescale 1ns/1ns
module oneshot
#(parameter SYNC = 2,
  parameter W = 1)
(input wire c,
 input  wire [W-1:0] d,
 output wire [W-1:0] q);

generate
  if (SYNC == 0 || SYNC == 1) begin
    wire d_d1;
    d1 #(W) d_d1_r(.c(c), .d(d), .q(d_d1));
    assign q = d & ~d_d1;
  end else begin
    // chain of N flops to synchronize to clock c
    wire [W*SYNC-1:0] shift;
    d1 #(W*SYNC) shift_r
    (.c(c), .d({d, shift[W*SYNC-1:W]}), .q(shift));
    assign q = shift[2*W-1:W] & ~shift[W-1:0];
  end
endgenerate

endmodule
