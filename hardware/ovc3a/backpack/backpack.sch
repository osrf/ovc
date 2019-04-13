EESchema Schematic File Version 5
LIBS:backpack-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L IMU:VN-100 U1
U 1 1 5C45B550
P 4850 3350
F 0 "U1" H 5500 4250 60  0000 L CNN
F 1 "VN-100" H 5500 4150 60  0000 L CNN
F 2 "IMU:VN-100" H 4850 3350 60  0001 C CNN
F 3 "http://www.vectornav.com/docs/default-source/documentation/vn-100-documentation/UM001.pdf?sfvrsn=10" H 5694 3244 60  0001 L CNN
	1    4850 3350
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 5C45E9D4
P 1000 7100
F 0 "H1" H 950 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 1100 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 1000 7100 50  0001 C CNN
F 3 "~" H 1000 7100 50  0001 C CNN
	1    1000 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 5C45F54D
P 1250 7100
F 0 "H2" H 1200 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 1350 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 1250 7100 50  0001 C CNN
F 3 "~" H 1250 7100 50  0001 C CNN
	1    1250 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H3
U 1 1 5C4604E9
P 1500 7100
F 0 "H3" H 1450 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 1600 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 1500 7100 50  0001 C CNN
F 3 "~" H 1500 7100 50  0001 C CNN
	1    1500 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H4
U 1 1 5C460769
P 1750 7100
F 0 "H4" H 1700 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 1850 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 1750 7100 50  0001 C CNN
F 3 "~" H 1750 7100 50  0001 C CNN
	1    1750 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C1
U 1 1 5C484EC9
P 7900 1250
F 0 "C1" H 7992 1296 50  0000 L CNN
F 1 "10u" H 7992 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7900 1250 50  0001 C CNN
F 3 "~" H 7900 1250 50  0001 C CNN
	1    7900 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5C487C7A
P 8250 1250
F 0 "C2" H 8342 1296 50  0000 L CNN
F 1 "100n" H 8342 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8250 1250 50  0001 C CNN
F 3 "~" H 8250 1250 50  0001 C CNN
	1    8250 1250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5C48DB67
P 7900 1350
F 0 "#PWR0103" H 7900 1100 50  0001 C CNN
F 1 "GND" H 7905 1177 50  0001 C CNN
F 2 "" H 7900 1350 50  0001 C CNN
F 3 "" H 7900 1350 50  0001 C CNN
	1    7900 1350
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0106
U 1 1 5C4A0352
P 7900 1150
F 0 "#PWR0106" H 7900 1000 50  0001 C CNN
F 1 "+3.3V" H 7915 1323 50  0000 C CNN
F 2 "" H 7900 1150 50  0001 C CNN
F 3 "" H 7900 1150 50  0001 C CNN
	1    7900 1150
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ISO7342C U2
U 1 1 5CA34A28
P 9050 1650
F 0 "U2" H 9050 2317 50  0000 C CNN
F 1 "ISOW7842" H 9050 2226 50  0000 C CNN
F 2 "Package_SO:SOIC-16W_7.5x10.3mm_P1.27mm" H 9050 1100 50  0001 C CIN
F 3 "http://www.ti.com/general/docs/lit/getliterature.tsp?genericPartNumber=iso7342c&fileType=pdf" H 9050 2050 50  0001 C CNN
	1    9050 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 1150 8250 1150
Wire Wire Line
	8650 1150 8650 1250
Connection ~ 8250 1150
Wire Wire Line
	8250 1150 8650 1150
Wire Wire Line
	7900 1350 8250 1350
Connection ~ 8250 1350
Wire Wire Line
	8250 1350 8650 1350
Connection ~ 7900 1350
Text Notes 8550 900  0    50   ~ 0
TODO: what's going\non with the EN pins
Wire Wire Line
	8650 1750 8300 1750
Text Label 8300 1750 0    50   ~ 0
GPIO1A
Wire Wire Line
	8650 1850 8300 1850
Text Label 8300 1850 0    50   ~ 0
GPIO1B
Wire Wire Line
	8650 1950 8300 1950
Text Label 8300 1950 0    50   ~ 0
GPIO1C
Wire Wire Line
	8650 2050 8300 2050
