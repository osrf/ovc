`timescale 1ns/1ns
module d1
#(parameter W=1)
(input c, input [W-1:0] d, output [W-1:0] q);

r #(W) ff(.c(c), .rst(1'b0), .en(1'b1), .d(d), .q(q));

endmodule
