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
S 700  800  1550 300 
U 590F56BE
F0 "jetson_power" 118
F1 "jetson_power.sch" 118
$EndSheet
$Sheet
S 700  1650 1500 300 
U 59559720
F0 "jetson_pcie" 118
F1 "jetson_pcie.sch" 118
$EndSheet
$Sheet
S 700  6300 1250 350 
U 596A6D90
F0 "power" 118
F1 "power.sch" 118
$EndSheet
$Sheet
S 700  2350 1500 200 
U 5978A932
F0 "jetson_enet" 118
F1 "jetson_enet.sch" 118
$EndSheet
$Sheet
S 700  2950 1500 200 
U 59790642
F0 "jetson_hdmi" 118
F1 "jetson_hdmi.sch" 59
$EndSheet
$Sheet
S 700  3550 1500 200 
U 59814498
F0 "jetson_usb" 118
F1 "jetson_usb.sch" 59
$EndSheet
$Sheet
S 700  4000 1500 200 
U 5983B367
F0 "jetson_jtag" 118
F1 "jetson_jtag.sch" 59
$EndSheet
$Sheet
S 700  4650 1500 200 
U 5983CE11
F0 "jetson_sdcard" 118
F1 "jetson_sdcard.sch" 60
$EndSheet
$Sheet
S 700  5150 1500 200 
U 59891DA7
F0 "jetson_uarts" 118
F1 "jetson_uarts.sch" 60
$EndSheet
$Sheet
S 700  5700 1250 250 
U 5994081C
F0 "jetson_sata" 118
F1 "jetson_sata.sch" 60
$EndSheet
$Comp
L Connector_Generic:Conn_02x28_Odd_Even J2
U 1 1 5A999CEF
P 9150 4450
F 0 "J2" H 9150 6050 50  0000 C CNN
F 1 "SAMTEC QRF8-RA" H 8950 5950 50  0000 C CNN
F 2 "Samtec:SAMTEC_QRF8-026-01-L-RA-GP" H 9150 4450 50  0001 C CNN
F 3 "~" H 9150 4450 50  0001 C CNN
F 4 "SAM9773" H 9150 4450 50  0001 C CNN "D1PN"
F 5 "QRF8-026-01-L-RA-GP" H 9150 4450 50  0001 C CNN "MPN"
F 6 "Samtec" H 9150 4450 50  0001 C CNN "MFN"
F 7 "Digikey" H 9150 4450 50  0001 C CNN "D1N"
	1    9150 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5A9A1AB4
P 8000 5550
F 0 "#PWR0101" H 8000 5300 50  0001 C CNN
F 1 "GND" H 8005 5377 50  0001 C CNN
F 2 "" H 8000 5550 50  0001 C CNN
F 3 "" H 8000 5550 50  0001 C CNN
	1    8000 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 5550 8950 5550
Text GLabel 8950 5050 0    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 8950 5150 0    60   Input ~ 0
PCIE_LANE0_TX-
Wire Wire Line
	8950 5250 8000 5250
Wire Wire Line
	8000 5250 8000 5550
Connection ~ 8000 5550
Text GLabel 9450 5450 2    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 9450 5550 2    60   Input ~ 0
PCIE_REFCLK-
Text GLabel 8950 4750 0    60   Input ~ 0
PCIE_LANE1_RX+
Text GLabel 8950 4850 0    60   Input ~ 0
PCIE_LANE1_RX-
Text GLabel 8950 5350 0    60   Input ~ 0
PCIE_LANE0_RX+
Text GLabel 8950 5450 0    60   Input ~ 0
PCIE_LANE0_RX-
Text GLabel 8950 4450 0    60   Input ~ 0
PCIE_LANE1_TX+
Text GLabel 8950 4550 0    60   Input ~ 0
PCIE_LANE1_TX-
Wire Wire Line
	8000 5250 8000 4950
Wire Wire Line
	8000 4950 8950 4950
Connection ~ 8000 5250
Wire Wire Line
	8000 4950 8000 4650
Wire Wire Line
	8000 4650 8950 4650
Connection ~ 8000 4950
Wire Wire Line
	8000 4650 8000 4350
Wire Wire Line
	8000 4350 8950 4350
Connection ~ 8000 4650
Text GLabel 9450 5150 2    60   Input ~ 0
PCIE_RST_3V3
Text GLabel 9450 3550 2    60   Input ~ 0
JETSON_RESET_OUT
Text GLabel 9450 3450 2    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 9450 5250 2    60   Input ~ 0
DISCHARGE
$Comp
L power:+12V #PWR0104
U 1 1 5AA2BB17
P 9600 3150
F 0 "#PWR0104" H 9600 3000 50  0001 C CNN
F 1 "+12V" H 9615 3323 50  0000 C CNN
F 2 "" H 9600 3150 50  0001 C CNN
F 3 "" H 9600 3150 50  0001 C CNN
	1    9600 3150
	-1   0    0    -1  
