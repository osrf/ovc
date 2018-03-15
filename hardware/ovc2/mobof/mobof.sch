EESchema Schematic File Version 4
LIBS:mobof-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 16
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 8800 900  1550 300 
U 590F56BE
F0 "jetson_power" 118
F1 "jetson_power.sch" 118
$EndSheet
$Sheet
S 8800 1750 1500 300 
U 59559720
F0 "jetson_pcie" 118
F1 "jetson_pcie.sch" 118
$EndSheet
$Sheet
S 3550 2500 1250 350 
U 596A6D90
F0 "power" 118
F1 "power.sch" 118
$EndSheet
$Sheet
S 8800 2450 1500 200 
U 5978A932
F0 "jetson_enet" 118
F1 "jetson_enet.sch" 118
$EndSheet
$Sheet
S 8800 3650 1500 200 
U 59814498
F0 "jetson_usb" 118
F1 "jetson_usb.sch" 59
$EndSheet
$Sheet
S 8800 4100 1500 200 
U 5983B367
F0 "jetson_jtag" 118
F1 "jetson_jtag.sch" 59
$EndSheet
$Sheet
S 8800 4750 1500 200 
U 5983CE11
F0 "jetson_sdcard" 118
F1 "jetson_sdcard.sch" 60
$EndSheet
$Sheet
S 8800 5250 1500 200 
U 59891DA7
F0 "jetson_uarts" 118
F1 "jetson_uarts.sch" 60
$EndSheet
$Sheet
S 8800 5800 1250 250 
U 5994081C
F0 "jetson_sata" 118
F1 "jetson_sata.sch" 60
$EndSheet
Text GLabel 3950 3550 0    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 3950 3650 0    60   Input ~ 0
PCIE_LANE0_TX-
Text GLabel 3150 4650 2    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 3150 4750 2    60   Input ~ 0
PCIE_REFCLK-
Text GLabel 3950 3900 0    60   Input ~ 0
PCIE_LANE1_RX+
Text GLabel 3950 4000 0    60   Input ~ 0
PCIE_LANE1_RX-
Text GLabel 3950 3200 0    60   Input ~ 0
PCIE_LANE0_RX+
Text GLabel 3950 3300 0    60   Input ~ 0
PCIE_LANE0_RX-
Text GLabel 3950 4200 0    60   Input ~ 0
PCIE_LANE1_TX+
Text GLabel 3950 4300 0    60   Input ~ 0
PCIE_LANE1_TX-
Text GLabel 3150 5750 2    60   Input ~ 0
PCIE_RST_3V3
Text GLabel 3150 5650 2    60   Input ~ 0
JETSON_RESET_OUT
Text GLabel 3150 5550 2    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 3150 5050 2    50   Input ~ 0
DISCHARGE
$Sheet
S 6050 1050 1500 500 
U 5AA3E427
F0 "jetson_gpio" 118
F1 "jetson_gpio.sch" 50
$EndSheet
Text GLabel 3150 5250 2    60   Input ~ 0
FPGA_CONFIG_DCLK
Text GLabel 3150 5150 2    60   Input ~ 0
FPGA_CONFIG_DATA0
$Sheet
S 1000 1150 1300 400 
U 5AA32FF8
F0 "fpga_power" 118
F1 "fpga_power.sch" 50
$EndSheet
$Sheet
S 1000 1950 1300 400 
U 5AA332F1
F0 "fpga_pcie" 118
F1 "fpga_pcie.sch" 50
$EndSheet
$Sheet
S 1000 2800 1300 400 
U 5AA333AC
F0 "fpga_config" 118
F1 "fpga_config.sch" 50
$EndSheet
$Sheet
S 1000 3650 1300 400 
U 5AA334B4
F0 "fpga_io" 118
F1 "fpga_io.sch" 50
$EndSheet
$Sheet
S 5600 3150 1350 500 
U 5AA6F737
F0 "imu" 118
F1 "imu.sch" 50
$EndSheet
Text Notes 2450 6050 0    50   ~ 0
FX23 board-to-board connector. 80-pin (?). Probably use vertical version on this board and right-angle on the sensor board
$EndSCHEMATC
