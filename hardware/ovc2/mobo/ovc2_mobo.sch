EESchema Schematic File Version 4
LIBS:ovc2_mobo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 11
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
$Comp
L power:GND #PWR0101
U 1 1 5A9A1AB4
P 4650 5300
F 0 "#PWR0101" H 4650 5050 50  0001 C CNN
F 1 "GND" H 4655 5127 50  0001 C CNN
F 2 "" H 4650 5300 50  0001 C CNN
F 3 "" H 4650 5300 50  0001 C CNN
	1    4650 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 5300 5600 5300
Text GLabel 5600 5100 0    60   Input ~ 0
PCIE_LANE0_TX+
Text GLabel 5600 5200 0    60   Input ~ 0
PCIE_LANE0_TX-
Wire Wire Line
	5600 5000 4650 5000
Wire Wire Line
	4650 5000 4650 5300
Connection ~ 4650 5300
$Comp
L power:GND #PWR0102
U 1 1 5A9A2C22
P 7100 5300
F 0 "#PWR0102" H 7100 5050 50  0001 C CNN
F 1 "GND" H 7105 5127 50  0001 C CNN
F 2 "" H 7100 5300 50  0001 C CNN
F 3 "" H 7100 5300 50  0001 C CNN
	1    7100 5300
	1    0    0    -1  
$EndComp
Text GLabel 6100 5000 2    60   Input ~ 0
PCIE_REFCLK+
Text GLabel 6100 5100 2    60   Input ~ 0
PCIE_REFCLK-
Wire Wire Line
	6100 4900 7100 4900
Wire Wire Line
	7100 4900 7100 5200
Wire Wire Line
	6100 5300 7100 5300
Connection ~ 7100 5300
Wire Wire Line
	6100 5200 7100 5200
Connection ~ 7100 5200
Wire Wire Line
	7100 5200 7100 5300
$EndSCHEMATC
