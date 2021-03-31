`timescale 1ns/1ps
module top_tb();

wire clk125;
sim_clk #(125) clk_inst(.c(clk125));
wire c = clk125;

wire cam_rxc;
sim_clk #(63) cam_clk_inst(.c(cam_rxc));

localparam IMAGE_FN="../cowells_stairs_640x64.bin";
localparam IMAGE_ROWS=64;  // 64;
localparam IMAGE_COLS=640;

wire [7:0] cam_d;
wire cam_fv, cam_lv;
sim_python
#(.INTERFRAME_WORDS(20), .USE_TRIGGER(0), .DATA_RST_VAL(32'hffff_ffff),
  .COLS(IMAGE_COLS), .ROWS(IMAGE_ROWS), .IMAGE_FILE(IMAGE_FN)) sim_python_inst
(.c(cam_rxc), .data(cam_d), .fv(cam_fv), .lv(cam_lv));

//////////////////////////////////////////////////////
wire [31:0] ast_q;
wire [15:0] ast_corner_count;
wire ast_qv;
ast_detector #(.CAM_ADDR(1'b0), .COLS(IMAGE_COLS)) ast_inst
(.c(cam_rxc), .t(8'd25), .en(1'b1), .d(cam_d), .lv(cam_lv), .fv(cam_fv),
 .q(ast_q), .qv(ast_qv), .qv_cnt(ast_corner_count));

integer f_log;
integer corner_row, corner_col, corner_score;
integer n_corners;

always @(posedge cam_rxc)
begin
  if (ast_qv) begin
    corner_row = ast_q[17:8];
    corner_col = ast_q[28:18];
    corner_score = ast_q[7:0];
    $display("corner: (%d, %d, %d)", corner_col, corner_row, corner_score);
    $fwrite(f_log, "%d %d\n", corner_col, corner_row);
    n_corners = n_corners + 1;
  end
end

//////////////////////////////////////////////////////

integer image_num;
initial begin
  n_corners = 0;
  image_num = 0;
  f_log = $fopen("../sim/corners.txt", "w");
  $dumpfile("corner_detector_tb.lxt");
  $dumpvars();
  #1000;
  //wait(cam_syncd == 8'hca);  // wait until sync channel indicates frame end
  for (image_num = 0; image_num < 2; image_num = image_num + 1) begin
    #1000;
    wait(cam_fv);
    $display("image start");
    wait(~cam_fv);
    $display("image end");
  end
  #10_000;
  $finish();
end

endmodule
