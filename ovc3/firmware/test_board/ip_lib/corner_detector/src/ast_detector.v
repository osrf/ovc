`timescale 1ns/1ns
module ast_detector
#(parameter CAM_ADDR=1'b0,
  parameter COLS=1280,
  parameter [15:0] MAX_QV = 16383)
(input c,
 input [7:0] t,  // threshold for corner detection
 input en,
 input [7:0] d,
 input lv,
 input fv,
 output [31:0] q,
 output qv,
 output [15:0] qv_cnt);

// synchronize threshold "t" into the pixel clock domain
wire [7:0] t_s;
s #(8) t_r(.c(c), .d(t), .q(t_s));

// todo: create 128-bit vector of detections.
wire fv_d1;
d1 fv_d1_r(.c(c), .d(fv), .q(fv_d1));
wire frame_end = fv_d1 & ~fv;
wire frame_start = ~fv_d1 & fv;

// wait a bit after the end of the frame for everybody to emerge from
// the corner detection machinery
wire frame_end_delayed;
dn #(.N(8)) frame_end_d16_r(.c(c), .d(frame_end), .q(frame_end_delayed));

localparam WROWS=7, WCOLS=7;
wire [WROWS*WCOLS*8-1:0] wnd_w0;
wire wv;
wire [9:0] wrow;
wire [10:0] wcol;  // dword index of w0

wnd wnd_inst
(.c(c), .p(d), .lv(lv), .fv(fv),
 .wv(wv), .w0(wnd_w0), .row(wrow), .col(wcol));

wire ast_qv;
wire [7:0] ast_q;

ast_7x7 a0(.c(c), .t(t_s), .d(wnd_w0), .dv(wv), .q(ast_q), .qv(ast_qv));

/*
`ifdef SIM
integer ast_idx;
always @(posedge c) begin
  for (ast_idx = 0; ast_idx < 4; ast_idx = ast_idx + 1) begin
    if (ast_qv[ast_idx]) begin
      $display("%d %d %d", wcol, wrow, ast_qv[ast_idx*8 +:8]);
    end
  end
