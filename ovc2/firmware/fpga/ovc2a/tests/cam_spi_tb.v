`timescale 1ns/1ps
module cam_spi_tb();

initial begin
  $dumpfile("cam_spi_tb.lxt");
  $dumpvars();
end

tb tb_inst();

initial begin
  #10_000;
  // try to send some camera SPI traffic to cam 0
  tb_inst.sim_reg_ram_inst.mem[8] = 32'h0012_3456;
  #2200;
  tb_inst.sim_reg_ram_inst.mem[7] = 32'h4000_0000;
  //wait(~tb_inst.sim_reg_ram_inst.mem[9][31]);
  //wait(tb_inst.sim_reg_ram_inst.mem[9][31]);
  #1000;
  tb_inst.sim_reg_ram_inst.mem[7] = 32'h0000_0000;
  #100_000;
  $finish(); 
end

endmodule
