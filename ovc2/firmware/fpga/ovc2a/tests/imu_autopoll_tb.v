`timescale 1ns/1ps
module imu_autopoll_tb();

initial begin
  $dumpfile("imu_autopoll.lxt");
  $dumpvars();
end

tb tb_inst();

initial begin
  #100;
  wait(tb_inst.top_inst.imu_reader_inst.state == 3);  // autopoll starts
  wait(~tb_inst.imu_sck);  // make sure imu sck is toggling
  wait(tb_inst.imu_sck);
  wait(tb_inst.top_inst.imu_reader_inst.state == 0);  // autopoll completes
  #10_000;
  $display($time, " IMU autopoll test success!");
  $finish(); 
end

endmodule