Text Label 8300 2050 0    50   ~ 0
GPIO1D
Wire Wire Line
	10200 1750 9450 1750
Text Label 9500 1750 0    50   ~ 0
GPIO1A_ISO
Wire Wire Line
	10200 1850 9450 1850
Text Label 9500 1850 0    50   ~ 0
GPIO1B_ISO
Wire Wire Line
	10200 1950 9450 1950
Text Label 9500 1950 0    50   ~ 0
GPIO1C_ISO
Wire Wire Line
	10200 2050 9450 2050
Text Label 9500 2050 0    50   ~ 0
GPIO1D_ISO
Connection ~ 7900 1150
$Comp
L Connector_Generic:Conn_01x05 J1
U 1 1 5CA4E3E9
P 10400 1950
F 0 "J1" H 10480 1992 50  0000 L CNN
F 1 "GPIO1" H 10480 1901 50  0000 L CNN
F 2 "Connector_Molex:Molex_Nano-Fit_105313-xx05_1x05_P2.50mm_Horizontal" H 10400 1950 50  0001 C CNN
F 3 "~" H 10400 1950 50  0001 C CNN
	1    10400 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5CA4F20F
P 10000 1250
F 0 "C4" H 10092 1296 50  0000 L CNN
F 1 "10u" H 10092 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 10000 1250 50  0001 C CNN
F 3 "~" H 10000 1250 50  0001 C CNN
	1    10000 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 1350 9650 1350
Connection ~ 9650 1350
Connection ~ 10000 1350
Wire Wire Line
	9450 1250 9500 1250
Wire Wire Line
	9500 1250 9500 1150
Wire Wire Line
	9500 1150 9650 1150
Connection ~ 9650 1150
Connection ~ 10000 1150
Text Label 10300 1150 0    50   ~ 0
GPIO1_VCC_ISO
Wire Wire Line
	10000 1150 10900 1150
Wire Wire Line
	10000 1350 10900 1350
Text Label 9500 2150 0    50   ~ 0
GPIO1_GND_ISO
Wire Wire Line
	9500 2150 10200 2150
Text Label 10300 1350 0    50   ~ 0
GPIO1_GND_ISO
Wire Wire Line
	5250 4250 5150 4250
Connection ~ 4750 4250
Wire Wire Line
	4750 4250 4650 4250
Connection ~ 4850 4250
Wire Wire Line
	4850 4250 4750 4250
Connection ~ 4950 4250
Wire Wire Line
	4950 4250 4850 4250
Connection ~ 5050 4250
Wire Wire Line
	5050 4250 4950 4250
Connection ~ 5150 4250
Wire Wire Line
	5150 4250 5050 4250
$Comp
L power:GND #PWR0101
U 1 1 5CA53199
P 4650 4250
F 0 "#PWR0101" H 4650 4000 50  0001 C CNN
F 1 "GND" H 4655 4077 50  0001 C CNN
F 2 "" H 4650 4250 50  0001 C CNN
F 3 "" H 4650 4250 50  0001 C CNN
	1    4650 4250
	1    0    0    -1  
$EndComp
Connection ~ 4650 4250
$Comp
L power:+3.3V #PWR0102
U 1 1 5CA53481
P 3950 2850
F 0 "#PWR0102" H 3950 2700 50  0001 C CNN
F 1 "+3.3V" H 3965 3023 50  0000 C CNN
F 2 "" H 3950 2850 50  0001 C CNN
F 3 "" H 3950 2850 50  0001 C CNN
	1    3950 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 2850 4150 2850
Wire Wire Line
	9650 1350 10000 1350
Wire Wire Line
	9650 1150 10000 1150
$Comp
L Device:C_Small C3
U 1 1 5CA4F219
P 9650 1250
F 0 "C3" H 9742 1296 50  0000 L CNN
F 1 "100n" H 9742 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 9650 1250 50  0001 C CNN
F 3 "~" H 9650 1250 50  0001 C CNN
	1    9650 1250
	1    0    0    -1  
$EndComp
Text Notes 1050 6800 0    50   ~ 0
MOUNTING HOLES
Wire Wire Line
	4150 3050 3600 3050
