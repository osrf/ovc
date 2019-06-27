`timescale 1ns/1ns
module d4
#(parameter W=1)
(input c, input [W-1:0] d, output [W-1:0] q);

wire [W-1:0] d_d1, d_d2, d_d3;

d1 #(W) ff1(.c(c), .d(d   ), .q(d_d1));
d1 #(W) ff2(.c(c), .d(d_d1), .q(d_d2));
d1 #(W) ff3(.c(c), .d(d_d2), .q(d_d3));
d1 #(W) ff4(.c(c), .d(d_d3), .q(q   ));

endmodule
