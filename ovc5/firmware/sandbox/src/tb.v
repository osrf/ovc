`timescale 1ns/1ns

module tb();
  wire led;
  reg clk=1'b0;
  reg rst=1'b0;

  top dut(.clk(clk), .rst(rst));  //, .led(led));

  initial begin
    clk <= 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("icarus_test.vcd");
    $dumpvars();
    #10000 $finish();
  end
endmodule
