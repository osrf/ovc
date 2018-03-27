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

// TODO: this has turned into an abomination. It needs to be factored into
// a few smaller pieces.
genvar i, j;

// register the mask and center point again here to help timing a bit
wire [W-1:0] dc_d1;
wire [C*W-1:0] dm_d1;
d1 #(W) dc_d1_r(.c(c), .d(dc), .q(dc_d1));
d1 #(C*W) dm_d1_r(.c(c), .d(dm), .q(dm_d1));

// delay the "dv" signal until later in the pipeline
wire dv_s;
dn #(.N(4)) dv_s_r(.c(c), .d(dv), .q(dv_s));

wire [C-1:0]   pos_corner, neg_corner;

// mask after the subtraction of the center
// mcpt = mask - center + thresh
// mcmt = mask - center - thresh
//
// for the center pixel to be a corner, it must:
// have N continuous pixels in which mpos = (mask-center+thresh) is negative
//   or N continuous pixels in which mneg = (mask-center-thresh) is positive
wire [C*(W+1)-1:0] mdiff, mdiff_d1;  // mask - center
/*
wire [C*(W+1)-1:0] mcpt, mcpt_d1;  // mask - center + threshold
wire [C*(W+1)-1:0] mcmt, mcmt_d1;  // mask - center - threshold
*/
d1 #(C*(W+1)) mdiff_r(.c(c), .d(mdiff), .q(mdiff_d1));
/*
d1 #(C*(W+1)) mcpt_r(.c(c), .d(mcpt), .q(mcpt_d1));
d1 #(C*(W+1)) mcmt_r(.c(c), .d(mcmt), .q(mcmt_d1));
*/

// these booleans hold each pixel state: {darker, lighter, or neither}
wire [C-1:0] darker, darker_d1, lighter, lighter_d1;
d1 #(C) darker_r(.c(c), .d(darker), .q(darker_d1));
d1 #(C) lighter_r(.c(c), .d(lighter), .q(lighter_d1));

/*
wire [C-1:0] signs_d, signs;
d1 #(C) signs_r(.c(c), .d(signs_d), .q(signs));
*/

// test if we have enough consecutive darker or lighter pixels
wire [C-1:0] darker_valid, darker_valid_d1;
wire [C-1:0] lighter_valid, lighter_valid_d1;
d1 #(C) darker_valid_r(.c(c), .d(darker_valid), .q(darker_valid_d1));
d1 #(C) lighter_valid_r(.c(c), .d(lighter_valid), .q(lighter_valid_d1));

/*
generate
  for (i = 0; i < C; i = i + 1) begin: consecutive_test
    assign signs_valid[i] = segment_signs == {N{1'b1}} |
                            segment_signs == {N{1'b0}};
  end
endgenerate
*/

// signs-valid is computed early in the pipeline; need to delay until the end
/*
wire [C-1:0] signs_valid_d3;
dn #(.W(C), .N(3)) signs_valid_d3_r(.c(c), .d(signs_valid), .q(signs_valid_d3));

wire [C*W-1:0] ma, ma_d; // absolute-value of m
d1 #(C*W) ma_r(.c(c), .d(ma_d), .q(ma));
*/

/*
wire [(C/2)*W-1:0] l0, l0_d; // level-0 minima between adjacent ma
d1 #(C/2*W) l0_r(.c(c), .d(l0_d), .q(l0));

wire [(C/2)*W-1:0] l1, l1_d; // level-1 minima between adjacent l0
d1 #(C/2*W) l1_r(.c(c), .d(l1_d), .q(l1));

wire [(C/2)*W-1:0] l2, l2_d; // level-2 minima between l1 skips
d1 #(C/2*W) l2_r(.c(c), .d(l2_d), .q(l2));

wire [C*W-1:0] min, min_d; // min of each N-pixel segment
d1 #(C*W) min_r(.c(c), .d(min_d), .q(min));

wire [C-1:0] thresh, thresh_d;
d1 #(C) thresh_r(.c(c), .d(thresh_d), .q(thresh));
*/

wire [C*W-1:0] mdiff_abs, mdiff_abs_d1;
d1 #(C*W) mdiff_abs_d1_r(.c(c), .d(mdiff_abs), .q(mdiff_abs_d1));

wire [(C/2)*W-1:0] l0_sums, l0_sums_d1;  // level-0 sums of |mask-center|
d1 #(C/2*W) l0_sums_d1_r(.c(c), .d(l0_sums), .q(l0_sums_d1));

wire [(C/4)*W-1:0] l1_sums, l1_sums_d1;  // level-1 sums of |mask-center|
d1 #(C/4*W) l1_sums_d1_r(.c(c), .d(l1_sums), .q(l1_sums_d1));

wire [(C/8)*W-1:0] l2_sums, l2_sums_d1;  // level-2 sums of |mask-center|
d1 #(C/8*W) l2_sums_d1_r(.c(c), .d(l2_sums), .q(l2_sums_d1));

