`timescale 1ns/1ns
module gmux
#(parameter DWIDTH = 1,
  parameter SELWIDTH = 2,
  parameter BIGENDIAN = 0,
  parameter TOT_DWIDTH = (DWIDTH << SELWIDTH),
  parameter NUM_WORDS = (1 << SELWIDTH))
(input wire [TOT_DWIDTH-1:0] d,
 input wire [SELWIDTH-1:0] sel,
 output wire [DWIDTH-1:0] z);

genvar b,w;
generate
  for (b=0;b<DWIDTH;b=b+1) begin: out
    wire [NUM_WORDS-1:0] tmp;
    for (w=0;w<NUM_WORDS;w=w+1) begin: mx
      if (BIGENDIAN == 1)
        assign tmp[NUM_WORDS-w-1] = d[w*DWIDTH+b];
      else
        assign tmp[w] = d[w*DWIDTH+b];
      end
      assign z[b] = tmp[sel];
    end
  endgenerate
endmodule

`ifdef TEST_GMUX
module tb
 (input clk,
  input [15:0] d,
  input [2:0] sel,
  output reg [1:0] tmp);

wire [1:0] z;
gmux #(2, 3) dut(d, sel, z);

always @(posedge clk)
  tmp <= z;

endmodule
`endif
