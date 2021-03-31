`timescale 1ns/1ns
module trigger
(input  c,
 input  imu_sync,
 input  [7:0] imu_decim,  // imu-per-image decimation rate
 input  [15:0] exposure_usec,
 output q);

// for initializing with something sane, assume IMU rate is 200 Hz
/*
localparam [7:0] IMU_DECIM_INIT = 8'h07;  // decimation rate of 7 = 28.57 fps

wire [7:0] imu_decim_d1;
r #(8, IMU_DECIM_INIT) imu_decim_r
(.c(c), .rst(1'b0), .en(imu_decim_dv), .d(imu_decim), .q(imu_decim_d1));
*/

wire [7:0] imu_cnt;
r #(8) imu_cnt_r
(.c(c), .rst(imu_cnt >= imu_decim), .en(imu_sync),
 .d(imu_cnt + 1'b1), .q(imu_cnt));

// 125 clock ticks per usec needs 7 bits
wire [6:0] usec_div_cnt;
wire usec_div = usec_div_cnt == 7'd124;
r #(7) usec_div_cnt_r
(.c(c), .rst(usec_div), .en(1'b1),
 .d(usec_div_cnt+1'b1), .q(usec_div_cnt));

// hold the output line high for as many usecs as requested
wire trigger_start = imu_cnt >= imu_decim;
wire [15:0] trigger_cnt;
r #(16) trigger_cnt_r
(.c(c), .rst(trigger_cnt > exposure_usec),
 .en(trigger_start | (|trigger_cnt & usec_div)),
 .d(trigger_cnt + 1'b1), .q(trigger_cnt));

// register once to help timing a bit
d1 q_r(.c(c), .d(|trigger_cnt), .q(q));

endmodule
