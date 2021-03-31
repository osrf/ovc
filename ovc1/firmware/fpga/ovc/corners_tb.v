`timescale 1ns/1ps
module corners_tb();

wire clk125;
sim_clk #(125) clk_inst(.c(clk125));

reg [23:0] pio_output;
wire [31:0] pio_input;

wire cam_trigger;

reg txs_waitrequest;
wire txs_write;

wire [22:0] txs_address;
wire [5:0] txs_burstcount;
wire [127:0] txs_writedata;
wire [1:0] irq;

wire cam_0_rxc;
sim_clk #(63) cam_0_clk_inst(.c(cam_0_rxc));

// todo: offset from cam_0_rxc a bit to simulate better
wire cam_1_rxc;
sim_clk #(63) cam_1_clk_inst(.c(cam_1_rxc));

localparam IMAGE_FN="../sim/image0006_middle.bin";
//localparam IMAGE_FN="../sim/fullwidth_squares_gradient_background.bin";
localparam IMAGE_ROWS=64;
localparam IMAGE_COLS=1280;

wire [1:0] cam_cs, cam_sck, cam_mosi, cam_miso;
wire [39:0] cam_0_rxd;
sim_python
#(.INTERFRAME_WORDS(142), .USE_TRIGGER(1),
  .COLS(IMAGE_COLS), .ROWS(IMAGE_ROWS), .IMAGE_FILE(IMAGE_FN)) sim_python_0
(.c(cam_0_rxc), .trigger(cam_trigger),
 .data(cam_0_rxd[31:0]),
 .sync(cam_0_rxd[39:32]),
 .cs(cam_cs[0]),
 .sck(cam_sck[0]),
 .mosi(cam_mosi[0]),
 .miso(cam_miso[0]));

wire [39:0] cam_1_rxd;
sim_python
#(.INTERFRAME_WORDS(142), .USE_TRIGGER(1),
  .COLS(IMAGE_COLS), .ROWS(IMAGE_ROWS), .IMAGE_FILE(IMAGE_FN)) sim_python_1
(.c(cam_1_rxc), .trigger(cam_trigger),
 .data(cam_1_rxd[31:0]),
 .sync(cam_1_rxd[39:32]),
 .cs(cam_cs[1]),
 .sck(cam_sck[1]),
 .mosi(cam_mosi[1]),
 .miso(cam_miso[1]));

// todo: something smarter
wire cam_0_rx_locked = 1'b1;
wire cam_1_rx_locked = 1'b1;
wire [4:0] cam_0_rxd_align, cam_1_rxd_align;

wire imu_sync_out, imu_cs, imu_sck, imu_mosi, imu_miso;
sim_imu #(.SPEEDUP(400)) sim_imu_inst
(.sync_out(imu_sync_out),
 .cs(imu_cs),
 .sck(imu_sck),
 .mosi(imu_mosi),
 .miso(imu_miso));

//////////////////////////////////////////////////////
wire [7:0] imu_ram_addr;
wire imu_ram_wr;
wire [31:0] imu_ram_d, imu_ram_q;

sim_imu_ram sim_imu_ram_inst
(.c(clk125), .addr(imu_ram_addr), .wr(imu_ram_wr),
 .d(imu_ram_d), .q(imu_ram_q));

//////////////////////////////////////////////////////
wire [7:0] reg_ram_addr;
wire reg_ram_wr;
wire [31:0] reg_ram_d, reg_ram_q;

sim_reg_ram sim_reg_ram_inst
(.c(clk125), .addr(reg_ram_addr), .wr(reg_ram_wr),
 .d(reg_ram_d), .q(reg_ram_q));

//////////////////////////////////////////////////////
top #(.SPEEDUP(4)) top_inst
(.clk125(clk125),
 .cam_trigger(cam_trigger),
 .pio_output(pio_output),
 .pio_input(pio_input),

 .txs_waitrequest(txs_waitrequest),
 .txs_write(txs_write),
 .txs_writedata(txs_writedata),
 .txs_burstcount(txs_burstcount),
 .txs_address(txs_address),
 .irq(irq),

 .cam_0_rxc(cam_0_rxc),
 .cam_0_rxd(cam_0_rxd),
 .cam_0_rx_locked(cam_0_rx_locked),
 .cam_0_rxd_align(cam_0_rxd_align),

 .cam_1_rxc(cam_1_rxc),
 .cam_1_rxd(cam_1_rxd),
 .cam_1_rx_locked(cam_1_rx_locked),
 .cam_1_rxd_align(cam_1_rxd_align),

 .cam_cs(cam_cs),
 .cam_sck(cam_sck),
 .cam_mosi(cam_mosi),
 .cam_miso(cam_miso),

 .imu_ram_addr(imu_ram_addr),
 .imu_ram_wr(imu_ram_wr),
 .imu_ram_d(imu_ram_d),
 .imu_ram_q(imu_ram_q),
 .imu_sync(imu_sync_out),
 .imu_cs(imu_cs),
 .imu_sck(imu_sck),
 .imu_mosi(imu_mosi),
 .imu_miso(imu_miso),

 .reg_ram_addr(reg_ram_addr),
 .reg_ram_wr(reg_ram_wr),
 .reg_ram_d(reg_ram_d),
 .reg_ram_q(reg_ram_q)
);

initial begin
  $dumpfile("corners.lxt");
  $dumpvars();
  pio_output = 24'h0;
  txs_waitrequest = 1'b1;
  #200;
  sim_imu_ram_inst.mem[0] = 32'h0100_0000;  // enable imu auto-poll after sync
  #10000;
  @(posedge clk125);
  sim_reg_ram_inst.mem[2] = 32'h1;  // bitslip cam 0 lane 0
  #10000;
  @(posedge clk125);
  sim_reg_ram_inst.mem[2] = 32'h0;  // reset bitslip request
  // start sending images
  pio_output = 24'h00_0001;
  sim_reg_ram_inst.mem[10] = 32'd30;  // corner threshold

  // todo: randomly hold txs_waitrequest high sometimes.
  // probably should put this in its own process/task
  #200 txs_waitrequest = 1'b0;
  #50  txs_waitrequest = 1'b1;
  #50  txs_waitrequest = 1'b0;
/*

  #550_000;
  // request a host-driven IMU SPI transaction
  sim_imu_ram_inst.mem[1] = 32'h0105_0000;  // set txd
  sim_imu_ram_inst.mem[0] = 32'h0000_0007;  // host_req, start, hold_cs
  // wait until "done" flag is set in memory
  wait(sim_imu_ram_inst.mem[3][1]);
  #1000;
  sim_imu_ram_inst.mem[0] = 32'h0000_0004;  // host_req.  release CS.
  #10000;

  // now do a longer IMU SPI transaction to read back
  sim_imu_ram_inst.mem[1] = 32'h0000_0000;  // set txd to clock out response
  sim_imu_ram_inst.mem[0] = 32'h0000_0007;  // host_req, start, hold_cs
  #1000;
  // wait until spi_done flag is set in memory
  wait(sim_imu_ram_inst.mem[3][1]);
  #1000;

  sim_imu_ram_inst.mem[0] = 32'h0000_0006;  // de-assert start
  #1000;
  sim_imu_ram_inst.mem[1] = 32'h0000_0005;  // set txd to clock out response
  sim_imu_ram_inst.mem[0] = 32'h0000_0007;  // re-assert start
  #1000;
  wait(sim_imu_ram_inst.mem[3][1]);  // wait for spi_done
  #1000;

  sim_imu_ram_inst.mem[0] = 32'h0000_0006;  // de-assert start
  #1000;
  sim_imu_ram_inst.mem[1] = 32'h0000_0042;  // set txd
  sim_imu_ram_inst.mem[0] = 32'h0000_0007;  // re-assert start
  #1000;
  wait(sim_imu_ram_inst.mem[3][1]);  // wait for spi_done
  #1000;

  sim_imu_ram_inst.mem[0] = 32'h0000_0000;  // de-assert start. ETX
  #1000;


  #100_000;
*/
  #20_000;

  // try to send some camera SPI traffic
  // first, to cam 0
  sim_reg_ram_inst.mem[8] = 32'h0012_3456;
  #2200;
  sim_reg_ram_inst.mem[7] = 32'h4000_0000;
  //wait(~sim_reg_ram_inst.mem[9][31]);
  //wait(sim_reg_ram_inst.mem[9][31]);
  #1000;
  sim_reg_ram_inst.mem[7] = 32'h0000_0000;
  #200_000;
  //sim_reg_ram_inst.mem[10] = 32'h0000_0042;  // test increase corner threshold
  sim_reg_ram_inst.mem[5] = 32'd10;  // 10 usec exposure (minimum time)
  #800_000;
  

  $finish();
end

endmodule
