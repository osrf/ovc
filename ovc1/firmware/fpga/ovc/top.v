`timescale 1ns/1ps
module top
#(parameter SPEEDUP=1)
(
  input clk125,
  output cam_trigger,
  input [23:0] pio_output,
  output [31:0] pio_input,
  input txs_waitrequest,
  output txs_write,
  output [127:0] txs_writedata,
  output [5:0] txs_burstcount,
  output [22:0] txs_address,
  output [1:0] irq,

  input cam_0_rxc,
  input [39:0] cam_0_rxd,
  input cam_0_rx_locked,
  output [4:0] cam_0_rxd_align,

  input cam_1_rxc,
  input [39:0] cam_1_rxd,
  input cam_1_rx_locked,
  output [4:0] cam_1_rxd_align,

  output [1:0] cam_cs,
  output [1:0] cam_sck,
  output [1:0] cam_mosi,
  input [1:0] cam_miso,

  input imu_sync,
  output led_flash,
  output [7:0] imu_ram_addr,
  output imu_ram_wr,
  output [31:0] imu_ram_d,
  input [31:0] imu_ram_q,
  output imu_cs,
  output imu_sck,
  output imu_mosi,
  input imu_miso,

  output [7:0] reg_ram_addr,
  output reg_ram_wr,
  output [31:0] reg_ram_d,
  input [31:0] reg_ram_q,

  output [7:0] aux
);

wire c = clk125;

////////////////////////////////////////////////////////////////////////
wire [63:0] timestamp_q;
timestamp timestamp_inst(.clk125(c), .rst(pio_output[1]), .q(timestamp_q));
wire t_image_en;
wire [63:0] t_image;
r #(64) t_image_r
(.c(c), .rst(1'b0), .en(t_image_en), .d(timestamp_q), .q(t_image));
////////////////////////////////////////////////////////////////////////

wire [31:0] reg_flags;
wire [31:0] reg_dma_wr_addr_base;
wire [9:0] reg_cam_rxd_align_req;
wire [3:0] reg_cam_rxd_align_sel;
wire [15:0] reg_trigger_exposure_usec;
wire [15:0] reg_flash_usec;
wire [7:0] reg_trigger_imu_decim;
wire [31:0] cam_spi_rxd, cam_spi_txd, cam_spi_ctrl;
wire [7:0] ast_threshold;  //corners_t;

reg_ram_iface reg_ram_iface_inst
(.c(c),
 .reg_ram_addr(reg_ram_addr), .reg_ram_wr(reg_ram_wr),
 .reg_ram_d(reg_ram_d), .reg_ram_q(reg_ram_q),
 .flags(reg_flags),
 .dma_wr_addr_base(reg_dma_wr_addr_base),
 .cam_rxd_align_req(reg_cam_rxd_align_req),
 .cam_rxd_align_sel(reg_cam_rxd_align_sel),
 .trigger_exposure_usec(reg_trigger_exposure_usec),
 .flash_usec(reg_flash_usec),
 .trigger_imu_decim(reg_trigger_imu_decim),
 //////////////////////////////////////////////////
 .cam_spi_ctrl(cam_spi_ctrl),
 .cam_spi_txd(cam_spi_txd),
 .cam_spi_rxd(cam_spi_rxd),
 //////////////////////////////////////////////////
 .corner_threshold(ast_threshold)
);

//wire [15:0] pio_dma_reg_addr = pio_dma_cmd[23:8];
//wire pio_dma_reg_wr = pio_dma_cmd[7];

wire [1:0] irq_set;
r irq_0_r(.c(c), .rst(pio_output[5]), .en(irq_set[0]), .d(1'b1), .q(irq[0]));
r irq_1_r(.c(c), .rst(pio_output[6]), .en(irq_set[1]), .d(1'b1), .q(irq[1]));

// synchronizer chain for imu_miso pin
wire imu_miso_s;
s imu_miso_s_r(.c(c), .d(imu_miso), .q(imu_miso_s));

// synchronizer chain for imu_sync pin
wire imu_sync_s;
s imu_sync_s_r(.c(c), .d(imu_sync), .q(imu_sync_s));

imu_reader #(.SPEEDUP(SPEEDUP)) imu_reader_inst
(.c(c), .irq(irq_set[1]), .sync(imu_sync_s), .t(timestamp_q),
 .ram_addr(imu_ram_addr),
 .ram_wr(imu_ram_wr), .ram_d(imu_ram_d), .ram_q(imu_ram_q),
 .cs(imu_cs), .sck(imu_sck), .mosi(imu_mosi), .miso(imu_miso_s));

//////////////////////////////////////////////////////////
// imager SPI stuff
// synchronizer chains for cam_miso pins
wire [1:0] cam_miso_s;
s #(2) cam_miso_s_r(.c(c), .d(cam_miso), .q(cam_miso_s));

wire [31:0] cam_0_spi_rxd;
spi_master #(.SCLK_DIV(100), .W(26),
             .CPOL(0), .CPHA(0),
             .SAMPLE_OPPOSITE_EDGE(1)) cam_0_spi_master
(.c(c), .start(cam_spi_ctrl[30]), .done(cam_0_spi_rxd[31]), .hold_cs(1'b0),
 .txd(cam_spi_txd[25:0]), .rxd(cam_0_spi_rxd[25:0]),
 .cs(cam_cs[0]), .sclk(cam_sck[0]), .mosi(cam_mosi[0]), .miso(cam_miso_s[0]));
assign cam_0_spi_rxd[30:26] = 5'h0;

wire [31:0] cam_1_spi_rxd;
spi_master #(.SCLK_DIV(100), .W(26),
             .CPOL(0), .CPHA(0),
             .SAMPLE_OPPOSITE_EDGE(1)) cam_1_spi_master
(.c(c), .start(cam_spi_ctrl[31]), .done(cam_1_spi_rxd[31]), .hold_cs(1'b0),
 .txd(cam_spi_txd[25:0]), .rxd(cam_1_spi_rxd[25:0]),
 .cs(cam_cs[1]), .sclk(cam_sck[1]), .mosi(cam_mosi[1]), .miso(cam_miso_s[1]));
assign cam_1_spi_rxd[30:26] = 5'h0;

d1 #(32) cam_spi_rxd_mux_r
(.c(c), .d(cam_spi_ctrl[29] ? cam_1_spi_rxd : cam_0_spi_rxd), .q(cam_spi_rxd));

wire start = pio_output[0];

// synchronize the cam0 align register over to the cam_0_rxc domain
wire [4:0] cam_0_rxd_align_pcie_s;
s #(5) cam_0_rxd_align_pcie_s_r
(.c(cam_0_rxc), .d(reg_cam_rxd_align_req[4:0]), .q(cam_0_rxd_align_pcie_s));

// convert these BAR-accessed registers to single pulses for the altlvdsrx
oneshot cam_0_rxd_align_oneshots [4:0]
(.c(cam_0_rxc), .d(cam_0_rxd_align_pcie_s[4:0]), .q(cam_0_rxd_align));

//////////////////////////////////////////////////////////////////////////
// same thing in cam_1 domain
// synchronize the cam0 align register over to the cam_0_rxc domain
wire [4:0] cam_1_rxd_align_pcie_s;
s #(5) cam_1_rxd_align_pcie_s_r
(.c(cam_1_rxc), .d(reg_cam_rxd_align_req[9:5]), .q(cam_1_rxd_align_pcie_s));

// convert these BAR-accessed registers to single pulses for the altlvdsrx
oneshot cam_1_rxd_align_oneshots [4:0]
(.c(cam_1_rxc), .d(cam_1_rxd_align_pcie_s[4:0]), .q(cam_1_rxd_align));

//////////////////////////////////////////////////////////
// imager trigger stuff

wire imu_sync_oneshot;
oneshot #(.SYNC(0)) imu_sync_oneshot_r
(.c(c), .d(imu_sync_s), .q(imu_sync_oneshot));

trigger trigger_inst
(.c(c), .imu_sync(imu_sync_oneshot), .imu_decim(reg_trigger_imu_decim),
 .exposure_usec(reg_trigger_exposure_usec),
 .flash_usec(reg_flash_usec),
 .trigger(cam_trigger), .flash(led_flash));

wire trigger_oneshot;
oneshot #(.SYNC(0)) trigger_oneshot_r
(.c(c), .d(cam_trigger), .q(trigger_oneshot));
assign t_image_en = trigger_oneshot;

//////////////////////////////////////////////////////////

`ifdef SIM
localparam UNSWAP_KERNELS = 0;
`else
localparam UNSWAP_KERNELS = 1;
`endif

