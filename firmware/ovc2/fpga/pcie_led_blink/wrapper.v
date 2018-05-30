module top_wrapper(
  input pcie_refclk,
  input pcie_perst,
  input [3:0] pcie_rx,
  output [3:0] pcie_tx,
  output led_ci,
  output led_di,
  output [1:0] aux,
  input clk100,

  output [1:0] cam_clk,
  input [1:0] cam_dclk,
  input [1:0] cam_sync,
  input [7:0] cam_dout,
  output [1:0] cam_rst,
  output [1:0] cam_cs,
  output [1:0] cam_sck,
  output [1:0] cam_mosi,
  input [1:0] cam_miso,
  output [1:0] cam_trigger,

  output imu_rst,
  output imu_cs,
  output imu_sck,
  output imu_mosi,
  input imu_miso,
  output imu_sync_in,
  input imu_sync_out
);


wire pcie_npor = pcie_perst;
wire [31:0] qsys_pio_output;
//wire [31:0] qsys_pio_input;

assign aux[0] = 1'b1;
assign aux[1] = qsys_pio_output[0];

wire pcie_clk_125;
//wire qsys_pio_clk_en = qsys_pio_output[0];

assign cam_trigger = 2'h0;
assign cam_rst = 2'h3;
assign cam_cs = 2'h3;
assign cam_sck = 2'h0;
assign cam_mosi = 2'h0;

assign imu_rst = 1'b1;
assign imu_cs = 1'b1;
assign imu_sck = 1'b0;
assign imu_mosi = 1'b0;
assign imu_sync_in = 1'b0;

assign led_ci = 1'b1;
assign led_di = 1'b1;
//wire cam_lvds_rx_rst = qsys_pio_output[15];


//wire txs_chipselect = 1'b1;  //qsys_pio_output[7];  //1'b1;
//wire [15:0] txs_byteenable = 16'hffff;
//wire txs_readdatavalid;

wire [127:0] txs_writedata = 128'h0123_4567_89ab_cdef;
wire txs_write = 1'b0;
wire [5:0] txs_burstcount = 6'h8;
wire txs_waitrequest;
wire [21:0] txs_address = 26'h0;
//wire [1:0] qsys_irq;

