`timescale 1ns/1ns
module dn
#(parameter W=1, parameter N=1)
(input c, input [W-1:0] d, output [W-1:0] q);

// delay W bits N clock cycles
wire [W*N-1:0] shift;
r #(.WIDTH(W*N)) shift_r
  (.c(c), .rst(1'b0), .en(1'b1),
   .d({shift[W*(N-1)-1:0], d}), .q(shift));
assign q = shift[W*N-1:W*(N-1)];

endmodule
