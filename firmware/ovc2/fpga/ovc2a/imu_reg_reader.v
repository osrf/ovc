`timescale 1ns/1ns
module imu_reg_reader
#(parameter SPEEDUP=1,
  parameter SPI_SCLK_DIV=8)
(input c,
 input start,
 output done,
 input [7:0] reg_idx,
 input [7:0] reg_len,
 input [7:0] reg_start_word,
 output [31:0] reg_d,
 output reg_dv,
 output cs,
 output sck,
 output mosi,
 input miso);

wire spi_done;

wire [15:0] c_cnt;
wire c_cnt_rst;
r #(16) c_cnt_r(.c(c), .rst(c_cnt_rst), .en(1'b1), .d(c_cnt+1'b1), .q(c_cnt));

wire [4:0] word_cnt;
wire word_cnt_rst, word_cnt_en;
r #(5) word_cnt_r
(.c(c), .rst(word_cnt_rst), .en(word_cnt_en), .d(word_cnt+1'b1), .q(word_cnt));

wire [4:0] words;
r #(5) words_r(.c(c), .rst(1'b0), .en(start), .d(reg_len[4:0]), .q(words));

localparam CW = 8, SW = 3;
localparam ST_IDLE          = 3'd0;
localparam ST_REQUEST_TXRX  = 3'd1;
localparam ST_REQUEST_WAIT  = 3'd2;
localparam ST_RESPONSE_TXRX = 3'd3;
localparam ST_RESPONSE_WAIT = 3'd4;
localparam ST_DONE          = 3'd5;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[CW+SW-1:CW];
r #(SW) state_r
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));

//localparam WAIT_CNT = 6249 / SPEEDUP;  // = 50us on a 125 MHz clock
localparam WAIT_CNT = 12499 / SPEEDUP;  // = 100us on a 125 MHz clock

always @* begin
  case (state)
    ST_IDLE:
      if (start)               ctrl = { ST_REQUEST_TXRX , 8'b00_0_01_011 };
      else                     ctrl = { ST_IDLE         , 8'b00_0_00_000 };
    ST_REQUEST_TXRX:   
      if (spi_done)            ctrl = { ST_REQUEST_WAIT , 8'b00_0_00_110 };
      else                     ctrl = { ST_REQUEST_TXRX , 8'b00_0_01_010 };
    ST_REQUEST_WAIT:
      if (c_cnt == WAIT_CNT)   ctrl = { ST_RESPONSE_TXRX, 8'b10_0_00_011 };
      else                     ctrl = { ST_REQUEST_WAIT , 8'b00_0_00_000 };
    ST_RESPONSE_TXRX:
      if (spi_done) begin
        if (word_cnt == words) ctrl = { ST_RESPONSE_WAIT, 8'b01_0_00_110 };
        else                   ctrl = { ST_RESPONSE_TXRX, 8'b01_0_00_011 };
      end else                 ctrl = { ST_RESPONSE_TXRX, 8'b00_0_00_010 };
    ST_RESPONSE_WAIT:
      if (c_cnt == WAIT_CNT)   ctrl = { ST_IDLE         , 8'b00_1_00_000 };
      else                     ctrl = { ST_RESPONSE_WAIT, 8'b00_0_00_000 };
    default:                   ctrl = { ST_IDLE         , 8'b00_0_00_000 };
  endcase
end

d1 done_d1_r(.c(c), .d(ctrl[5]), .q(done));  // delay done pulse one cycle

wire spi_start = ctrl[0];
wire hold_cs = ctrl[1];
assign c_cnt_rst = ctrl[2];
assign word_cnt_en = ctrl[6];
assign word_cnt_rst = ctrl[7];
assign reg_dv = word_cnt_en & word_cnt > reg_start_word;

wire txd_sel = ctrl[3];
wire [31:0] txd_request_header = {8'h01, reg_idx, 16'h0};
/*
d1 #(32) txd_request_header_r
(.c(c), .d({8'h01, reg_idx, 16'h0}), .q(txd_request_header));
*/

wire [31:0] spi_txd, spi_rxd;
assign reg_d = spi_rxd;

//assign spi_txd = txd_sel ? txd_request_header : 32'h0;
d1 #(32) spi_txd_r
(.c(c), .d(txd_sel ? txd_request_header : 32'h0), .q(spi_txd));

wire spi_start_d1;
d1 spi_start_d1_r(.c(c), .d(spi_start), .q(spi_start_d1));

wire spi_done_hold;  // convert to oneshot
oneshot #(.SYNC(0)) spi_done_oneshot_r
(.c(c), .d(spi_done_hold), .q(spi_done));

wire cs_i, sck_i, mosi_i;  // internal versions before output regs
spi_master #(.SCLK_DIV(SPI_SCLK_DIV), .W(32)) spi_master_inst
(.c(c), .start(spi_start_d1), .done(spi_done_hold), .hold_cs(hold_cs),
 .txd(spi_txd), .rxd(spi_rxd),
 .cs(cs_i), .sclk(sck_i), .mosi(mosi_i), .miso(miso));

d1 cs_r(.c(c), .d(cs_i), .q(cs));
d1 sck_r(.c(c), .d(sck_i), .q(sck));
d1 mosi_r(.c(c), .d(mosi_i), .q(mosi));

endmodule
