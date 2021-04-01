`timescale 1ns/1ps
module corners_nonmax_tb();

wire clk125;
sim_clk #(125) clk_inst(.c(clk125));
wire c = clk125;

wire cam_rxc;
sim_clk #(63) cam_clk_inst(.c(cam_rxc));

localparam IMAGE_FN="../sim/fullwidth_squares_gradient_background.bin";
//localparam IMAGE_FN="../sim/128x64.bin";
localparam IMAGE_ROWS=64;
localparam IMAGE_COLS=1280;

reg cam_trigger;
wire cam_cs, cam_sck, cam_mosi, cam_miso;
wire [31:0] cam_rxd;
wire [7:0] cam_syncd;
sim_python
#(.INTERFRAME_WORDS(20), .USE_TRIGGER(1),
  .COLS(IMAGE_COLS), .ROWS(IMAGE_ROWS), .IMAGE_FILE(IMAGE_FN)) sim_python_inst
(.c(cam_rxc), .trigger(cam_trigger), .data(cam_rxd), .sync(cam_syncd),
 .cs(cam_cs), .sck(cam_sck), .mosi(cam_mosi), .miso(cam_miso));

wire cam_fv, cam_lv;
wire [31:0] cam_d;
python_decoder #(.UNSWAP_KERNELS(0)) decoder_inst
(.c(cam_rxc), .sync(cam_syncd), .data(cam_rxd),
 .fv(cam_fv), .lv(cam_lv), .q(cam_d));

//////////////////////////////////////////////////////
wire [31:0] ast_q;
wire [15:0] ast_corner_count;
wire ast_qv;
ast_detector #(.CAM_ADDR(1'b0), .COLS(IMAGE_COLS)) ast_inst
(.c(cam_rxc), .t(8'h10), .en(1'b1), .d(cam_d), .lv(cam_lv), .fv(cam_fv),
 .q(ast_q), .qv(ast_qv), .qv_cnt(ast_corner_count));

//////////////////////////////////////////////////////
initial begin
  cam_trigger = 1'b0;
  $dumpfile("corners_nonmax.lxt");
  $dumpvars();
  #1000;
  #100 cam_trigger = 1'b1;
  #100 cam_trigger = 1'b0;
  #500_000;
  #100 cam_trigger = 1'b1;
  #100 cam_trigger = 1'b0;
  #500_000;
  $finish();
end

endmodule