Text Label 3600 3050 0    50   ~ 0
IMU_EN
Wire Wire Line
	4150 3150 3600 3150
Text Label 3600 3150 0    50   ~ 0
IMU_TARE
Wire Wire Line
	4150 3250 3600 3250
Text Label 3600 3250 0    50   ~ 0
IMU_SYNC_IN
Wire Wire Line
	4150 3450 3600 3450
Text Label 3600 3450 0    50   ~ 0
IMU_SCK
Wire Wire Line
	4150 3550 3600 3550
Text Label 3600 3550 0    50   ~ 0
IMU_MOSI
Wire Wire Line
	4150 3650 3600 3650
Text Label 3600 3650 0    50   ~ 0
IMU_MISO
Wire Wire Line
	4150 3750 3600 3750
Text Label 3600 3750 0    50   ~ 0
IMU_CS
Wire Wire Line
	4150 3950 3600 3950
Text Label 3600 3950 0    50   ~ 0
IMU_NRST
Text Notes 7500 1950 0    50   ~ 0
TODO: level shift\n1v8 <-> 3v3
Text Label 5700 3550 0    50   ~ 0
IMU_SYNC_OUT
Wire Wire Line
	5650 3550 6250 3550
Text Label 5700 3050 0    50   ~ 0
IMU_TX1
Wire Wire Line
	5650 3050 6050 3050
Text Label 5700 3150 0    50   ~ 0
IMU_RX1
Wire Wire Line
	5650 3150 6050 3150
Text Label 5700 3250 0    50   ~ 0
IMU_TX2
Wire Wire Line
	5650 3250 6050 3250
Text Label 5700 3350 0    50   ~ 0
IMU_RX2
Wire Wire Line
	5650 3350 6050 3350
NoConn ~ 4550 2450
NoConn ~ 4650 2450
NoConn ~ 4750 2450
NoConn ~ 4850 2450
NoConn ~ 4950 2450
NoConn ~ 5050 2450
NoConn ~ 5150 2450
NoConn ~ 5250 2450
NoConn ~ 5350 2450
$Comp
L Connector_Generic:Conn_02x15_Odd_Even J2
U 1 1 5CA72B5D
P 1750 2150
F 0 "J2" H 1800 3067 50  0000 C CNN
F 1 "TO_CAMERA" H 1800 2976 50  0000 C CNN
F 2 "Connector_PinSocket_1.27mm:PinSocket_2x15_P1.27mm_Vertical" H 1750 2150 50  0001 C CNN
F 3 "~" H 1750 2150 50  0001 C CNN
	1    1750 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 1450 1450 1450
Wire Wire Line
	1450 1450 1450 1350
$Comp
L power:+1V8 #PWR0104
U 1 1 5CA7463F
P 1450 1350
F 0 "#PWR0104" H 1450 1200 50  0001 C CNN
F 1 "+1V8" H 1465 1523 50  0000 C CNN
F 2 "" H 1450 1350 50  0001 C CNN
F 3 "" H 1450 1350 50  0001 C CNN
	1    1450 1350
	1    0    0    -1  
$EndComp
$Comp
L power:+1V8 #PWR0105
U 1 1 5CA756D1
P 2200 1350
F 0 "#PWR0105" H 2200 1200 50  0001 C CNN
F 1 "+1V8" H 2215 1523 50  0000 C CNN
F 2 "" H 2200 1350 50  0001 C CNN
F 3 "" H 2200 1350 50  0001 C CNN
	1    2200 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 1450 2200 1450
Wire Wire Line
	2200 1450 2200 1350
Text Label 1050 1550 0    50   ~ 0
GPIO0_1V8
Wire Wire Line
	1000 1550 1550 1550
Text Notes 2850 3450 0    50   ~ 0
TODO: level shift\n1v8 <-> 3v3
Text Label 1050 1650 0    50   ~ 0
GPIO1_1V8
Wire Wire Line
	1000 1650 1550 1650
Text Label 1050 1750 0    50   ~ 0
GPIO2_1V8
Wire Wire Line
	1000 1750 1550 1750
Text Label 1050 1850 0    50   ~ 0
GPIO3_1V8
Wire Wire Line
	1000 1850 1550 1850
