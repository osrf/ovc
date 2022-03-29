//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
//Date        : Mon Mar 28 17:03:02 2022
//Host        : luca-focal running 64-bit Ubuntu 20.04.4 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (ENABLE,
    FRAME_END_0,
    FRAME_START_0,
    GPIO,
    TRIG0,
    TRIG1,
    TRIG2,
    TRIG3,
    TRIG4,
    TRIG5,
    TRIG_PROBE,
    USER_DIP,
    USER_LEDS,
    iic_rtl_0_scl_io,
    iic_rtl_0_sda_io,
    iic_rtl_1_scl_io,
    iic_rtl_1_sda_io,
    iic_rtl_2_scl_io,
    iic_rtl_2_sda_io,
    iic_rtl_3_scl_io,
    iic_rtl_3_sda_io,
    iic_rtl_4_scl_io,
    iic_rtl_4_sda_io,
    iic_rtl_5_scl_io,
    iic_rtl_5_sda_io,
    mipi_phy_if_0_clk_n,
    mipi_phy_if_0_clk_p,
    mipi_phy_if_0_data_n,
    mipi_phy_if_0_data_p,
    mipi_phy_if_1_clk_n,
    mipi_phy_if_1_clk_p,
    mipi_phy_if_1_data_n,
    mipi_phy_if_1_data_p,
    mipi_phy_if_2_clk_n,
    mipi_phy_if_2_clk_p,
    mipi_phy_if_2_data_n,
    mipi_phy_if_2_data_p,
    mipi_phy_if_3_clk_n,
    mipi_phy_if_3_clk_p,
    mipi_phy_if_3_data_n,
    mipi_phy_if_3_data_p,
    mipi_phy_if_4_clk_n,
    mipi_phy_if_4_clk_p,
    mipi_phy_if_4_data_n,
    mipi_phy_if_4_data_p,
    mipi_phy_if_5_clk_n,
    mipi_phy_if_5_clk_p,
    mipi_phy_if_5_data_n,
    mipi_phy_if_5_data_p,
    qwiic_rtl_0_scl_io,
    qwiic_rtl_0_sda_io,
    qwiic_rtl_1_scl_io,
    qwiic_rtl_1_sda_io,
    qwiic_rtl_2_scl_io,
    qwiic_rtl_2_sda_io,
    usb_smbus_rtl_0_scl_io,
    usb_smbus_rtl_0_sda_io);
  output [5:0]ENABLE;
  output [0:0]FRAME_END_0;
  output [0:0]FRAME_START_0;
  inout [5:0]GPIO;
  input TRIG0;
  output [0:0]TRIG1;
  output [0:0]TRIG2;
  output [0:0]TRIG3;
  output [0:0]TRIG4;
  output [0:0]TRIG5;
  output [0:0]TRIG_PROBE;
  input USER_DIP;
  output [1:0]USER_LEDS;
  inout iic_rtl_0_scl_io;
  inout iic_rtl_0_sda_io;
  inout iic_rtl_1_scl_io;
  inout iic_rtl_1_sda_io;
  inout iic_rtl_2_scl_io;
  inout iic_rtl_2_sda_io;
  inout iic_rtl_3_scl_io;
  inout iic_rtl_3_sda_io;
  inout iic_rtl_4_scl_io;
  inout iic_rtl_4_sda_io;
  inout iic_rtl_5_scl_io;
  inout iic_rtl_5_sda_io;
  input mipi_phy_if_0_clk_n;
  input mipi_phy_if_0_clk_p;
  input [3:0]mipi_phy_if_0_data_n;
  input [3:0]mipi_phy_if_0_data_p;
  input mipi_phy_if_1_clk_n;
  input mipi_phy_if_1_clk_p;
  input [1:0]mipi_phy_if_1_data_n;
  input [1:0]mipi_phy_if_1_data_p;
  input mipi_phy_if_2_clk_n;
  input mipi_phy_if_2_clk_p;
  input [1:0]mipi_phy_if_2_data_n;
  input [1:0]mipi_phy_if_2_data_p;
  input mipi_phy_if_3_clk_n;
  input mipi_phy_if_3_clk_p;
  input [3:0]mipi_phy_if_3_data_n;
  input [3:0]mipi_phy_if_3_data_p;
  input mipi_phy_if_4_clk_n;
  input mipi_phy_if_4_clk_p;
  input [1:0]mipi_phy_if_4_data_n;
  input [1:0]mipi_phy_if_4_data_p;
  input mipi_phy_if_5_clk_n;
  input mipi_phy_if_5_clk_p;
  input [1:0]mipi_phy_if_5_data_n;
  input [1:0]mipi_phy_if_5_data_p;
  inout qwiic_rtl_0_scl_io;
  inout qwiic_rtl_0_sda_io;
  inout qwiic_rtl_1_scl_io;
  inout qwiic_rtl_1_sda_io;
  inout qwiic_rtl_2_scl_io;
  inout qwiic_rtl_2_sda_io;
  inout usb_smbus_rtl_0_scl_io;
  inout usb_smbus_rtl_0_sda_io;

  wire [5:0]ENABLE;
  wire [0:0]FRAME_END_0;
  wire [0:0]FRAME_START_0;
  wire [5:0]GPIO;
  wire TRIG0;
  wire [0:0]TRIG1;
  wire [0:0]TRIG2;
  wire [0:0]TRIG3;
  wire [0:0]TRIG4;
  wire [0:0]TRIG5;
  wire [0:0]TRIG_PROBE;
  wire USER_DIP;
  wire [1:0]USER_LEDS;
  wire iic_rtl_0_scl_i;
  wire iic_rtl_0_scl_io;
  wire iic_rtl_0_scl_o;
  wire iic_rtl_0_scl_t;
  wire iic_rtl_0_sda_i;
  wire iic_rtl_0_sda_io;
  wire iic_rtl_0_sda_o;
  wire iic_rtl_0_sda_t;
  wire iic_rtl_1_scl_i;
  wire iic_rtl_1_scl_io;
  wire iic_rtl_1_scl_o;
  wire iic_rtl_1_scl_t;
  wire iic_rtl_1_sda_i;
  wire iic_rtl_1_sda_io;
  wire iic_rtl_1_sda_o;
  wire iic_rtl_1_sda_t;
  wire iic_rtl_2_scl_i;
  wire iic_rtl_2_scl_io;
  wire iic_rtl_2_scl_o;
  wire iic_rtl_2_scl_t;
  wire iic_rtl_2_sda_i;
  wire iic_rtl_2_sda_io;
  wire iic_rtl_2_sda_o;
  wire iic_rtl_2_sda_t;
  wire iic_rtl_3_scl_i;
  wire iic_rtl_3_scl_io;
  wire iic_rtl_3_scl_o;
  wire iic_rtl_3_scl_t;
  wire iic_rtl_3_sda_i;
  wire iic_rtl_3_sda_io;
  wire iic_rtl_3_sda_o;
  wire iic_rtl_3_sda_t;
  wire iic_rtl_4_scl_i;
  wire iic_rtl_4_scl_io;
  wire iic_rtl_4_scl_o;
  wire iic_rtl_4_scl_t;
  wire iic_rtl_4_sda_i;
  wire iic_rtl_4_sda_io;
  wire iic_rtl_4_sda_o;
  wire iic_rtl_4_sda_t;
  wire iic_rtl_5_scl_i;
  wire iic_rtl_5_scl_io;
  wire iic_rtl_5_scl_o;
  wire iic_rtl_5_scl_t;
  wire iic_rtl_5_sda_i;
  wire iic_rtl_5_sda_io;
  wire iic_rtl_5_sda_o;
  wire iic_rtl_5_sda_t;
  wire mipi_phy_if_0_clk_n;
  wire mipi_phy_if_0_clk_p;
  wire [3:0]mipi_phy_if_0_data_n;
  wire [3:0]mipi_phy_if_0_data_p;
  wire mipi_phy_if_1_clk_n;
  wire mipi_phy_if_1_clk_p;
  wire [1:0]mipi_phy_if_1_data_n;
  wire [1:0]mipi_phy_if_1_data_p;
  wire mipi_phy_if_2_clk_n;
  wire mipi_phy_if_2_clk_p;
  wire [1:0]mipi_phy_if_2_data_n;
  wire [1:0]mipi_phy_if_2_data_p;
  wire mipi_phy_if_3_clk_n;
  wire mipi_phy_if_3_clk_p;
  wire [3:0]mipi_phy_if_3_data_n;
  wire [3:0]mipi_phy_if_3_data_p;
  wire mipi_phy_if_4_clk_n;
  wire mipi_phy_if_4_clk_p;
  wire [1:0]mipi_phy_if_4_data_n;
  wire [1:0]mipi_phy_if_4_data_p;
  wire mipi_phy_if_5_clk_n;
  wire mipi_phy_if_5_clk_p;
  wire [1:0]mipi_phy_if_5_data_n;
  wire [1:0]mipi_phy_if_5_data_p;
  wire qwiic_rtl_0_scl_i;
  wire qwiic_rtl_0_scl_io;
  wire qwiic_rtl_0_scl_o;
  wire qwiic_rtl_0_scl_t;
  wire qwiic_rtl_0_sda_i;
  wire qwiic_rtl_0_sda_io;
  wire qwiic_rtl_0_sda_o;
  wire qwiic_rtl_0_sda_t;
  wire qwiic_rtl_1_scl_i;
  wire qwiic_rtl_1_scl_io;
  wire qwiic_rtl_1_scl_o;
  wire qwiic_rtl_1_scl_t;
  wire qwiic_rtl_1_sda_i;
  wire qwiic_rtl_1_sda_io;
  wire qwiic_rtl_1_sda_o;
  wire qwiic_rtl_1_sda_t;
  wire qwiic_rtl_2_scl_i;
  wire qwiic_rtl_2_scl_io;
  wire qwiic_rtl_2_scl_o;
  wire qwiic_rtl_2_scl_t;
  wire qwiic_rtl_2_sda_i;
  wire qwiic_rtl_2_sda_io;
  wire qwiic_rtl_2_sda_o;
  wire qwiic_rtl_2_sda_t;
  wire usb_smbus_rtl_0_scl_i;
  wire usb_smbus_rtl_0_scl_io;
  wire usb_smbus_rtl_0_scl_o;
  wire usb_smbus_rtl_0_scl_t;
  wire usb_smbus_rtl_0_sda_i;
  wire usb_smbus_rtl_0_sda_io;
  wire usb_smbus_rtl_0_sda_o;
  wire usb_smbus_rtl_0_sda_t;

  design_1 design_1_i
       (.ENABLE(ENABLE),
        .FRAME_END_0(FRAME_END_0),
        .FRAME_START_0(FRAME_START_0),
        .GPIO(GPIO),
        .TRIG0(TRIG0),
        .TRIG1(TRIG1),
        .TRIG2(TRIG2),
        .TRIG3(TRIG3),
        .TRIG4(TRIG4),
        .TRIG5(TRIG5),
        .TRIG_PROBE(TRIG_PROBE),
        .USER_DIP(USER_DIP),
        .USER_LEDS(USER_LEDS),
        .iic_rtl_0_scl_i(iic_rtl_0_scl_i),
        .iic_rtl_0_scl_o(iic_rtl_0_scl_o),
        .iic_rtl_0_scl_t(iic_rtl_0_scl_t),
        .iic_rtl_0_sda_i(iic_rtl_0_sda_i),
        .iic_rtl_0_sda_o(iic_rtl_0_sda_o),
        .iic_rtl_0_sda_t(iic_rtl_0_sda_t),
        .iic_rtl_1_scl_i(iic_rtl_1_scl_i),
        .iic_rtl_1_scl_o(iic_rtl_1_scl_o),
        .iic_rtl_1_scl_t(iic_rtl_1_scl_t),
        .iic_rtl_1_sda_i(iic_rtl_1_sda_i),
        .iic_rtl_1_sda_o(iic_rtl_1_sda_o),
        .iic_rtl_1_sda_t(iic_rtl_1_sda_t),
        .iic_rtl_2_scl_i(iic_rtl_2_scl_i),
        .iic_rtl_2_scl_o(iic_rtl_2_scl_o),
        .iic_rtl_2_scl_t(iic_rtl_2_scl_t),
        .iic_rtl_2_sda_i(iic_rtl_2_sda_i),
        .iic_rtl_2_sda_o(iic_rtl_2_sda_o),
        .iic_rtl_2_sda_t(iic_rtl_2_sda_t),
        .iic_rtl_3_scl_i(iic_rtl_3_scl_i),
        .iic_rtl_3_scl_o(iic_rtl_3_scl_o),
        .iic_rtl_3_scl_t(iic_rtl_3_scl_t),
        .iic_rtl_3_sda_i(iic_rtl_3_sda_i),
        .iic_rtl_3_sda_o(iic_rtl_3_sda_o),
        .iic_rtl_3_sda_t(iic_rtl_3_sda_t),
        .iic_rtl_4_scl_i(iic_rtl_4_scl_i),
        .iic_rtl_4_scl_o(iic_rtl_4_scl_o),
        .iic_rtl_4_scl_t(iic_rtl_4_scl_t),
        .iic_rtl_4_sda_i(iic_rtl_4_sda_i),
        .iic_rtl_4_sda_o(iic_rtl_4_sda_o),
        .iic_rtl_4_sda_t(iic_rtl_4_sda_t),
        .iic_rtl_5_scl_i(iic_rtl_5_scl_i),
        .iic_rtl_5_scl_o(iic_rtl_5_scl_o),
        .iic_rtl_5_scl_t(iic_rtl_5_scl_t),
        .iic_rtl_5_sda_i(iic_rtl_5_sda_i),
        .iic_rtl_5_sda_o(iic_rtl_5_sda_o),
        .iic_rtl_5_sda_t(iic_rtl_5_sda_t),
        .mipi_phy_if_0_clk_n(mipi_phy_if_0_clk_n),
        .mipi_phy_if_0_clk_p(mipi_phy_if_0_clk_p),
        .mipi_phy_if_0_data_n(mipi_phy_if_0_data_n),
        .mipi_phy_if_0_data_p(mipi_phy_if_0_data_p),
        .mipi_phy_if_1_clk_n(mipi_phy_if_1_clk_n),
        .mipi_phy_if_1_clk_p(mipi_phy_if_1_clk_p),
        .mipi_phy_if_1_data_n(mipi_phy_if_1_data_n),
        .mipi_phy_if_1_data_p(mipi_phy_if_1_data_p),
        .mipi_phy_if_2_clk_n(mipi_phy_if_2_clk_n),
        .mipi_phy_if_2_clk_p(mipi_phy_if_2_clk_p),
        .mipi_phy_if_2_data_n(mipi_phy_if_2_data_n),
        .mipi_phy_if_2_data_p(mipi_phy_if_2_data_p),
        .mipi_phy_if_3_clk_n(mipi_phy_if_3_clk_n),
        .mipi_phy_if_3_clk_p(mipi_phy_if_3_clk_p),
        .mipi_phy_if_3_data_n(mipi_phy_if_3_data_n),
        .mipi_phy_if_3_data_p(mipi_phy_if_3_data_p),
        .mipi_phy_if_4_clk_n(mipi_phy_if_4_clk_n),
        .mipi_phy_if_4_clk_p(mipi_phy_if_4_clk_p),
        .mipi_phy_if_4_data_n(mipi_phy_if_4_data_n),
        .mipi_phy_if_4_data_p(mipi_phy_if_4_data_p),
        .mipi_phy_if_5_clk_n(mipi_phy_if_5_clk_n),
        .mipi_phy_if_5_clk_p(mipi_phy_if_5_clk_p),
        .mipi_phy_if_5_data_n(mipi_phy_if_5_data_n),
        .mipi_phy_if_5_data_p(mipi_phy_if_5_data_p),
        .qwiic_rtl_0_scl_i(qwiic_rtl_0_scl_i),
        .qwiic_rtl_0_scl_o(qwiic_rtl_0_scl_o),
        .qwiic_rtl_0_scl_t(qwiic_rtl_0_scl_t),
        .qwiic_rtl_0_sda_i(qwiic_rtl_0_sda_i),
        .qwiic_rtl_0_sda_o(qwiic_rtl_0_sda_o),
        .qwiic_rtl_0_sda_t(qwiic_rtl_0_sda_t),
        .qwiic_rtl_1_scl_i(qwiic_rtl_1_scl_i),
        .qwiic_rtl_1_scl_o(qwiic_rtl_1_scl_o),
        .qwiic_rtl_1_scl_t(qwiic_rtl_1_scl_t),
        .qwiic_rtl_1_sda_i(qwiic_rtl_1_sda_i),
        .qwiic_rtl_1_sda_o(qwiic_rtl_1_sda_o),
        .qwiic_rtl_1_sda_t(qwiic_rtl_1_sda_t),
        .qwiic_rtl_2_scl_i(qwiic_rtl_2_scl_i),
        .qwiic_rtl_2_scl_o(qwiic_rtl_2_scl_o),
        .qwiic_rtl_2_scl_t(qwiic_rtl_2_scl_t),
        .qwiic_rtl_2_sda_i(qwiic_rtl_2_sda_i),
        .qwiic_rtl_2_sda_o(qwiic_rtl_2_sda_o),
        .qwiic_rtl_2_sda_t(qwiic_rtl_2_sda_t),
        .usb_smbus_rtl_0_scl_i(usb_smbus_rtl_0_scl_i),
        .usb_smbus_rtl_0_scl_o(usb_smbus_rtl_0_scl_o),
        .usb_smbus_rtl_0_scl_t(usb_smbus_rtl_0_scl_t),
        .usb_smbus_rtl_0_sda_i(usb_smbus_rtl_0_sda_i),
        .usb_smbus_rtl_0_sda_o(usb_smbus_rtl_0_sda_o),
        .usb_smbus_rtl_0_sda_t(usb_smbus_rtl_0_sda_t));
  IOBUF iic_rtl_0_scl_iobuf
       (.I(iic_rtl_0_scl_o),
        .IO(iic_rtl_0_scl_io),
        .O(iic_rtl_0_scl_i),
        .T(iic_rtl_0_scl_t));
  IOBUF iic_rtl_0_sda_iobuf
       (.I(iic_rtl_0_sda_o),
        .IO(iic_rtl_0_sda_io),
        .O(iic_rtl_0_sda_i),
        .T(iic_rtl_0_sda_t));
  IOBUF iic_rtl_1_scl_iobuf
       (.I(iic_rtl_1_scl_o),
        .IO(iic_rtl_1_scl_io),
        .O(iic_rtl_1_scl_i),
        .T(iic_rtl_1_scl_t));
  IOBUF iic_rtl_1_sda_iobuf
       (.I(iic_rtl_1_sda_o),
        .IO(iic_rtl_1_sda_io),
        .O(iic_rtl_1_sda_i),
        .T(iic_rtl_1_sda_t));
  IOBUF iic_rtl_2_scl_iobuf
       (.I(iic_rtl_2_scl_o),
        .IO(iic_rtl_2_scl_io),
        .O(iic_rtl_2_scl_i),
        .T(iic_rtl_2_scl_t));
  IOBUF iic_rtl_2_sda_iobuf
       (.I(iic_rtl_2_sda_o),
        .IO(iic_rtl_2_sda_io),
        .O(iic_rtl_2_sda_i),
        .T(iic_rtl_2_sda_t));
  IOBUF iic_rtl_3_scl_iobuf
       (.I(iic_rtl_3_scl_o),
        .IO(iic_rtl_3_scl_io),
        .O(iic_rtl_3_scl_i),
        .T(iic_rtl_3_scl_t));
  IOBUF iic_rtl_3_sda_iobuf
       (.I(iic_rtl_3_sda_o),
        .IO(iic_rtl_3_sda_io),
        .O(iic_rtl_3_sda_i),
        .T(iic_rtl_3_sda_t));
  IOBUF iic_rtl_4_scl_iobuf
       (.I(iic_rtl_4_scl_o),
        .IO(iic_rtl_4_scl_io),
        .O(iic_rtl_4_scl_i),
        .T(iic_rtl_4_scl_t));
  IOBUF iic_rtl_4_sda_iobuf
       (.I(iic_rtl_4_sda_o),
        .IO(iic_rtl_4_sda_io),
        .O(iic_rtl_4_sda_i),
        .T(iic_rtl_4_sda_t));
  IOBUF iic_rtl_5_scl_iobuf
       (.I(iic_rtl_5_scl_o),
        .IO(iic_rtl_5_scl_io),
        .O(iic_rtl_5_scl_i),
        .T(iic_rtl_5_scl_t));
  IOBUF iic_rtl_5_sda_iobuf
       (.I(iic_rtl_5_sda_o),
        .IO(iic_rtl_5_sda_io),
        .O(iic_rtl_5_sda_i),
        .T(iic_rtl_5_sda_t));
  IOBUF qwiic_rtl_0_scl_iobuf
       (.I(qwiic_rtl_0_scl_o),
        .IO(qwiic_rtl_0_scl_io),
        .O(qwiic_rtl_0_scl_i),
        .T(qwiic_rtl_0_scl_t));
  IOBUF qwiic_rtl_0_sda_iobuf
       (.I(qwiic_rtl_0_sda_o),
        .IO(qwiic_rtl_0_sda_io),
        .O(qwiic_rtl_0_sda_i),
        .T(qwiic_rtl_0_sda_t));
  IOBUF qwiic_rtl_1_scl_iobuf
       (.I(qwiic_rtl_1_scl_o),
        .IO(qwiic_rtl_1_scl_io),
        .O(qwiic_rtl_1_scl_i),
        .T(qwiic_rtl_1_scl_t));
  IOBUF qwiic_rtl_1_sda_iobuf
       (.I(qwiic_rtl_1_sda_o),
        .IO(qwiic_rtl_1_sda_io),
        .O(qwiic_rtl_1_sda_i),
        .T(qwiic_rtl_1_sda_t));
  IOBUF qwiic_rtl_2_scl_iobuf
       (.I(qwiic_rtl_2_scl_o),
        .IO(qwiic_rtl_2_scl_io),
        .O(qwiic_rtl_2_scl_i),
        .T(qwiic_rtl_2_scl_t));
  IOBUF qwiic_rtl_2_sda_iobuf
       (.I(qwiic_rtl_2_sda_o),
        .IO(qwiic_rtl_2_sda_io),
        .O(qwiic_rtl_2_sda_i),
        .T(qwiic_rtl_2_sda_t));
  IOBUF usb_smbus_rtl_0_scl_iobuf
       (.I(usb_smbus_rtl_0_scl_o),
        .IO(usb_smbus_rtl_0_scl_io),
        .O(usb_smbus_rtl_0_scl_i),
        .T(usb_smbus_rtl_0_scl_t));
  IOBUF usb_smbus_rtl_0_sda_iobuf
       (.I(usb_smbus_rtl_0_sda_o),
        .IO(usb_smbus_rtl_0_sda_io),
        .O(usb_smbus_rtl_0_sda_i),
        .T(usb_smbus_rtl_0_sda_t));
endmodule
