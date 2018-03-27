set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CGTFD5C5U19C7
set_global_assignment -name TOP_LEVEL_ENTITY ovc
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 17.0.2
set_global_assignment -name PROJECT_CREATION_TIME_DATE "23:27:27  OCTOBER 28, 2017"
set_global_assignment -name LAST_QUARTUS_VERSION "17.1.0 Lite Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name DEVICE_FILTER_PACKAGE UFBGA
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 484
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
#set_global_assignment -name VERILOG_FILE placement.v
set_instance_assignment -name IO_STANDARD "2.5 V" -to pcie_perst
set_location_assignment PIN_R17 -to pcie_perst
set_location_assignment PIN_V4 -to pcie_refclk
set_location_assignment PIN_U4 -to "pcie_refclk(n)"
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_refclk
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_rx[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_rx[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_rx[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_rx[0]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_tx[3]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_tx[2]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_tx[1]
set_instance_assignment -name IO_STANDARD "1.5-V PCML" -to pcie_tx[0]
set_location_assignment PIN_AA2 -to pcie_rx[0]
set_location_assignment PIN_Y4 -to pcie_tx[0]
set_location_assignment PIN_W2 -to pcie_rx[1]
set_location_assignment PIN_U2 -to pcie_tx[1]
set_location_assignment PIN_R2 -to pcie_rx[2]
set_location_assignment PIN_N2 -to pcie_tx[2]
set_location_assignment PIN_L2 -to pcie_rx[3]
set_location_assignment PIN_J2 -to pcie_tx[3]
set_location_assignment PIN_U22 -to aux[0]
set_location_assignment PIN_U21 -to aux[1]
set_location_assignment PIN_T22 -to aux[2]
set_location_assignment PIN_J21 -to aux[3]
set_location_assignment PIN_G22 -to aux[4]
set_location_assignment PIN_G21 -to aux[5]
set_location_assignment PIN_D22 -to aux[6]
set_location_assignment PIN_E21 -to aux[7]
set_location_assignment PIN_L17 -to clk100
set_location_assignment PIN_AB16 -to cam_clk[0]
#set_location_assignment PIN_AB15 -to "cam_clk[0](n)"
set_location_assignment PIN_P9 -to cam_dclk[0]
set_location_assignment PIN_R9 -to "cam_dclk[0](n)"
set_location_assignment PIN_N10 -to cam_sync[0]
set_location_assignment PIN_N9 -to "cam_sync[0](n)"
set_location_assignment PIN_V9 -to cam_dout[0]
set_location_assignment PIN_U8 -to "cam_dout[0](n)"
set_location_assignment PIN_Y9 -to cam_dout[1]
set_location_assignment PIN_AA9 -to "cam_dout[1](n)"
set_location_assignment PIN_R10 -to cam_dout[2]
set_location_assignment PIN_U11 -to cam_dout[3]
set_location_assignment PIN_AB18 -to cam_rst[0]
set_location_assignment PIN_AA18 -to cam_cs[0]
set_location_assignment PIN_AA20 -to cam_sck[0]
set_location_assignment PIN_AB20 -to cam_mosi[0]
set_location_assignment PIN_AA17 -to cam_miso[0]
set_location_assignment PIN_AB17 -to cam_trigger[0]

set_location_assignment PIN_A8 -to cam_clk[1]
#set_location_assignment PIN_A7 -to "cam_clk[1](n)"
set_location_assignment PIN_G10 -to cam_dclk[1]
set_location_assignment PIN_H6 -to cam_sync[1]
set_location_assignment PIN_D11 -to cam_dout[4]
set_location_assignment PIN_C10 -to cam_dout[5]
set_location_assignment PIN_D9 -to cam_dout[6]
set_location_assignment PIN_H8 -to cam_dout[7]
set_location_assignment PIN_A18 -to cam_rst[1]
set_location_assignment PIN_A17 -to cam_cs[1]
set_location_assignment PIN_A13 -to cam_sck[1]
set_location_assignment PIN_A15 -to cam_mosi[1]
set_location_assignment PIN_A14 -to cam_miso[1]
set_location_assignment PIN_A19 -to cam_trigger[1]

set_location_assignment PIN_Y20 -to imu_rst
set_location_assignment PIN_W21 -to imu_cs
set_location_assignment PIN_AA22 -to imu_sck
set_location_assignment PIN_Y22 -to imu_miso
set_location_assignment PIN_Y21 -to imu_mosi
set_location_assignment PIN_W22 -to imu_sync_in
set_location_assignment PIN_AB22 -to imu_sync_out
set_location_assignment PIN_AB21 -to imu_tare

set_location_assignment PIN_A9 -to led[0]
set_location_assignment PIN_A10 -to led[1]
set_instance_assignment -name IO_STANDARD "2.5 V" -to led[*]
set_instance_assignment -name SLEW_RATE 0 -to led[*]

set_instance_assignment -name IO_STANDARD LVDS -to cam_clk[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_dclk[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_dout[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_sync[*]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_dclk[*]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_dout[*]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_sync[*]

set_instance_assignment -name IO_STANDARD "2.5 V" -to aux[*]
set_instance_assignment -name SLEW_RATE 0 -to aux[*]

set_instance_assignment -name IO_STANDARD "2.5 V" -to clk100
set_instance_assignment -name IO_STANDARD "2.5 V" -to imu_*
set_instance_assignment -name SLEW_RATE 0 -to imu_rst
set_instance_assignment -name SLEW_RATE 0 -to imu_cs
set_instance_assignment -name SLEW_RATE 0 -to imu_sck
set_instance_assignment -name SLEW_RATE 0 -to imu_mosi

set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_rst[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_rst[*]
set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_cs[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_cs[*]
set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_sck[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_sck[*]
set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_mosi[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_mosi[*]
set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_miso[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_miso[*]
set_instance_assignment -name IO_STANDARD "2.5 V" -to cam_trigger[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_trigger[*]

set_global_assignment -name ENABLE_OCT_DONE OFF
set_global_assignment -name ENABLE_AUTONOMOUS_PCIE_HIP OFF
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE SERIAL"
set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
set_global_assignment -name CVP_MODE "CORE INITIALIZATION AND UPDATE"
set_global_assignment -name ENABLE_CVP_CONFDONE ON
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name VCCPGM_USER_VOLTAGE 2.5V
set_global_assignment -name VCCBAT_USER_VOLTAGE 2.5V
set_global_assignment -name VCCE_GXBL_USER_VOLTAGE 1.2V
set_global_assignment -name VCCE_GXBR_USER_VOLTAGE 1.2V
set_global_assignment -name VCCL_GXBL_USER_VOLTAGE 1.2V
set_global_assignment -name VCCL_GXBR_USER_VOLTAGE 1.2V
set_global_assignment -name CONFIGURATION_VCCIO_LEVEL 2.5V
set_global_assignment -name SDC_FILE ovc.sdc
set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
#set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

#set_global_assignment -name QIP_FILE cam_pll.qip
#set_global_assignment -name SIP_FILE cam_pll.sip
#set_global_assignment -name QIP_FILE cam_rx.qip
set_global_assignment -name QIP_FILE ovc_qsys/synthesis/ovc_qsys.qip
