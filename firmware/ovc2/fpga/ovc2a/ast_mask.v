`timescale 1ns/1ns
module ast_mask
#(parameter C=16,     // circumference of mask
  parameter W=8,      // bit width of elements in mask
  parameter N=10)     // arc length required before it's considered a corner
(input             c, // input clock
 input  [C*W-1:0] dm, // input data: the pixels in the mask
 input  [W-1:0]   dc, // input data: the center pixel
 input            dv, // data-valid
 input [7:0]       t,  // detection threshold
 output            q,
 output [W-1:0] score
);

wire [7:0] t_d1;  // help timing a bit by copying it here
d1 #(8) t_d1_r(.c(c), .d(t), .q(t_d1));

genvar i, j;

// register the mask and center point again here to help timing a bit
wire [W-1:0] dc_d1;
wire [C*W-1:0] dm_d1;
d1 #(W) dc_d1_r(.c(c), .d(dc), .q(dc_d1));
d1 #(C*W) dm_d1_r(.c(c), .d(dm), .q(dm_d1));

// delay the "dv" signal until later in the pipeline
wire dv_s;
dn #(.N(4)) dv_s_r(.c(c), .d(dv), .q(dv_s));

// mask after the subtraction of the center
// pos_margin = mask - center - thresh
// neg_margin = mask - center + thresh
// diff = mask - center
wire [C*(W+1)-1:0] diff, diff_d1;  //, diff_dn;
d1 #(C*(W+1)) diff_r(.c(c), .d(diff), .q(diff_d1));
// dn is used in the final minima pyramid step to be the 9th minima element

wire [C*(W+1)-1:0] abs, abs_d1, abs_dn;
d1 #(C*(W+1)) abs_r(.c(c), .d(abs), .q(abs_d1));
dn #(.W(C*(W+1)), .N(4)) abs_dn_r(.c(c), .d(abs), .q(abs_dn));

// for the center pixel to be a corner, it must:
// have N continuous pixels in which mpos = (mask-center+thresh) is negative
//   or N continuous pixels in which mneg = (mask-center-thresh) is positive

wire [C*(W+1)-1:0] l0, l0_d1; // level-0 minima pyramid between adjacent diff
d1 #(C*(W+1)) l0_r(.c(c), .d(l0), .q(l0_d1));

wire [C*(W+1)-1:0] l1, l1_d1; // level-1 minima pyramid between l0
d1 #(C*(W+1)) l1_r(.c(c), .d(l1), .q(l1_d1));

wire [C*(W+1)-1:0] l2, l2_d1; // level-2 minima pyramid between l1
d1 #(C*(W+1)) l2_r(.c(c), .d(l2), .q(l2_d1));

wire [C*(W+1)-1:0] l3, l3_d1; // level-3 minima pyramid between l2
d1 #(C*(W+1)) l3_r(.c(c), .d(l3), .q(l3_d1));

// now, build a maxima pyramid to complete the maximin calculation
wire [C/2*W-1:0] max_l0, max_l0_d1;  // max pyramid l0
d1 #(C/2*W) max_l0_r(.c(c), .d(max_l0), .q(max_l0_d1));

wire [C/4*W-1:0] max_l1, max_l1_d1;  // max pyramid l1
d1 #(C/4*W) max_l1_r(.c(c), .d(max_l1), .q(max_l1_d1));

wire [C/8*W-1:0] max_l2, max_l2_d1;  // max pyramid l2
d1 #(C/8*W) max_l2_r(.c(c), .d(max_l2), .q(max_l2_d1));

wire [W-1:0] max_l3, max_l3_d1;  // final max calculation
d1 #(W) max_l3_r(.c(c), .d(max_l3), .q(max_l3_d1));

// stage  0: 16 subtractions
// stage  1: 16 two's-complement conversions (absolute value)
// stage  2: 16 comparisons (8-bit) building 9-element sequence minima pyramid
// stage  3: 16 comparisons (8-bit) building 9-element sequence minima pyramid
// stage  4: 16 comparisons (8-bit) building 9-element sequence minima pyramid
// stage  5: 16 comparisons (8-bit) building 9-element sequence minima pyramid
// stage  6:  8 comparisons (8-bit) building maxima pyramid
// stage  7:  4 comparisons (8-bit) building maxima pyramid
// stage  8:  2 comparisons (8-bit) building maxima pyramid
// stage  9:  1 comparison  (8-bit) building maxima pyramid
// stage 10:  1 comparison  (8-bit) threshold check

generate
  for (i = 0; i < C; i = i + 1) begin: iterate_mask
    // stage 0: subtract the center from each mask pixel
    assign diff[i*(W+1) +:(W+1)] = {1'b0, dm_d1[i*W +:W]} - {1'b0, dc_d1};

    // stage 1: calculate absolute-value of diff, but preserve sign bit
    wire diff_sign_bit = diff_d1[i*(W+1) + W];
    assign abs[i*(W+1) +:(W+1)] =
      { diff_sign_bit,
        diff_sign_bit ?
          ~(diff_d1[i*(W+1) +:W]) + 1'b1 :
          diff_d1[i*(W+1) +:(W-1)]
      };

    // stage 2: compare each difference element with neighbor
    wire [W:0] l0_left  = abs_d1[i*(W+1) +:(W+1)];
    wire [W:0] l0_right;
    if (i < C-1)
      assign l0_right = abs_d1[(i+1)*(W+1) +:(W+1)];
    else
      assign l0_right = abs_d1[0 +:(W+1)];  // wrap around
    wire l0_signs_same = l0_left[W] == l0_right[W];
    wire [W:0] l0_min = l0_right < l0_left ? l0_right : l0_left;
    assign l0[i*(W+1) +:(W+1)] = l0_signs_same ? l0_min : {W{1'b0}};

    // stage 3: compare (L0, L0+2) to build L1 minima pyramid
    wire [W:0] l1_left = l0_d1[i*(W+1) +:(W+1)];
    wire [W:0] l1_right;
    if (i < C-2)
      assign l1_right = l0_d1[(i+2)*(W+1) +:(W+1)];
    else
      assign l1_right = l0_d1[(i+2-C)*(W+1) +:(W+1)];
    wire l1_signs_same = l1_left[W] == l1_right[W];
    wire [W:0] l1_min = l1_right < l1_left ? l1_right : l1_left;
    assign l1[i*(W+1) +:(W+1)] = l1_signs_same ? l1_min : {W{1'b0}};

    // stage 4: compare (L1, L1+4) to build L2 minima pyramid
    wire [W:0] l2_left = l1_d1[i*(W+1) +:(W+1)];
    wire [W:0] l2_right;
    if (i < C-4)
      assign l2_right = l1_d1[(i+4)*(W+1) +:(W+1)];
    else
      assign l2_right = l1_d1[(i+4-C)*(W+1) +:(W+1)];
    wire l2_signs_same = l2_left[W] == l2_right[W];
    wire [W:0] l2_min = l2_right < l2_left ? l2_right : l2_left;
    assign l2[i*(W+1) +:(W+1)] = l2_signs_same ? l2_min : {W{1'b0}};

    // stage 5: compare (L2, diff+8) to build final 9-element minima
    wire [W:0] l3_left = l2_d1[i*(W+1) +:(W+1)];
    wire [W:0] l3_right;
    if (i < C-8)
      assign l3_right = abs_dn[(i+8)*(W+1) +:(W+1)];
    else
      assign l3_right = abs_dn[(i+8-C)*(W+1) +:(W+1)];
    wire l3_signs_same = l3_left[W] == l3_right[W];
    wire [W:0] l3_min = l3_right < l3_left ? l3_right : l3_left;
    assign l3[i*(W+1) +:(W+1)] = l3_signs_same ? l3_min : {W{1'b0}};

    // stage 6: level 0 of maxima pyramid of l3 minima
    if (i < C/2) begin
      wire [W-1:0] max_l0_left  = l3_d1[(2*i  )*(W+1) +:W];
      wire [W-1:0] max_l0_right = l3_d1[(2*i+1)*(W+1) +:W];
      assign max_l0[i*W +:W] =
        max_l0_left > max_l0_right ? max_l0_left : max_l0_right;
    end

    // stage 7: level 1 of maxima pyramid
    if (i < C/4) begin
      wire [W-1:0] max_l1_left  = max_l0_d1[(2*i  )*W +:W];
      wire [W-1:0] max_l1_right = max_l0_d1[(2*i+1)*W +:W];
      assign max_l1[i*W +:W] =
        max_l1_left > max_l1_right ? max_l1_left : max_l1_right;
    end

    // stage 8: level 2 of maxima pyramid
    if (i < C/8) begin
      wire [W-1:0] max_l2_left  = max_l1_d1[(2*i  )*W +:W];
      wire [W-1:0] max_l2_right = max_l1_d1[(2*i+1)*W +:W];
      assign max_l2[i*W +:W] =
        max_l2_left > max_l2_right ? max_l2_left : max_l2_right;
    end

    // stage 9: level 3 (completion) of maxima pyramid
    if (i == 0) begin
      wire [W-1:0] max_l3_left  = max_l2_d1[(2*i  )*W +:W];
      wire [W-1:0] max_l3_right = max_l2_d1[(2*i+1)*W +:W];
      assign max_l3[W-1:0] =
        max_l3_left > max_l3_right ? max_l3_left : max_l3_right;
    end

  end

  // stage 10: test if maxima is above threshold
  assign q = max_l3_d1 >= t;
  assign score = q ? max_l3_d1-1'b1 : 8'h0;

endgenerate

/////////////////////////////////////////////////////////////////
`ifdef FOOBAR
`ifdef SIM
wire dv_d1;
d1 dv_d1_r(.c(c), .d(dv), .q(dv_d1));
wire row_end = dv_d1 & ~dv;
wire [15:0] row_cnt, col_cnt;
r #(16) row_cnt_r(.c(c), .rst(1'b0), .en(row_end), 
                  .d(row_cnt+1'b1), .q(row_cnt));
r #(16) col_cnt_r(.c(c), .rst(row_end), .en(dv),
                  .d(col_cnt+1'b1), .q(col_cnt));
wire [W-1:0] dc_d2, dc_d3;
d1 #(W) dc_d2_r(.c(c), .d(dc_d1), .q(dc_d2));
d1 #(W) dc_d3_r(.c(c), .d(dc_d2), .q(dc_d3));

integer k;
task print_vec_c(input [C*W-1:0] v);
  for (k = 0; k < C; k = k + 1)
    $write("%02x ", v[k*W +:W]);
endtask

task print_vec_c2(input [C/2*W-1:0] v);
  for (k = 0; k < C/2; k = k + 1)
    $write("%02x    ", v[k*W +:W]);
endtask

task print_mask;
  begin
    $write("(%4d, %4d) dc = [%02x]\n", col_cnt, row_cnt, dc_d3);
    $write("             ma = [");
    print_vec_c(ma);
    $write("]\n             l0 = [");
    print_vec_c2(l0);
    $write("]\n             l1 = [");
    print_vec_c2(l1);
    $write("]\n             l2 = [");
    print_vec_c2(l2);
    $write("]\n            min = [");
    print_vec_c(min);
    $write("]\n");
  end
endtask
localparam LATENCY = 32'h7;
always @(posedge c) begin
  #1;
  if ((row_cnt >= 16'd1   && row_cnt <= 16'd2  ) &&
      (col_cnt >= 16'd560 && col_cnt <= 16'd570))
    print_mask();
end
`endif

