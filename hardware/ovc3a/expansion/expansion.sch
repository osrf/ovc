EESchema Schematic File Version 4
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
F 0 "U1" H 5694 3403 60  0000 L CNN
F 1 "VN-100" H 5694 3297 60  0000 L CNN
F 2 "IMU:VN-100" H 4850 3350 60  0001 C CNN
F 3 "http://www.vectornav.com/docs/default-source/documentation/vn-100-documentation/UM001.pdf?sfvrsn=10" H 5694 3244 60  0001 L CNN
	1    4850 3350
	1    0    0    -1  
$EndComp
Text Notes 4150 2000 0    118  ~ 24
use MPU-9250 symbol for now,\nswitch to ICM-20498 when merged
$Comp
L Isolator:ADuM5412 U2
U 1 1 5C45C387
P 9600 4400
F 0 "U2" H 9600 3711 50  0000 C CNN
F 1 "ADuM5412" H 9600 3620 50  0000 C CNN
F 2 "Package_SO:SSOP-24_5.3x8.2mm_P0.65mm" H 9650 3250 50  0001 C CIN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/ADuM5410-5411-5412.pdf" H 9100 4750 50  0001 C CNN
	1    9600 4400
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
L power:GND #PWR0101
U 1 1 5C45EDF2
P 1000 7200
F 0 "#PWR0101" H 1000 6950 50  0001 C CNN
F 1 "GND" H 1005 7027 50  0001 C CNN
F 2 "" H 1000 7200 50  0001 C CNN
F 3 "" H 1000 7200 50  0001 C CNN
	1    1000 7200
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
Wire Wire Line
	1250 7200 1000 7200
Connection ~ 1000 7200
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
Wire Wire Line
	1750 7200 1500 7200
Connection ~ 1250 7200
Connection ~ 1500 7200
Wire Wire Line
	1500 7200 1250 7200
$EndSCHEMATC