Text Label 1050 1950 0    50   ~ 0
GPIO4_1V8
Wire Wire Line
	1000 1950 1550 1950
Text Label 1050 2050 0    50   ~ 0
GPIO5_1V8
Wire Wire Line
	1000 2050 1550 2050
Text Label 1050 2150 0    50   ~ 0
GPIO6_1V8
Wire Wire Line
	1000 2150 1550 2150
Text Label 1050 2250 0    50   ~ 0
GPIO7_1V8
Wire Wire Line
	1000 2250 1550 2250
Text Label 1050 2350 0    50   ~ 0
GPIO8_1V8
Wire Wire Line
	1000 2350 1550 2350
Text Label 1050 2450 0    50   ~ 0
GPIO9_1V8
Wire Wire Line
	1000 2450 1550 2450
Text Label 1050 2550 0    50   ~ 0
GPIO10_1V8
Wire Wire Line
	1000 2550 1550 2550
Text Label 1050 2650 0    50   ~ 0
GPIO11_1V8
Wire Wire Line
	1000 2650 1550 2650
Text Label 1050 2750 0    50   ~ 0
ROOT_RX
Wire Wire Line
	1000 2750 1550 2750
Text Label 1050 2850 0    50   ~ 0
ROOT_TX
Wire Wire Line
	1000 2850 1550 2850
Text Label 2550 2250 2    50   ~ 0
GPIO12_1V8
Wire Wire Line
	2550 2250 2050 2250
Text Label 2550 2350 2    50   ~ 0
GPIO13_1V8
Wire Wire Line
	2550 2350 2050 2350
Text Label 2550 2450 2    50   ~ 0
GPIO14_1V8
Wire Wire Line
	2550 2450 2050 2450
Text Label 2550 2550 2    50   ~ 0
GPIO15_1V8
Wire Wire Line
	2550 2550 2050 2550
Text Label 2550 2650 2    50   ~ 0
GPIO16_1V8
Wire Wire Line
	2550 2650 2050 2650
Text Label 2550 2750 2    50   ~ 0
GPIO17_1V8
Wire Wire Line
	2550 2750 2050 2750
$Comp
L power:+3V3 #PWR0107
U 1 1 5CA8FC0A
P 2250 1750
F 0 "#PWR0107" H 2250 1600 50  0001 C CNN
F 1 "+3V3" H 2265 1915 39  0000 C CNN
F 2 "" H 2250 1750 50  0001 C CNN
F 3 "" H 2250 1750 50  0001 C CNN
	1    2250 1750
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2250 1750 2050 1750
$Comp
L power:+1V2 #PWR0108
U 1 1 5CA92D42
P 2250 2050
F 0 "#PWR0108" H 2250 1900 50  0001 C CNN
F 1 "+1V2" H 2265 2215 39  0000 C CNN
F 2 "" H 2250 2050 50  0001 C CNN
F 3 "" H 2250 2050 50  0001 C CNN
	1    2250 2050
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2250 2050 2050 2050
Wire Wire Line
	2050 2150 2650 2150
Wire Wire Line
	2650 2150 2650 2850
Wire Wire Line
	2650 2850 2050 2850
Wire Wire Line
	2050 1850 2650 1850
Wire Wire Line
	2650 1850 2650 2150
Connection ~ 2650 2150
Wire Wire Line
	2050 1550 2650 1550
Wire Wire Line
	2650 1550 2650 1850
Connection ~ 2650 1850
$Comp
L power:GND #PWR0109
U 1 1 5CAA1FAF
P 2650 2850
F 0 "#PWR0109" H 2650 2600 50  0001 C CNN
F 1 "GND" H 2655 2677 50  0001 C CNN
F 2 "" H 2650 2850 50  0001 C CNN
F 3 "" H 2650 2850 50  0001 C CNN
	1    2650 2850
	-1   0    0    -1  
$EndComp
Connection ~ 2650 2850
Wire Wire Line
	2050 1950 2050 2050
Connection ~ 2050 2050
Wire Wire Line
	2050 1650 2050 1750
