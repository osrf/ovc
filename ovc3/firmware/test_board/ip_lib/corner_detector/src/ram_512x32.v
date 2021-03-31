`timescale 1ns/1ns
module ram_512x32
(input wire c,
 input wire [10:0] raddr, output reg [7:0] q,
 input wire [7:0] d, input wire [10:0] waddr, input wire we);

reg [7:0] mem[2047:0];
always @ (posedge c) begin
  if (we)
    mem[waddr] <= d;
  q <= mem[raddr];
end

`ifdef SIM
integer i;
initial begin
  for (i = 0; i < 2048; i = i + 1)
    mem[i] <= 8'h0;
end
`endif

endmodule
