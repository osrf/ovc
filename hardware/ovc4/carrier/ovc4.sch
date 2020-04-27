EESchema Schematic File Version 5
EELAYER 34 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
Comment5 ""
Comment6 ""
Comment7 ""
Comment8 ""
Comment9 ""
$EndDescr
$Comp
L nvidia_jetson:Jetson_Nano U1
U 3 1 5E9F1F00
P 5650 3150
F 0 "U1" H 5780 5114 50  0000 C CNN
F 1 "Jetson_Nano" H 5780 5023 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 5750 850 50  0001 C CNN
F 3 "" H 6550 1350 50  0001 C CNN
	3    5650 3150
	1    0    0    -1  
$EndComp
$Comp
L nvidia_jetson:Jetson_Nano U1
U 4 1 5E9F5B57
P 7000 3250
F 0 "U1" H 7155 5214 50  0000 C CNN
F 1 "Jetson_Nano" H 7155 5123 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 7100 950 50  0001 C CNN
F 3 "" H 7900 1450 50  0001 C CNN
	4    7000 3250
	1    0    0    -1  
$EndComp
$Sheet
S 1050 1800 850  250 
U 5EA124C3
F0 "Cameras" 50
F1 "cameras.sch" 50
$EndSheet
$Sheet
S 1050 3650 850  250 
U 5EA3CD8C
F0 "Interfaces" 50
F1 "interfaces.sch" 50
$EndSheet
$Sheet
S 1050 3000 850  250 
U 5EA33658
F0 "MCU" 50
F1 "mcu.sch" 50
$EndSheet
$Sheet
S 1050 1200 850  250 
U 5E9EA1EA
F0 "Power" 50
F1 "power.sch" 50
$EndSheet
$Sheet
S 1050 2400 850  250 
U 5EA2A3DC
F0 "USB" 50
F1 "usb.sch" 50
$EndSheet
$EndSCHEMATC
