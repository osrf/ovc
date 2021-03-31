// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Fri Oct 23 14:42:05 2020
// Host        : feather5 running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/mquigley/hw/ovc/firmware/ovc5/sandbox/vivado_gui_project/sandbox.srcs/sources_1/ip/enet_pcs/enet_pcs_stub.v
// Design      : enet_pcs
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu4cg-fbvb900-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "xxv_ethernet_v3_2_0,Vivado 2020.1" *)
module enet_pcs(gt_rxp_in_0, gt_rxn_in_0, gt_txp_out_0, 
  gt_txn_out_0, tx_mii_clk_0, rx_core_clk_0, rx_clk_out_0, gt_loopback_in_0, rx_reset_0, 
  user_rx_reset_0, rxrecclkout_0, rx_mii_d_0, rx_mii_c_0, ctl_rx_test_pattern_0, 
  ctl_rx_test_pattern_enable_0, ctl_rx_data_pattern_select_0, 
  ctl_rx_prbs31_test_pattern_enable_0, stat_rx_block_lock_0, 
  stat_rx_framing_err_valid_0, stat_rx_framing_err_0, stat_rx_hi_ber_0, 
  stat_rx_valid_ctrl_code_0, stat_rx_bad_code_0, stat_rx_bad_code_valid_0, 
  stat_rx_error_valid_0, stat_rx_error_0, stat_rx_fifo_error_0, stat_rx_local_fault_0, 
  stat_rx_status_0, tx_reset_0, user_tx_reset_0, tx_mii_d_0, tx_mii_c_0, 
  ctl_tx_test_pattern_0, ctl_tx_test_pattern_enable_0, ctl_tx_test_pattern_select_0, 
  ctl_tx_data_pattern_select_0, ctl_tx_test_pattern_seed_a_0, 
  ctl_tx_test_pattern_seed_b_0, ctl_tx_prbs31_test_pattern_enable_0, 
  stat_tx_local_fault_0, gtwiz_reset_tx_datapath_0, gtwiz_reset_rx_datapath_0, 
  gtpowergood_out_0, txoutclksel_in_0, rxoutclksel_in_0, gt_refclk_p, gt_refclk_n, 
  gt_refclk_out, qpllreset_in_0, sys_reset, dclk)
/* synthesis syn_black_box black_box_pad_pin="gt_rxp_in_0,gt_rxn_in_0,gt_txp_out_0,gt_txn_out_0,tx_mii_clk_0,rx_core_clk_0,rx_clk_out_0,gt_loopback_in_0[2:0],rx_reset_0,user_rx_reset_0,rxrecclkout_0,rx_mii_d_0[63:0],rx_mii_c_0[7:0],ctl_rx_test_pattern_0,ctl_rx_test_pattern_enable_0,ctl_rx_data_pattern_select_0,ctl_rx_prbs31_test_pattern_enable_0,stat_rx_block_lock_0,stat_rx_framing_err_valid_0,stat_rx_framing_err_0,stat_rx_hi_ber_0,stat_rx_valid_ctrl_code_0,stat_rx_bad_code_0,stat_rx_bad_code_valid_0,stat_rx_error_valid_0,stat_rx_error_0[7:0],stat_rx_fifo_error_0,stat_rx_local_fault_0,stat_rx_status_0,tx_reset_0,user_tx_reset_0,tx_mii_d_0[63:0],tx_mii_c_0[7:0],ctl_tx_test_pattern_0,ctl_tx_test_pattern_enable_0,ctl_tx_test_pattern_select_0,ctl_tx_data_pattern_select_0,ctl_tx_test_pattern_seed_a_0[57:0],ctl_tx_test_pattern_seed_b_0[57:0],ctl_tx_prbs31_test_pattern_enable_0,stat_tx_local_fault_0,gtwiz_reset_tx_datapath_0,gtwiz_reset_rx_datapath_0,gtpowergood_out_0,txoutclksel_in_0[2:0],rxoutclksel_in_0[2:0],gt_refclk_p[0:0],gt_refclk_n[0:0],gt_refclk_out[0:0],qpllreset_in_0,sys_reset,dclk" */;
  input gt_rxp_in_0;
  input gt_rxn_in_0;
  output gt_txp_out_0;
  output gt_txn_out_0;
  output tx_mii_clk_0;
  input rx_core_clk_0;
  output rx_clk_out_0;
  input [2:0]gt_loopback_in_0;
  input rx_reset_0;
  output user_rx_reset_0;
  output rxrecclkout_0;
  output [63:0]rx_mii_d_0;
  output [7:0]rx_mii_c_0;
  input ctl_rx_test_pattern_0;
  input ctl_rx_test_pattern_enable_0;
  input ctl_rx_data_pattern_select_0;
  input ctl_rx_prbs31_test_pattern_enable_0;
  output stat_rx_block_lock_0;
  output stat_rx_framing_err_valid_0;
  output stat_rx_framing_err_0;
  output stat_rx_hi_ber_0;
  output stat_rx_valid_ctrl_code_0;
  output stat_rx_bad_code_0;
  output stat_rx_bad_code_valid_0;
  output stat_rx_error_valid_0;
  output [7:0]stat_rx_error_0;
  output stat_rx_fifo_error_0;
  output stat_rx_local_fault_0;
  output stat_rx_status_0;
  input tx_reset_0;
  output user_tx_reset_0;
  input [63:0]tx_mii_d_0;
  input [7:0]tx_mii_c_0;
  input ctl_tx_test_pattern_0;
  input ctl_tx_test_pattern_enable_0;
  input ctl_tx_test_pattern_select_0;
  input ctl_tx_data_pattern_select_0;
  input [57:0]ctl_tx_test_pattern_seed_a_0;
  input [57:0]ctl_tx_test_pattern_seed_b_0;
  input ctl_tx_prbs31_test_pattern_enable_0;
  output stat_tx_local_fault_0;
  input gtwiz_reset_tx_datapath_0;
  input gtwiz_reset_rx_datapath_0;
  output gtpowergood_out_0;
  input [2:0]txoutclksel_in_0;
  input [2:0]rxoutclksel_in_0;
  input [0:0]gt_refclk_p;
  input [0:0]gt_refclk_n;
  output [0:0]gt_refclk_out;
  input qpllreset_in_0;
  input sys_reset;
  input dclk;
endmodule
