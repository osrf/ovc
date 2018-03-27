`timescale 1ns/1ns
module spi_master
#(parameter SCLK_DIV = 8'd8,
  parameter W = 8'd8,
  parameter CPOL = 1,
  parameter CPHA = 1,
  parameter SAMPLE_OPPOSITE_EDGE = 0)
(input c, input start, output done,
 input [W-1:0] txd, output [W-1:0] rxd,
 input hold_cs,  // for multi-word transfers
 output sclk, output mosi, input miso, output cs);

wire [7:0] sclk_cnt;
wire sclk_match = sclk_cnt == SCLK_DIV-1;

r #(8) sclk_cnt_r
(.c(c), .en(1'b1), .rst(sclk_match), .d(sclk_cnt+1'b1), .q(sclk_cnt));

wire sclk_int;
r sclk_int_r
(.c(c), .en(sclk_match), .rst(1'b0), .d(~sclk_int), .q(sclk_int));

wire sclk_rising  = ~sclk_int & sclk_match;
wire sclk_falling =  sclk_int & sclk_match;

wire sclk_tx_edge, sclk_rx_edge, sclk_tx_inactive_edge;
wire clk_idle;

// todo: handle cases we haven't needed yet
generate
  if (CPOL == 1 && CPHA == 1) begin
    assign sclk_tx_edge = sclk_falling;
    assign sclk_tx_inactive_edge = sclk_rising;
    assign clk_idle = 1'b1;
  end
  else if (CPOL == 0 && CPHA == 0) begin
    assign sclk_tx_edge = sclk_falling;
    assign sclk_tx_inactive_edge = sclk_rising;
    assign clk_idle = 1'b0;
  end

  // some crazy chips require you to sample on the opposite clock edge
  // but most links require sampling on the same (active) edge
  // these signals are tricky to name... these are the instants that we
  // shift the respective registers. Since the TX sampling happens in the
  // middle of the window at the receiver, we shift TX a half-clock before
  // it's sampled.
  if (SAMPLE_OPPOSITE_EDGE) begin
    assign sclk_rx_edge = sclk_tx_edge;
  end
  else begin
    assign sclk_rx_edge = sclk_tx_inactive_edge;
  end
endgenerate


/////////////////////////////////////////////////////////
localparam SW = 3;
localparam ST_IDLE      = 3'd0;
localparam ST_SCLK_SYNC = 3'd1;
localparam ST_PRE_TXRX  = 3'd2;
localparam ST_TXRX      = 3'd3;
localparam ST_POST_TXRX = 3'd4;
localparam ST_DONE      = 3'd5;

localparam CW = 4;
reg [SW+CW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[SW+CW-1:CW];
r #(SW) state_reg
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));


localparam BIT_CNT_W = 8;
wire [BIT_CNT_W-1:0] bit_cnt;
wire bit_cnt_rst, bit_cnt_en;
r #(BIT_CNT_W) bit_cnt_r
(.c(c), .rst(bit_cnt_rst), .en(bit_cnt_en), .d(bit_cnt + 1'b1), .q(bit_cnt));
assign bit_cnt_rst = (state == ST_PRE_TXRX);
assign bit_cnt_en = (state == ST_TXRX & sclk_tx_inactive_edge);

always @* begin
  case (state)
    ST_IDLE:
      if (start)                         ctrl = { ST_SCLK_SYNC , 4'b0001 };
      else                               ctrl = { ST_IDLE      , 4'b0000 };
    ST_SCLK_SYNC:
      if (sclk_tx_inactive_edge)         ctrl = { ST_PRE_TXRX  , 4'b0001 };
      else                               ctrl = { ST_SCLK_SYNC , 4'b0001 };
    ST_PRE_TXRX: 
      if (sclk_tx_edge)                  ctrl = { ST_TXRX      , 4'b0001 };
      else                               ctrl = { ST_PRE_TXRX  , 4'b0001 };
    ST_TXRX:
      if (sclk_tx_edge & bit_cnt == W)   ctrl = { ST_POST_TXRX , 4'b0001 };
      else                               ctrl = { ST_TXRX      , 4'b0011 };
    ST_POST_TXRX:
      if (sclk_tx_edge)                  ctrl = { ST_DONE      , 4'b0001 };
      else                               ctrl = { ST_POST_TXRX , 4'b0001 };
    ST_DONE:                             ctrl = { ST_IDLE      , 4'b0001 };
    default:                             ctrl = { ST_IDLE      , 4'b0000 };
  endcase
end

assign cs = ~(hold_cs | ctrl[0]);
assign sclk = ctrl[1] ? sclk_int : clk_idle;
//wire done_int = state == ST_DONE;
// latch the DONE flag until we've been told to start again
r done_r(.c(c), .rst(start), .en(state == ST_DONE), .d(1'b1), .q(done));
//d1 done_d1_r(.c(c), .d(done_int), .q(done));  // delay done until we're idle

wire mosi_load = state == ST_IDLE;
wire mosi_shift_en = state == ST_TXRX & sclk_tx_edge;
wire [W-1:0] mosi_shift;
r #(W) mosi_shift_r
(.c(c), .rst(1'b0), .en(mosi_shift_en | mosi_load),
 .d(state != ST_TXRX ? txd : {mosi_shift[W-2:0],1'b0}), 
 .q(mosi_shift));
assign mosi = ~cs & mosi_shift[W-1];

wire [W-1:0] miso_shift;
wire miso_shift_en = state == ST_TXRX & sclk_rx_edge;
r #(W) miso_shift_r
(.c(c), .rst(state == ST_IDLE), .en(miso_shift_en),
 .d({miso_shift[W-2:0], miso}), .q(miso_shift));

r #(W) rxd_r
(.c(c), .en(state == ST_DONE), .rst(1'b0), .d(miso_shift), .q(rxd));

endmodule

/////////////////////////////////////////////////////////////////////////

`ifdef test_spi_master
module spi_master_tb();
wire c;
sim_clk #(100) clk_inst(c);

