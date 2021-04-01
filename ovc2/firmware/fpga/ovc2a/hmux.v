`timescale 1ns/1ns
// input is a concatenation of all inputs
module hmux
#(parameter DWIDTH = 1,
  parameter WORDCOUNT = 4,
  parameter OUTPUT_REG = 0,
  parameter TOT_DWIDTH = (DWIDTH * WORDCOUNT)
 )
(input wire c, // only needed if OUTPUT_REG=1
 input wire [TOT_DWIDTH-1:0] d,
 input wire [WORDCOUNT-1:0] sel,
 output wire [DWIDTH-1:0] q
);

wire [DWIDTH-1:0] q_int;
genvar b,w;
generate
  for (b=0;b<DWIDTH;b=b+1) begin:bx
    wire [WORDCOUNT-1:0] t;
    for (w=0;w<WORDCOUNT;w=w+1) begin:wx
      assign t[w] = sel[w] & d[w*DWIDTH+b];
    end
    assign q_int[b] = |t;
  end

  if (OUTPUT_REG)
    d1 #(DWIDTH) r(.c(c), .d(q_int), .q(q));
  else
    assign q = q_int;
endgenerate

endmodule

`ifdef TEST_HMUX
module tb
(input clk,
 input [31:0] d,
 input [3:0] sel,
 output reg [7:0] tmp);

wire [7:0] q;
hmux #(8, 4) dut(d, sel, q);
// assign q = (({8{sel[0]}} & d[7:0]) |
//             ({8{sel[1]}} & d[15:8]) |
//             ({8{sel[2]}} & d[23:16]) |
//             ({8{sel[3]}} & d[31:24]) );

always @(posedge clk)
  tmp <= q;

endmodule
`endif
