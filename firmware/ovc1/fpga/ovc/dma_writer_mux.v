`timescale 1ns/1ns
module dma_writer_mux
#(parameter N=4,  // number of streams
  parameter AW=23,  // address width
  parameter [AW*N-1:0] BASE_ADDRS=0)
(input [N-1:0]    in_c,   // inbound clocks
 input [N*32-1:0] in_d,   // inbound data
 input [N-1:0]    in_dv,  // inbound data-valid
 input c,  // clock for the dma machinery
 input rst,  // reset all addresses to BASE_ADDRS
 input flush,  // request to flush all outbound fifos, zero-padding as needed
 output flush_complete,
 output txs_write,
 output [127:0] txs_writedata,
 output [5:0] txs_burstcount,
 output [22:0] txs_address,
 input txs_waitrequest);

localparam STRETCH_SHIFT_LEN = 6;  // deal with difference in clocks
wire [STRETCH_SHIFT_LEN-1:0] rst_shift;
d1 #(STRETCH_SHIFT_LEN) rst_shift_r
(.c(c), .d({rst_shift[STRETCH_SHIFT_LEN-2:0], rst}), .q(rst_shift));
wire rst_longer = |rst_shift;

wire [STRETCH_SHIFT_LEN-1:0] flush_shift;
d1 #(STRETCH_SHIFT_LEN) flush_shift_r
(.c(c), .d({flush_shift[STRETCH_SHIFT_LEN-2:0], flush}), .q(flush_shift));
wire flush_longer = |flush_shift;

// mix a bunch of 32-bit streams into 128-bit streams
// chop the outbound 128-bit stream into 8 beats and maintain addresses

wire [127:0] dma_d;
wire dma_dv, dma_de;
wire [22:0] dma_addr;
wire dma_ready;

dma_writer dma_writer_inst
(.c(c), .txs_write(txs_write), .txs_writedata(txs_writedata),
 .txs_burstcount(txs_burstcount), .txs_address(txs_address),
 .txs_waitrequest(txs_waitrequest),
 .d(dma_d), .dv(dma_dv), .de(dma_de), .daddr(dma_addr), .ready(dma_ready));

localparam CW = 8, SW = 4;
localparam ST_ADVANCE  = 4'h0;  // advance stream_sel to address next FIFO
localparam ST_TEST     = 4'h1;  // see if this FIFO has data to read
localparam ST_WAIT     = 4'h2;  // wait for the dma_writer to become ready
localparam ST_WRITE    = 4'h3;  // read an 8-word packet from selected fifo
localparam ST_FADV     = 4'h4;
localparam ST_FTEST    = 4'h5;  // test for non-empty fifo (flush mode)
localparam ST_FWAIT    = 4'h6;  // wait for dma_writer (flush mode)
localparam ST_FWRITE   = 4'h7;  // read an 8-word packet from selected fifo
localparam ST_FLUSHED  = 4'h8;  // flush complete

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] state_d = ctrl[CW+SW-1:CW];
r #(SW) state_r(.c(c), .d(state_d), .rst(rst), .en(1'b1), .q(state));

wire [N-1:0] stream_sel;
wire stream_sel_en;
wire stream_sel_rst;
r #(N, {1'b1, {(N-1){1'b0}}}) stream_sel_r
(.c(c), .rst(stream_sel_rst), .en(stream_sel_en),
 .d({stream_sel[N-2:0], stream_sel[N-1]}), .q(stream_sel));

wire [N-1:0] stream_addr_en;
wire [AW*N-1:0] stream_addr;

wire [N-1:0] sfifo_rdempty, sfifo_rdreq;
wire [128*N-1:0] sfifo_q;

localparam USEDW = 10;
wire [USEDW*N-1:0] sfifo_rdusedw;
wire [N-1:0] sfifo_pkt_ready;

wire [2:0] burst_cnt;
wire burst_cnt_en, burst_cnt_rst;
r #(3) burst_cnt_r
(.c(c), .rst(burst_cnt_rst), .en(burst_cnt_en),
 .d(burst_cnt+1'b1), .q(burst_cnt));

genvar i;
generate
  for (i = 0; i < N; i = i + 1) begin: gen_fifos
    // cross reset and flush to each of the inbound clock domains
    wire rst_in_c, flush_in_c;
    s rst_in_c_r(.c(in_c[i]), .d(rst_longer), .q(rst_in_c));

    oneshot #(.SYNC(2)) flush_oneshot_r
    (.c(in_c[i]), .d(flush_longer), .q(flush_in_c));

    wire sfifo_wrfull, sfifo_wrempty;
    assign sfifo_pkt_ready[i] = sfifo_rdusedw[USEDW*i +:USEDW] >= 4'h8;

    wire [3:0] d_slot_sel;  // = in_dv[i];
    r #(4, 4'h1) d_slot_sel_r 
    (.c(in_c[i]), .rst(rst_in_c), .en(in_dv[i]),
     .d({d_slot_sel[2:0], d_slot_sel[3]}), .q(d_slot_sel));

    wire [3:0] sfifo_d_en = d_slot_sel & {4{in_dv[i]}};
    wire [127:0] sfifo_d;
    r #(32) sfifo_d_r [3:0]
    (.c(in_c[i]), .rst(1'b0), .en(sfifo_d_en),
     .d(in_d[32*i +:32]), .q(sfifo_d));

    wire dv_d1;
    d1 dv_d1_r(.c(in_c[i]), .d(in_dv[i]), .q(dv_d1));
    wire sfifo_wrreq = flush_in_c | (dv_d1 & (d_slot_sel == 4'h1));

    // the stream write pointer is kept in the read-clock domain
    r #(AW, BASE_ADDRS[AW*i +:AW]) stream_addr_r
    (.c(c), .rst(rst), .en(stream_addr_en[i]),
     .d(stream_addr[AW*i +:AW] + 8'h80), .q(stream_addr[AW*i +:AW]));

    dcfifo
    #(.lpm_width(128),
      .lpm_widthu(USEDW),
      .lpm_numwords(512),  // 2^USEDW
      .lpm_showahead("ON"),
      .intended_device_family("CYCLONE V"),
      .add_usedw_msb_bit("ON"),
      .rdsync_delaypipe(4),
      .wrsync_delaypipe(4)) sfifo  // sfifo = "stream FIFO"
    (.aclr(rst_longer),
     .wrclk(in_c[i]),
     .wrreq(sfifo_wrreq),
     .wrfull(sfifo_wrfull),
     .wrempty(sfifo_wrempty),
     .data(sfifo_d),
     .rdclk(c),
     .rdreq(sfifo_rdreq[i]),
     .rdempty(sfifo_rdempty[i]),
     .q(sfifo_q[128*i +:128]),
     .rdusedw(sfifo_rdusedw[USEDW*i +:USEDW]));
  end
endgenerate

always @* begin
  case (state)
    ST_ADVANCE:
      if (~flush)                          ctrl = { ST_TEST   , 8'b0000_0001 };
      else                                 ctrl = { ST_FADV   , 8'b0100_0000 };
    ST_TEST:
      if (|(sfifo_pkt_ready & stream_sel)) ctrl = { ST_WAIT   , 8'b0000_0000 };
      else                                 ctrl = { ST_ADVANCE, 8'b0000_0000 };
    ST_WAIT:
      if (dma_ready)                       ctrl = { ST_WRITE  , 8'b0010_0100 };
      else                                 ctrl = { ST_WAIT   , 8'b0000_0000 };
    ST_WRITE:
      if (burst_cnt == 3'h7)               ctrl = { ST_ADVANCE, 8'b0001_1010 };
      else                                 ctrl = { ST_WRITE  , 8'b0010_1010 };
    ST_FADV:                               ctrl = { ST_FTEST  , 8'b0000_0001 };
    ST_FTEST:
      if (|(~sfifo_rdempty & stream_sel))  ctrl = { ST_FWAIT  , 8'b0000_0000 };
      else 
        if (stream_sel[N-1] == 1'b1)       ctrl = { ST_FLUSHED, 8'b0000_0000 };
        else                               ctrl = { ST_FADV   , 8'b0000_0000 };
    ST_FWAIT:
      if (dma_ready)                       ctrl = { ST_FWRITE , 8'b0010_0100 };
      else                                 ctrl = { ST_FWAIT  , 8'b0000_0000 };
    ST_FWRITE:
      if (burst_cnt == 3'h7)               ctrl = { ST_FTEST  , 8'b0001_1010 };
      else                                 ctrl = { ST_FWRITE , 8'b0010_1010 };
    ST_FLUSHED:                            ctrl = { ST_FLUSHED, 8'b1000_0000 };
    default:                               ctrl = { ST_ADVANCE, 8'b0000_0000 };
  endcase
end

assign stream_sel_en = ctrl[0];
assign burst_cnt_en = ctrl[1];
assign burst_cnt_rst = ctrl[2];
assign dma_dv = ctrl[3];
assign dma_de = ctrl[4];
assign stream_addr_en = {N{dma_de}} & stream_sel;
wire fifo_read = ctrl[5];
assign stream_sel_rst = rst | ctrl[6];
assign flush_complete = ctrl[7];

assign sfifo_rdreq = {N{fifo_read}} & stream_sel;  // {N{dma_dv}} & fifo_read;

//assign txs_burstcount = 6'h8;  // for now, always 8-word bursts
// this mux adds a 1-cycle delay!
hmux #(.DWIDTH(128), .WORDCOUNT(N), .OUTPUT_REG(1)) dma_d_mux
(.c(c), .d(sfifo_q), .sel(stream_sel), .q(dma_d));

hmux #(.DWIDTH(AW), .WORDCOUNT(N), .OUTPUT_REG(1)) dma_addr_mux
(.c(c), .d(stream_addr), .sel(stream_sel), .q(dma_addr));

endmodule

///////////////////////////////////////////////////////////////
`ifdef test_dma_writer_mux
module dma_writer_mux_tb();