wire cam_0_fv, cam_0_lv;
wire [31:0] cam_0_d;
python_decoder #(.UNSWAP_KERNELS(UNSWAP_KERNELS)) decoder_0
(.c(cam_0_rxc), .sync(cam_0_rxd[39:32]), .data(cam_0_rxd[31:0]),
 .fv(cam_0_fv), .lv(cam_0_lv), .q(cam_0_d));

wire cam_1_fv, cam_1_lv;
wire [31:0] cam_1_d;
python_decoder #(.UNSWAP_KERNELS(UNSWAP_KERNELS)) decoder_1
(.c(cam_1_rxc), .sync(cam_1_rxd[39:32]), .data(cam_1_rxd[31:0]),
 .fv(cam_1_fv), .lv(cam_1_lv), .q(cam_1_d));

wire cam_0_fv_clk125;
s cam_0_fv_clk125_r(.c(c), .d(cam_0_fv), .q(cam_0_fv_clk125));

/*
wire cam_1_fv_clk125;
s cam_1_fv_clk125_r(.c(c), .d(cam_1_fv), .q(cam_1_fv_clk125));
*/

wire cam_cap_en;
wire cam_0_cap_en_rxc, cam_1_cap_en_rxc;
s cam_0_cap_en_rxc_s(.c(cam_0_rxc), .d(cam_cap_en), .q(cam_0_cap_en_rxc));
s cam_1_cap_en_rxc_s(.c(cam_1_rxc), .d(cam_cap_en), .q(cam_1_cap_en_rxc));

