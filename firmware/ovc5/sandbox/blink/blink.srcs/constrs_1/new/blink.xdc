set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]

set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

set_property PACKAGE_PIN AF13 [get_ports {led_n}]
set_property IOSTANDARD LVCMOS12 [get_ports {led_n}]

set_property PACKAGE_PIN AH6 [get_ports {clk100_p}]
set_property PACKAGE_PIN AJ6 [get_ports {clk100_n}]

set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports {clk100_p}]
set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports {clk100_n}]

create_clock -period 10 [get_ports clk100_p]