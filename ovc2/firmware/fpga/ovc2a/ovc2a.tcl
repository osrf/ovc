set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name FAMILY "Cyclone 10 GX"
set_global_assignment -name DEVICE 10CX220YF672E6G
set_global_assignment -name TOP_LEVEL_ENTITY ovc
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 18.0.0
#set_global_assignment -name PROJECT_CREATION_TIME_DATE "23:27:27  OCTOBER 28, 2017"
set_global_assignment -name LAST_QUARTUS_VERSION "18.0.0 Pro Edition"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 672
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH STILL AIR"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_global_assignment -name POWER_AUTO_COMPUTE_TJ ON
set_global_assignment -name GENERATE_RBF_FILE ON
#set_global_assignment -name VERILOG_FILE placement.v

set_location_assignment PIN_AB8 -to pcie_perst
set_location_assignment PIN_N22 -to pcie_refclk
set_location_assignment PIN_N21 -to "pcie_refclk(n)"
set_location_assignment PIN_T24 -to pcie_rx[0]
set_location_assignment PIN_U26 -to pcie_tx[0]
set_location_assignment PIN_P24 -to pcie_rx[1]
set_location_assignment PIN_R26 -to pcie_tx[1]
set_location_assignment PIN_M24 -to pcie_rx[2]
set_location_assignment PIN_N26 -to pcie_tx[2]
set_location_assignment PIN_K24 -to pcie_rx[3]
set_location_assignment PIN_L26 -to pcie_tx[3]

set_instance_assignment -name XCVR_REFCLK_PIN_TERMINATION AC_COUPLING -to pcie_refclk

set_instance_assignment -name IO_STANDARD HCSL -to pcie_refclk
set_instance_assignment -name IO_STANDARD "1.8 V" -to pcie_perst
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to pcie_rx
set_instance_assignment -name IO_STANDARD "HSSI DIFFERENTIAL I/O" -to pcie_tx

set_location_assignment PIN_M1 -to aux[0]
set_location_assignment PIN_N1 -to aux[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to aux
set_instance_assignment -name SLEW_RATE 0 -to aux

set_location_assignment PIN_AC13 -to clk100
set_global_assignment -name AUTO_RESERVE_CLKUSR_FOR_CALIBRATION OFF
set_instance_assignment -name IO_STANDARD "1.8 V" -to clk100

set_location_assignment PIN_E21 -to cam_clk[0]
set_location_assignment PIN_C17 -to cam_dclk[0]
set_location_assignment PIN_C16 -to "cam_dclk[0](n)"
set_location_assignment PIN_C11 -to cam_sync[0]
set_location_assignment PIN_C12 -to "cam_sync[0](n)"
set_location_assignment PIN_C21 -to cam_dout[0]
set_location_assignment PIN_C20 -to "cam_dout[0](n)"
set_location_assignment PIN_D19 -to cam_dout[1]
set_location_assignment PIN_E19 -to "cam_dout[1](n)"
set_location_assignment PIN_B15 -to cam_dout[2]
set_location_assignment PIN_B13 -to cam_dout[3]
set_location_assignment PIN_C7 -to cam_rst[0]
set_location_assignment PIN_D7 -to cam_cs[0]
set_location_assignment PIN_E9 -to cam_sck[0]
set_location_assignment PIN_D8 -to cam_mosi[0]
set_location_assignment PIN_G3 -to cam_miso[0]
set_location_assignment PIN_D4 -to cam_trigger[0]

set_location_assignment PIN_AF11 -to cam_clk[1]
set_location_assignment PIN_AF19 -to cam_dclk[1]
set_location_assignment PIN_AF14 -to cam_sync[1]
set_location_assignment PIN_AF18 -to cam_dout[4]
set_location_assignment PIN_AF16 -to cam_dout[5]
set_location_assignment PIN_AE17 -to cam_dout[6]
set_location_assignment PIN_AD14 -to cam_dout[7]
set_location_assignment PIN_AF7 -to cam_rst[1]
set_location_assignment PIN_AE7 -to cam_cs[1]
set_location_assignment PIN_AE6 -to cam_sck[1]
set_location_assignment PIN_AF6 -to cam_mosi[1]
set_location_assignment PIN_AD8 -to cam_miso[1]
set_location_assignment PIN_AF8 -to cam_trigger[1]

set_instance_assignment -name IO_STANDARD LVDS -to cam_clk[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_dclk[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_dout[*]
set_instance_assignment -name IO_STANDARD LVDS -to cam_sync[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_rst[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_cs[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_sck[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_mosi[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_miso[*]
set_instance_assignment -name IO_STANDARD "1.8 V" -to cam_trigger[*]

set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_dclk[*]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_dout[*]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to cam_sync[*]

set_instance_assignment -name SLEW_RATE 0 -to cam_rst[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_cs[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_sck[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_mosi[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_miso[*]
set_instance_assignment -name SLEW_RATE 0 -to cam_trigger[*]

##################################

set_location_assignment PIN_C3 -to imu_rst
set_location_assignment PIN_C6 -to imu_cs
set_location_assignment PIN_E5 -to imu_sck
set_location_assignment PIN_F4 -to imu_miso
set_location_assignment PIN_D5 -to imu_mosi
set_location_assignment PIN_E4 -to imu_sync_in
set_location_assignment PIN_H2 -to imu_sync_out
set_instance_assignment -name IO_STANDARD "1.8 V" -to imu_*
set_instance_assignment -name SLEW_RATE 0 -to imu_rst
set_instance_assignment -name SLEW_RATE 0 -to imu_cs
set_instance_assignment -name SLEW_RATE 0 -to imu_sck
set_instance_assignment -name SLEW_RATE 0 -to imu_mosi

##################################

set_location_assignment PIN_D3 -to led_ci
set_location_assignment PIN_D2 -to led_di
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_*
set_instance_assignment -name SLEW_RATE 0 -to led_*

##################################

set_global_assignment -name ENABLE_OCT_DONE OFF
set_global_assignment -name ENABLE_AUTONOMOUS_PCIE_HIP OFF
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE SERIAL"
set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
#set_global_assignment -name CVP_MODE "CORE INITIALIZATION AND UPDATE"
#set_global_assignment -name ENABLE_CVP_CONFDONE ON
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name VCCPGM_USER_VOLTAGE 1.8V
set_global_assignment -name VCCBAT_USER_VOLTAGE 1.8V
set_global_assignment -name VCCE_GXBL_USER_VOLTAGE 1.03V
set_global_assignment -name VCCE_GXBR_USER_VOLTAGE 1.03V
set_global_assignment -name VCCL_GXBL_USER_VOLTAGE 1.03V
set_global_assignment -name VCCL_GXBR_USER_VOLTAGE 1.03V
set_global_assignment -name CONFIGURATION_VCCIO_LEVEL 1.8V
set_global_assignment -name SDC_FILE ovc2a.sdc
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION ON
#set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
#set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

#set_global_assignment -name QIP_FILE cam_pll.qip
#set_global_assignment -name SIP_FILE cam_pll.sip
#set_global_assignment -name QIP_FILE cam_rx.qip
set_global_assignment -name QIP_FILE platform/platform.qip
