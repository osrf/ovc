`timescale 1ns/1ns
module dma_writer
(input c,
 output txs_write,
 output [127:0] txs_writedata,
 output [5:0] txs_burstcount,
 output [22:0] txs_address,
 input txs_waitrequest,
 input [127:0] d,  // data
 input dv,  // data-valid
 input de,  // data-end
 input [22:0] daddr,  // data-address start
 output ready);

// this module assembles inbound data into packets of max 1024 bits (128 bytes)
// and has the required state machine to forward them to the TXS port of the
// Altera PCIe module

// dfifo = data FIFO
// M10K blocks natively support a 32-bit, 256-deep mode. So a 128-bit
// wide, 256-deep fifo is what we want.
wire dfifo_wrreq, dfifo_rdreq, dfifo_empty, dfifo_almost_full;
wire [7:0] dfifo_usedw;
scfifo
#(.lpm_width(128), .lpm_numwords(256), .lpm_widthu(8),
  .lpm_showahead("ON"), .almost_full_value(240),
  .intended_device_family("CYCLONE V"), .add_ram_output_register("ON")) dfifo
(.clock(c), .aclr(1'b0), .sclr(1'b0),
 .wrreq(dv), .data(d),
 .rdreq(dfifo_rdreq), .q(txs_writedata), .empty(dfifo_empty),
 .usedw(dfifo_usedw), .almost_full(dfifo_almost_full));

////////////////////////////////////////////////////////////////////
// afifo = FIFO for the target address and burst length.
wire [31:0] afifo_d, afifo_q;
wire [7:0] afifo_usedw;
wire afifo_wrreq, afifo_rdreq, afifo_empty;
scfifo
#(.lpm_width(32), .lpm_numwords(256), .lpm_widthu(8),
  .lpm_showahead("ON"),
  .add_ram_output_register("ON")) afifo
(.clock(c), .aclr(1'b0), .sclr(1'b0),
 .wrreq(afifo_wrreq), .data(afifo_d),
 .rdreq(afifo_rdreq), .q(afifo_q), .empty(afifo_empty),
 .usedw(afifo_usedw));

assign ready = ~dfifo_almost_full;

// let's use a 6-bit counter in case we get a 256-byte max payload in the
// future on a different platform.
wire rx_burst_cnt_rst;
wire [3:0] rx_burst_cnt;
r #(4) rx_burst_cnt_r
(.c(c), .rst(de), .en(dv), .d(rx_burst_cnt+1'b1), .q(rx_burst_cnt));
assign afifo_d = { rx_burst_cnt,  // bits 31:28
                   5'b0, daddr};  // bits 27:0
assign afifo_wrreq = de;
assign txs_burstcount = {2'h0, afifo_q[31:28]} + 1'h1;
assign txs_address = afifo_q[22:0];
wire [3:0] tx_len_m1 = afifo_q[31:28];

wire [3:0] tx_burst_cnt;
wire tx_burst_cnt_rst, tx_burst_cnt_en;
r #(4) tx_burst_cnt_r
(.c(c), .rst(tx_burst_cnt_rst), .en(tx_burst_cnt_en),
 .d(tx_burst_cnt+1'b1), .q(tx_burst_cnt));

//////////////////////////////////////////////////
localparam CW = 4, SW = 1;
localparam ST_IDLE    = 1'b0;
localparam ST_WRITING = 1'b1;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] state_d = ctrl[CW+SW-1:CW];
r #(SW) state_r(.c(c), .d(state_d), .rst(1'b0), .en(1'b1), .q(state));

always @* begin
  case (state)
    ST_IDLE:
      if (~afifo_empty)                 ctrl = { ST_WRITING, 4'b1000 };
      else                              ctrl = { ST_IDLE   , 4'b0000 };
    ST_WRITING:
      if (~txs_waitrequest)
        if (tx_burst_cnt == tx_len_m1)  ctrl = { ST_IDLE   , 4'b0111 };
        else                            ctrl = { ST_WRITING, 4'b0011 };
      else                              ctrl = { ST_WRITING, 4'b0001 };
    default:                            ctrl = { ST_IDLE   , 4'b0000 };
  endcase
end

assign txs_write   = ctrl[0];
assign dfifo_rdreq = ctrl[1];
assign afifo_rdreq = ctrl[2];
assign tx_burst_cnt_en = dfifo_rdreq;
assign tx_burst_cnt_rst = ctrl[3];

endmodule

///////////////////////////////////
`ifdef test_dma_writer
module dma_writer_tb();

wire c;
sim_clk #(125) sim_clk_inst(.c(c));

wire txs_write;
wire [127:0] txs_writedata;
wire [5:0] txs_burstcount;
wire [22:0] txs_address;
reg txs_waitrequest;
reg [127:0] d;
reg dv;
reg de;
reg [22:0] daddr;
wire ready;

dma_writer dma_writer_inst(.*);

integer i;
initial begin
  $dumpfile("test_dma_writer.lxt");
  $dumpvars();
  txs_waitrequest <= 1'b0;
  d <= 128'h0;
  dv <= 1'b0;
  de <= 1'b0;
  daddr <= 23'h12_3456;
  #100;
  for (i = 0; i < 16; i = i + 1) begin
    @(posedge c);
    dv <= 1'b1;
    d <= i;
    if (i % 8 == 7)
      de <= 1'b1;
    else
      de <= 1'b0;
  end
  @(posedge c);
  dv <= 1'b0;
  de <= 1'b0;
  #100;
  daddr <= 23'h23_4567;
  #100;
  for (i = 0; i < 8; i = i + 1) begin
    @(posedge c);
    dv <= 1'b1;
    d <= i;
    if (i % 8 == 7)
      de <= 1'b1;
    else
      de <= 1'b0;
  end
  @(posedge c);
  dv <= 1'b0;
  de <= 1'b0;
  #200;
  $finish();
end

endmodule
`endif

`ifdef AHHHHH
// one-hot circular shifter to select which slot to land "d" into
wire [3:0] dfifo_d_en;
r #(4, 4'h1) dfifo_dv_en_r
(.c(c), .rst(de), .en(dv), .d({dfifo_d_en[2:0], dfifo_d_en[3]}),
 .q(dfifo_d_en));

wire [3:0] dfifo_d_rst;
r #(32) dfifo_d_r[3:0] 
(.c(c), .rst(dfifo_d_rst), .en(dfifo_d_en), .d(d), .q(dfifo_d));

// wipe out the high words every time we assign the first word
assign dfifo_d_rst = (dfifo_d_en == 4'b0001 & dv) ? 4'b1110 : 4'b0000;
assign dfifo_d_en = dfifo_d_en & {4{dv}}; 
`endif
