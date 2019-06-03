`timescale 1ns/1ns
module max
#(parameter W=8,
  parameter L=16)
(input c,
 input [L*W-1:0] d,
 output [W-1:0] q);

// simplest implementation has latency of L cycles
// smarter implementation would use more comparators and have latency log2(L)

// memory looks like a triangle: we need to store all elements at t=0, but
// this goes linearly down to storing only 1 element at t=(L-1)

// tools will do the right thing, so long as we model it correctly
wire [L*L*W-1:0] mem_d, mem_q;
d1 #(L*L*W) mem_r(.c(c), .d(mem_d), .q(mem_q));

genvar i;
generate
  for (i = 0; i < L; i = i + 1) begin: max_pyramid
    wire [L*W-1:0] ps; // previous stage
    if (i == 0)
      assign ps = d;
    else
      assign ps = mem_q[i*L*W +:(L*W)];
    wire [W-1:0] lhs = ps[0 +:W];
    wire [W-1:0] rhs = ps[W +:W];
    wire [W-1:0] comp = lhs > rhs ? lhs : rhs;
    if (i < L - 1) begin
      wire [W*L-1:0] ns = { {W{1'b0}}, ps[2*W +:((L-2)*W)], comp};
      assign mem_d[(i+1)*L*W +:L*W] = ns;
    end else
      assign q = comp;
  end
  assign mem_d[0 +:L*W] = 0;
endgenerate

//assign q = mem_q[(L-1)*L*W :+W];

endmodule

///////////////////////////////////////////////////////////////////////////

`ifdef test_max
module max_tb();

wire c;
sim_clk #(100) sim_clk_inst(.c(c));

localparam W = 8;
localparam L = 16;
reg [W*L-1:0] d;
wire [W-1:0] q;

max max_inst(.*);

integer i;
task test(input [W-1:0] expected);
  begin
    for(i = 0; i < L; i = i + 1)
      @(posedge c);
    if (q == expected)
      $display("OK:    found %02h correctly", expected);
    else
      $display("ERROR: expected %02h but got %02h instead", expected, q);
  end
endtask

initial begin
  $dumpfile("test_max.lxt");
  $dumpvars();
  d = 0;
  #(100);
  @(posedge c);
  #1;
  for (i = 0; i < L; i = i + 1)
    d[i*W +:W] = i;
  test(8'h0f);
  d[5*W +:W] = 8'hbe;
  test(8'hbe);
  #100;
  $finish();
end

endmodule
`endif
