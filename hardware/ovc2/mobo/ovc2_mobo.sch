EESchema Schematic File Version 4
LIBS:ovc2_mobo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 12
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
S 8800 3050 1500 200 
U 59790642
F0 "jetson_hdmi" 118
F1 "jetson_hdmi.sch" 59
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
$Comp
L Connector_Generic:Conn_02x28_Odd_Even J2
U 1 1 5A999CEF
P 5800 4500
F 0 "J2" H 5800 6100 50  0000 C CNN
F 1 "SAMTEC QRF8-RA" H 5600 6000 50  0000 C CNN
F 2 "Samtec:SAMTEC_QRF8-026-01-L-RA-GP" H 5800 4500 50  0001 C CNN
F 3 "~" H 5800 4500 50  0001 C CNN
F 4 "SAM9773" H 5800 4500 50  0001 C CNN "D1PN"
F 5 "QRF8-026-01-L-RA-GP" H 5800 4500 50  0001 C CNN "MPN"
F 6 "Samtec" H 5800 4500 50  0001 C CNN "MFN"
F 7 "Digikey" H 5800 4500 50  0001 C CNN "D1N"
	1    5800 4500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5A9A1AB4
P 4650 5600
F 0 "#PWR0101" H 4650 5350 50  0001 C CNN
F 1 "GND" H 4655 5427 50  0001 C CNN
F 2 "" H 4650 5600 50  0001 C CNN
F 3 "" H 4650 5600 50  0001 C CNN
	1    4650 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 5600 5600 5600
Text GLabel 5600 5100 0    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 5600 5200 0    60   Input ~ 0
PCIE_LANE0_TX-
Wire Wire Line
	5600 5300 4650 5300
Wire Wire Line
	4650 5300 4650 5600
Connection ~ 4650 5600
Text GLabel 6100 5500 2    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 6100 5600 2    60   Input ~ 0
PCIE_REFCLK-
Text GLabel 5600 4800 0    60   Input ~ 0
PCIE_LANE1_RX+
Text GLabel 5600 4900 0    60   Input ~ 0
PCIE_LANE1_RX-
Text GLabel 5600 5400 0    60   Input ~ 0
PCIE_LANE0_RX+
Text GLabel 5600 5500 0    60   Input ~ 0
PCIE_LANE0_RX-
Text GLabel 5600 4500 0    60   Input ~ 0
PCIE_LANE1_TX+
Text GLabel 5600 4600 0    60   Input ~ 0
PCIE_LANE1_TX-
Wire Wire Line
	4650 5300 4650 5000
Wire Wire Line
	4650 5000 5600 5000
Connection ~ 4650 5300
Wire Wire Line
	4650 5000 4650 4700
Wire Wire Line
	4650 4700 5600 4700
Connection ~ 4650 5000
Wire Wire Line
	4650 4700 4650 4400
Wire Wire Line
	4650 4400 5600 4400
Connection ~ 4650 4700
Text GLabel 6100 5200 2    60   Input ~ 0
PCIE_RST_3V3
Text GLabel 6100 3600 2    60   Input ~ 0
JETSON_RESET_OUT
Text GLabel 6100 3500 2    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 6100 5300 2    60   Input ~ 0
DISCHARGE
$Comp
L power:+12V #PWR0104
U 1 1 5AA2BB17
P 6250 3200
F 0 "#PWR0104" H 6250 3050 50  0001 C CNN
F 1 "+12V" H 6265 3373 50  0000 C CNN
F 2 "" H 6250 3200 50  0001 C CNN
F 3 "" H 6250 3200 50  0001 C CNN
	1    6250 3200
	-1   0    0    -1  
$EndComp
$Sheet
S 6050 1050 1500 500 
U 5AA3E427
F0 "jetson_gpio" 118
F1 "jetson_gpio.sch" 50
$EndSheet
Text GLabel 6100 4700 2    60   Input ~ 0
FPGA_CONFIG_DCLK
Text GLabel 6100 4600 2    60   Input ~ 0
FPGA_CONFIG_DATA0
Text GLabel 5600 3900 0    60   Input ~ 0
PCIE_LANE2_TX-
Text GLabel 5600 4000 0    60   Input ~ 0
PCIE_LANE2_TX+
Text GLabel 5600 4300 0    60   Input ~ 0
PCIE_LANE2_RX+
Text GLabel 5600 4200 0    60   Input ~ 0
PCIE_LANE2_RX-
Text GLabel 5600 3300 0    60   Input ~ 0
PCIE_LANE3_TX-
Text GLabel 5600 3400 0    60   Input ~ 0
PCIE_LANE3_TX+
Text GLabel 5600 3700 0    60   Input ~ 0
PCIE_LANE3_RX+
Text GLabel 5600 3600 0    60   Input ~ 0
PCIE_LANE3_RX-
Wire Wire Line
	5600 3200 4650 3200
