#derive_pll_clocks -create_base_clocks
#derive_clock_uncertainty

create_generated_clock -name cam_clk_0 -source [get_pins {cam_pll|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] [get_ports cam_clk[0]]
create_generated_clock -name cam_clk_1 -source [get_pins {cam_pll|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] [get_ports cam_clk[1]]

#create_clock -name cam_virt_dclk_0 -period 4
#create_clock -name cam_virt_dclk_1 -period 4

#create_clock -name cam_dclk_0 -period 4 [get_ports { cam_dclk[0] }];
#create_clock -name cam_dclk_1 -period 4 [get_ports { cam_dclk[1] }];

#create_generated_clock -name cam_dclk_0_90 -source [get_pins 

#set clk125 qsys_inst|pcie_cv_hip_avmm_0|c5_hip_ast|altpcie_av_hip_ast_hwtcl|altpcie_av_hip_128bit_atom|g_cavhip.arriav_hd_altpe2_hip_top|coreclkout

#create_clock -name virt_cam_0_dclk -period 4

set_false_path -to top:top_inst|s:cam_0_rxd_align_pcie_s_r|d_d1[*]
set_false_path -to top:top_inst|s:cam_1_rxd_align_pcie_s_r|d_d1[*]

set_false_path -to top:top_inst|s:sync_s_r|d_d1[*]

set_false_path -to top:top_inst|s:cam_0_rxd_s_r|d_d1[*]
set_false_path -to top:top_inst|s:cam_1_rxd_s_r|d_d1[*]

set_false_path -to top:top_inst|s:cam_0_fv_clk125_r|d_d1[*]
#set_false_path -to top:top_inst|s:cam_1_fv_clk125_r|d_d1[*]

set_false_path -to top_inst|cam_0_cap_en_rxc_s|d_d1[*]
set_false_path -to top_inst|cam_1_cap_en_rxc_s|d_d1[*]

set_false_path -to top:top_inst|s:imu_miso_s_r|d_d1[*]
set_false_path -to top:top_inst|s:imu_sync_s_r|d_d1[*]

set_false_path -to top_inst|cam_miso_s_r|d_d1[*]

set_false_path -to cam_clk_gpio_oe_s|d_d1[*]

#set_false_path -from [get_keepers cam_fifo_aclr] -to [get_keepers *dcfifo*]

set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[*].rst_in_c_r|d_d1[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[1].rst_in_c_r|d_d1[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[2].rst_in_c_r|d_d1[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[3].rst_in_c_r|d_d1[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[3].rst_in_c_r|d_d1[*]
set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[*].flush_oneshot_r|shift_r|ff|q[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[1].flush_oneshot_r|shift_r|q[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[2].flush_oneshot_r|shift_r|q[*]
#set_false_path -to top_inst|dma_writer_mux_inst|gen_fifos[3].flush_oneshot_r|shift_r|q[*]

set_false_path -to top_inst|metadata_inst|img_0_rst_r|d_d1[*]
#set_false_path -to top_inst|metadata_inst|img_1_rst_r|d_d1[*]
set_false_path -to top_inst|metadata_inst|stats_roi_s_r|d_d1[*]
set_false_path -to top_inst|metadata_inst|img_0_sum_s_r|d_d1[*]

set_false_path -to top_inst|metadata_inst|sig_0_sig_r|d_d1[*]
#set_false_path -to top:top_inst|s:sig_1_rst_r|d_d1[*]

set_false_path -to top_inst|metadata_inst|corner_cnt_r|d_d1[*]
#set_false_path -to top:top_inst|corners:corners_inst|ast_detector:cd1|s:corner_count_r|d_d1[*]

set_false_path -to top_inst|cd0|t_r|d_d1[*]
set_false_path -to top_inst|cd1|t_r|d_d1[*]

set_false_path -from [get_ports {pcie_perst}]

#create_clock -period 20 -name imu_clk_virt
#set_input_delay -clock imu_clk_virt -max  10.0 [get_ports {imu_miso imu_sync_out}]
#set_input_delay -clock imu_clk_virt -min -10.0 [get_ports {imu_miso imu_sync_out}]

#set mainclk qsys_inst|pcie_cv_hip_avmm_0|c5_hip_ast|altpcie_av_hip_ast_hwtcl|altpcie_av_hip_128bit_atom|g_cavhip.arriav_hd_altpe2_hip_top|coreclkout
#set_output_delay -clock $mainclk -min 0.0 [get_ports {imu_cs imu_sck imu_mosi}]
#set_output_delay -clock $mainclk -max 0.0 [get_ports {imu_cs imu_sck imu_mosi}]
set_false_path -to [get_ports {led_ci led_di}]
set_false_path -to [get_ports {aux[*]}]

# these interfaces are so slow we'll just forget about them timing-wise.
set_false_path -to [get_ports {cam_cs[*]}]
set_false_path -to [get_ports {cam_sck[*]}]
set_false_path -to [get_ports {cam_mosi[*]}]
set_false_path -to [get_ports {cam_trigger[*]}]
set_false_path -to [get_ports {cam_rst[*]}]

set_false_path -to [get_ports {imu_cs}]
set_false_path -to [get_ports {imu_mosi}]
set_false_path -to [get_ports {imu_sck}]
set_false_path -to [get_ports {imu_rst}]

# output phase of the camera clocks doesn't matter
set_false_path -to [get_ports {cam_clk[*]}]
set_false_path -to [get_ports {cam_clk[*](n)}]
