`timescale 1ns/1ns
module python_decoder
#(parameter UNSWAP_KERNELS=1)
(input wire c,
 input wire [7:0] sync,
 input wire [31:0] data,
 output wire fv,
 output wire lv,
 output wire [31:0] q);

localparam TR = 8'he9; // link training
localparam FS = 8'haa; // frame start
localparam FE = 8'hca; // frame end
localparam LS = 8'h2a; // line start
localparam IM = 8'h0d; // valid image data
localparam LE = 8'h4a; // line end
localparam WN = 8'h00; // window 0 (the full image)
localparam CS = 8'h16; // checksum
localparam BL = 8'h05; // black pixels (before the image)


localparam SW=3, CW=8;
localparam ST_LOST       = 3'd0;
localparam ST_INTERFRAME = 3'd1;
localparam ST_BLACK      = 3'd2;
localparam ST_FRAME      = 3'd3;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[SW+CW-1:CW];

// longest state is ST_FRAME, which lasts at most 324*1024 = 331776 ticks
// actually... at 30 fps, we could need to wait 33ms between frames = 2.3M tick
// and if we slow down to 1 fps, we could need to wait 1000ms = 62.5M ticks
wire [25:0] cnt;
r #(26) cnt_r (.c(c), .en(1'b1), .rst(ctrl[0]), .d(cnt+1'b1), .q(cnt));
wire state_rst = cnt == 26'h3ff_ffff; // no state is this long. try again.
r #(SW) state_r(.c(c), .rst(state_rst), .en(1'b1), .d(next_state), .q(state));

wire [7:0] sync_d1;
d1 #(8) sync_d1_r(.c(c), .d(sync), .q(sync_d1));

always @* begin
  case (state)
    ST_LOST:
      if (sync == FE)      ctrl = { ST_INTERFRAME, 8'b0000_0001 };
      else                 ctrl = { ST_LOST      , 8'b0000_0000 };
    ST_INTERFRAME:
      if (sync == LS)      ctrl = { ST_BLACK     , 8'b0000_0001 };
      else                 ctrl = { ST_INTERFRAME, 8'b0000_0000 };
    ST_BLACK:
      if (sync == FS)      ctrl = { ST_FRAME     , 8'b0000_1011 };
      else if (sync == CS) ctrl = { ST_BLACK     , 8'b0000_0000 };
      else                 ctrl = { ST_BLACK     , 8'b0000_0000 };
    ST_FRAME:
      if (sync_d1 == FE)   ctrl = { ST_INTERFRAME, 8'b0000_0011 };
      else if (sync == LS) ctrl = { ST_FRAME     , 8'b0000_1010 };
      else                 ctrl = { ST_FRAME     , 8'b0000_0010 };
    default:               ctrl = { ST_LOST      , 8'b0000_0000 };
  endcase
end

// we need to buffer 2 words' worth (8 pixels) to straighten the ordering
wire [63:0] data_shift;
d1 #(64) data_shift_r(.c(c), .d({data, data_shift[63:32]}), .q(data_shift));

// re-order as necessary in the output shift register
wire kernel_done;
r #(.INIT(1'b0)) kernel_done_r
(.c(c), .en(1'b1), .rst(ctrl[3]), .d(~kernel_done), .q(kernel_done));

wire kernel_parity_odd;
r #(.INIT(1'b0)) kernel_parity_odd_r
(.c(c), .en(kernel_done), .rst(ctrl[3]), 
 .d(~kernel_parity_odd), .q(kernel_parity_odd));

wire [63:0] next_kernel;
wire [63:0] ds = data_shift; // save some typing

generate
  if (UNSWAP_KERNELS)
    assign next_kernel = kernel_parity_odd ? 
    { ds[ 7: 0], ds[39:32], ds[15: 8], ds[47:40],
      ds[23:16], ds[55:48], ds[31:24], ds[63:56] } :
    { ds[63:56], ds[31:24], ds[55:48], ds[23:16],
      ds[47:40], ds[15: 8], ds[39:32], ds[ 7: 0] } ;
  else
    assign next_kernel = ds;
endgenerate

wire [63:0] output_shift;
d1 #(64) output_shift_r
(.c(c), 
 .d(kernel_done ? next_kernel : { 32'h0, output_shift[63:32] }),
 .q(output_shift));

// in the future, we may want to buffer lines here and verify checksums?
// for now, we'll just pass the pixels through
//d1 #(32) q_r(.c(c), .d(data), .q(q));
//d1 fv_r(.c(c), .d(ctrl[1]), .q(fv));
//d1 lv_r(.c(c), .d(ctrl[1] & sync != CS), .q(lv));

wire sync_img_data = sync == IM | sync == WN | 
                     sync == FS | sync == LS |
                     sync == FE | sync == LE ;

d1 #(32) q_r(.c(c), .d(output_shift[31:0]), .q(q));

// I can't remember why we need 4 cycles of delay here. Sad.
d4 fv_r(.c(c), .d(ctrl[1]), .q(fv));
d4 lv_r(.c(c), .d(ctrl[1] & sync_img_data), .q(lv));

/*
s #(.S(4)) fv_r(.c(c), .d(ctrl[1]), .q(fv));
s #(.S(4)) lv_r(.c(c), .d(ctrl[1] & sync_img_data), .q(lv));
*/

endmodule

