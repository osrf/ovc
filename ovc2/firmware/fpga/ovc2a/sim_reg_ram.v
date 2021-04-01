`timescale 1ns/1ns
module sim_reg_ram
(input c,
 input [7:0] addr, 
 input wr, 
 input [31:0] d,
 output reg [31:0] q);

reg [31:0] mem [255:0];
always @ (posedge c) begin
  if (wr)
    mem[addr] <= d;
  q <= mem[addr]; // q doesn't get d in this clock cycle
end

`ifdef SIM
wire [31:0] a00 = mem[0];
wire [31:0] a01 = mem[1];
wire [31:0] a02 = mem[2];
wire [31:0] a03 = mem[3];
wire [31:0] a04 = mem[4];
wire [31:0] a05 = mem[5];
wire [31:0] a06 = mem[6];
wire [31:0] a07 = mem[7];
wire [31:0] a08 = mem[8];
wire [31:0] a09 = mem[9];
wire [31:0] a0a = mem[10];
wire [31:0] a0b = mem[11];
wire [31:0] a0c = mem[12];
wire [31:0] a0d = mem[13];
wire [31:0] a0e = mem[14];
wire [31:0] a0f = mem[15];
wire [31:0] a10 = mem[16];
wire [31:0] a11 = mem[17];
wire [31:0] a12 = mem[18];
wire [31:0] a13 = mem[19];
wire [31:0] a14 = mem[20];
wire [31:0] a15 = mem[21];
wire [31:0] a16 = mem[22];
wire [31:0] a17 = mem[23];
wire [31:0] a18 = mem[24];
wire [31:0] a19 = mem[25];
wire [31:0] a1a = mem[26];
wire [31:0] a1b = mem[27];
wire [31:0] a1c = mem[28];
wire [31:0] a1d = mem[29];
wire [31:0] a1e = mem[30];
wire [31:0] a1f = mem[31];
wire [31:0] a20 = mem[32];
wire [31:0] a21 = mem[33];
wire [31:0] a22 = mem[34];
wire [31:0] a23 = mem[35];
wire [31:0] a24 = mem[36];
wire [31:0] a25 = mem[37];
wire [31:0] a26 = mem[38];
wire [31:0] a27 = mem[39];
wire [31:0] a28 = mem[40];
wire [31:0] a29 = mem[41];
wire [31:0] a2a = mem[42];
wire [31:0] a2b = mem[43];
wire [31:0] a2c = mem[44];
wire [31:0] a2d = mem[45];
wire [31:0] a2e = mem[46];
wire [31:0] a2f = mem[47];

initial begin
  mem[0] = 32'h0;
  #1000;
  mem[0] = 32'h1;  // set 'valid' flag bit
  mem[1] = 32'hdead_beef;  // dma target address
  mem[2] = 32'h0;  // alignment request (bitslip request)
  mem[3] = 32'h0;  // alignment channel-read index
  mem[4] = 32'h0;
  mem[5] = 32'd10;  // exposure in usec
  mem[6] = 32'h0000_0007;
  mem[7] = 32'h0000_0000;
  mem[8] = 32'h0000_0000;
  mem[9] = 32'h0000_0012;
  mem[10] = 32'h0;
end
`endif

endmodule