Connection ~ 2050 1750
$Comp
L Connector_Generic:Conn_01x03 J3
U 1 1 5CAC20C4
P 1450 4150
F 0 "J3" H 1450 4500 50  0000 C CNN
F 1 "ROOT CONSOLE" H 1200 4400 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Horizontal" H 1450 4150 50  0001 C CNN
F 3 "~" H 1450 4150 50  0001 C CNN
	1    1450 4150
	-1   0    0    -1  
$EndComp
Text Label 1700 4150 0    50   ~ 0
ROOT_RX
Wire Wire Line
	1650 4150 2100 4150
Text Label 1700 4250 0    50   ~ 0
ROOT_TX
Wire Wire Line
	1650 4250 2100 4250
Wire Wire Line
	1650 4050 2100 4050
Text Label 1700 4050 0    50   ~ 0
GND
$Comp
L Device:C_Small C5
U 1 1 5CAD81A5
P 7900 2800
F 0 "C5" H 7992 2846 50  0000 L CNN
F 1 "10u" H 7992 2755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7900 2800 50  0001 C CNN
F 3 "~" H 7900 2800 50  0001 C CNN
	1    7900 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C6
U 1 1 5CAD81AF
P 8250 2800
F 0 "C6" H 8342 2846 50  0000 L CNN
F 1 "100n" H 8342 2755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8250 2800 50  0001 C CNN
F 3 "~" H 8250 2800 50  0001 C CNN
	1    8250 2800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5CAD81B9
P 7900 2900
F 0 "#PWR0110" H 7900 2650 50  0001 C CNN
F 1 "GND" H 7905 2727 50  0001 C CNN
F 2 "" H 7900 2900 50  0001 C CNN
F 3 "" H 7900 2900 50  0001 C CNN
	1    7900 2900
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0111
U 1 1 5CAD81C3
P 7900 2700
F 0 "#PWR0111" H 7900 2550 50  0001 C CNN
F 1 "+3.3V" H 7915 2873 50  0000 C CNN
F 2 "" H 7900 2700 50  0001 C CNN
F 3 "" H 7900 2700 50  0001 C CNN
	1    7900 2700
	1    0    0    -1  
$EndComp
$Comp
L Isolator:ISO7342C U3
U 1 1 5CAD81CD
P 9050 3200
F 0 "U3" H 9050 3867 50  0000 C CNN
F 1 "ISOW7842" H 9050 3776 50  0000 C CNN
F 2 "Package_SO:SOIC-16W_7.5x10.3mm_P1.27mm" H 9050 2650 50  0001 C CIN
F 3 "http://www.ti.com/general/docs/lit/getliterature.tsp?genericPartNumber=iso7342c&fileType=pdf" H 9050 3600 50  0001 C CNN
	1    9050 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 2700 8250 2700
Wire Wire Line
	8650 2700 8650 2800
Connection ~ 8250 2700
Wire Wire Line
	8250 2700 8650 2700
Wire Wire Line
	7900 2900 8250 2900
Connection ~ 8250 2900
Wire Wire Line
	8250 2900 8650 2900
Connection ~ 7900 2900
Wire Wire Line
	8650 3300 8300 3300
Text Label 8300 3300 0    50   ~ 0
GPIO2A
Wire Wire Line
	8650 3400 8300 3400
Wire Wire Line
	8650 3500 8300 3500
Text Label 8300 3500 0    50   ~ 0
GPIO2C
Wire Wire Line
	8650 3600 8300 3600
Text Label 8300 3600 0    50   ~ 0
GPIO2D
Wire Wire Line
	10200 3300 9450 3300
Text Label 9500 3300 0    50   ~ 0
GPIO2A_ISO
Wire Wire Line
	10200 3400 9450 3400
Text Label 9500 3400 0    50   ~ 0
GPIO2B_ISO
Wire Wire Line
	10200 3500 9450 3500
Text Label 9500 3500 0    50   ~ 0
GPIO2C_ISO
Wire Wire Line
	10200 3600 9450 3600
