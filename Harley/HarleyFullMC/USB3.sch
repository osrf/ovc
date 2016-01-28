EESchema Schematic File Version 2
LIBS:artix7
LIBS:cameras
LIBS:DCDC_Converters
LIBS:device
LIBS:generic_ic
LIBS:IMU
LIBS:mt41k128m16
LIBS:OSCILLATOR
LIBS:usb3_connector
LIBS:usb_controller
LIBS:i2c_flash
LIBS:power
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:HarleyFullMC-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 14 14
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
L USB_3.1_microB J1
U 1 1 56A18764
P 4950 2250
F 0 "J1" H 4800 1600 50  0000 C CNN
F 1 "USB_3.1_microB" H 4850 2950 50  0000 C CNN
F 2 "Connectors:USB3_Micro-B" H 4750 2150 50  0001 C CNN
F 3 "http://media.digikey.com/pdf/Data%20Sheets/Amphenol%20PDFs/GSB4_Series_USB_31_rev2.pdf" V 4750 2150 50  0001 C CNN
F 4 "Amphenol Commercial Products" H 4950 2250 60  0001 C CNN "MFN"
F 5 "GSB443133HR" H 4950 2250 60  0001 C CNN "MFP"
F 6 "digikey" H 4950 2250 60  0001 C CNN "D1"
F 7 "mouser" H 4950 2250 60  0001 C CNN "D2"
F 8 "GSB443133HR" H 4950 2250 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/GSB443133HR/GSB443133HRCT-ND/4936161" H 4950 2250 60  0001 C CNN "D1PL"
F 10 "_" H 4950 2250 60  0001 C CNN "D2PN"
F 11 "_" H 4950 2250 60  0001 C CNN "D2PL"
F 12 "_" H 4950 2250 60  0001 C CNN "Package"
F 13 "_" H 4950 2250 60  0000 C CNN "Description"
F 14 "_" H 4950 2250 60  0001 C CNN "Voltage"
F 15 "_" H 4950 2250 60  0001 C CNN "Power"
F 16 "_" H 4950 2250 60  0001 C CNN "Tolerance"
F 17 "_" H 4950 2250 60  0001 C CNN "Temperature"
F 18 "_" H 4950 2250 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 4950 2250 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 4950 2250 60  0001 C CNN "Cont.Current"
F 21 "_" H 4950 2250 60  0001 C CNN "Frequency"
F 22 "_" H 4950 2250 60  0001 C CNN "ResonnanceFreq"
	1    4950 2250
	1    0    0    -1  
$EndComp
$Comp
L IC10pins U8
U 1 1 56A1877D
P 4850 3600
F 0 "U8" H 4900 3200 50  0000 C CNN
F 1 "IC10pins" H 4900 3950 50  0000 C CNN
F 2 "UFDFN:10-UFDFN" H 4900 3500 50  0001 C CNN
F 3 "http://www.littelfuse.com/~/media/electronics/datasheets/tvs_diode_arrays/littelfuse_tvs_diode_array_sp3010_datasheet.pdf.pdf" H 4900 3500 50  0001 C CNN
F 4 "Littelfuse Inc" H 4850 3600 60  0001 C CNN "MFN"
F 5 "SP3010-04UTG" H 4850 3600 60  0001 C CNN "MFP"
F 6 "digikey" H 4850 3600 60  0001 C CNN "D1"
F 7 "mouser" H 4850 3600 60  0001 C CNN "D2"
F 8 "F3507" H 4850 3600 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/SP3010-04UTG/F3507CT-ND/2297266" H 4850 3600 60  0001 C CNN "D1PL"
F 10 "_" H 4850 3600 60  0001 C CNN "D2PN"
F 11 "_" H 4850 3600 60  0001 C CNN "D2PL"
F 12 "10-UFDFN" H 4850 3600 60  0001 C CNN "Package"
F 13 "_" H 4850 3600 60  0000 C CNN "Description"
F 14 "_" H 4850 3600 60  0001 C CNN "Voltage"
F 15 "_" H 4850 3600 60  0001 C CNN "Power"
F 16 "_" H 4850 3600 60  0001 C CNN "Tolerance"
F 17 "_" H 4850 3600 60  0001 C CNN "Temperature"
F 18 "_" H 4850 3600 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 4850 3600 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 4850 3600 60  0001 C CNN "Cont.Current"
F 21 "_" H 4850 3600 60  0001 C CNN "Frequency"
F 22 "_" H 4850 3600 60  0001 C CNN "ResonnanceFreq"
	1    4850 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR48
U 1 1 56A18783
P 4450 3600
F 0 "#PWR48" H 4450 3350 50  0001 C CNN
F 1 "GND" H 4450 3450 50  0000 C CNN
F 2 "" H 4450 3600 60  0000 C CNN
F 3 "" H 4450 3600 60  0000 C CNN
	1    4450 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR65
U 1 1 56A18789
P 5400 3600
F 0 "#PWR65" H 5400 3350 50  0001 C CNN
F 1 "GND" H 5400 3450 50  0000 C CNN
F 2 "" H 5400 3600 60  0000 C CNN
F 3 "" H 5400 3600 60  0000 C CNN
	1    5400 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR47