localparam W = 8;
reg [W-1:0] txd;
wire [W-1:0] rxd;

reg start, hold_cs;
wire done;
wire sclk, mosi, cs;
reg miso;
spi_master #(.SCLK_DIV(50), .W(W)) spi_master_inst
(.c(c), .start(start), .done(done), .hold_cs(hold_cs),
 .txd(txd), .rxd(rxd),
 .sclk(sclk), .mosi(mosi), .miso(miso), .cs(cs));

reg [25:0] txd_26;
wire [25:0] rxd_26;
reg start_26;
wire done_26;
wire sclk_26, mosi_26, cs_26;
reg miso_26;

// now we can test a weird case
spi_master #(.SCLK_DIV(50), .W(26),
             .CPOL(0), .CPHA(0),
             .SAMPLE_OPPOSITE_EDGE(1)) spi_master_26bit
(.c(c), .start(start_26), .done(done_26), .hold_cs(1'b0),
 .txd(txd_26), .rxd(rxd_26),
 .sclk(sclk_26), .mosi(mosi_26), .miso(miso_26), .cs(cs_26));

initial begin
  $dumpfile("spi_master_test.lxt");
  $dumpvars();
  txd = 8'ha5;
  start = 1'b0;
  hold_cs = 1'b0;
  miso = 1'b1;
  start_26 = 1'b0;
  miso_26 = 1'b1;
  #1000
  @(posedge c);
  #1 hold_cs = 1'b1;
  @(posedge c);
  #1 start = 1'b1;
  @(posedge c);
  #1 start = 1'b0;
  #1000
  wait(done);
  @(posedge c);
  #1 txd = 8'h42;
  start = 1'b1;
  @(posedge c);
  #1 start = 1'b0;
  hold_cs = 1'b0;
  #15000
  // todo: make sure that rxd is 0xff

  ////////////////////////////////////////
  // now test the crazy 26-bit setup
  txd_26 = 26'h151_4271;
  @(posedge c);
  #1 start_26 = 1'b1;
  @(posedge c);
  #1 start_26 = 1'b0;
  @(posedge c);
  #30000

  $finish;
end
endmodule
`endif