Text Label 9500 3600 0    50   ~ 0
GPIO2D_ISO
Connection ~ 7900 2700
$Comp
L Connector_Generic:Conn_01x05 J4
U 1 1 5CAD81F1
P 10400 3500
F 0 "J4" H 10480 3542 50  0000 L CNN
F 1 "GPIO2" H 10480 3451 50  0000 L CNN
F 2 "Connector_Molex:Molex_Nano-Fit_105313-xx05_1x05_P2.50mm_Horizontal" H 10400 3500 50  0001 C CNN
F 3 "~" H 10400 3500 50  0001 C CNN
	1    10400 3500
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C8
U 1 1 5CAD81FB
P 10000 2800
F 0 "C8" H 10092 2846 50  0000 L CNN
F 1 "10u" H 10092 2755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 10000 2800 50  0001 C CNN
F 3 "~" H 10000 2800 50  0001 C CNN
	1    10000 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9450 2900 9650 2900
Connection ~ 9650 2900
Connection ~ 10000 2900
Wire Wire Line
	9450 2800 9500 2800
Wire Wire Line
	9500 2800 9500 2700
Wire Wire Line
	9500 2700 9650 2700
Connection ~ 9650 2700
Connection ~ 10000 2700
Text Label 10300 2700 0    50   ~ 0
GPIO2_VCC_ISO
Wire Wire Line
	10000 2700 10900 2700
Wire Wire Line
	10000 2900 10900 2900
Text Label 9500 3700 0    50   ~ 0
GPIO2_GND_ISO
Wire Wire Line
	9500 3700 10200 3700
Text Label 10300 2900 0    50   ~ 0
GPIO2_GND_ISO
Wire Wire Line
	9650 2900 10000 2900
Wire Wire Line
	9650 2700 10000 2700
$Comp
L Device:C_Small C7
U 1 1 5CAD8215
P 9650 2800
F 0 "C7" H 9742 2846 50  0000 L CNN
F 1 "100n" H 9742 2755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 9650 2800 50  0001 C CNN
F 3 "~" H 9650 2800 50  0001 C CNN
	1    9650 2800
	1    0    0    -1  
$EndComp
Text Notes 7500 3500 0    50   ~ 0
TODO: level shift\n1v8 <-> 3v3
Text Label 8300 3400 0    50   ~ 0
GPIO2B
$Comp
L Mechanical:MountingHole_Pad H5
U 1 1 5CAF6E23
P 2300 7100
F 0 "H5" H 2250 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 2400 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 2300 7100 50  0001 C CNN
F 3 "~" H 2300 7100 50  0001 C CNN
	1    2300 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H6
U 1 1 5CAF6E2D
P 2550 7100
F 0 "H6" H 2500 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 2650 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 2550 7100 50  0001 C CNN
F 3 "~" H 2550 7100 50  0001 C CNN
	1    2550 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H7
U 1 1 5CAF6E37
P 2800 7100
F 0 "H7" H 2750 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 2900 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 2800 7100 50  0001 C CNN
F 3 "~" H 2800 7100 50  0001 C CNN
	1    2800 7100
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H8
U 1 1 5CAF6E41
P 3050 7100
F 0 "H8" H 3000 7300 50  0000 L CNN
F 1 "MountingHole_Pad" H 3150 7058 50  0001 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 3050 7100 50  0001 C CNN
F 3 "~" H 3050 7100 50  0001 C CNN
	1    3050 7100
	1    0    0    -1  
$EndComp
Text Notes 2200 6800 0    50   ~ 0
TRENZ MOUNTING HOLES
Text Notes 2200 4250 0    79   ~ 16
TODO: ESD diodes
Text Notes 2950 5600 0    79   ~ 16
TODO: isolated RS232. ADM3252E does it in a single package but wants 5v VCC.\nMaybe easiest to use "normal" RS-232 transceiver downstream of isolater IC.
NoConn ~ 8650 1550
NoConn ~ 8650 3100
Wire Wire Line
	9450 1550 9650 1550
Wire Wire Line
	9650 1550 9650 1350
Wire Wire Line
	9450 3100 9650 3100
Wire Wire Line
	9650 3100 9650 2900
Text Notes 9750 1550 0    50   ~ 0
set  V_ISO to 3v3
Text Notes 9750 3100 0    50   ~ 0
set  V_ISO to 3v3
$EndSCHEMATC
