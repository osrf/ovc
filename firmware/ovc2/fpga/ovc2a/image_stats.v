`timescale 1ns/1ns
module image_stats
(input c,
 input [31:0] d,
 input dv,
 input rst,
 input [31:0] roi,
 output [31:0] sum);

// first-level addition of inbound pixels
wire [8:0] addend_0, addend_1;

d1 #(9) addend_0_r
(.c(c), .d({1'b0, d[ 7: 0]} + {1'b0, d[15: 8]}), .q(addend_0));

d1 #(9) addend_1_r
(.c(c), .d({1'b0, d[23:16]} + {1'b0, d[31:24]}), .q(addend_1));

// second-level addition
wire [9:0] addend_2;
d1 #(10) addend_2_r
(.c(c), .d({1'b0, addend_0} + {1'b0, addend_1}), .q(addend_2));

// delay the inbound image 0 data-valid to let pixels flow through adder tree
wire dv_0_dn;
dn #(.N(2)) dv_0_dn_r(.c(c), .d(dv), .q(dv_0_dn));

// synchronize ROI bounding box to the image 0 clock domain
wire [10:0] roi_left   = {roi[ 7: 0], 3'h0};
wire [10:0] roi_right  = {roi[15: 8], 3'h0};
wire [ 9:0] roi_top    = {roi[23:16], 2'h0};
wire [ 9:0] roi_bottom = {roi[31:24], 2'h0};

wire dv_d1;
d1 dv_d1_r(.c(c), .d(dv), .q(dv_d1));
wire row_start = dv & ~dv_d1;
wire row_end = ~dv & dv_d1;

wire [9:0] row;
r #(10) row_r
(.c(c), .en(row_end), .rst(rst), .d(row + 1'b1), .q(row));

wire [10:0] col;
r #(11) col_r
(.c(c), .en(dv), .rst(row_end), .d(col + 1'b1), .q(col));

wire in_roi = dv_0_dn;  // todo: not this. use ROI someday.

wire sum_en;
r #(32) img_sum_r(.c(c), .en(in_roi), .rst(rst), .d(sum + addend_2), .q(sum));

endmodule