wire [W-1:0] l3_sum, l3_sum_d1;  // final sum of |mask-center|
d1 #(W) l3_sum_d1_r(.c(c), .d(l3_sum), .q(l3_sum_d1));

generate
  for (i = 0; i < C; i = i + 1) begin: iterate_mask
    // stage 0: subtract the center from each mask pixel
    assign mdiff[i*(W+1) +:(W+1)] = {1'b0, dm_d1[i*W +:W]} - {1'b0, dc_d1};

    // stage 1: add and subtract the threshold to (mask-center)
    //          also, for score calculation, compute abs(mask-center)
    wire [C*(W+1)-1:0] mcpt, mcmt;  // entire calculation, for debugging
    assign mcpt[i*(W+1) +:(W+1)] = mdiff_d1[i*(W+1) +:(W+1)] + {1'b0, t+1'b1};
    assign mcmt[i*(W+1) +:(W+1)] = mdiff_d1[i*(W+1) +:(W+1)] - {1'b0, t+1'b1};
    assign darker[i]  =  mcpt[i*(W+1) + W];  // only need to store MSB
    assign lighter[i] = ~mcmt[i*(W+1) + W];  // only need to store MSB
    wire [W-1:0] mdiff_d1_i = mdiff_d1[i*(W+1) +:W];
    wire [W-1:0] mdiff_d1_complement_i = (~mdiff_d1_i) + 1'b1;
    assign mdiff_abs[i*W +:W] =
      mdiff_d1[i*(W+1)+W] ? mdiff_d1_complement_i : mdiff_d1_i;

    // stage 2: test if we have enough consecutive darker/lighter bits
    //          also, for score calculation, compute first round of sum(abs)
    wire [N-1:0] darker_segment, lighter_segment;
    for (j = 0; j < N; j = j + 1) begin: assign_segments
      assign darker_segment[j]  = darker_d1[(i+j)%C];
      assign lighter_segment[j] = lighter_d1[(i+j)%C];
    end
    assign darker_valid[i] = &darker_segment;  // pixel i = start of dark seg
    assign lighter_valid[i] = &lighter_segment;  // pixel i = start light seg
    wire [W:0] sum_i;
    if (i < C/2) begin
      assign sum_i = mdiff_abs_d1[(i*2)*W +:W] + mdiff_abs_d1[(i*2+1)*W +:W];
      assign l0_sums[i*W +:W] = sum_i[W:1];  // drop LSB of sum
    end

    // stage 3: for score calculation, compute second round of sum(abs)
    wire [W:0] sum_i2;
    if (i < C/4) begin
      assign sum_i2 = l0_sums_d1[(i*2)*W +:W] + l0_sums_d1[(i*2+1)*W +:W];
      assign l1_sums[i*W +:W] = sum_i2[W:1];
    end

    // stage 4: for score calculation, compute third round of sum(abs)
    wire [W:0] sum_i3;
    if (i < C/8) begin
      assign sum_i3 = l1_sums_d1[(i*2)*W +:W] + l1_sums_d1[(i*2+1)*W +:W];
      assign l2_sums[i*W +:W] = sum_i3[W:1];
    end
  end
endgenerate

// delay the corner-found signal until the score is ready
wire corner_valid = |darker_valid_d1 | |lighter_valid_d1;
wire corner_valid_d2;
dn #(.N(2)) cvd2_r(.c(c), .d(corner_valid & dv_s), .q(corner_valid_d2));
d1 q_r(.c(c), .d(corner_valid_d2), .q(q));

// stage 5: for score calculation, compute the final level of sum(abs)
wire [8:0] sum_i4 = l2_sums_d1[15:8] + l2_sums_d1[7:0];
assign l3_sum = corner_valid_d2 ? sum_i4[8:1] : 8'h0;
assign score = l3_sum_d1;

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


/*
`define MASK_DEBUG
`ifdef MASK_DEBUG
integer pc; // print-mask index
always begin
  wait(c);
  wait(~c);
  if (dv) begin
    //#1; 
    $write("CENTER = %02x C = [", dc);
    for (pc = 0; pc < C; pc = pc + 1) begin: print_mask
      $write("%2x ", dm[pc*8 +: 8]);
    end
    $write("]\n pos_valid = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_pos_valid
      $write("%x", pos_valid[pc]);
    end
    $write("]\n neg_valid = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_neg_valid
      $write("%x", neg_valid[pc]);
    end
    $write("]\n pos = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_pos
      $write("%x", pos[pc]);
    end
    $write("] neg = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_neg
      $write("%x", neg[pc]);
    end
    $write("]\n");
    $write("pos_corner = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_pos_corner
      $write("%x", pos_corner[pc]);
    end
    $write("] neg_corner = [");
    for (pc = 0; pc < C; pc = pc + 1) begin: print_neg_corner
      $write("%x", neg_corner[pc]);
    end
    $write("]\n");
  end
end
`endif
*/
`endif

endmodule
