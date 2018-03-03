EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 7
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
S 1200 1650 1200 200 
U 590F42A0
F0 "fpga_power" 118
F1 "fpga_power.sch" 118
$EndSheet
$Sheet
S 1200 5350 1500 250 
U 590F5214
F0 "imagers" 118
F1 "imagers.sch" 118
$EndSheet
$Sheet
S 1200 2550 1200 200 
U 590F67D7
F0 "fpga_config" 118
F1 "fpga_config.sch" 118
$EndSheet
$Sheet
S 1200 4550 1250 350 
U 596A6D90
F0 "power" 118
F1 "power.sch" 118
$EndSheet
$Sheet
S 1200 3200 1200 300 
U 59F6DCBA
F0 "fpga_pcie" 118
F1 "fpga_pcie.sch" 60
$EndSheet
$Sheet
S 1200 3850 1200 350 
U 5A96DC8F
F0 "fpga_io" 118
F1 "fpga_io.sch" 59
$EndSheet
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5A999CEF
P 5800 4300
F 0 "J2" H 5850 5417 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 5850 5326 50  0000 C CNN
F 2 "Connectors_OSRF:SAMTEC_ERF8-020" H 5800 4300 50  0001 C CNN
F 3 "~" H 5800 4300 50  0001 C CNN
	1    5800 4300
	1    0    0    -1  
$EndComp
Text GLabel 5600 4600 0    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 5600 4700 0    60   Input ~ 0
JETSON_RESET_OUT
Text Notes 4000 4300 0    50   ~ 0
TODO: >=1 uart for IMU and misc
Text GLabel 5600 5000 0    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 5600 5100 0    60   Input ~ 0
PCIE_REFCLK-
Text GLabel 6100 5200 2    60   Input ~ 0
PCIE_LANE0_TX-
Text GLabel 6100 5100 2    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 6100 4900 2    60   Input ~ 0
PCIE_LANE0_RX-
Text GLabel 6100 4800 2    60   Input ~ 0
PCIE_LANE0_RX+
Text GLabel 6100 4600 2    60   Input ~ 0
PCIE_LANE1_TX-
Text GLabel 6100 4500 2    60   Input ~ 0
PCIE_LANE1_TX+
Text GLabel 6100 4200 2    60   Input ~ 0
PCIE_LANE1_RX+
Text GLabel 6100 4300 2    60   Input ~ 0
PCIE_LANE1_RX-
Text GLabel 5600 4800 0    60   Input ~ 0
PCIE_RST_3V3
Text GLabel 5600 4500 0    60   Input ~ 0
DISCHARGE
Wire Wire Line
	6100 5300 7050 5300
$Comp
L power:GND #PWR0112
U 1 1 5A9A7965
P 7050 5300
F 0 "#PWR0112" H 7050 5050 50  0001 C CNN
F 1 "GND" H 7055 5127 50  0001 C CNN
F 2 "" H 7050 5300 50  0001 C CNN
F 3 "" H 7050 5300 50  0001 C CNN
	1    7050 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 5000 7050 5000
Wire Wire Line
	7050 5000 7050 5300
Connection ~ 7050 5300
Wire Wire Line
	6100 4700 7050 4700
Wire Wire Line
	7050 4700 7050 5000
Connection ~ 7050 5000
Wire Wire Line
	6100 4400 7050 4400
Wire Wire Line
	7050 4400 7050 4700
Connection ~ 7050 4700
Wire Wire Line
	6100 4100 7050 4100
Wire Wire Line
	7050 4100 7050 4400
Connection ~ 7050 4400
$Comp
L power:GND #PWR0127
U 1 1 5A9A7E63
P 4750 5300
F 0 "#PWR0127" H 4750 5050 50  0001 C CNN
F 1 "GND" H 4755 5127 50  0001 C CNN
F 2 "" H 4750 5300 50  0001 C CNN
F 3 "" H 4750 5300 50  0001 C CNN
	1    4750 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 5300 5600 5300
Wire Wire Line
	5600 5200 5600 5300
Connection ~ 5600 5300
Wire Wire Line
	5600 4900 4750 4900
Wire Wire Line
	4750 4900 4750 5300
Connection ~ 4750 5300
$Comp
L Graphic:Logo_Open_Hardware_Small Z1
U 1 1 5A9A8815
P 2250 6700
F 0 "Z1" H 2497 6725 50  0000 L CNN
F 1 "Logo_Open_Hardware_Small" H 2250 6475 50  0001 C CNN
F 2 "Symbols:OSHW-Symbol_6.7x6mm_SilkScreen" H 2250 6700 50  0001 C CNN
F 3 "~" H 2250 6700 50  0001 C CNN
	1    2250 6700
	1    0    0    -1  
$EndComp
$EndSCHEMATC
