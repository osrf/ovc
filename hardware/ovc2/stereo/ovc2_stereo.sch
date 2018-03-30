EESchema Schematic File Version 4
LIBS:ovc2_stereo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 8
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
L Connector_Generic:Conn_02x28_Odd_Even J2
U 1 1 5A999CEF
P 5800 4100
F 0 "J2" H 5850 5650 50  0000 C CNN
F 1 "Samtec QRM8" H 5800 5550 50  0000 C CNN
F 2 "Samtec:SAMTEC_QRM8-026-02.0-L-D-A-GP" H 5800 4100 50  0001 C CNN
F 3 "~" H 5800 4100 50  0001 C CNN
F 4 "QRM8-026-02.0-L-D-A-GP" H 5800 4100 50  0001 C CNN "MPN"
F 5 "SAM11585" H 5800 4100 50  0001 C CNN "D1PN"
	1    5800 4100
	1    0    0    -1  
$EndComp
Text GLabel 6100 4800 2    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 6100 4900 2    60   Input ~ 0
JETSON_RESET_OUT
Text Notes 4050 6000 0    50   ~ 0
TODO: >=1 uart for IMU and misc
Text GLabel 6100 5200 2    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 6100 5300 2    60   Input ~ 0
PCIE_REFCLK-
Text GLabel 5600 3800 0    60   Input ~ 0
PCIE_LANE2_TX-
Text GLabel 5600 3900 0    60   Input ~ 0
PCIE_LANE2_TX+
Text GLabel 5600 3500 0    60   Input ~ 0
PCIE_LANE2_RX-
Text GLabel 5600 3600 0    60   Input ~ 0
PCIE_LANE2_RX+
Text GLabel 5600 4500 0    60   Input ~ 0
PCIE_LANE1_TX-
Text GLabel 5600 4400 0    60   Input ~ 0
PCIE_LANE1_TX+
Text GLabel 5600 4100 0    60   Input ~ 0
PCIE_LANE1_RX+
Text GLabel 5600 4200 0    60   Input ~ 0
PCIE_LANE1_RX-
Text GLabel 6100 5000 2    60   Input ~ 0
PCIE_RST_3V3
Text GLabel 6100 4700 2    60   Input ~ 0
DISCHARGE
Wire Wire Line
	5600 5200 4650 5200
$Comp
L power:GND #PWR0112
U 1 1 5A9A7965
P 4650 5200
F 0 "#PWR0112" H 4650 4950 50  0001 C CNN
F 1 "GND" H 4655 5027 50  0001 C CNN
F 2 "" H 4650 5200 50  0001 C CNN
F 3 "" H 4650 5200 50  0001 C CNN
	1    4650 5200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5600 4900 4650 4900
Wire Wire Line
	4650 4900 4650 5200
Connection ~ 4650 5200
Wire Wire Line
	5600 4600 4650 4600
Wire Wire Line
	4650 4600 4650 4900
Connection ~ 4650 4900
Wire Wire Line
	5600 4300 4650 4300
Wire Wire Line
	4650 4300 4650 4600
Connection ~ 4650 4600
Wire Wire Line
	5600 4000 4650 4000
Wire Wire Line
	4650 4000 4650 4300
Connection ~ 4650 4300
$Comp
L power:GND #PWR0127
U 1 1 5A9A7E63
P 6950 5500
F 0 "#PWR0127" H 6950 5250 50  0001 C CNN
F 1 "GND" H 6955 5327 50  0001 C CNN
F 2 "" H 6950 5500 50  0001 C CNN
F 3 "" H 6950 5500 50  0001 C CNN
	1    6950 5500
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6950 5500 6100 5500
Wire Wire Line
	6100 5100 6950 5100
Wire Wire Line
	6950 5100 6950 5500
Connection ~ 6950 5500
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
$Sheet
S 5900 1650 1400 400 
U 5A9D8938
F0 "imu" 118
F1 "imu.sch" 50
$EndSheet
Text GLabel 5600 5100 0    60   Input ~ 0
PCIE_LANE0_TX-
Text GLabel 5600 5000 0    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 5600 4800 0    60   Input ~ 0
PCIE_LANE0_RX-
Text GLabel 5600 4700 0    60   Input ~ 0
PCIE_LANE0_RX+
Text GLabel 5600 3200 0    60   Input ~ 0
PCIE_LANE3_TX-
Text GLabel 5600 3300 0    60   Input ~ 0
PCIE_LANE3_TX+
Text GLabel 5600 3000 0    60   Input ~ 0
PCIE_LANE3_RX+
Text GLabel 5600 2900 0    60   Input ~ 0
PCIE_LANE3_RX-
Wire Wire Line
	5600 3700 4650 3700
Wire Wire Line
	4650 3700 4650 4000
Wire Wire Line
	5600 3400 4650 3400
Wire Wire Line
	4650 3400 4650 3700
Connection ~ 4650 3700
Wire Wire Line
	5600 3100 4650 3100
Wire Wire Line
	4650 3100 4650 3400
Connection ~ 4650 3400
Wire Wire Line
	5600 2800 4650 2800
Wire Wire Line
	4650 2800 4650 3100
Connection ~ 4650 3100
Connection ~ 4650 4000
Wire Wire Line
	5600 5400 5600 5500
Wire Wire Line
	5600 5700 6100 5700
Wire Wire Line
	6100 5700 6100 5500
Connection ~ 5600 5500
Wire Wire Line
	5600 5500 5600 5700
Connection ~ 6100 5500
Wire Wire Line
	6100 5500 6100 5400
$Comp
L power:GND #PWR0128
U 1 1 5ABE2CE3
P 6100 5700
F 0 "#PWR0128" H 6100 5450 50  0001 C CNN
F 1 "GND" H 6105 5527 50  0001 C CNN
F 2 "" H 6100 5700 50  0001 C CNN
F 3 "" H 6100 5700 50  0001 C CNN
	1    6100 5700
	1    0    0    -1  
$EndComp
Connection ~ 6100 5700
Wire Wire Line
	5600 5400 5600 5300
Connection ~ 5600 5400
$EndSCHEMATC
