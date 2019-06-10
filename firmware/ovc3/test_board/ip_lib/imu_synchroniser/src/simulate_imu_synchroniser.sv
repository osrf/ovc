`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2019 07:01:04 PM
// Design Name: 
// Module Name: simulate_imu_synchroniser
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simulate_imu_synchroniser();

reg clk;
reg rst;
reg imu_int = 0;
reg[7:0] samples_per_frame = 33; // Aim at maximum IMU frequency and 30 FPS
wire[7:0] sample_count;
wire trigger_frame;

imu_synchroniser DUT(
    .clk(clk),
    .rst(rst),
    .imu_int(imu_int),
    .samples_per_frame(samples_per_frame),
    .sample_count(sample_count),
    .trigger_frame(trigger_frame)
    );

// Clock and reset process
initial begin
    clk = 0;
    rst = 1;
    repeat(4) #5 clk = ~clk;
    rst = 0;
    forever #2.5 clk = ~clk;
end

integer ii=0;
initial begin
    for (ii=0; ii<1000; ii=ii+1) begin
        #100;
        /*
        imu_int = 1;
        #5;
        // Noise
        imu_int = 0;
        #50;
        */
        // Make sure single transition
        imu_int = 1;
        #50000;
        imu_int = 0;
        #1000;
        // Kinda 1ms sampling rate
        #950000;
        // Repeat
    end
end

// Dynamic reconfigure of samples per frame
initial begin
    #50000000;; // wait 50 ms
    samples_per_frame = 10;
end
endmodule