`endif

endmodule

`ifdef SIM

module ast_mask_tb();

wire c;
sim_clk #(63) sim_clk_inst(.c(c));

localparam C=16;
localparam W=8;
reg [C*W-1:0] dm;  // data mask
reg [W-1:0] dc;  // center pixel
reg dv;
wire [W-1:0] threshold = 8'h30;
wire ast_mask_q;
wire [W-1:0] ast_mask_score;

ast_mask #(.N(9)) ast_mask_inst
(.c(c), .dm(dm), .dc(dc), .dv(dv), .t(threshold),
 .q(ast_mask_q), .score(ast_mask_score));

integer k;
task test_mask(input [W-1:0] center, input [C*W-1:0] mask);
begin
  dc = center;
  dm = mask;
  dv = 1'b1;
  #1000;

  $write("==========================================================\n");
  $write("center: %02x\n", dc); 
  $write("mask:   ");
  for (i = 0; i < 16; i = i + 1)
    $write(" %02x ", dm[i*W +:W]);
  $write("\n");

  $write("diff:   ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.diff[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("abs:    ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.abs[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("l0:     ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.l0[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("l1:     ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.l1[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("l2:     ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.l2[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("l3:     ");
  for (i = 0; i < C; i = i + 1)
    $write("%02x ", ast_mask_inst.l3[i*(W+1) +:(W+1)]);
  $write("\n");

  $write("max_l0: ");
  for (i = 0; i < C/2; i = i + 1)
    $write("%03x ", ast_mask_inst.max_l0[i*W +:W]);
  $write("\n");

  $write("max_l1: ");
  for (i = 0; i < C/4; i = i + 1)
    $write("%03x ", ast_mask_inst.max_l1[i*W +:W]);
  $write("\n");

  $write("max_l2: ");
  for (i = 0; i < C/8; i = i + 1)
    $write("%03x ", ast_mask_inst.max_l2[i*W +:W]);
  $write("\n");

  $write("max_l3: %03x\n", ast_mask_inst.max_l3);
  $write("q:      %01x\n", ast_mask_inst.q);
  $write("score:  %02x\n", ast_mask_inst.score);
end
endtask

integer i;
initial begin
  // positive corner
  test_mask(8'h40, { 8'h41, 8'h42, 8'h43, 8'h44, 8'h45, 8'h46, 8'h47, 8'h90,
                     8'h91, 8'h92, 8'h93, 8'h94, 8'h95, 8'h96, 8'h97, 8'h98 });
  // negative corner
  test_mask(8'h8f, { 8'h41, 8'h42, 8'h43, 8'h44, 8'h45, 8'h46, 8'h47, 8'h41,
                     8'h49, 8'h92, 8'h93, 8'h94, 8'h95, 8'h96, 8'h97, 8'h98 });

  // negative corner in middle of mask
  test_mask(8'h8f, { 8'hc5, 8'hb9, 8'h8e, 8'h44, 8'h45, 8'h46, 8'h47, 8'h41,
                     8'h49, 8'h20, 8'h01, 8'h33, 8'h95, 8'h96, 8'h97, 8'h98 });

  // negative corner on right edge of mask
  test_mask(8'h8f, { 8'hc5, 8'hb9, 8'h8e, 8'h44, 8'h45, 8'h46, 8'h47, 8'h41,
                     8'h41, 8'h20, 8'h01, 8'h33, 8'h03, 8'h01, 8'h00, 8'h20 });

  // not a corner
  test_mask(8'h8f, { 16 { 8'h81 } });

  $finish();
end

endmodule

`endif