wire c;
sim_clk #(125) sim_clk_inst(.c(c));

wire c_cam0, c_cam1, c_cam1_nodelay;
sim_clk #(63) sim_cam0_inst(.c(c_cam0));
sim_clk #(63) sim_cam1_inst(.c(c_cam1_nodelay));
assign #7 c_cam1 = c_cam1_nodelay;  // cameras may not be phase-aligned

reg [31:0] d_cam0, d_cam1, d_corner0, d_corner1;
reg [3:0] dv;
reg rst, flush;
wire flush_complete;
wire txs_write;
wire [127:0] txs_writedata;
wire [5:0] txs_burstcount;
wire [22:0] txs_address;
reg txs_waitrequest;

dma_writer_mux
#(.N(4),
  .BASE_ADDRS({23'h4_0000, 23'h3_0000, 23'h2_0000, 23'h1_0000})) dut
(.in_c({c_cam1, c_cam0, c_cam1, c_cam0}),
 .in_d({d_corner1, d_corner0, d_cam1, d_cam0}),
 .in_dv(dv),
 .c(c), .rst(rst), .flush(flush), .flush_complete(flush_complete),
 .txs_write(txs_write), .txs_writedata(txs_writedata),
 .txs_burstcount(txs_burstcount), .txs_address(txs_address),
 .txs_waitrequest(txs_waitrequest));

integer i;
initial begin
  $dumpfile("test_dma_writer_mux.lxt");
  $dumpvars();
  txs_waitrequest <= 1'b0;
  flush <= 1'b0;
  rst <= 1'b0;
  dv <= 4'h0;
  d_cam0 <= 32'h0;
  d_cam1 <= 32'h800;
  d_corner0 <= 32'h0;
  d_corner1 <= 32'h0;
  #100;
  for (i = 0; i < 512; i += 1) begin
    @(posedge c_cam0);
    dv[1:0] <= 2'h3;
    d_cam0 <= d_cam0 + 1;
    d_cam1 <= d_cam1 + 1;
    if (i % 4 == 0) begin
      d_corner0 <= d_corner0 + 1;
      dv[2] <= 1'b1;
    end else begin
      dv[2] <= 1'b0;
    end
    if (i % 5 == 0) begin
      d_corner1 <= d_corner1 + 1;
      dv[3] <= 1'b1;
    end else begin
      dv[3] <= 1'b0;
    end
  end
  dv <= 4'h0;
  #1000;
  @(posedge c);
  flush <= 1'b1;
  #2000;
  wait(flush_complete);
  #100;
  flush <= 1'b0;
  rst <= 1'b1;
  #100;
  @(posedge c);
  rst <= 1'b0;
  #100;
  for (i = 0; i < 512; i += 1) begin
    @(posedge c_cam0);
    dv[1:0] <= 2'h3;
    d_cam0 <= d_cam0 + 1;
    d_cam1 <= d_cam1 + 1;
    if (i % 4 == 0) begin
      d_corner0 <= d_corner0 + 1;
      dv[2] <= 1'b1;
    end else begin
      dv[2] <= 1'b0;
    end
    if (i % 5 == 0) begin
      d_corner1 <= d_corner1 + 1;
      dv[3] <= 1'b1;
    end else begin
      dv[3] <= 1'b0;
    end
  end
  dv <= 4'h0;
  #1000;
  @(posedge c);
  flush <= 1'b1;
  #2000;
  wait(flush_complete);
  #100;
 
  $finish();
end

endmodule
`endif
