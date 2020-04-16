EESchema Schematic File Version 5
EELAYER 33 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 5
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
Text GLabel 4250 2850 2    50   Input ~ 0
USB_SCL
Text GLabel 4250 2950 2    50   Input ~ 0
USB_SDA
Text GLabel 4250 3700 2    50   Input ~ 0
NX_SPI_CLK
Text GLabel 4250 3800 2    50   Input ~ 0
NX_SPI_MOSI
Text GLabel 4250 3900 2    50   Input ~ 0
NX_SPI_MISO
Text GLabel 4250 4000 2    50   Input ~ 0
NX_SPI_CS
$Comp
L nvidia_jetson:Jetson_Nano U1
U 7 1 5E9FDC9C
P 10250 3150
F 0 "U1" H 10300 4264 50  0000 C CNN
F 1 "Jetson_Nano" H 10300 4173 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 10350 850 50  0001 C CNN
F 3 "" H 11150 1350 50  0001 C CNN
	7    10250 3150
	1    0    0    -1  
$EndComp
$Comp
L nvidia_jetson:Jetson_Nano U1
U 3 1 5E9F1F00
P 5300 2950
F 0 "U1" H 5430 4914 50  0000 C CNN
F 1 "Jetson_Nano" H 5430 4823 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 5400 650 50  0001 C CNN
F 3 "" H 6200 1150 50  0001 C CNN
	3    5300 2950
	1    0    0    -1  
$EndComp
$Comp
L nvidia_jetson:Jetson_Nano U1
U 4 1 5E9F5B57
P 6650 3050
F 0 "U1" H 6805 5014 50  0000 C CNN
F 1 "Jetson_Nano" H 6805 4923 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 6750 750 50  0001 C CNN
F 3 "" H 7550 1250 50  0001 C CNN
	4    6650 3050
	1    0    0    -1  
$EndComp
$Comp
L nvidia_jetson:Jetson_Nano U1
U 6 1 5E9FB4B7
P 3750 3400
F 0 "U1" H 3856 5964 50  0000 C CNN
F 1 "Jetson_Nano" H 3856 5873 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 3850 1100 50  0001 C CNN
F 3 "" H 4650 1600 50  0001 C CNN
	6    3750 3400
	1    0    0    -1  
$EndComp
$Sheet
S 1050 1800 850  250 
U 5EA124C3
F0 "Cameras" 50
F1 "cameras.sch" 50
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
