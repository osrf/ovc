`timescale 1ns/1ns
module signature
(input c,
 input r,  // reset
 input dv,
 input [31:0] d,
 output [31:0] sig);

// todo: something smarter
crc32 crc32_inst
(.c(c), .r(r), .dv(dv), .d(d[31:24] ^ d[23:16] ^ d[15:8] ^ d[7:0]), .crc(sig));

endmodule

/////////////////
`ifdef test_signature
module signature_tb();

wire c;
sim_clk #(100) sim_clk_inst(.c(c));

reg [31:0] d;
reg dv, r;
wire [31:0] sig;
signature signature_inst(.c(c), .r(r), .dv(dv), .d(d), .sig(sig));

initial begin
  $dumpfile("test_signature.lxt");
  $dumpvars();
  d <= 32'h0;
  dv <= 1'h0;
  r <= 1'h0;
  @(posedge c);
  r <= 1'h1;
  @(posedge c);
  @(posedge c);
  @(posedge c);
  r <= 1'h0;
  @(posedge c);
  @(posedge c);
  @(posedge c);
  dv <= 1'h1;
  d <= 32'h0;
  @(posedge c);
  dv <= 1'h0;
  /*
  d <= 32'h1;
  @(posedge c);
  d <= 32'h2;
  @(posedge c);
  d <= 32'h3;
  @(posedge c);
  dv <= 1'h0;
  */
  @(posedge c);
  @(posedge c);
  @(posedge c);
  $display("sig: %08x", sig);
  $finish();
end

endmodule
`endif
