EESchema Schematic File Version 4
LIBS:ovc2_stereo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 8 8
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
L IMU:VN-100 U4
U 1 1 59E05F71
P 3450 3550
F 0 "U4" H 2900 4350 60  0000 L CNN
F 1 "VN-100" H 4050 4350 60  0000 L CNN
F 2 "IMU:VN-100" H 4291 3444 60  0001 L CNN
F 3 "" H 3450 3550 60  0000 C CNN
F 4 "DNP" H 2900 4450 50  0001 C CNN "D1"
F 5 "DNP" H 2900 4450 50  0001 C CNN "D1PN"
F 6 "DNP" H 2900 4450 50  0001 C CNN "MFN"
F 7 "DNP" H 2900 4450 50  0001 C CNN "MPN"
	1    3450 3550
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR08
U 1 1 59E0678D
P 2750 2800
F 0 "#PWR08" H 2750 2650 50  0001 C CNN
F 1 "+3V3" H 2765 2973 50  0000 C CNN
F 2 "" H 2750 2800 50  0001 C CNN
F 3 "" H 2750 2800 50  0001 C CNN
	1    2750 2800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 59E06F47
P 3250 4450
F 0 "#PWR09" H 3250 4200 50  0001 C CNN
F 1 "GND" H 3255 4277 50  0001 C CNN
F 2 "" H 3250 4450 50  0001 C CNN
F 3 "" H 3250 4450 50  0001 C CNN
	1    3250 4450
	1    0    0    -1  
$EndComp
$Comp
L device:C_Small C5
U 1 1 59E07815
P 2400 2900
F 0 "C5" H 2492 2946 50  0000 L CNN
F 1 "100n" H 2492 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 2400 2900 50  0001 C CNN
F 3 "" H 2400 2900 50  0001 C CNN
F 4 "DNP" H 2492 3046 50  0001 C CNN "D1"
F 5 "DNP" H 2400 2900 50  0001 C CNN "MFN"
F 6 "DNP" H 2400 2900 50  0001 C CNN "MPN"
	1    2400 2900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 59E078D5
P 2400 3000
F 0 "#PWR010" H 2400 2750 50  0001 C CNN
F 1 "GND" H 2405 2827 50  0001 C CNN
F 2 "" H 2400 3000 50  0001 C CNN
F 3 "" H 2400 3000 50  0001 C CNN
	1    2400 3000
	1    0    0    -1  
$EndComp
$Comp
L IMU:uIMU-2 U15
U 1 1 5AE5AA8D
P 7250 3750
F 0 "U15" H 7525 2956 60  0000 C CNN
F 1 "uIMU-2" H 7525 2850 60  0000 C CNN
F 2 "IMU:DFP-22_0.5mmPitch_125x155mm" H 7300 3750 60  0001 C CNN
F 3 "" H 7300 3750 60  0001 C CNN
F 4 "DNP" H 0   0   50  0001 C CNN "D1"
F 5 "DNP" H 0   0   50  0001 C CNN "D1PN"
F 6 "DNP" H 0   0   50  0001 C CNN "MFN"
F 7 "DNP" H 0   0   50  0001 C CNN "MPN"
	1    7250 3750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0226
U 1 1 5AE5AC63
P 7250 4450
F 0 "#PWR0226" H 7250 4200 50  0001 C CNN
F 1 "GND" H 7255 4277 50  0001 C CNN
F 2 "" H 7250 4450 50  0001 C CNN
F 3 "" H 7250 4450 50  0001 C CNN
	1    7250 4450
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0227
U 1 1 5AE5C957
P 6450 3100
F 0 "#PWR0227" H 6450 2950 50  0001 C CNN
F 1 "+3V3" H 6465 3273 50  0000 C CNN
F 2 "" H 6450 3100 50  0001 C CNN
F 3 "" H 6450 3100 50  0001 C CNN
	1    6450 3100
	1    0    0    -1  
$EndComp
Text Label 4300 3450 0    60   ~ 0
TX2
Text Label 4300 3550 0    60   ~ 0
RX2
Text GLabel 4550 3250 2    60   Input ~ 0
IMU_TX1_3V3
Text GLabel 4550 3350 2    60   Input ~ 0
IMU_RX1_3V3
Text Label 4300 3250 0    60   ~ 0
TX1
Text Label 4300 3350 0    60   ~ 0
RX1
Text GLabel 4550 3450 2    60   Input ~ 0
IMU_TX2_3V3
Text GLabel 4550 3550 2    60   Input ~ 0
IMU_RX2_3V3
Text GLabel 6600 4050 0    60   Input ~ 0
IMU_NRST_3V3
Text GLabel 2750 3650 0    60   Input ~ 0
IMU_SCK_3V3
Text GLabel 2750 3750 0    60   Input ~ 0
IMU_MOSI_3V3
Text GLabel 2750 3450 0    60   Input ~ 0
IMU_SYNC_IN_3V3
Text GLabel 2750 3950 0    60   Input ~ 0
IMU_CS_3V3
Text GLabel 4250 3750 2    60   Input ~ 0
IMU_SYNC_OUT_3V3
Text GLabel 2750 3850 0    60   Input ~ 0
IMU_MISO_3V3
Text GLabel 8450 3850 2    60   Input ~ 0
IMU_TX1_3V3
Text GLabel 8450 3950 2    60   Input ~ 0
IMU_RX1_3V3
Text GLabel 8450 3750 2    60   Input ~ 0
IMU_SYNC_OUT_3V3
Text GLabel 6600 3750 0    60   Input ~ 0
IMU_TX2_3V3
Text GLabel 6600 3650 0    60   Input ~ 0
IMU_RX2_3V3
Text GLabel 2750 4150 0    60   Input ~ 0
IMU_NRST_3V3
Wire Wire Line
	2750 2800 2750 3050
Wire Wire Line
	3250 4450 3350 4450
Wire Wire Line
	4250 3450 4550 3450
Wire Wire Line
	4550 3550 4250 3550
Wire Wire Line
	4250 3350 4550 3350
Wire Wire Line
	4250 3250 4550 3250
Wire Wire Line
	3350 4450 3450 4450
Wire Wire Line
	3450 4450 3550 4450
Wire Wire Line
	3550 4450 3650 4450
Wire Wire Line
	3650 4450 3750 4450
Wire Wire Line
	3750 4450 3850 4450
Wire Wire Line
	2400 2800 2750 2800
Wire Wire Line
	7350 4450 7250 4450
Wire Wire Line
	6450 3100 6450 3200
Wire Wire Line
	6450 3200 6600 3200
Wire Wire Line
	6600 3100 6450 3100
Connection ~ 3350 4450
Connection ~ 3450 4450
Connection ~ 3550 4450
Connection ~ 3650 4450
Connection ~ 3750 4450
Connection ~ 7250 4450
Connection ~ 6450 3100
NoConn ~ 3150 2650
NoConn ~ 3250 2650
NoConn ~ 3350 2650
NoConn ~ 3450 2650
NoConn ~ 3550 2650
NoConn ~ 3650 2650
NoConn ~ 3750 2650
NoConn ~ 3850 2650
NoConn ~ 3950 2650
NoConn ~ 2750 3250
$EndSCHEMATC
