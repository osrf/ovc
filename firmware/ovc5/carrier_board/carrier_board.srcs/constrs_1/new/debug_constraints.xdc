

connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/v_tpg_0/m_axis_video_TDATA[0]} {design_1_i/v_tpg_0/m_axis_video_TDATA[1]} {design_1_i/v_tpg_0/m_axis_video_TDATA[2]} {design_1_i/v_tpg_0/m_axis_video_TDATA[3]} {design_1_i/v_tpg_0/m_axis_video_TDATA[4]} {design_1_i/v_tpg_0/m_axis_video_TDATA[5]} {design_1_i/v_tpg_0/m_axis_video_TDATA[6]} {design_1_i/v_tpg_0/m_axis_video_TDATA[7]} {design_1_i/v_tpg_0/m_axis_video_TDATA[8]} {design_1_i/v_tpg_0/m_axis_video_TDATA[9]} {design_1_i/v_tpg_0/m_axis_video_TDATA[10]} {design_1_i/v_tpg_0/m_axis_video_TDATA[11]} {design_1_i/v_tpg_0/m_axis_video_TDATA[12]} {design_1_i/v_tpg_0/m_axis_video_TDATA[13]} {design_1_i/v_tpg_0/m_axis_video_TDATA[14]} {design_1_i/v_tpg_0/m_axis_video_TDATA[15]} {design_1_i/v_tpg_0/m_axis_video_TDATA[16]} {design_1_i/v_tpg_0/m_axis_video_TDATA[17]} {design_1_i/v_tpg_0/m_axis_video_TDATA[18]} {design_1_i/v_tpg_0/m_axis_video_TDATA[19]} {design_1_i/v_tpg_0/m_axis_video_TDATA[20]} {design_1_i/v_tpg_0/m_axis_video_TDATA[21]} {design_1_i/v_tpg_0/m_axis_video_TDATA[22]} {design_1_i/v_tpg_0/m_axis_video_TDATA[23]} {design_1_i/v_tpg_0/m_axis_video_TDATA[24]} {design_1_i/v_tpg_0/m_axis_video_TDATA[25]} {design_1_i/v_tpg_0/m_axis_video_TDATA[26]} {design_1_i/v_tpg_0/m_axis_video_TDATA[27]} {design_1_i/v_tpg_0/m_axis_video_TDATA[28]} {design_1_i/v_tpg_0/m_axis_video_TDATA[29]} {design_1_i/v_tpg_0/m_axis_video_TDATA[30]} {design_1_i/v_tpg_0/m_axis_video_TDATA[31]} {design_1_i/v_tpg_0/m_axis_video_TDATA[32]} {design_1_i/v_tpg_0/m_axis_video_TDATA[33]} {design_1_i/v_tpg_0/m_axis_video_TDATA[34]} {design_1_i/v_tpg_0/m_axis_video_TDATA[35]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/v_tpg_0/m_axis_video_TLAST[0]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/v_tpg_0/m_axis_video_TKEEP[0]} {design_1_i/v_tpg_0/m_axis_video_TKEEP[1]} {design_1_i/v_tpg_0/m_axis_video_TKEEP[2]} {design_1_i/v_tpg_0/m_axis_video_TKEEP[3]} {design_1_i/v_tpg_0/m_axis_video_TKEEP[4]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {design_1_i/v_tpg_0/m_axis_video_TUSER[0]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list design_1_i/v_tpg_0/m_axis_video_TREADY]]
connect_debug_port u_ila_0/probe8 [get_nets [list design_1_i/v_tpg_0/m_axis_video_TVALID]]

set_property PACKAGE_PIN K15 [get_ports iic_rtl_0_scl_io]
set_property PACKAGE_PIN K14 [get_ports iic_rtl_0_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports iic_rtl_0_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports iic_rtl_0_sda_io]





