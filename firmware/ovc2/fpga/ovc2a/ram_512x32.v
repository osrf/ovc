`timescale 1ns/1ns
module ram_512x32
(input wire c,
 input wire [8:0] raddr, output reg [31:0] q,
 input wire [31:0] d, input wire [8:0] waddr, input wire we);

reg [31:0] mem[511:0];
always @ (posedge c) begin
  if (we)
    mem[waddr] <= d;
  q <= mem[raddr];
end

`ifdef SIM
integer i;
initial begin
  for (i = 0; i < 256; i = i + 1)
    mem[i] <= 32'h0;
end
`endif

endmodule