platform platform_inst(
 .clk_clk(pcie_refclk),
 .pcie_clock_bridge_out_clk_clk(pcie_clk_125),
 .pcie_hip_serial_rx_in0(pcie_rx[0]),
 .pcie_hip_serial_rx_in1(pcie_rx[1]),
 .pcie_hip_serial_rx_in2(pcie_rx[2]),
 .pcie_hip_serial_rx_in3(pcie_rx[3]),
 .pcie_hip_serial_tx_out0(pcie_tx[0]),
 .pcie_hip_serial_tx_out1(pcie_tx[1]),
 .pcie_hip_serial_tx_out2(pcie_tx[2]),
 .pcie_hip_serial_tx_out3(pcie_tx[3]),
 .pcie_hip_ctrl_test_in(32'ha8),
 .pcie_hip_ctrl_simu_mode_pipe(1'b0),
 //.irq_irq(qsys_irq),
 .pcie_npor_npor(pcie_npor),
 .pcie_npor_pin_perst(pcie_perst),

 .pio_output_external_connection_export(qsys_pio_output),
 //.ovc2_qsys_pio_input_external_connection_export(qsys_pio_input),

 .pcie_txs_byteenable(16'hffff),
 .pcie_txs_chipselect(1'b1),  // txs_chipselect),
 .pcie_txs_readdata(),
 .pcie_txs_writedata(txs_writedata),
 .pcie_txs_read(1'b0),
 .pcie_txs_write(txs_write),
 .pcie_txs_burstcount(txs_burstcount),
 .pcie_txs_readdatavalid(),
 .pcie_txs_waitrequest(txs_waitrequest),
 .pcie_txs_address(txs_address)
 
 /*
 .imu_ram_clk2_clk(imu_ram_clk),
 .imu_ram_reset2_reset(1'b0),
 .imu_ram_s2_address(imu_ram_addr),
 .imu_ram_s2_chipselect(imu_ram_cs),
 .imu_ram_s2_clken(imu_ram_clken),
 .imu_ram_s2_write(imu_ram_wr),
 .imu_ram_s2_readdata(imu_ram_q),
 .imu_ram_s2_writedata(imu_ram_d),
 .imu_ram_s2_byteenable(4'hf),

 .reg_ram_clk2_clk(reg_ram_clk),
 .reg_ram_reset2_reset(1'b0),
 .reg_ram_s2_address(reg_ram_addr),
 .reg_ram_s2_chipselect(reg_ram_cs),
 .reg_ram_s2_clken(reg_ram_clken),
 .reg_ram_s2_write(reg_ram_wr),
 .reg_ram_s2_readdata(reg_ram_q),
 .reg_ram_s2_writedata(reg_ram_d),
 .reg_ram_s2_byteenable(4'hf)
 */
 );

/*
wire [127:0] txs_writedata; // = 128'h0123_4567_89ab_cdef;
wire txs_write;
wire [5:0] txs_burstcount;  // = 6'h1;
wire txs_waitrequest;
wire [26:0] txs_address;  // = 27'h0;
*/

/*
wire [4:0] cam_0_rxd_align;
wire [39:0] cam_0_rxd;
wire cam_0_rx_locked;
wire cam_0_rxc;

wire [4:0] cam_1_rxd_align;
wire [39:0] cam_1_rxd;
wire cam_1_rx_locked;
wire cam_1_rxc;
*/

/*

top top_inst(
  .clk125(pcie_clk_125),
  .aux(aux),

  .cam_trigger(cam_trigger[0]),
  .pio_output(qsys_pio_output[31:8]),
  .pio_input(qsys_pio_input),
  .txs_waitrequest(txs_waitrequest),
  .txs_write(txs_write),
  .txs_writedata(txs_writedata),
  .txs_burstcount(txs_burstcount),
  .txs_address(txs_address),
  .irq(qsys_irq),

  .cam_0_rxc(cam_0_rxc),
  .cam_0_rxd(cam_0_rxd),
  .cam_0_rxd_align(cam_0_rxd_align),
  .cam_0_rx_locked(cam_0_rx_locked),

  .cam_1_rxc(cam_1_rxc),
  .cam_1_rxd({cam_1_rxd[39:32], ~cam_1_rxd[31:0]}),  // fix routing inversion
  .cam_1_rxd_align(cam_1_rxd_align),
  .cam_1_rx_locked(cam_1_rx_locked),

  .cam_cs(cam_cs),
  .cam_sck(cam_sck),
  .cam_mosi(cam_mosi),
  .cam_miso(cam_miso),

  .imu_ram_addr(imu_ram_addr),
  .imu_ram_wr(imu_ram_wr),
  .imu_ram_d(imu_ram_d),
  .imu_ram_q(imu_ram_q),
  .imu_cs(imu_cs),
  .imu_sck(imu_sck),
  .imu_mosi(imu_mosi),
  .imu_miso(imu_miso),
  .imu_sync(imu_sync_out),

  .reg_ram_addr(reg_ram_addr),
  .reg_ram_wr(reg_ram_wr),
  .reg_ram_d(reg_ram_d),
  .reg_ram_q(reg_ram_q)
);
*/

/*
wire [1:0] cam_locked;
wire [1:0] cam_rx_outclock;

cam_rx cam_0
(.rx_channel_data_align(4'b0),
 .rx_in(cam_dout[3:0]),
 .rx_inclock(cam_dclk[0]),
 .rx_locked(cam_locked[0]),
 .rx_out(cam_rx_out[31:0]),
 .rx_outclock(cam_rx_outclock[0]));

cam_rx cam_1
(.rx_channel_data_align(4'b0),
 .rx_in(cam_dout[7:4]),
 .rx_inclock(cam_dclk[1]),
 .rx_locked(cam_locked[1]),
 .rx_out(cam_rx_out[63:32]),
 .rx_outclock(cam_rx_outclock[1]));
 
*/

//wire [4:0] cam_0_rx_channel_data_align = 5'h0;
/*
cam_lvds_rx cam_0_lvds_rx
(.inclock(cam_dclk[0]),
 .pll_areset(cam_lvds_rx_rst),
 .pll_locked(),
 .rx_bitslip_ctrl(cam_0_rxd_align),
 .rx_bitslip_reset(5'b0),
 .rx_coreclock(cam_0_rxc),
 .rx_in({cam_sync[0], cam_dout[3:0]}),
 .rx_out(cam_0_rxd)
);

cam_lvds_rx cam_1_lvds_rx
(.inclock(cam_dclk[1]),
 .pll_areset(cam_lvds_rx_rst),
 .pll_locked(),
 .rx_bitslip_ctrl(cam_1_rxd_align),
 .rx_bitslip_reset(5'b0),
 .rx_coreclock(cam_1_rxc),
 .rx_in({cam_sync[1], cam_dout[7:4]}),
 .rx_out(cam_1_rxd)
);

assign qsys_pio_input =
{
  |cam_1_rxd,
  |cam_0_rxd,
  imu_miso,
  cam_miso
};

*/
/*
altlvds_rx #(
 .data_align_rollover(8),
 .deserialization_factor(8),
 .implement_in_les("OFF"),
 //.inclock_data_alignment("90_DEGREES"),  // request phase shift for sim
 //.inclock_period(3636),  // 275 MHz in picoseconds
 //.inclock_period(3472),  // 288 MHz in picoseconds
 .inclock_period(10000),  // 100 MHz in picoseconds
 //.inclock_phase_shift(909), //909),  // shift inbound data clock 90 degrees
 .inclock_phase_shift(0), //909),  // shift inbound data clock 90 degrees
 .data_rate("500.0 Mbps"),
 //.data_rate("200.0 Mbps"),
 .input_data_rate(500),  // Mbps
 //.input_data_rate(200),  // Mbps
 .intended_device_family("Cyclone V"),
 .refclk_frequency("250.0 MHz"),
 //.refclk_frequency("100.0 MHz"),
 .registered_output("ON"),
 //.input_data_rate(576),  // 576 Mbps
 //.input_data_rate(200),  // 200 Mbps
 .number_of_channels(5),
 .use_no_phase_shift("OFF")  // add 90 degree phase shift in PLL
) cam_0_altlvds_rx (
 .pll_areset(1'b0),
 .rx_cda_reset(5'b0),
 .rx_channel_data_align(cam_0_rxd_align),
 .rx_coreclk(5'h1f),  // ?
 .rx_data_reset(1'h0),
 .rx_deskew(1'b0),
 .rx_dpll_reset(5'h0),
 .rx_enable(1'b1),
 .rx_fifo_reset(5'h0),
 .rx_in({cam_sync[0], cam_dout[3:0]}),
 .rx_inclock(cam_dclk[0]),
 .rx_pll_enable(1'b1),
 .rx_readclock(1'b0),
 .rx_reset(5'h0),
 .rx_syncclock(1'b0),
 .rx_locked(cam_0_rx_locked),
 .rx_out(cam_0_rxd),
 .rx_outclock(cam_0_rxc)
);

altlvds_rx #(
 .data_align_rollover(8),
 .deserialization_factor(8),
 .implement_in_les("OFF"),
 .inclock_period(10000),  // 100 MHz in picoseconds
 .inclock_phase_shift(0), //909),  // shift inbound data clock 90 degrees
 .data_rate("500.0 Mbps"),
 .input_data_rate(500),  // Mbps
 .intended_device_family("Cyclone V"),
 .refclk_frequency("250.0 MHz"),
 .registered_output("ON"),
 .number_of_channels(5),
 .use_no_phase_shift("OFF")  // add 90 degree phase shift in PLL
) cam_1_altlvds_rx (
 .pll_areset(1'b0), .rx_cda_reset(5'b0),
 .rx_channel_data_align(cam_1_rxd_align),
 .rx_coreclk(5'h1f),  // ?
 .rx_data_reset(1'h0), .rx_deskew(1'b0), .rx_dpll_reset(5'h0),
 .rx_enable(1'b1), .rx_fifo_reset(5'h0),
 .rx_in({cam_sync[1], cam_dout[7:4]}),
 .rx_inclock(cam_dclk[1]),
 .rx_pll_enable(1'b1),
 .rx_readclock(1'b0),
 .rx_reset(5'h0),
 .rx_syncclock(1'b0),
 .rx_locked(cam_1_rx_locked),
 .rx_out(cam_1_rxd),
 .rx_outclock(cam_1_rxc)
);
*/


/*
wire cam_clk_pll;
altera_pll
#(.fractional_vco_multiplier("false"),
  .reference_clock_frequency("125.0 MHz"),
  .operation_mode("direct"),
  .number_of_clocks(1),
  .output_clock_frequency0("250MHz"), .phase_shift0("0 ps"), .duty_cycle0(50),
  //.output_clock_frequency0("288MHz"), .phase_shift0("0 ps"), .duty_cycle0(50),
  //.output_clock_frequency0("100MHz"), .phase_shift0("0 ps"), .duty_cycle0(50),
  .pll_type("General"), .pll_subtype("General")
) cam_pll (
  .refclk(pcie_clk_125), .rst(~qsys_pio_clk_en), .locked(),
  .outclk(cam_clk_pll), .fboutclk(), .fbclk(1'b0)
);
*/
/*
wire cam_clk_pll_out;
cam_clk_pll cam_clk_pll_inst
(.locked(),
 .rst(cam_lvds_rx_rst),
 .outclk_0(cam_clk_pll_out),
 .refclk(pcie_clk_125));

cam_clk_out cam_0_clk_out
(.ck(cam_clk_pll_out), .din(2'h1), .pad_out(cam_clk[0]));

cam_clk_out cam_1_clk_out
(.ck(cam_clk_pll_out), .din(2'h1), .pad_out(cam_clk[1]));
*/
/*

altddio_out #(.width(1)) cam_0_clk_ddio(
  .datain_h(1'b0),
  .datain_l(1'b1),
  .outclocken(1'b1),
  .outclock(cam_clk_pll),
  .aclr(1'b0),
  .aset(1'b0),
  .dataout(cam_clk[0])
);

altddio_out #(.width(1)) cam_1_clk_ddio(
  .datain_h(1'b0),
  .datain_l(1'b1),
  .outclocken(1'b1),
  .outclock(cam_clk_pll),
  .aclr(1'b0),
  .aset(1'b0),
  .dataout(cam_clk[1])
);

*/
/*

assign led[1] = cam_0_rx_locked & cam_1_rx_locked;
*/
//assign imu_rst = ~qsys_pio_output[2];
//assign cam_rst = {2{~qsys_pio_output[3]}};

endmodule