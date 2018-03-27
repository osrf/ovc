`timescale 1ns/1ns
module metadata
(input [1:0] img_c,
 input [63:0] img_d,
 input [1:0] img_dv,
 input c,
 input rst,
 input en,
 input flush,
 input [31:0] stats_roi,
 input [31:0] corner_cnt,
 input [63:0] t,
 output flush_complete,
 output [31:0] q,
 output qv
);

wire img_0_rst;  //, img_1_rst;
s img_0_rst_r(.c(img_c[0]), .d(rst), .q(img_0_rst));
//s img_1_rst_r(.c(img_c[1]), .d(rst), .q(img_1_rst));

wire [31:0] sig_0_sig;
signature sig_0
(.c(img_c[0]), .r(img_0_rst), .dv(img_dv[0]), .d(img_d[31:0]),
 .sig(sig_0_sig));

wire [31:0] sig_0_sig_s;
s #(32) sig_0_sig_r(.c(c), .d(sig_0_sig), .q(sig_0_sig_s));

wire [31:0] corner_cnt_s;
s #(32) corner_cnt_r(.c(c), .d(corner_cnt), .q(corner_cnt_s));

// synchronize ROI box to image 0 clock domain
wire [31:0] stats_roi_s;
s #(.W(32)) stats_roi_s_r(.c(img_c[0]), .d(stats_roi), .q(stats_roi_s));

wire [31:0] img_0_sum_c_0;  // image 0 ROI sum in image 0 clock
image_stats image_stats_inst
(.c(img_c[0]), .d(img_d[31:0]), .dv(img_dv[0]), .rst(img_0_rst),
 .roi(stats_roi_s), .sum(img_0_sum_c_0));

// synchronize image 0 sum back to PCIe clock domain
wire [31:0] img_0_sum;
s #(.W(32)) img_0_sum_s_r(.c(c), .d(img_0_sum_c_0), .q(img_0_sum));

/*
wire [7:0] cnt;
wire cnt_rst, cnt_en;
r #(8) cnt_r(.c(c), .rst(cnt_rst), .en(cnt_en), .d(cnt+1'b1), .q(cnt));
*/

//////////////////////////////////////////////////////////////////////////
localparam CW = 16, SW = 4;
localparam ST_IDLE = 4'h0;  // wait for "en" signal to start listening
localparam ST_CALC = 4'h1;  // listen to pixels and calculate statistics
localparam ST_SIG0 = 4'h2;  // send image 0 signature
localparam ST_SIG1 = 4'h3;
localparam ST_CRNR = 4'h4;  // send image corner counts
localparam ST_TIM0 = 4'h5;  // send timestamp low bytes
localparam ST_TIM1 = 4'h6;  // send timestamp high bytes
localparam ST_SUM  = 4'h8;  // send image 0 sum
localparam ST_DONE = 4'h7;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] state_d = ctrl[CW+SW-1:CW];
r #(SW) state_r(.c(c), .d(state_d), .rst(rst), .en(1'b1), .q(state));

always @* begin
  case (state)
    ST_IDLE:
      if (en)     ctrl = { ST_CALC, 8'h00, 8'b0000_0000 };
      else        ctrl = { ST_IDLE, 8'h00, 8'b0000_0000 };
    ST_CALC:
      if (flush)  ctrl = { ST_SIG0, 8'h00, 8'b0000_0000 };
      else        ctrl = { ST_CALC, 8'h00, 8'b0000_0000 };
    ST_SIG0:      ctrl = { ST_SIG1, 8'h01, 8'b0000_0000 };
    ST_SIG1:      ctrl = { ST_CRNR, 8'h00, 8'b0000_0100 };  
    ST_CRNR:      ctrl = { ST_TIM0, 8'h02, 8'b0000_0100 };
    ST_TIM0:      ctrl = { ST_TIM1, 8'h04, 8'b0000_0100 };
    ST_TIM1:      ctrl = { ST_SUM , 8'h08, 8'b0000_0100 };
    ST_SUM:       ctrl = { ST_DONE, 8'h10, 8'b0000_0100 };
    ST_DONE:      ctrl = { ST_IDLE, 8'h00, 8'b0000_1100 };
    default:      ctrl = { ST_IDLE, 8'h00, 8'b0000_0000 };
  endcase
end

wire [4:0] q_sel = ctrl[12:8];
assign flush_complete = ctrl[3];

hmux #(.DWIDTH(32), .WORDCOUNT(5), .OUTPUT_REG(1)) q_mux
(.c(c), .sel(q_sel), .q(q),
 .d({img_0_sum, t, corner_cnt_s, sig_0_sig_s}));

assign qv = ctrl[2];

endmodule
