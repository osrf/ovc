EESchema Schematic File Version 4
LIBS:ovc2_mobo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 19 23
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
L 5cgtfd5_u484:5CGTFD5U19 U23
U 3 1 59F5F422
P 3750 3650
F 0 "U23" H 4361 6315 50  0000 C CNN
F 1 "5CGTFD5C5U19I7N" H 4361 6224 50  0000 C CNN
F 2 "BGA:INTEL_U484" H 3750 3650 50  0001 C CNN
F 3 "" H 3750 3650 50  0001 C CNN
F 4 "mouser" H 3750 3650 50  0001 C CNN "D1"
F 5 "989-5CGTFD5C5U19I7N" H 3750 3650 50  0001 C CNN "D1PN"
F 6 "Altera" H 3750 3650 50  0001 C CNN "MFN"
F 7 "5CGTFD5C5U19I7N" H 4361 6415 50  0001 C CNN "MPN"
	3    3750 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0133
U 1 1 59F600DB
P 5050 6050
F 0 "#PWR0133" H 5050 5800 50  0001 C CNN
F 1 "GND" H 5055 5877 50  0001 C CNN
F 2 "" H 5050 6050 50  0001 C CNN
F 3 "" H 5050 6050 50  0001 C CNN
	1    5050 6050
	1    0    0    -1  
$EndComp
Text GLabel 5050 2150 2    60   Input ~ 0
CAM1_CLKIN+
Text GLabel 5050 2050 2    60   Input ~ 0
CAM1_CLKIN-
Text GLabel 5050 2750 2    60   Input ~ 0
CAM1_CS
Text GLabel 5050 4250 2    60   Input ~ 0
CAM1_MOSI
Text GLabel 5050 5150 2    60   Input ~ 0
CAM1_TRG
Text GLabel 5050 2650 2    60   Input ~ 0
CAM1_RST
Text GLabel 5050 3450 2    60   Input ~ 0
CAM1_SCK
Text GLabel 5050 4350 2    60   Input ~ 0
IMU_NRST
Text GLabel 5050 4450 2    60   Input ~ 0
IMU_SYNC_OUT
Text GLabel 5050 4550 2    60   Input ~ 0
IMU_SCK
Text GLabel 5050 5350 2    60   Input ~ 0
IMU_MOSI
Text GLabel 5050 5250 2    60   Input ~ 0
IMU_MISO
Text GLabel 5050 3550 2    60   Input ~ 0
IMU_TARE
Text GLabel 5050 5950 2    60   Input ~ 0
IMU_SYNC_IN
Text GLabel 5050 5850 2    60   Input ~ 0
IMU_CS
Text GLabel 5050 5050 2    60   Input ~ 0
CAM1_MISO
$EndSCHEMATC
