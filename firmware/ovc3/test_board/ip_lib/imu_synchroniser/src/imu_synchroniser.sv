`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2019 06:09:34 PM
// Design Name: 
// Module Name: imu_synchroniser
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


module imu_synchroniser(
    input clk,
    input rst,
    input imu_int,
    input [7:0] samples_per_frame,
    output reg [7:0] sample_count,
    output trigger_frame
    );
    

enum reg {IDLE=0, WAIT_RESET=1} state;
reg trigger_frame_signal;
// IMU pulse will be 50us, avoid metastability by counting consecutive pulses
reg imu_int_del1, imu_int_del2;

wire trigger_frame_ce;
wire trigger_frame_thresh;

two_ms_counter trigger_frame_counter (
  .CLK(clk),          // input wire CLK
  .CE(trigger_frame_ce),            // input wire CE
  .THRESH0(trigger_frame_thresh),  // output wire THRESH0
  .Q()              // output wire [18 : 0] Q, not needed
);

// Count when we didn't reach the threshold OR we want to trigger a new frame
assign trigger_frame_ce = (~trigger_frame_thresh) | trigger_frame_signal;
// The output is a negated threshold, note it will produce one extra frame on startup, likely not an issue
assign trigger_frame = ~trigger_frame_thresh;
// Grey output

always @(posedge clk) begin
    if (rst == 1) begin
        sample_count <= 10'b0;
        trigger_frame_signal <= 1'b0;
        imu_int_del1 <= 1'b0;
        imu_int_del2 <= 1'b0;
        state <= IDLE;
    end else begin
        imu_int_del1 <= imu_int;
        imu_int_del2 <= imu_int_del1;
        case (state)
            IDLE: begin
                if (imu_int_del2 == 1'b1) begin
                    // We received an interrupt
                    state <= WAIT_RESET;
                    // Interrupt on GPIO is triggered on any transition
                    // Trigger frame every samples_per_frame IMU samples
                    if (sample_count >= (samples_per_frame-1)) begin
                        sample_count <= 10'b0;
                        trigger_frame_signal <= 1'b1;
                    end
                    else begin
                        sample_count <= sample_count + 10'b1;
                    end
                end
            end
            WAIT_RESET: begin
                trigger_frame_signal <= 1'b0;
                if (imu_int_del2 == 1'b0) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule
