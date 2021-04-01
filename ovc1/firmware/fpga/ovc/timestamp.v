`timescale 1ns/1ns
module timestamp
(input clk125,
 input rst,
 /*
 input [6:0] divider,
 input [15:0] skip_interval,
 */
 output [63:0] q);

/*
wire [6:0] divider_d1;
d1 #(7, 7'd124) divider_d1_r(.c(c), .d(divider), .q(divider_d1));
*/

// 125 clock ticks per usec needs 7 bits
wire [6:0] usec_div_cnt;
wire usec_div = usec_div_cnt == 7'd124;  //divider_d1;
r #(7) usec_div_cnt_r
(.c(clk125), .rst(usec_div), .en(1'b1),
 .d(usec_div_cnt+1'b1), .q(usec_div_cnt));

// every skip_interval updates, let a microsecond slip by
// keep a skip_cnt and every skip_interval, we don't update on usec_div

r #(64) t_r(.c(clk125), .en(usec_div), .rst(rst), .d(q+1'b1), .q(q));

endmodule
