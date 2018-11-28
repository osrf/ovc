EESchema Schematic File Version 4
LIBS:ovc3-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
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
S 7900 1900 2050 600 
U 5BFA87C9
F0 "imagers" 50
F1 "imagers.sch" 50
$EndSheet
$Comp
L trenz:TE0820 U3
U 1 1 5BFAAE4A
P 2450 2300
F 0 "U3" H 2437 2525 50  0000 C CNN
F 1 "TE0820" H 2437 2434 50  0000 C CNN
F 2 "Trenz:TE0820" H 2450 2300 50  0001 C CNN
F 3 "" H 2450 2300 50  0001 C CNN
	1    2450 2300
	1    0    0    -1  
$EndComp
$Sheet
S 8000 3300 1650 650 
U 5BFAB517
F0 "imu" 50
F1 "imu.sch" 50
$EndSheet
$Comp
L connector:USB_C_Receptacle J3
U 1 1 5BFBE7C3
P 3200 3950
F 0 "J3" H 3307 5217 50  0000 C CNN
F 1 "USB_C_Receptacle" H 3307 5126 50  0000 C CNN
F 2 "USB:USB_C_Receptacle_Wurth_632723300011" H 3350 3950 50  0001 C CNN
F 3 "https://www.usb.org/sites/default/files/documents/usb_type-c.zip" H 3350 3950 50  0001 C CNN
F 4 "632723300011" H 3200 3950 50  0001 C CNN "MPN"
F 5 "Wurth" H 3200 3950 50  0001 C CNN "MFN"
	1    3200 3950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5BFC0E07
P 3200 5550
F 0 "#PWR0102" H 3200 5300 50  0001 C CNN
F 1 "GND" H 3205 5377 50  0001 C CNN
F 2 "" H 3200 5550 50  0001 C CNN
F 3 "" H 3200 5550 50  0001 C CNN
	1    3200 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3800 3950 4450 3950
Text Label 3850 3950 0    50   ~ 0
CONN_RX1-
Wire Wire Line
	3800 4050 4450 4050
Text Label 3850 4050 0    50   ~ 0
CONN_RX1+
Wire Wire Line
	3800 4250 4450 4250
Text Label 3850 4250 0    50   ~ 0
CONN_TX1-
Wire Wire Line
	3800 4350 4450 4350
Text Label 3850 4350 0    50   ~ 0
CONN_TX1+
Wire Wire Line
	3800 4550 4450 4550
Text Label 3850 4550 0    50   ~ 0
CONN_RX2-
Wire Wire Line
	3800 4650 4450 4650
Text Label 3850 4650 0    50   ~ 0
CONN_RX2+
Wire Wire Line
	3800 4850 4450 4850
Text Label 3850 4850 0    50   ~ 0
CONN_TX2-
Wire Wire Line
	3800 4950 4450 4950
Text Label 3850 4950 0    50   ~ 0
CONN_TX2+
Wire Wire Line
	3800 3450 4450 3450
Text Label 3850 3450 0    50   ~ 0
CONN_D-1
Wire Wire Line
	3800 3550 4450 3550
Text Label 3850 3550 0    50   ~ 0
CONN_D-2
Wire Wire Line
	3800 3650 4450 3650
Text Label 3850 3650 0    50   ~ 0
CONN_D+1
Wire Wire Line
	3800 3750 4450 3750
Text Label 3850 3750 0    50   ~ 0
CONN_D+2
Wire Wire Line
	3800 3250 4450 3250
Text Label 3850 3250 0    50   ~ 0
CONN_CC2
Wire Wire Line
	3800 3150 4450 3150
Text Label 3850 3150 0    50   ~ 0
CONN_CC1
Wire Wire Line
	3800 2950 4450 2950
Text Label 3850 2950 0    50   ~ 0
CONN_VBUS
Wire Wire Line
	3800 5250 4450 5250
Text Label 3850 5250 0    50   ~ 0
CONN_SBU2
Wire Wire Line
	3800 5150 4450 5150
Text Label 3850 5150 0    50   ~ 0
CONN_SBU1
$Comp
L usb_controller:STUSB4500 U5
U 1 1 5BFED805
P 6150 4050
F 0 "U5" H 6250 5115 50  0000 C CNN
F 1 "STUSB4500" H 6250 5024 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-24-1EP_4x4mm_P0.5mm_EP2.7x2.7mm" H 6150 5150 50  0001 C CNN
F 3 "" H 5800 3750 50  0001 C CNN
	1    6150 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4150 5550 4150
Wire Wire Line
	5550 4150 5550 4250
Wire Wire Line
	5550 4250 5650 4250
Wire Wire Line
	5650 4350 5550 4350
Wire Wire Line
	5550 4350 5550 4450
Wire Wire Line
	5550 4450 5650 4450
Wire Wire Line
	5550 4250 5100 4250
Connection ~ 5550 4250
Text Label 5100 4250 0    50   ~ 0
CONN_CC1
Wire Wire Line
	5550 4350 5100 4350
Connection ~ 5550 4350
Text Label 5100 4350 0    50   ~ 0
CONN_CC2
$Comp
L power:GND #PWR0103
U 1 1 5BFF11DE
P 5550 4950
F 0 "#PWR0103" H 5550 4700 50  0001 C CNN
F 1 "GND" H 5555 4777 50  0001 C CNN
F 2 "" H 5550 4950 50  0001 C CNN
F 3 "" H 5550 4950 50  0001 C CNN
	1    5550 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4950 5550 4950
Wire Wire Line
	5650 4850 5550 4850
Wire Wire Line
	5550 4850 5550 4950
Connection ~ 5550 4950
Wire Wire Line
	5650 4650 5550 4650
Wire Wire Line
	5550 4650 5550 4850
Connection ~ 5550 4850
Wire Wire Line
	5650 4550 5550 4550
Wire Wire Line
	5550 4550 5550 4650
Connection ~ 5550 4650
NoConn ~ 5650 4750
$EndSCHEMATC
