`timescale 1ns/1ns
module corners
(input cam_0_rxc,
 input [31:0] cam_0_d,
 input cam_0_lv,
 input cam_0_fv,
 input cam_0_en,
 input cam_1_rxc,
 input [31:0] cam_1_d,
 input cam_1_lv,
 input cam_1_fv,
 input cam_1_en,
 input c,  // read clock
 input [7:0] t,  // threshold (in read-clock domain, for convenience)
 output [255:0] q,
 input [1:0] q_read,
 output [1:0] q_empty,
 output [13:0] q_avail,
 output [63:0] corner_count);

wire [7:0] cam_0_t_s, cam_1_t_s;
s #(8) cam_0_t_r(.c(cam_0_rxc), .d(t), .q(cam_0_t_s));
s #(8) cam_1_t_r(.c(cam_1_rxc), .d(t), .q(cam_1_t_s));

ast_detector #(.CAM_ADDR(1'b0)) cd0
(.c(cam_0_rxc), .t(cam_0_t_s), .en(cam_0_en),
 .d(cam_0_d), .lv(cam_0_lv), .fv(cam_0_fv),
 .rd_clk(c), .q(q[127:0]), .q_read(q_read[0]),
 .q_avail(q_avail[6:0]), .q_empty(q_empty[0]),
 .corner_count(corner_count[31:0]));

ast_detector #(.CAM_ADDR(1'b1)) cd1
(.c(cam_1_rxc), .t(cam_1_t_s), .en(cam_1_en),
 .d(cam_1_d), .lv(cam_1_lv), .fv(cam_1_fv),
 .rd_clk(c), .q(q[255:128]), .q_read(q_read[1]),
 .q_avail(q_avail[13:7]), .q_empty(q_empty[1]),
 .corner_count(corner_count[63:32]));

/*
d1 aux_w0_r(.c(cam_0_rxc), .d(ast_w0_qv), .q(aux[0]));
d1 aux_w1_r(.c(cam_0_rxc), .d(ast_w1_qv), .q(aux[1]));
d1 aux_w2_r(.c(cam_0_rxc), .d(ast_w2_qv), .q(aux[2]));
d1 aux_w3_r(.c(cam_0_rxc), .d(ast_w3_qv), .q(aux[3]));
assign aux[7:4] = 4'h0;
*/

endmodule
