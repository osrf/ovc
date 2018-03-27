`timescale 1ns/1ns
module reg_ram_iface
(input c,
 output [7:0] reg_ram_addr,
 output reg_ram_wr,
 output [31:0] reg_ram_d,
 input [31:0] reg_ram_q,

 output [31:0] flags,
 output [31:0] dma_wr_addr_base,
 output [9:0] cam_rxd_align_req,
 output [3:0] cam_rxd_align_sel,
 output [15:0] trigger_exposure_usec,
 output [7:0] trigger_imu_decim,
 output [31:0] cam_spi_ctrl,
 output [31:0] cam_spi_txd,
 input [31:0] cam_spi_rxd,
 output [7:0] corner_threshold
);

localparam CW = 10, SW = 4;
localparam ST_READ_FLAGS        = 4'd0;
localparam ST_CHECK_FLAGS       = 4'd1;
localparam ST_DMA_WR_ADDR_BASE  = 4'd2;
localparam ST_CAM_RXD_ALIGN_REQ = 4'd3;
localparam ST_CAM_RXD_ALIGN_SEL = 4'd4;
localparam ST_TRIGGER_USEC      = 4'd5;
localparam ST_TRIGGER_IMU_DECIM = 4'd6;
localparam ST_CAM_SPI_CTRL      = 4'd7;
localparam ST_CAM_SPI_TXD       = 4'd8;
localparam ST_CAM_SPI_RXD       = 4'd9;
localparam ST_CORNER_THRESHOLD  = 4'd10;
localparam ST_END               = 4'd11;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[CW+SW-1:CW];
r #(SW) state_r
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));

always @* begin
  case (state)
    ST_READ_FLAGS:              ctrl = { ST_CHECK_FLAGS      , 10'b0000000000 };
    ST_CHECK_FLAGS:
      if (reg_ram_q[0] == 1'b1) ctrl = { ST_DMA_WR_ADDR_BASE , 10'b0000000001 };
      else                      ctrl = { ST_READ_FLAGS       , 10'b0000000000 };
    ST_DMA_WR_ADDR_BASE:        ctrl = { ST_CAM_RXD_ALIGN_REQ, 10'b0000000000 };
    ST_CAM_RXD_ALIGN_REQ:       ctrl = { ST_CAM_RXD_ALIGN_SEL, 10'b0000000010 };
    ST_CAM_RXD_ALIGN_SEL:       ctrl = { ST_TRIGGER_USEC     , 10'b0000000100 };
    ST_TRIGGER_USEC:            ctrl = { ST_TRIGGER_IMU_DECIM, 10'b0000001000 };
    ST_TRIGGER_IMU_DECIM:       ctrl = { ST_CAM_SPI_CTRL     , 10'b0000010000 };
    ST_CAM_SPI_CTRL:            ctrl = { ST_CAM_SPI_TXD      , 10'b0000100000 };
    ST_CAM_SPI_TXD:             ctrl = { ST_CAM_SPI_RXD      , 10'b0001000000 };
    ST_CAM_SPI_RXD:             ctrl = { ST_CORNER_THRESHOLD , 10'b0110000000 };
    ST_CORNER_THRESHOLD:        ctrl = { ST_END              , 10'b0000000000 };
    ST_END:                     ctrl = { ST_READ_FLAGS       , 10'b1000000000 };
    default:                    ctrl = { ST_READ_FLAGS       , 10'b0000000000 };
  endcase
end

assign reg_ram_addr = { 4'h0, state };
assign reg_ram_wr = ctrl[8];
assign reg_ram_d = cam_spi_rxd;

wire flags_en                 = ctrl[0];
wire dma_wr_addr_base_en      = ctrl[1];
wire cam_rxd_align_req_en     = ctrl[2];
wire cam_rxd_align_sel_en     = ctrl[3];
wire trigger_exposure_usec_en = ctrl[4];
wire trigger_imu_decim_en     = ctrl[5];
wire cam_spi_ctrl_en          = ctrl[6];
wire cam_spi_txd_en           = ctrl[7];
//wire cam_spi_rxd_en           = ctrl[8];
wire corner_threshold_en      = ctrl[9];

r #(32) flags_r(.c(c), .rst(1'b0), .en(flags_en), .d(reg_ram_q), .q(flags));

r #(32) dma_wr_addr_base_r
(.c(c), .rst(1'b0), .en(dma_wr_addr_base_en),
 .d(reg_ram_q), .q(dma_wr_addr_base));

r #(10) cam_rxd_align_req_r
(.c(c), .rst(1'b0), .en(cam_rxd_align_req_en),
 .d(reg_ram_q[9:0]), .q(cam_rxd_align_req));

r #(4) cam_rxd_align_sel_r
(.c(c), .rst(1'b0), .en(cam_rxd_align_sel_en),
 .d(reg_ram_q[3:0]), .q(cam_rxd_align_sel));

localparam [15:0] EXPOSURE_INIT = 16'd5000;
r #(16, EXPOSURE_INIT) trigger_exposure_usec_r
(.c(c), .rst(1'b0), .en(trigger_exposure_usec_en),
 .d(reg_ram_q[15:0]), .q(trigger_exposure_usec));

// for initializing with something sane, assume IMU rate is 200 Hz
localparam [7:0] IMU_DECIM_INIT = 8'h07;  // decimation rate of 7 = 28.57 fps
r #(8, IMU_DECIM_INIT) trigger_imu_decim_r
(.c(c), .rst(1'b0), .en(trigger_imu_decim_en),
 .d(reg_ram_q[7:0]), .q(trigger_imu_decim));

r #(32) cam_spi_ctrl_r
(.c(c), .rst(1'b0), .en(cam_spi_ctrl_en),
 .d(reg_ram_q), .q(cam_spi_ctrl));

r #(32) cam_spi_txd_r
(.c(c), .rst(1'b0), .en(cam_spi_txd_en),
 .d(reg_ram_q), .q(cam_spi_txd));

r #(8, 8'd20) corner_threshold_r
(.c(c), .rst(1'b0), .en(corner_threshold_en),
 .d(reg_ram_q[7:0]), .q(corner_threshold));

endmodule