set_property PACKAGE_PIN H16 [get_ports {I2C_MIPI_SEL[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {I2C_MIPI_SEL[0]}]

set_property PACKAGE_PIN H16 [get_ports {I2C_MIPI_SEL_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {I2C_MIPI_SEL_tri_io[0]}]

connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[0]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[1]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[2]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[3]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[4]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[5]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[6]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[7]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[8]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[9]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[10]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[11]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[12]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[13]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[14]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[15]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[16]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[17]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[18]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[19]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[20]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[21]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[22]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[23]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[24]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[25]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[26]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[27]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[28]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[29]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[30]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[31]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[32]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[33]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[34]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[35]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[36]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[37]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[38]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[39]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[40]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[41]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[42]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[43]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[44]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[45]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[46]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[47]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[48]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[49]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[50]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[51]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[52]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[53]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[54]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[55]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[56]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[57]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[58]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[59]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[60]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[61]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[62]} {design_1_i/axi_vdma_0/s_axis_s2mm_tdata[63]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[0]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[1]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[2]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[3]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[4]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[5]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[6]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[7]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[8]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[9]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[10]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[11]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[12]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[13]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[14]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[15]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[16]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[17]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[18]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[19]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[20]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[21]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[22]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[23]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[24]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[25]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[26]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[27]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[28]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[29]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[30]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[31]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[32]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[33]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[34]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[35]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[36]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[37]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[38]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[39]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[40]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[41]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[42]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[43]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[44]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[45]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[46]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[47]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[48]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[49]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[50]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[51]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[52]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[53]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[54]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[55]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[56]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[57]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[58]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[59]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[60]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[61]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[62]} {design_1_i/axi_vdma_0/m_axi_s2mm_wdata[63]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/axi_vdma_0/m_axi_s2mm_wlast]]
connect_debug_port u_ila_0/probe3 [get_nets [list design_1_i/axi_vdma_0/m_axi_s2mm_wvalid]]
connect_debug_port u_ila_0/probe4 [get_nets [list design_1_i/axi_vdma_0/s2mm_introut]]
connect_debug_port u_ila_0/probe5 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tlast]]
connect_debug_port u_ila_0/probe6 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tready]]
connect_debug_port u_ila_0/probe7 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tvalid]]

connect_debug_port u_ila_0/probe0 [get_nets [list design_1_i/axi_dma_0/m_axi_s2mm_wlast]]
connect_debug_port u_ila_0/probe1 [get_nets [list design_1_i/axi_dma_0/m_axi_sg_rvalid]]
connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/axi_dma_0/s_axis_s2mm_tvalid]]
connect_debug_port u_ila_0/probe3 [get_nets [list design_1_i/axi_dma_0/s_axis_s2mm_tlast]]

connect_debug_port u_ila_0/probe0 [get_nets [list design_1_i/axi_vdma_0/m_axi_s2mm_wlast]]
connect_debug_port u_ila_0/probe1 [get_nets [list design_1_i/axi_vdma_0/m_axi_s2mm_wready]]
connect_debug_port u_ila_0/probe2 [get_nets [list design_1_i/axi_vdma_0/m_axi_s2mm_wvalid]]
connect_debug_port u_ila_0/probe3 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tvalid]]
connect_debug_port u_ila_0/probe4 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tready]]
connect_debug_port u_ila_0/probe5 [get_nets [list design_1_i/axi_vdma_0/s_axis_s2mm_tlast]]







set_property PACKAGE_PIN E17 [get_ports {TRIG0[0]}]
set_property PACKAGE_PIN J15 [get_ports {TRIG1[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TRIG0[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TRIG1[0]}]
set_property SLEW SLOW [get_ports {TRIG0[0]}]
set_property SLEW SLOW [get_ports {TRIG1[0]}]


connect_debug_port u_ila_0/probe0 [get_nets [list {design_1_i/hdr_tvalid_0/Res[0]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {design_1_i/nonhdr_tvalid_0/Res[0]}]]

