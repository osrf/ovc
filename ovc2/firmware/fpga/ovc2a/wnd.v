`timescale 1ns/1ns
module wnd
#(parameter COLS=7, ROWS=7)
(input c,
 input [31:0] p,
 input lv, input fv,
 output [ROWS*COLS*8-1:0] w0,  // the window buffer centered on byte 0
 output [ROWS*COLS*8-1:0] w1,  // the window buffer centered on byte 1
 output [ROWS*COLS*8-1:0] w2,  // the window buffer centered on byte 2
 output [ROWS*COLS*8-1:0] w3,  // the window buffer centered on byte 3
 output wv,  // window-valid
 output [9:0] row,  // rows are in image rows
 output [8:0] col);  // cols are the "dword" index into this row

localparam CDW = (COLS >> 2) + 2;  // number of "dword columns" in window

wire lv_d1;
d1 lv_d1_r(.c(c), .d(lv), .q(lv_d1));
//wire end_of_row = ~lv & lv_d1;
wire row_start = lv & ~lv_d1;

wire [4:0] postrow_cnt;
r #(5) postrow_cnt_r
(.c(c), .en(1'b1), .rst(lv), .d(postrow_cnt+1'b1), .q(postrow_cnt));
wire postrow_end = postrow_cnt == CDW;

wire [9:0] rcnt; // row count
r #(10) rcnt_r(.c(c), .rst(~fv), .en(postrow_end), .d(rcnt+1'b1), .q(rcnt));
assign row = rcnt;

wire w_active = ~(~lv & postrow_cnt >= CDW);
r #(9) col_r
(.c(c), .en(1'b1), .rst(~w_active), .d(col+1'b1), .q(col));

wire [ROWS*CDW*32-1:0] w_next, w;
r #(ROWS*CDW*32) w_r  // register to help timing a bit
(.c(c), .rst(~fv), .en(1'b1), .d(w_next), .q(w)); 

//wire bram_we = (col >= COLS) & (postrow_cnt <= COLS - 1);
wire bram_we = (col >= CDW) & (postrow_cnt <= CDW);
wire [8:0] waddr = col - CDW - 1;
assign wv = rcnt > ROWS & fv & col >= CDW+1 & (postrow_cnt < CDW);

genvar i;
generate
for (i = 0; i < ROWS; i = i + 1) begin: gen_rows
  // todo: rewrite this in order to register on the BRAM output (for timing).
  wire [31:0] ram_q;
  // to slide the window "to the right" in the image, we need to shift-left
  // each row of the window buffer and stick either the BRAM read or the
  // inbound pixels onto the right side of the row buffer. Note that,
  // confusingly, this will be in the MSB's of the bit vector assignment...
  wire [31:0] w_rhs = i == ROWS-1 ? p : ram_q; //w_next[(i*COLS*8) +: 8]; // q;
  // each window row buffer is CDW*32 = 3*32 = 96 bits 
  // next_row_0 = { new_pixels , prev_row_0[95:32] = w[ 95: 32] }
  // next_row_1 = { bram_read_1, prev_row_1[95:32] = w[191:128] }
  // next_row_2 = { bram_read_2, prev_row_2[95:32] = w[287:224] }
  // and so on.
  // row 0: w_next[23:0] = {w_lr, w[23:8]}
  /*
  assign w_next[(i*COLS+COLS)*8-1:i*COLS*8] = 
    {w_lr, w[(i*COLS+COLS)*8-1:(i*COLS+1)*8]};
  */
  assign w_next[((i+1)*CDW)*32-1:i*CDW*32] = 
      {w_rhs, w[((i+1)*CDW)*32-1:(i*CDW+1)*32]};

  // now, for the BRAM data: we want the left-hand column of the window
  // to be written one row "up" in the BRAMS
  //wire [7:0] d = (i < ROWS) ? w[(i+1)*COLS+7:(i+1)*COLS] : p; //8'h0;
  wire [31:0] ram_d;
  if (i < ROWS - 1) 
    assign ram_d = w[(i+1)*CDW*32 +:32];
  else
    assign ram_d = w[i*CDW*32 +:32];  // doesn't matter, will get overwritten
                                      // maybe better to just set to zero?
         //  (i+1)*COLS+7:(i+1)*COLS]; // : p; //8'h0;

  ram_512x32 row_ram
  (.c(c), .raddr(col), .q(ram_q), .d(ram_d), .waddr(waddr), .we(bram_we));
  // todo write beyond the RHS of the line-valid as we shift-out the window

  // now pick out the windows centered on each pixel column
  assign w0[(i+1)*COLS*8-1:i*COLS*8] = w[i*CDW*32+24 +:(COLS*8)];
  assign w1[(i+1)*COLS*8-1:i*COLS*8] = w[i*CDW*32+16 +:(COLS*8)];
  assign w2[(i+1)*COLS*8-1:i*COLS*8] = w[i*CDW*32+08 +:(COLS*8)];
  assign w3[(i+1)*COLS*8-1:i*COLS*8] = w[i*CDW*32+00 +:(COLS*8)];
end
endgenerate

//`define VERBOSE_WND_DEBUG
`ifdef VERBOSE_WND_DEBUG
integer lv_cnt = 0;

always begin
  wait(c);
  wait(~c);
  if (lv) begin
    //print_window();
    lv_cnt = lv_cnt + 1;
    if (lv_cnt > 194 && lv_cnt < 199)
      print_window();
    //  $finish();
  end
end

localparam BRAM_PRINT_COLS = 14;
integer pr, pc;
reg [7:0] wnd_pix;
task print_window;
begin
/*
  $display("\n");
  $display("== BRAMS ==");
  //for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_bram_rows
    for (pc = 0; pc < BRAM_PRINT_COLS; pc = pc + 1) //begin: print_bram_cols
      $write("%02x ", gen_rows[0].row_ram.mem[pc]); //w[(pr*CO+pc)*8 +: 8]);
    $write("\n");
    for (pc = 0; pc < BRAM_PRINT_COLS; pc = pc + 1) //begin: print_bram_cols
      $write("%02x ", gen_rows[1].row_ram.mem[pc]); //w[(pr*CO+pc)*8 +: 8]);
    $write("\n");
    for (pc = 0; pc < BRAM_PRINT_COLS; pc = pc + 1) //begin: print_bram_cols
      $write("%02x ", gen_rows[2].row_ram.mem[pc]); //w[(pr*CO+pc)*8 +: 8]);
    $write("\n");
    //end
    
  //end
*/

  $display("== WINDOW == p=0x%2x col=%x wv=%1x", p, col, wv);
  for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_rows
    for (pc = 0; pc < CDW*4; pc = pc + 1) begin: print_cols
      $write("%2x ", w[(pr*CDW*4+pc)*8 +: 8]);
    end
    $write("\n");
  end
  $display("== W0 ==");
  for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_w0_rows
    for (pc = 0; pc < COLS; pc = pc + 1) begin: print_w0_cols
      $write("%2x ", w0[(pr*COLS+pc)*8 +: 8]);
    end
    $write("\n");
  end
  $display("== W1 ==");
  for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_w1_rows
    for (pc = 0; pc < COLS; pc = pc + 1) begin: print_w1_cols
      $write("%2x ", w1[(pr*COLS+pc)*8 +: 8]);
    end
    $write("\n");
  end
  $display("== W2 ==");
  for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_w2_rows
    for (pc = 0; pc < COLS; pc = pc + 1) begin: print_w2_cols
      $write("%2x ", w2[(pr*COLS+pc)*8 +: 8]);
    end
    $write("\n");
  end
  $display("== W3 ==");
  for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_w3_rows
    for (pc = 0; pc < COLS; pc = pc + 1) begin: print_w3_cols
      $write("%2x ", w3[(pr*COLS+pc)*8 +: 8]);
    end
    $write("\n");
  end

end
endtask

/*
wire [5:0] arow; // active row buffer currently being written
r #(6) arow_r
(.c(c), .en(end_of_row), .rst(~fv), 
 .d(arow+1'b1 >= COLS ? 6'h0 : arow+1'b1), .q(arow));
  wire [5:0] wnd_row = arow + i; // where this row belongs in the window

  assign rolled_rhs_col[i*8+7:i*8] = q;

  for (j = 0; j < ROWS; j = j + 1) begin: gen_row_shifts
    // column-major: each column of this matrix is a different shift
    assign all_rhs_col_shifts[i*ROWS*j*8+7:i*ROWS*j*8] = q;
  end

  //assign row_step[(i+1)*COLS*8-1:i*COLS*8] = 
  //  i < ROWS-1 ? w[(i+2)*COLS*8-1:(i+1)*COLS*8] : {{COLS}{8'h0}};
  //assign w_int[(wnd_row*COLS+col)*8+7:(wnd_row*COLS+col)*8] = q;

*/
`endif

endmodule
