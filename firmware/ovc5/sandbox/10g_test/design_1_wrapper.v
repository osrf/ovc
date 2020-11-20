//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
//Date        : Mon Nov  2 13:39:44 2020
//Host        : leds3 running 64-bit Ubuntu 18.04.3 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (output mipi_phy_if_0_clk_n,
    output mipi_phy_if_0_clk_p,
    output [1:0] mipi_phy_if_0_data_n,
    output [1:0] mipi_phy_if_0_data_p,
    input mipi_phy_if_1_clk_n,
    input mipi_phy_if_1_clk_p,
    input [1:0] mipi_phy_if_1_data_n,
    input [1:0] mipi_phy_if_1_data_p,
    input clk100_p,
    input clk100_n,
    input gt_refclk_p,
    input gt_refclk_n,
    input sfp_rxp,
    input sfp_rxn,
    output sfp_txp,
    output sfp_txn,
    output led_n);
    
    // only for sanity check: output clk156_out_pin);
  /*
  output mipi_phy_if_0_clk_n;
  output mipi_phy_if_0_clk_p;
  output [1:0]mipi_phy_if_0_data_n;
  output [1:0]mipi_phy_if_0_data_p;
  input mipi_phy_if_1_clk_n;
  input mipi_phy_if_1_clk_p;
  input [1:0]mipi_phy_if_1_data_n;
  input [1:0]mipi_phy_if_1_data_p;

  wire mipi_phy_if_0_clk_n;
  wire mipi_phy_if_0_clk_p;
  wire [1:0]mipi_phy_if_0_data_n;
  wire [1:0]mipi_phy_if_0_data_p;
  wire mipi_phy_if_1_clk_n;
  wire mipi_phy_if_1_clk_p;
  wire [1:0]mipi_phy_if_1_data_n;
  wire [1:0]mipi_phy_if_1_data_p;
  */
  
  /////////////////////////////////////////////////////////////////
  // bring in 100M clock
  wire clk100;
  IBUFDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("TRUE"),
    .IOSTANDARD("DIFF_SSTL12_DCI")
    ) clk100_buf (
        .I(clk100_p),
        .IB(clk100_n),
        .O(clk100)
    );

  /////////////////////////////////////////////////////////////////
  // block design instantiation
  wire bd_nreset;
  design_1 design_1_i
       (.mipi_phy_if_0_clk_n(mipi_phy_if_0_clk_n),
        .mipi_phy_if_0_clk_p(mipi_phy_if_0_clk_p),
        .mipi_phy_if_0_data_n(mipi_phy_if_0_data_n),
        .mipi_phy_if_0_data_p(mipi_phy_if_0_data_p),
        .mipi_phy_if_1_clk_n(mipi_phy_if_1_clk_n),
        .mipi_phy_if_1_clk_p(mipi_phy_if_1_clk_p),
        .mipi_phy_if_1_data_n(mipi_phy_if_1_data_n),
        .mipi_phy_if_1_data_p(mipi_phy_if_1_data_p),
        .reset(bd_nreset));

  /////////////////////////////////////////////////////////////////
  // 10G ethernet stuff
  wire gt_refclk_out;
  wire enet_10g_tx_clk;
  wire [63:0] enet_10g_rx_mii_d;
  wire [7:0] enet_10g_rx_mii_c;
  
  assign led_n = 1'b1;
  // buffer the reset with the 100m clock so it's easier to constrain
  reg reset_100;
  always @(posedge clk100)
    reset_100 <= ~bd_nreset;
    
  wire [63:0] xgmii_txd;
  wire [7:0] xgmii_txc;
  top top_inst(
    .clk(enet_10g_tx_clk),
    .rst(reset_100),  // todo: create 156M reset
    .write_rst(reset_100),
    .write_clk(clk100),
    .xgmii_c(xgmii_txc),
    .xgmii_d(xgmii_txd));
  
  xxv_ethernet_0 xxv_ethernet_0_i(
    .gt_refclk_p(gt_refclk_p),
    .gt_refclk_n(gt_refclk_n),
    .gt_refclk_out(gt_refclk_out),
    .gt_rxp_in_0(sfp_rxp),
    .gt_rxn_in_0(sfp_rxn),
    .gt_txp_out_0(sfp_txp),
    .gt_txn_out_0(sfp_txn),
    .qpllreset_in_0(reset_100),
    .sys_reset(reset_100),
    .dclk(clk100),
    .tx_mii_clk_0(enet_10g_tx_clk),
    .rx_reset_0(reset_100),
    .tx_reset_0(reset_100),
    .tx_mii_d_0(xgmii_txd),
    .tx_mii_c_0(xgmii_txc),
    .rx_core_clk_0(enet_10g_tx_clk),
    .rx_clk_out_0(),
    .gt_loopback_in_0(3'h0),
    .user_rx_reset_0(),  // output
    .rxrecclkout_0(),  // output: recovered RX clock
    .rx_mii_d_0(enet_10g_rx_mii_d),
    .rx_mii_c_0(enet_10g_rx_mii_c),
    .ctl_rx_test_pattern_0(1'b0),
    .ctl_rx_test_pattern_enable_0(1'b0),
    .ctl_rx_data_pattern_select_0(1'b0),
    .ctl_rx_prbs31_test_pattern_enable_0(1'b0),
    .stat_rx_block_lock_0(),
    .stat_rx_framing_err_valid_0(),
    .stat_rx_framing_err_0(),
    .stat_rx_hi_ber_0(),
    .stat_rx_valid_ctrl_code_0(),
    .stat_rx_bad_code_0(),
    .stat_rx_bad_code_valid_0(),
    .stat_rx_error_valid_0(),
    .stat_rx_error_0(),
    .stat_rx_fifo_error_0(),
    .stat_rx_local_fault_0(),
    .stat_rx_status_0(),
    .user_tx_reset_0(),
    .ctl_tx_test_pattern_0(1'b0),
    .ctl_tx_test_pattern_enable_0(1'b0),
    .ctl_tx_test_pattern_select_0(1'b0),
    .ctl_tx_data_pattern_select_0(1'b0),
    .ctl_tx_test_pattern_seed_a_0(58'h0),
    .ctl_tx_test_pattern_seed_b_0(58'h0),
    .ctl_tx_prbs31_test_pattern_enable_0(1'b0),
    .stat_tx_local_fault_0(),
    .gtwiz_reset_tx_datapath_0(reset_100),
    .gtwiz_reset_rx_datapath_0(reset_100),  // needs reset from optics signal detect 
    .gtpowergood_out_0(),  // output
    .txoutclksel_in_0(3'h5),
    .rxoutclksel_in_0(3'h5)
  );

/*
  /////////////////////////////////////////////////////////////////
  // 156M clocking sanity check
  ODDR #(
    .SRTYPE("ASYNC"),
    .DDR_CLK_EDGE("SAME_EDGE")
  ) clk156_oddr(
    .C(gt_refclk_out),
    //.C(clk100),
    .Q(clk156_out_pin),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );
*/

endmodule