Wire Wire Line
	4650 3200 4650 3500
Connection ~ 4650 4400
Wire Wire Line
	5600 4100 4650 4100
Connection ~ 4650 4100
Wire Wire Line
	4650 4100 4650 4400
Wire Wire Line
	5600 3800 4650 3800
Connection ~ 4650 3800
Wire Wire Line
	4650 3800 4650 4100
Wire Wire Line
	5600 3500 4650 3500
Connection ~ 4650 3500
Wire Wire Line
	4650 3500 4650 3800
Wire Wire Line
	5600 5800 5600 5900
Wire Wire Line
	5600 5900 5600 6050
Wire Wire Line
	5600 6050 6100 6050
Wire Wire Line
	6100 6050 6100 5900
Connection ~ 5600 5900
Wire Wire Line
	6100 5900 6100 5800
Connection ~ 6100 5900
$Comp
L power:GND #PWR0105
U 1 1 5AABF684
P 5600 6050
F 0 "#PWR0105" H 5600 5800 50  0001 C CNN
F 1 "GND" H 5605 5877 50  0001 C CNN
F 2 "" H 5600 6050 50  0001 C CNN
F 3 "" H 5600 6050 50  0001 C CNN
	1    5600 6050
	1    0    0    -1  
$EndComp
Connection ~ 5600 6050
Text Notes 1250 2000 0    118  ~ 24
TODO: move to (much) taller TX2 mount, to allow PCIe connector underneath
Wire Wire Line
	6100 5700 6100 5800
Connection ~ 6100 5800
Wire Wire Line
	5600 5700 5600 5800
Connection ~ 5600 5800
Wire Wire Line
	6100 5400 7150 5400
$Comp
L power:GND #PWR0102
U 1 1 5ABDE62D
P 7150 5400
F 0 "#PWR0102" H 7150 5150 50  0001 C CNN
F 1 "GND" H 7155 5227 50  0001 C CNN
F 2 "" H 7150 5400 50  0001 C CNN
F 3 "" H 7150 5400 50  0001 C CNN
	1    7150 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 3200 6100 3200
Wire Wire Line
	6100 3300 6250 3300
Wire Wire Line
	6250 3300 6250 3200
Connection ~ 6250 3200
Wire Wire Line
	6100 3400 6250 3400
Wire Wire Line
	6250 3400 6250 3300
Connection ~ 6250 3300
$Comp
L power:+3V3 #PWR0103
U 1 1 5AC98B62
P 7450 3700
F 0 "#PWR0103" H 7450 3550 50  0001 C CNN
F 1 "+3V3" H 7465 3873 50  0000 C CNN
F 2 "" H 7450 3700 50  0001 C CNN
F 3 "" H 7450 3700 50  0001 C CNN
	1    7450 3700
	1    0    0    -1  
$EndComp
Text GLabel 6100 4900 2    60   Input ~ 0
LED
$Comp
L power:+5V #PWR0106
U 1 1 5ACA8EA2
P 7150 4000
F 0 "#PWR0106" H 7150 3850 50  0001 C CNN
F 1 "+5V" H 7165 4173 50  0000 C CNN
F 2 "" H 7150 4000 50  0001 C CNN
F 3 "" H 7150 4000 50  0001 C CNN
	1    7150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 4000 6100 4000
Text GLabel 6100 4500 2    60   Input ~ 0
FPGA_CONF_DONE
Text GLabel 6100 4400 2    60   Input ~ 0
FPGA_NSTATUS
Text GLabel 6100 4300 2    60   Input ~ 0
FPGA_NCONFIG
Wire Wire Line
	6100 4800 7150 4800
Wire Wire Line
	7150 4800 7150 5400
Connection ~ 7150 5400
Wire Wire Line
	6100 4200 7150 4200
Wire Wire Line
	7150 4200 7150 4800
Connection ~ 7150 4800
Wire Wire Line
	6100 3700 7450 3700
$EndSCHEMATC