/////////////////////////////////////////////////////////////////////
wire cap_rst;

wire [7:0] state_cnt;
wire state_cnt_rst, state_cnt_en;
r #(8) state_cnt_r
(.c(c), .rst(state_cnt_rst), .en(state_cnt_en),
 .d(state_cnt+1'b1), .q(state_cnt));

wire dma_flush_complete;
wire metadata_flush, metadata_flush_complete;

// FIFO read-side state machine
localparam CW = 8, SW = 4;
localparam ST_IDLE         = 4'd0;
localparam ST_EOF          = 4'd1;  // wait for current frame (if any) to end
localparam ST_SOF          = 4'd2;  // wait for a frame to start
localparam ST_IMAGE        = 4'd3;  // send the image
localparam ST_IMAGE_WAIT   = 4'd4;  // wait for corner detector pipelines
localparam ST_META         = 4'd5;  // send metadata (CRC, sum, etc.)
localparam ST_META_WAIT    = 4'd6;  // wait for metadata to flow through FIFOs
localparam ST_DMA_FLUSH    = 4'd7;  // wait for DMA flush to end
localparam ST_RST          = 4'd8;  // reset all image-handling machinery

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[CW+SW-1:CW];
r #(SW) state_r
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));

always @* begin
  case (state)
    ST_IDLE:
      if (start)                      ctrl = { ST_EOF        , 8'b0000_0000 };
      else                            ctrl = { ST_IDLE       , 8'b0000_0000 };
    ST_EOF:
      if (~cam_0_fv_clk125)           ctrl = { ST_SOF        , 8'b0000_0001 };
      else                            ctrl = { ST_EOF        , 8'b0000_0000 };
    ST_SOF:
      if (cam_0_fv_clk125)            ctrl = { ST_IMAGE      , 8'b0000_0001 };
      else                            ctrl = { ST_SOF        , 8'b0000_0001 };
    ST_IMAGE:
      if (~cam_0_fv_clk125)           ctrl = { ST_IMAGE_WAIT , 8'b0000_0011 };
      else                            ctrl = { ST_IMAGE      , 8'b0000_0001 };
    ST_IMAGE_WAIT:
      if (state_cnt == 8'hff)         ctrl = { ST_META       , 8'b0000_1010 };
      else                            ctrl = { ST_IMAGE_WAIT , 8'b0000_0100 };
    ST_META:
      if (metadata_flush_complete)    ctrl = { ST_META_WAIT  , 8'b0000_0010 };
      else                            ctrl = { ST_META       , 8'b0000_0100 };
    ST_META_WAIT:
      if (state_cnt == 8'h1f)         ctrl = { ST_DMA_FLUSH  , 8'b0010_0010 };
      else                            ctrl = { ST_META_WAIT  , 8'b0000_0100 };
    ST_DMA_FLUSH:
      if (dma_flush_complete)         ctrl = { ST_RST        , 8'b0010_0010 };
      else                            ctrl = { ST_DMA_FLUSH  , 8'b0010_0000 };
    ST_RST:
      if (state_cnt == 8'h0f)         ctrl = { ST_IDLE       , 8'b1100_0010 };
      else                            ctrl = { ST_RST        , 8'b0101_0100 };
    default:                          ctrl = { ST_IDLE       , 8'b0000_0000 };
  endcase
end

assign cam_cap_en = ctrl[0];
assign state_cnt_rst = ctrl[1];
assign state_cnt_en = ctrl[2];
assign metadata_flush = ctrl[3];
wire dma_flush = ctrl[5];
assign irq_set[0] = ctrl[7];
assign cap_rst = ctrl[6];  // reset lots of things at end of capture

localparam AW=23;  // address width
localparam [AW-1:0] IMAGE_LEN     = 1280*1024;
localparam [AW-1:0] IMAGE_0_BASE  = 23'h0;
localparam [AW-1:0] IMAGE_1_BASE  = IMAGE_0_BASE + IMAGE_LEN;
localparam [AW-1:0] METADATA_BASE = IMAGE_1_BASE + IMAGE_LEN;
localparam [AW-1:0] CORNER_0_BASE = METADATA_BASE + 1024;
localparam [AW-1:0] CORNER_1_BASE = CORNER_0_BASE + 64*1024;

wire [31:0] metadata_q;
wire metadata_qv;
wire [31:0] ast_qv_cnt;

metadata metadata_inst
(.img_c({cam_1_rxc, cam_0_rxc}),
 .img_d({cam_1_d, cam_0_d}), .img_dv({cam_1_lv, cam_0_lv}),
 .stats_roi(32'hff00ff00),  // roi = full image
 .c(c), .rst(cap_rst), .en(start), .t(t_image),
 .corner_cnt(ast_qv_cnt),
 .flush(metadata_flush), .flush_complete(metadata_flush_complete),
 .q(metadata_q), .qv(metadata_qv));

/*
wire [7:0] cam_0_t_s, cam_1_t_s;
s #(8) cam_0_t_r(.c(cam_0_rxc), .d(ast_threshold), .q(cam_0_t_s));
s #(8) cam_1_t_r(.c(cam_1_rxc), .d(ast_threshold), .q(cam_1_t_s));
*/

wire [63:0] ast_q;
wire [1:0] ast_qv;
ast_detector #(.CAM_ADDR(1'b0)) cd0
(.c(cam_0_rxc), .t(ast_threshold), .en(cam_0_cap_en_rxc),
 .d(cam_0_d), .lv(cam_0_lv), .fv(cam_0_fv),
 .q(ast_q[31:0]), .qv(ast_qv[0]), .qv_cnt(ast_qv_cnt[15:0]));

ast_detector #(.CAM_ADDR(1'b1)) cd1
(.c(cam_1_rxc), .t(ast_threshold), .en(cam_1_cap_en_rxc),
 .d(cam_1_d), .lv(cam_1_lv), .fv(cam_1_fv),
 .q(ast_q[63:32]), .qv(ast_qv[1]), .qv_cnt(ast_qv_cnt[31:16]));

dma_writer_mux #(.N(5),
                 .BASE_ADDRS({
                   METADATA_BASE,
                   CORNER_1_BASE,
                   CORNER_0_BASE,
                   IMAGE_1_BASE,
                   IMAGE_0_BASE})) dma_writer_mux_inst
(.in_c({c, cam_1_rxc, cam_0_rxc, cam_1_rxc, cam_0_rxc}),
 .in_d({metadata_q, ast_q, cam_1_d, cam_0_d}),
 .in_dv({metadata_qv, ast_qv, cam_1_lv, cam_0_lv}),
 .c(c), .rst(cap_rst), .flush(dma_flush), .flush_complete(dma_flush_complete),
 .txs_write(txs_write), .txs_writedata(txs_writedata),
 .txs_burstcount(txs_burstcount), .txs_address(txs_address),
 .txs_waitrequest(txs_waitrequest));

///////////////////////////////////////////////////////////////////////
// synchronize the inbound camera sync words to the PCIe clock domain
wire pio_cam_sel = reg_cam_rxd_align_sel[2];
wire [7:0] sync_s;
s #(8) sync_s_r
(.c(c), .q(sync_s),
 .d(reg_cam_rxd_align_sel[2] ? cam_1_rxd[39:32] : cam_0_rxd[39:32]));
// synchronize the inbound camera data channels to the PCIe clock domain
wire [31:0] cam_0_rxd_s, cam_1_rxd_s;
s #(32) cam_0_rxd_s_r(.c(c), .d(cam_0_rxd[31:0]), .q(cam_0_rxd_s));
s #(32) cam_1_rxd_s_r(.c(c), .d(cam_1_rxd[31:0]), .q(cam_1_rxd_s));

//select one of the inbound camera data channels and make it visible to PCIe
wire [7:0] lane_s;
gmux #(.DWIDTH(8), .SELWIDTH(3)) lane_gmux
(.d({cam_1_rxd_s, cam_0_rxd_s}), .sel(reg_cam_rxd_align_sel[2:0]), .z(lane_s));

/////////////////////////////////
wire [31:0] pio_input_d1;  //dma_status_d1;

d1 #(32) pio_input_r
(.c(c), .q(pio_input_d1),
 .d({sync_s,  // 8
     lane_s,  // 8
     16'h0}));  //,  // 8

// add an extra stage to help timing
d1 #(32) pio_input_d2_r
(.c(c), .d(pio_input_d1), .q(pio_input));

wire [7:0] aux_d1;
d1 #(8) aux_d1_r
(.c(c),
 .d({4'h0,  // txs_waitrequest, txs_write, cam_trigger,
     2'b0, 1'b0, cam_trigger}),
 //.d(8'h0),
 .q(aux_d1));
assign aux = aux_d1;

endmodule