end
`endif
*/

localparam [7:0] AST_LATENCY = 10;
// add 7-clock delay to frame-valid and line-valid signals
wire fv_dn, lv_dn;
dn #(.N(AST_LATENCY)) fv_dn_r(.c(c), .d(fv), .q(fv_dn));
dn #(.N(AST_LATENCY)) lv_dn_r(.c(c), .d(lv), .q(lv_dn));

wire score_wv;
wire [71:0] score_w0;
wire [9:0] srow;
wire [10:0] scol;  // dword index of score_w0
wnd #(.COLS(3), .ROWS(3)) score_wnd
(.c(c),
 .p(ast_q),
 .lv(lv_dn), .fv(fv_dn),
 .wv(score_wv), .w0(score_w0),
 .row(srow), .col(scol));

// compute max of each 3x3 score window
wire [7:0] max_w0;
max #(.W(8), .L(9)) max_s0(.c(c), .d(score_w0), .q(max_w0));

wire [7:0] center_w0 = score_w0[4*8 +:8];

// delay the center scores N cycles
wire [7:0] center_w0_dn;
dn #(.W(8), .N(8)) center_w0_dn_r(.c(c), .d(center_w0), .q(center_w0_dn));

wire nm_qv = { |center_w0_dn & (center_w0_dn == max_w0) };
wire [7:0] nm_q = { max_w0 };

localparam [8:0] DETECTOR_LATENCY = 9'd22;
// "nm_row" is the row of the center point of the 3x3 nonmax neighborhood
wire [9:0] nm_row;
r #(10) nm_row_r
(.c(c), .en(1'b1), .rst(1'b0), .q(nm_row),
 .d(wcol < DETECTOR_LATENCY ? wrow - 10'd5 : wrow - 10'd4));

// deal with row wraparound due to latency in the AST+nonmax pipelines
localparam [8:0] COLS_DIV_4 = COLS / 4;
wire [10:0] nm_col;
dn #(.W(11), .N(DETECTOR_LATENCY)) wcol_d(.c(c), .d(wcol), .q(nm_col));
/*
r #(9) nm_col_r
(.c(c), .en(1'b1), .rst(1'b0), .q(nm_col),
 .d(wcol >= DETECTOR_LATENCY ?
    wcol  - DETECTOR_LATENCY :
    wcol  + COLS_DIV_4));
*/
// mask out detections that occur near the image right boundary
// (todo: move this upstream somewhere...)
wire nm_invalid = (wrow < 10'd8)   |
                  (nm_col  < 9'h8) |
                  (nm_col >= COLS - 3'h4);
                  //(nm_col >= COLS_DIV_4 - 3'h4);

// make a shallow FIFO for each detector
wire [31:0] dfifo_q = { CAM_ADDR, 2'h0, // bits 31-29
                        nm_col,  // bits 28-18
                        nm_row,  // bits 17-8
                        nm_q};  // bits 7-0

/*
shallow_fifo dfifo (
    .clk(c),      // input wire clk
    .din(dfifo_d),      // input wire [31 : 0] din
    .wr_en(en & nm_qv & ~nm_invalid),  // input wire wr_en
    .rd_en(dfifo_rd),  // input wire rd_en
    .dout(dfifo_q),    // output wire [31 : 0] dout
    .full(),    // output wire full
    .empty(dfifo_empty)  // output wire empty
);
*/
//    scfifo #(.lpm_width(32), .lpm_numwords(256), .lpm_widthu(8),
//             .lpm_showahead("ON"), .intended_device_family("CYCLONE V")) dfifo
//    (.clock(c), .aclr(1'b0), .sclr(1'b0),
//     .wrreq(en & nm_qv[i] & ~nm_invalid), .data(dfifo_d),
//     .rdreq(dfifo_rd[i]), .q(dfifo_q[32*i +:32]), .empty(dfifo_empty[i]));

// now, a bigger FIFO that vacuums all the smaller FIFOs together and
// crosses the clock domain to rd_clk

// first, collect the smaller FIFO 32-bit words into 128-bit words
// that can be vacuumed into DMA transfers
/*
wire [127:0] rfifo_d;
wire [31:0] rfifo_d_shift_in;
wire rfifo_d_en;
wire [1:0] rfifo_d_shift_cnt;
r #(2) rfifo_d_shift_cnt_r
(.c(c), .rst(~en), .en(rfifo_d_en),
 .d(rfifo_d_shift_cnt + 1'b1), .q(rfifo_d_shift_cnt));
*/

//wire [31:0] ast_qv_cnt;
r #(16) qv_cnt_r
(.c(c), .rst(frame_start), .en(qv), .d(qv_cnt+1'b1), .q(qv_cnt));

wire qv_full;
d1 qv_full_r(.c(c), .d(qv_cnt > MAX_QV-2'h2), .q(qv_full));

assign q = dfifo_q;
assign qv = en & nm_qv & ~nm_invalid & !qv_full;
//s #(32) corner_count_r(.c(rd_clk), .d(ast_qv_cnt), .q(corner_count));

/*
r #(128) rfifo_d_r
(.c(c), .rst(1'b0), .en(rfifo_d_en),
 .d({rfifo_d[95:0], rfifo_d_shift_in}), .q(rfifo_d));

wire rfifo_wr;
d1 rfifo_wr_d1_r
(.c(c), .q(rfifo_wr),
 .d(frame_end_delayed | (rfifo_d_en & (rfifo_d_shift_cnt == 3'h3))));

wire rfifo_aclr = 1'b0;
dcfifo #(.lpm_width(128), .lpm_numwords(64), .lpm_widthu(7),
         .lpm_showahead("ON"), .intended_device_family("CYCLONE V"),
         .add_usedw_msb_bit("ON"),
         .rdsync_delaypipe(4), .wrsync_delaypipe(4)) rfifo
(.aclr(rfifo_aclr),
 .wrclk(c), .wrreq(en & rfifo_wr), .data(rfifo_d),
 .rdclk(rd_clk), .rdreq(q_read), .q(q), .rdusedw(q_avail), .rdempty(q_empty));
*/

/*
hmux #(.DWIDTH(32), .WORDCOUNT(4), .OUTPUT_REG(1)) dfifo_q_mux
(.c(c), .d(dfifo_q), .sel(dfifo_sel), .q(q));
*/
/*
wire [3:0] dfifo_nonempty = { |dfifo_usedw[31:24],
                              |dfifo_usedw[23:16],
                              |dfifo_usedw[15: 8],
                              |dfifo_usedw[ 7: 0] };
*/

//hmux #(.DWIDTH(1), .WORDCOUNT(4), .OUTPUT_REG(1)) dfifo_nonempty_mux
//(.c(c), .d(dfifo_nonempty), .sel(dfifo_sel), .q(rfifo_wr));

//d1 qv_d1_r(.c(c), .d(|dfifo_rd), .q(qv));

//assign rfifo_wr = |dfifo_rd;

endmodule