U 1 1 56A1878F
P 4450 3050
F 0 "#PWR47" H 4450 2800 50  0001 C CNN
F 1 "GND" H 4450 2900 50  0000 C CNN
F 2 "" H 4450 3050 60  0000 C CNN
F 3 "" H 4450 3050 60  0000 C CNN
	1    4450 3050
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR50
U 1 1 56A187AE
P 4750 900
F 0 "#PWR50" H 4750 750 50  0001 C CNN
F 1 "+5V" H 4750 1040 50  0000 C CNN
F 2 "" H 4750 900 60  0000 C CNN
F 3 "" H 4750 900 60  0000 C CNN
	1    4750 900 
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR51
U 1 1 56A187B4
P 4750 1200
F 0 "#PWR51" H 4750 950 50  0001 C CNN
F 1 "GND" H 4750 1050 50  0000 C CNN
F 2 "" H 4750 1200 60  0000 C CNN
F 3 "" H 4750 1200 60  0000 C CNN
	1    4750 1200
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR46
U 1 1 56A187BA
P 4450 1850
F 0 "#PWR46" H 4450 1700 50  0001 C CNN
F 1 "+5V" H 4450 1990 50  0000 C CNN
F 2 "" H 4450 1850 60  0000 C CNN
F 3 "" H 4450 1850 60  0000 C CNN
	1    4450 1850
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 J2
U 1 1 56A24E0A
P 5000 1050
F 0 "J2" H 5078 1187 50  0000 L CNN
F 1 "CONN_01X04" H 5078 1095 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04_Pitch1.27mm" H 5078 1003 50  0000 L CNN
F 3 "" H 5000 1050 50  0000 C CNN
F 4 "_" H 5000 1050 60  0001 C CNN "MFN"
F 5 "_" H 5000 1050 60  0001 C CNN "MFP"
F 6 "digikey" H 5000 1050 60  0001 C CNN "D1"
F 7 "mouser" H 5000 1050 60  0001 C CNN "D2"
F 8 "_" H 5000 1050 60  0001 C CNN "D1PN"
F 9 "_" H 5000 1050 60  0001 C CNN "D1PL"
F 10 "_" H 5000 1050 60  0001 C CNN "D2PN"
F 11 "_" H 5000 1050 60  0001 C CNN "D2PL"
F 12 "_" H 5000 1050 60  0001 C CNN "Package"
F 13 "_" H 5078 904 60  0000 L CNN "Description"
F 14 "_" H 5000 1050 60  0001 C CNN "Voltage"
F 15 "_" H 5000 1050 60  0001 C CNN "Power"
F 16 "_" H 5000 1050 60  0001 C CNN "Tolerance"
F 17 "_" H 5000 1050 60  0001 C CNN "Temperature"
F 18 "_" H 5000 1050 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 5000 1050 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 5000 1050 60  0001 C CNN "Cont.Current"
F 21 "_" H 5000 1050 60  0001 C CNN "Frequency"
F 22 "_" H 5000 1050 60  0001 C CNN "ResonnanceFreq"
	1    5000 1050
	1    0    0    -1  
$EndComp
Text GLabel 4450 2250 0    60   Input ~ 12
SS_TX-
Text GLabel 4450 2350 0    60   Input ~ 12
SS_TX+
Text GLabel 4450 2450 0    60   Input ~ 12
SS_RX-
Text GLabel 4450 2550 0    60   Input ~ 12
SS_RX+
Text GLabel 4200 3400 0    60   Input ~ 12
SS_TX-
Text GLabel 4200 3500 0    60   Input ~ 12
SS_TX+
Text GLabel 4200 3700 0    60   Input ~ 12
SS_RX-
Text GLabel 4200 3800 0    60   Input ~ 12
SS_RX+
Text GLabel 5550 3400 2    60   Input ~ 12
SS_TX-
Text GLabel 5550 3500 2    60   Input ~ 12
SS_TX+
Text GLabel 5550 3700 2    60   Input ~ 12
SS_RX-
Text GLabel 5550 3800 2    60   Input ~ 12
SS_RX+
Text GLabel 4450 1950 0    60   Input ~ 0
USB_HS_D-
Text GLabel 4450 2050 0    60   Input ~ 0
USB_HS_D+
Text GLabel 4800 1000 0    60   Input ~ 0
USB_HS_D-
Text GLabel 4800 1100 0    60   Input ~ 0
USB_HS_D+
Wire Wire Line
	4450 2650 4450 3050
Wire Wire Line
	4450 3600 4550 3600
Wire Wire Line
	5400 3600 5250 3600
Wire Wire Line
	4200 3700 4550 3700
Wire Wire Line
	4200 3800 4550 3800
Wire Wire Line
	4200 3400 4550 3400
Wire Wire Line
	4550 3500 4200 3500
Wire Wire Line
	5250 3400 5550 3400
Wire Wire Line
	5250 3500 5550 3500
Wire Wire Line
	5250 3700 5550 3700
Wire Wire Line
	5250 3800 5550 3800
Wire Wire Line
	4750 900  4800 900 
Wire Wire Line
	4750 1200 4800 1200
Wire Wire Line
	4450 3050 4950 3050
Connection ~ 4450 2750
NoConn ~ 4450 2150
$EndSCHEMATC
