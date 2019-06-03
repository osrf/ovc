`timescale 1ns/1ns
module r
#(parameter WIDTH=1,
  parameter INIT={WIDTH{1'b0}},
  parameter ASYNC_RESET=0)
(input wire c,
 input wire [WIDTH-1:0] d,
 input wire rst,
 input wire en,
 output reg [WIDTH-1:0] q);

initial q = INIT;

`ifndef SIM
(* keep = "true" *)
wire rst_int = rst;
`else
wire rst_int = rst;
`endif

generate if (ASYNC_RESET)
  always @(posedge c or posedge rst) begin
    if (rst_int)
      q <= INIT;
    else if (en)
      q <= d;
  end
else
  always @(posedge c) begin
    if (rst_int)
      q <= INIT;
    else if (en)
      q <= d;
  end
endgenerate

endmodule
