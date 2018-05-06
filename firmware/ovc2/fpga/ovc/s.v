`timescale 1ns/1ns
// generic synchronizer
module s
#(parameter W=1)
(input wire c,
 input wire [W-1:0] d,
 output wire [W-1:0] q);

// originally this re-used the "r" DFF module, but for synchronizers,
// we want to explicitly prevent inference of shift registers

/*
wire [W*S-1:0] shift;
r #(.WIDTH(W*S)) shift_r
  (.c(c), .rst(1'b0), .en(1'b1),
   .d({shift[W*(S-1)-1:0], d}), .q(shift));
assign q = shift[W*S-1:W*(S-1)];
*/

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION off" *)
reg [W-1:0] d_d1;

(* altera_attribute = "-name AUTO_SHIFT_REGISTER_RECOGNITION off" *)
reg [W-1:0] d_d2;

initial begin
  d_d1 <= {W{1'b0}};
  d_d2 <= {W{1'b0}};
end

always @(posedge c) begin
  d_d1 <= d;
  d_d2 <= d_d1;
end
assign q = d_d2;

endmodule
