set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]

set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

set_property PACKAGE_PIN AF13 [get_ports led_n]
set_property IOSTANDARD LVCMOS12 [get_ports led_n]

set_property PACKAGE_PIN AH6 [get_ports clk100_p]
set_property PACKAGE_PIN AJ6 [get_ports clk100_n]

set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports clk100_p]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports clk100_n]

create_clock -period 10.000 [get_ports clk100_p]

set_property PACKAGE_PIN L7 [get_ports gt_refclk_n]
set_property PACKAGE_PIN L8 [get_ports gt_refclk_p]


set_property PACKAGE_PIN J4 [get_ports sfp_rxp]
set_property PACKAGE_PIN J3 [get_ports sfp_rxn]
set_property PACKAGE_PIN K6 [get_ports sfp_txp]
set_property PACKAGE_PIN K5 [get_ports sfp_txn]

set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks clk100_p]

# for now, we're only deriving the async reset this way. TODO: make this more granular
set_clock_groups -asynchronous -group [get_clocks clk100_p] -group [get_clocks enet_10g_tx_clk]

# io0 is A15..A54
# io1 is partly C105..C140
# io3 and io4 are pmod since VCC_IO_A is currently 3v3
# io3 and io4 are A64..A87
#
# FPGA banks 45 and 46 are HD banks which means they can only go up to 125 MHz
# these become IO_BN_* and IO_BO_* on the module pin naming convention
# HP banks are banks IO_B64_*, IO_B65_*, and IO_B66_* and can go to many hundreds of MHz
#
# so higher-speed (>125 MHz) GPIO is only possible on these module pins:
# Y1   (bank 66) = C128 = IO1_D16_P = IO1 connector pin 11 (row 6)
# AD12 (bank 66) = C130 = IO1_D17_N = IO1 connector pin 12 (row 6)
# AD9  (bank 66) = C132 = IO1_D14_P = IO1 connector pin 15 (row 8)
# AE7  (bank 66) = C134 = IO1_D15_N = IO1 connector pin 16 (row 8)
# AE3  (bank 66) = C138 = IO1_D12_P = IO1 connector pin 17 (row 9)
# AE2  (bank 66) = C140 = IO1_D13_N = IO1 connector pin 18 (row 9)
#set_property PACKAGE_PIN Y1 [get_ports clk156_out_pin]
#set_property IOSTANDARD LVCMOS12 [get_ports clk156_out_pin]

set_property PACKAGE_PIN K15 [get_ports IIC_1_0_scl_io]
set_property PACKAGE_PIN K14 [get_ports IIC_1_0_sda_io]
set_property PACKAGE_PIN AE2 [get_ports {reset[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_1_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports IIC_1_0_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports {reset[0]}]
