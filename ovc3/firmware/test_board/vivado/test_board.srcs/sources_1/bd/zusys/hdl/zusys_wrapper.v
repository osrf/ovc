//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Wed Nov  6 14:11:02 2019
//Host        : luca running 64-bit Ubuntu 18.04.3 LTS
//Command     : generate_target zusys_wrapper.bd
//Design      : zusys_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zusys_wrapper
   (AUX,
    BONUS1_EXTCLK,
    BONUS1_FLASH,
    BONUS1_I2C0_scl_io,
    BONUS1_I2C0_sda_io,
    BONUS1_I2C1_scl_io,
    BONUS1_I2C1_sda_io,
    BONUS1_MIPI0_clk_n,
    BONUS1_MIPI0_clk_p,
    BONUS1_MIPI0_data_n,
    BONUS1_MIPI0_data_p,
    BONUS1_MIPI1_clk_n,
    BONUS1_MIPI1_clk_p,
    BONUS1_MIPI1_data_n,
    BONUS1_MIPI1_data_p,
    BONUS1_RESET,
    BONUS1_TRIGGER,
    BONUS2_EXTCLK,
    BONUS2_FLASH,
    BONUS2_I2C0_scl_io,
    BONUS2_I2C0_sda_io,
    BONUS2_I2C1_scl_io,
    BONUS2_I2C1_sda_io,
    BONUS2_MIPI0_clk_n,
    BONUS2_MIPI0_clk_p,
    BONUS2_MIPI0_data_n,
    BONUS2_MIPI0_data_p,
    BONUS2_MIPI1_clk_n,
    BONUS2_MIPI1_clk_p,
    BONUS2_MIPI1_data_n,
    BONUS2_MIPI1_data_p,
    BONUS2_RESET,
    BONUS2_TRIGGER,
    BONUS3_EXTCLK,
    BONUS3_FLASH,
    BONUS3_RESET,
    BONUS3_TRIGGER,
    BONUS4_EXTCLK,
    BONUS4_FLASH,
    BONUS4_RESET,
    BONUS4_TRIGGER,
    CAM0_EXTCLK,
    CAM0_I2C_scl_io,
    CAM0_I2C_sda_io,
    CAM0_MIPI_clk_n,
    CAM0_MIPI_clk_p,
    CAM0_MIPI_data_n,
    CAM0_MIPI_data_p,
    CAM0_NRESET,
    CAM0_TRIG,
    CAM1_EXTCLK,
    CAM1_I2C_scl_io,
    CAM1_I2C_sda_io,
    CAM1_MIPI_clk_n,
    CAM1_MIPI_clk_p,
    CAM1_MIPI_data_n,
    CAM1_MIPI_data_p,
    CAM1_NRESET,
    CAM1_TRIG,
    CAM2_EXTCLK,
    CAM2_I2C_scl_io,
    CAM2_I2C_sda_io,
    CAM2_MIPI_clk_n,
    CAM2_MIPI_clk_p,
    CAM2_MIPI_data_n,
    CAM2_MIPI_data_p,
    CAM2_NRESET,
    CAM2_TRIG,
    DIP_SWITCH,
    GPIO0,
    GPIO1,
    GPIO10,
    GPIO11,
    GPIO12,
    GPIO13,
    GPIO14,
    GPIO15,
    GPIO16,
    GPIO17,
    GPIO2,
    GPIO3,
    GPIO4,
    GPIO5,
    GPIO6,
    GPIO7,
    GPIO8,
    GPIO9,
    ICM_IMU_INT1,
    IMU_CLK,
    IMU_CS,
    IMU_MISO,
    IMU_MOSI,
    x0,
    x1);
  inout [3:0]AUX;
  output BONUS1_EXTCLK;
  input BONUS1_FLASH;
  inout BONUS1_I2C0_scl_io;
  inout BONUS1_I2C0_sda_io;
  inout BONUS1_I2C1_scl_io;
  inout BONUS1_I2C1_sda_io;
  input BONUS1_MIPI0_clk_n;
  input BONUS1_MIPI0_clk_p;
  input [0:0]BONUS1_MIPI0_data_n;
  input [0:0]BONUS1_MIPI0_data_p;
  input BONUS1_MIPI1_clk_n;
  input BONUS1_MIPI1_clk_p;
  input [0:0]BONUS1_MIPI1_data_n;
  input [0:0]BONUS1_MIPI1_data_p;
  output BONUS1_RESET;
  output BONUS1_TRIGGER;
  output BONUS2_EXTCLK;
  input BONUS2_FLASH;
  inout BONUS2_I2C0_scl_io;
  inout BONUS2_I2C0_sda_io;
  inout BONUS2_I2C1_scl_io;
  inout BONUS2_I2C1_sda_io;
  input BONUS2_MIPI0_clk_n;
  input BONUS2_MIPI0_clk_p;
  input [0:0]BONUS2_MIPI0_data_n;
  input [0:0]BONUS2_MIPI0_data_p;
  input BONUS2_MIPI1_clk_n;
  input BONUS2_MIPI1_clk_p;
  input [0:0]BONUS2_MIPI1_data_n;
  input [0:0]BONUS2_MIPI1_data_p;
  output BONUS2_RESET;
  output BONUS2_TRIGGER;
  output BONUS3_EXTCLK;
  input BONUS3_FLASH;
  output BONUS3_RESET;
  output BONUS3_TRIGGER;
  output BONUS4_EXTCLK;
  input BONUS4_FLASH;
  output BONUS4_RESET;
  output BONUS4_TRIGGER;
  output CAM0_EXTCLK;
  inout CAM0_I2C_scl_io;
  inout CAM0_I2C_sda_io;
  input CAM0_MIPI_clk_n;
  input CAM0_MIPI_clk_p;
  input [0:0]CAM0_MIPI_data_n;
  input [0:0]CAM0_MIPI_data_p;
  output [0:0]CAM0_NRESET;
  output [0:0]CAM0_TRIG;
  output CAM1_EXTCLK;
  inout CAM1_I2C_scl_io;
  inout CAM1_I2C_sda_io;
  input CAM1_MIPI_clk_n;
  input CAM1_MIPI_clk_p;
  input [0:0]CAM1_MIPI_data_n;
  input [0:0]CAM1_MIPI_data_p;
  output CAM1_NRESET;
  output [0:0]CAM1_TRIG;
  output CAM2_EXTCLK;
  inout CAM2_I2C_scl_io;
  inout CAM2_I2C_sda_io;
  input CAM2_MIPI_clk_n;
  input CAM2_MIPI_clk_p;
  input [0:0]CAM2_MIPI_data_n;
  input [0:0]CAM2_MIPI_data_p;
  output [0:0]CAM2_NRESET;
  output [0:0]CAM2_TRIG;
  input DIP_SWITCH;
  input GPIO0;
  input GPIO1;
  output [0:0]GPIO10;
  input GPIO11;
  output [0:0]GPIO12;
  output [0:0]GPIO13;
  output GPIO14;
  output GPIO15;
  output GPIO16;
  output GPIO17;
  input GPIO2;
  input GPIO3;
  output [0:0]GPIO4;
  output [0:0]GPIO5;
  output [0:0]GPIO6;
  output GPIO7;
  input GPIO8;
  input GPIO9;
  input ICM_IMU_INT1;
  output IMU_CLK;
  output IMU_CS;
  input IMU_MISO;
  output IMU_MOSI;
  output [0:0]x0;
  output [0:0]x1;

  wire [3:0]AUX;
  wire BONUS1_EXTCLK;
  wire BONUS1_FLASH;
  wire BONUS1_I2C0_scl_i;
  wire BONUS1_I2C0_scl_io;
  wire BONUS1_I2C0_scl_o;
  wire BONUS1_I2C0_scl_t;
  wire BONUS1_I2C0_sda_i;
  wire BONUS1_I2C0_sda_io;
  wire BONUS1_I2C0_sda_o;
  wire BONUS1_I2C0_sda_t;
  wire BONUS1_I2C1_scl_i;
  wire BONUS1_I2C1_scl_io;
  wire BONUS1_I2C1_scl_o;
  wire BONUS1_I2C1_scl_t;
  wire BONUS1_I2C1_sda_i;
  wire BONUS1_I2C1_sda_io;
  wire BONUS1_I2C1_sda_o;
  wire BONUS1_I2C1_sda_t;
  wire BONUS1_MIPI0_clk_n;
  wire BONUS1_MIPI0_clk_p;
  wire [0:0]BONUS1_MIPI0_data_n;
  wire [0:0]BONUS1_MIPI0_data_p;
  wire BONUS1_MIPI1_clk_n;
  wire BONUS1_MIPI1_clk_p;
  wire [0:0]BONUS1_MIPI1_data_n;
  wire [0:0]BONUS1_MIPI1_data_p;
  wire BONUS1_RESET;
  wire BONUS1_TRIGGER;
  wire BONUS2_EXTCLK;
  wire BONUS2_FLASH;
  wire BONUS2_I2C0_scl_i;
  wire BONUS2_I2C0_scl_io;
  wire BONUS2_I2C0_scl_o;
  wire BONUS2_I2C0_scl_t;
  wire BONUS2_I2C0_sda_i;
  wire BONUS2_I2C0_sda_io;
  wire BONUS2_I2C0_sda_o;
  wire BONUS2_I2C0_sda_t;
  wire BONUS2_I2C1_scl_i;
  wire BONUS2_I2C1_scl_io;
  wire BONUS2_I2C1_scl_o;
  wire BONUS2_I2C1_scl_t;
  wire BONUS2_I2C1_sda_i;
  wire BONUS2_I2C1_sda_io;
  wire BONUS2_I2C1_sda_o;
  wire BONUS2_I2C1_sda_t;
  wire BONUS2_MIPI0_clk_n;
  wire BONUS2_MIPI0_clk_p;
  wire [0:0]BONUS2_MIPI0_data_n;
  wire [0:0]BONUS2_MIPI0_data_p;
  wire BONUS2_MIPI1_clk_n;
  wire BONUS2_MIPI1_clk_p;
  wire [0:0]BONUS2_MIPI1_data_n;
  wire [0:0]BONUS2_MIPI1_data_p;
  wire BONUS2_RESET;
  wire BONUS2_TRIGGER;
  wire BONUS3_EXTCLK;
  wire BONUS3_FLASH;
  wire BONUS3_RESET;
  wire BONUS3_TRIGGER;
  wire BONUS4_EXTCLK;
  wire BONUS4_FLASH;
  wire BONUS4_RESET;
  wire BONUS4_TRIGGER;
  wire CAM0_EXTCLK;
  wire CAM0_I2C_scl_i;
  wire CAM0_I2C_scl_io;
  wire CAM0_I2C_scl_o;
  wire CAM0_I2C_scl_t;
  wire CAM0_I2C_sda_i;
  wire CAM0_I2C_sda_io;
  wire CAM0_I2C_sda_o;
  wire CAM0_I2C_sda_t;
  wire CAM0_MIPI_clk_n;
  wire CAM0_MIPI_clk_p;
  wire [0:0]CAM0_MIPI_data_n;
  wire [0:0]CAM0_MIPI_data_p;
  wire [0:0]CAM0_NRESET;
  wire [0:0]CAM0_TRIG;
  wire CAM1_EXTCLK;
  wire CAM1_I2C_scl_i;
  wire CAM1_I2C_scl_io;
  wire CAM1_I2C_scl_o;
  wire CAM1_I2C_scl_t;
  wire CAM1_I2C_sda_i;
  wire CAM1_I2C_sda_io;
  wire CAM1_I2C_sda_o;
  wire CAM1_I2C_sda_t;
  wire CAM1_MIPI_clk_n;
  wire CAM1_MIPI_clk_p;
  wire [0:0]CAM1_MIPI_data_n;
  wire [0:0]CAM1_MIPI_data_p;
  wire CAM1_NRESET;
  wire [0:0]CAM1_TRIG;
  wire CAM2_EXTCLK;
  wire CAM2_I2C_scl_i;
  wire CAM2_I2C_scl_io;
  wire CAM2_I2C_scl_o;
  wire CAM2_I2C_scl_t;
  wire CAM2_I2C_sda_i;
  wire CAM2_I2C_sda_io;
  wire CAM2_I2C_sda_o;
  wire CAM2_I2C_sda_t;
  wire CAM2_MIPI_clk_n;
  wire CAM2_MIPI_clk_p;
  wire [0:0]CAM2_MIPI_data_n;
  wire [0:0]CAM2_MIPI_data_p;
  wire [0:0]CAM2_NRESET;
  wire [0:0]CAM2_TRIG;
  wire DIP_SWITCH;
  wire GPIO0;
  wire GPIO1;
  wire [0:0]GPIO10;
  wire GPIO11;
  wire [0:0]GPIO12;
  wire [0:0]GPIO13;
  wire GPIO14;
  wire GPIO15;
  wire GPIO16;
  wire GPIO17;
  wire GPIO2;
  wire GPIO3;
  wire [0:0]GPIO4;
  wire [0:0]GPIO5;
  wire [0:0]GPIO6;
  wire GPIO7;
  wire GPIO8;
  wire GPIO9;
  wire ICM_IMU_INT1;
  wire IMU_CLK;
  wire IMU_CS;
  wire IMU_MISO;
  wire IMU_MOSI;
  wire [0:0]x0;
  wire [0:0]x1;

  IOBUF BONUS1_I2C0_scl_iobuf
       (.I(BONUS1_I2C0_scl_o),
        .IO(BONUS1_I2C0_scl_io),
        .O(BONUS1_I2C0_scl_i),
        .T(BONUS1_I2C0_scl_t));
  IOBUF BONUS1_I2C0_sda_iobuf
       (.I(BONUS1_I2C0_sda_o),
        .IO(BONUS1_I2C0_sda_io),
        .O(BONUS1_I2C0_sda_i),
        .T(BONUS1_I2C0_sda_t));
  IOBUF BONUS1_I2C1_scl_iobuf
       (.I(BONUS1_I2C1_scl_o),
        .IO(BONUS1_I2C1_scl_io),
        .O(BONUS1_I2C1_scl_i),
        .T(BONUS1_I2C1_scl_t));
  IOBUF BONUS1_I2C1_sda_iobuf
       (.I(BONUS1_I2C1_sda_o),
        .IO(BONUS1_I2C1_sda_io),
        .O(BONUS1_I2C1_sda_i),
        .T(BONUS1_I2C1_sda_t));
  IOBUF BONUS2_I2C0_scl_iobuf
       (.I(BONUS2_I2C0_scl_o),
        .IO(BONUS2_I2C0_scl_io),
        .O(BONUS2_I2C0_scl_i),
        .T(BONUS2_I2C0_scl_t));
  IOBUF BONUS2_I2C0_sda_iobuf
       (.I(BONUS2_I2C0_sda_o),
        .IO(BONUS2_I2C0_sda_io),
        .O(BONUS2_I2C0_sda_i),
        .T(BONUS2_I2C0_sda_t));
  IOBUF BONUS2_I2C1_scl_iobuf
       (.I(BONUS2_I2C1_scl_o),
        .IO(BONUS2_I2C1_scl_io),
        .O(BONUS2_I2C1_scl_i),
        .T(BONUS2_I2C1_scl_t));
  IOBUF BONUS2_I2C1_sda_iobuf
       (.I(BONUS2_I2C1_sda_o),
        .IO(BONUS2_I2C1_sda_io),
        .O(BONUS2_I2C1_sda_i),
        .T(BONUS2_I2C1_sda_t));
  IOBUF CAM0_I2C_scl_iobuf
       (.I(CAM0_I2C_scl_o),
        .IO(CAM0_I2C_scl_io),
        .O(CAM0_I2C_scl_i),
        .T(CAM0_I2C_scl_t));
  IOBUF CAM0_I2C_sda_iobuf
       (.I(CAM0_I2C_sda_o),
        .IO(CAM0_I2C_sda_io),
        .O(CAM0_I2C_sda_i),
        .T(CAM0_I2C_sda_t));
  IOBUF CAM1_I2C_scl_iobuf
       (.I(CAM1_I2C_scl_o),
        .IO(CAM1_I2C_scl_io),
        .O(CAM1_I2C_scl_i),
        .T(CAM1_I2C_scl_t));
  IOBUF CAM1_I2C_sda_iobuf
       (.I(CAM1_I2C_sda_o),
        .IO(CAM1_I2C_sda_io),
        .O(CAM1_I2C_sda_i),
        .T(CAM1_I2C_sda_t));
  IOBUF CAM2_I2C_scl_iobuf
       (.I(CAM2_I2C_scl_o),
        .IO(CAM2_I2C_scl_io),
        .O(CAM2_I2C_scl_i),
        .T(CAM2_I2C_scl_t));
  IOBUF CAM2_I2C_sda_iobuf
       (.I(CAM2_I2C_sda_o),
        .IO(CAM2_I2C_sda_io),
        .O(CAM2_I2C_sda_i),
        .T(CAM2_I2C_sda_t));
  zusys zusys_i
       (.AUX(AUX),
        .BONUS1_EXTCLK(BONUS1_EXTCLK),
        .BONUS1_FLASH(BONUS1_FLASH),
        .BONUS1_I2C0_scl_i(BONUS1_I2C0_scl_i),
        .BONUS1_I2C0_scl_o(BONUS1_I2C0_scl_o),
        .BONUS1_I2C0_scl_t(BONUS1_I2C0_scl_t),
        .BONUS1_I2C0_sda_i(BONUS1_I2C0_sda_i),
        .BONUS1_I2C0_sda_o(BONUS1_I2C0_sda_o),
        .BONUS1_I2C0_sda_t(BONUS1_I2C0_sda_t),
        .BONUS1_I2C1_scl_i(BONUS1_I2C1_scl_i),
        .BONUS1_I2C1_scl_o(BONUS1_I2C1_scl_o),
        .BONUS1_I2C1_scl_t(BONUS1_I2C1_scl_t),
        .BONUS1_I2C1_sda_i(BONUS1_I2C1_sda_i),
        .BONUS1_I2C1_sda_o(BONUS1_I2C1_sda_o),
        .BONUS1_I2C1_sda_t(BONUS1_I2C1_sda_t),
        .BONUS1_MIPI0_clk_n(BONUS1_MIPI0_clk_n),
        .BONUS1_MIPI0_clk_p(BONUS1_MIPI0_clk_p),
        .BONUS1_MIPI0_data_n(BONUS1_MIPI0_data_n),
        .BONUS1_MIPI0_data_p(BONUS1_MIPI0_data_p),
        .BONUS1_MIPI1_clk_n(BONUS1_MIPI1_clk_n),
        .BONUS1_MIPI1_clk_p(BONUS1_MIPI1_clk_p),
        .BONUS1_MIPI1_data_n(BONUS1_MIPI1_data_n),
        .BONUS1_MIPI1_data_p(BONUS1_MIPI1_data_p),
        .BONUS1_RESET(BONUS1_RESET),
        .BONUS1_TRIGGER(BONUS1_TRIGGER),
        .BONUS2_EXTCLK(BONUS2_EXTCLK),
        .BONUS2_FLASH(BONUS2_FLASH),
        .BONUS2_I2C0_scl_i(BONUS2_I2C0_scl_i),
        .BONUS2_I2C0_scl_o(BONUS2_I2C0_scl_o),
        .BONUS2_I2C0_scl_t(BONUS2_I2C0_scl_t),
        .BONUS2_I2C0_sda_i(BONUS2_I2C0_sda_i),
        .BONUS2_I2C0_sda_o(BONUS2_I2C0_sda_o),
        .BONUS2_I2C0_sda_t(BONUS2_I2C0_sda_t),
        .BONUS2_I2C1_scl_i(BONUS2_I2C1_scl_i),
        .BONUS2_I2C1_scl_o(BONUS2_I2C1_scl_o),
        .BONUS2_I2C1_scl_t(BONUS2_I2C1_scl_t),
        .BONUS2_I2C1_sda_i(BONUS2_I2C1_sda_i),
        .BONUS2_I2C1_sda_o(BONUS2_I2C1_sda_o),
        .BONUS2_I2C1_sda_t(BONUS2_I2C1_sda_t),
        .BONUS2_MIPI0_clk_n(BONUS2_MIPI0_clk_n),
        .BONUS2_MIPI0_clk_p(BONUS2_MIPI0_clk_p),
        .BONUS2_MIPI0_data_n(BONUS2_MIPI0_data_n),
        .BONUS2_MIPI0_data_p(BONUS2_MIPI0_data_p),
        .BONUS2_MIPI1_clk_n(BONUS2_MIPI1_clk_n),
        .BONUS2_MIPI1_clk_p(BONUS2_MIPI1_clk_p),
        .BONUS2_MIPI1_data_n(BONUS2_MIPI1_data_n),
        .BONUS2_MIPI1_data_p(BONUS2_MIPI1_data_p),
        .BONUS2_RESET(BONUS2_RESET),
        .BONUS2_TRIGGER(BONUS2_TRIGGER),
        .BONUS3_EXTCLK(BONUS3_EXTCLK),
        .BONUS3_FLASH(BONUS3_FLASH),
        .BONUS3_RESET(BONUS3_RESET),
        .BONUS3_TRIGGER(BONUS3_TRIGGER),
        .BONUS4_EXTCLK(BONUS4_EXTCLK),
        .BONUS4_FLASH(BONUS4_FLASH),
        .BONUS4_RESET(BONUS4_RESET),
        .BONUS4_TRIGGER(BONUS4_TRIGGER),
        .CAM0_EXTCLK(CAM0_EXTCLK),
        .CAM0_I2C_scl_i(CAM0_I2C_scl_i),
        .CAM0_I2C_scl_o(CAM0_I2C_scl_o),
        .CAM0_I2C_scl_t(CAM0_I2C_scl_t),
        .CAM0_I2C_sda_i(CAM0_I2C_sda_i),
        .CAM0_I2C_sda_o(CAM0_I2C_sda_o),
        .CAM0_I2C_sda_t(CAM0_I2C_sda_t),
        .CAM0_MIPI_clk_n(CAM0_MIPI_clk_n),
        .CAM0_MIPI_clk_p(CAM0_MIPI_clk_p),
        .CAM0_MIPI_data_n(CAM0_MIPI_data_n),
        .CAM0_MIPI_data_p(CAM0_MIPI_data_p),
        .CAM0_NRESET(CAM0_NRESET),
        .CAM0_TRIG(CAM0_TRIG),
        .CAM1_EXTCLK(CAM1_EXTCLK),
        .CAM1_I2C_scl_i(CAM1_I2C_scl_i),
        .CAM1_I2C_scl_o(CAM1_I2C_scl_o),
        .CAM1_I2C_scl_t(CAM1_I2C_scl_t),
        .CAM1_I2C_sda_i(CAM1_I2C_sda_i),
        .CAM1_I2C_sda_o(CAM1_I2C_sda_o),
        .CAM1_I2C_sda_t(CAM1_I2C_sda_t),
        .CAM1_MIPI_clk_n(CAM1_MIPI_clk_n),
        .CAM1_MIPI_clk_p(CAM1_MIPI_clk_p),
        .CAM1_MIPI_data_n(CAM1_MIPI_data_n),
        .CAM1_MIPI_data_p(CAM1_MIPI_data_p),
        .CAM1_NRESET(CAM1_NRESET),
        .CAM1_TRIG(CAM1_TRIG),
        .CAM2_EXTCLK(CAM2_EXTCLK),
        .CAM2_I2C_scl_i(CAM2_I2C_scl_i),
        .CAM2_I2C_scl_o(CAM2_I2C_scl_o),
        .CAM2_I2C_scl_t(CAM2_I2C_scl_t),
        .CAM2_I2C_sda_i(CAM2_I2C_sda_i),
        .CAM2_I2C_sda_o(CAM2_I2C_sda_o),
        .CAM2_I2C_sda_t(CAM2_I2C_sda_t),
        .CAM2_MIPI_clk_n(CAM2_MIPI_clk_n),
        .CAM2_MIPI_clk_p(CAM2_MIPI_clk_p),
        .CAM2_MIPI_data_n(CAM2_MIPI_data_n),
        .CAM2_MIPI_data_p(CAM2_MIPI_data_p),
        .CAM2_NRESET(CAM2_NRESET),
        .CAM2_TRIG(CAM2_TRIG),
        .DIP_SWITCH(DIP_SWITCH),
        .GPIO0(GPIO0),
        .GPIO1(GPIO1),
        .GPIO10(GPIO10),
        .GPIO11(GPIO11),
        .GPIO12(GPIO12),
        .GPIO13(GPIO13),
        .GPIO14(GPIO14),
        .GPIO15(GPIO15),
        .GPIO16(GPIO16),
        .GPIO17(GPIO17),
        .GPIO2(GPIO2),
        .GPIO3(GPIO3),
        .GPIO4(GPIO4),
        .GPIO5(GPIO5),
        .GPIO6(GPIO6),
        .GPIO7(GPIO7),
        .GPIO8(GPIO8),
        .GPIO9(GPIO9),
        .ICM_IMU_INT1(ICM_IMU_INT1),
        .IMU_CLK(IMU_CLK),
        .IMU_CS(IMU_CS),
        .IMU_MISO(IMU_MISO),
        .IMU_MOSI(IMU_MOSI),
        .x0(x0),
        .x1(x1));
endmodule