$EndComp
$Sheet
S 700  7050 1500 500 
U 5AA3E427
F0 "jetson_gpio" 118
F1 "jetson_gpio.sch" 50
$EndSheet
Text GLabel 9450 4650 2    60   Input ~ 0
FPGA_CONFIG_DCLK
Text GLabel 9450 4550 2    60   Input ~ 0
FPGA_CONFIG_DATA0
Text GLabel 8950 3850 0    60   Input ~ 0
PCIE_LANE2_TX-
Text GLabel 8950 3950 0    60   Input ~ 0
PCIE_LANE2_TX+
Text GLabel 8950 4250 0    60   Input ~ 0
PCIE_LANE2_RX+
Text GLabel 8950 4150 0    60   Input ~ 0
PCIE_LANE2_RX-
Text GLabel 8950 3250 0    60   Input ~ 0
PCIE_LANE3_TX-
Text GLabel 8950 3350 0    60   Input ~ 0
PCIE_LANE3_TX+
Text GLabel 8950 3550 0    60   Input ~ 0
PCIE_LANE3_RX+
Text GLabel 8950 3650 0    60   Input ~ 0
PCIE_LANE3_RX-
Wire Wire Line
	8950 3150 8000 3150
Wire Wire Line
	8000 3150 8000 3450
Connection ~ 8000 4350
Wire Wire Line
	8950 4050 8000 4050
Connection ~ 8000 4050
Wire Wire Line
	8000 4050 8000 4350
Wire Wire Line
	8950 3750 8000 3750
Connection ~ 8000 3750
Wire Wire Line
	8000 3750 8000 4050
Wire Wire Line
	8950 3450 8000 3450
Connection ~ 8000 3450
Wire Wire Line
	8000 3450 8000 3750
Wire Wire Line
	8950 5750 8950 5850
Wire Wire Line
	8950 5850 8950 6000
Wire Wire Line
	8950 6000 9450 6000
Wire Wire Line
	9450 6000 9450 5850
Connection ~ 8950 5850
Wire Wire Line
	9450 5850 9450 5750
Connection ~ 9450 5850
$Comp
L power:GND #PWR0105
U 1 1 5AABF684
P 8950 6000
F 0 "#PWR0105" H 8950 5750 50  0001 C CNN
F 1 "GND" H 8955 5827 50  0001 C CNN
F 2 "" H 8950 6000 50  0001 C CNN
F 3 "" H 8950 6000 50  0001 C CNN
	1    8950 6000
	1    0    0    -1  
$EndComp
Connection ~ 8950 6000
Wire Wire Line
	9450 5650 9450 5750
Connection ~ 9450 5750
Wire Wire Line
	8950 5650 8950 5750
Connection ~ 8950 5750
Wire Wire Line
	9450 5350 10500 5350
$Comp
L power:GND #PWR0102
U 1 1 5ABDE62D
P 10500 5350
F 0 "#PWR0102" H 10500 5100 50  0001 C CNN
F 1 "GND" H 10505 5177 50  0001 C CNN
F 2 "" H 10500 5350 50  0001 C CNN
F 3 "" H 10500 5350 50  0001 C CNN
	1    10500 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 3150 9450 3150
Wire Wire Line
	9450 3250 9600 3250
Wire Wire Line
	9600 3250 9600 3150
Connection ~ 9600 3150
Wire Wire Line
	9450 3350 9600 3350
Wire Wire Line
	9600 3350 9600 3250
Connection ~ 9600 3250
$Comp
L power:+3V3 #PWR0103
U 1 1 5AC98B62
P 10800 3650
F 0 "#PWR0103" H 10800 3500 50  0001 C CNN
F 1 "+3V3" H 10815 3823 50  0000 C CNN
F 2 "" H 10800 3650 50  0001 C CNN
F 3 "" H 10800 3650 50  0001 C CNN
	1    10800 3650
	1    0    0    -1  
$EndComp
Text GLabel 9450 4850 2    60   Input ~ 0
LED
$Comp
L power:+5V #PWR0106
U 1 1 5ACA8EA2
P 10500 3950
F 0 "#PWR0106" H 10500 3800 50  0001 C CNN
F 1 "+5V" H 10515 4123 50  0000 C CNN
F 2 "" H 10500 3950 50  0001 C CNN
F 3 "" H 10500 3950 50  0001 C CNN
	1    10500 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	10500 3950 9450 3950
Text GLabel 9450 4450 2    60   Input ~ 0
FPGA_CONF_DONE
Text GLabel 9450 4350 2    60   Input ~ 0
FPGA_NSTATUS
Text GLabel 9450 4250 2    60   Input ~ 0
FPGA_NCONFIG
Wire Wire Line
	9450 4750 10500 4750
Wire Wire Line
	10500 4750 10500 5350
Connection ~ 10500 5350
Wire Wire Line
	9450 4150 10500 4150
Wire Wire Line
	10500 4150 10500 4750
Connection ~ 10500 4750
Wire Wire Line
	9450 3650 10800 3650
$EndSCHEMATC
