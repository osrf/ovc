EESchema Schematic File Version 2
LIBS:device
LIBS:artix7
LIBS:OSCILLATOR
LIBS:mt41k128m16
LIBS:DCDC_Converters
LIBS:usb_controller
LIBS:usb3_connector
LIBS:i2c_flash
LIBS:generic_ic
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
LIBS:HarleyGhostRider-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 12 12
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
P 4850 4050
F 0 "U8" H 4900 3650 50  0000 C CNN
F 1 "IC10pins" H 4900 4400 50  0000 C CNN
F 2 "UFDFN:10-UFDFN" H 4900 3950 50  0001 C CNN
F 3 "http://www.littelfuse.com/~/media/electronics/datasheets/tvs_diode_arrays/littelfuse_tvs_diode_array_sp3010_datasheet.pdf.pdf" H 4900 3950 50  0001 C CNN
F 4 "Littelfuse Inc" H 4850 4050 60  0001 C CNN "MFN"
F 5 "SP3010-04UTG" H 4850 4050 60  0001 C CNN "MFP"
F 6 "digikey" H 4850 4050 60  0001 C CNN "D1"
F 7 "mouser" H 4850 4050 60  0001 C CNN "D2"
F 8 "F3507" H 4850 4050 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/SP3010-04UTG/F3507CT-ND/2297266" H 4850 4050 60  0001 C CNN "D1PL"
F 10 "_" H 4850 4050 60  0001 C CNN "D2PN"
F 11 "_" H 4850 4050 60  0001 C CNN "D2PL"
F 12 "10-UFDFN" H 4850 4050 60  0001 C CNN "Package"
F 13 "_" H 4850 4050 60  0000 C CNN "Description"
F 14 "_" H 4850 4050 60  0001 C CNN "Voltage"
F 15 "_" H 4850 4050 60  0001 C CNN "Power"
F 16 "_" H 4850 4050 60  0001 C CNN "Tolerance"
F 17 "_" H 4850 4050 60  0001 C CNN "Temperature"
F 18 "_" H 4850 4050 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 4850 4050 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 4850 4050 60  0001 C CNN "Cont.Current"
F 21 "_" H 4850 4050 60  0001 C CNN "Frequency"
F 22 "_" H 4850 4050 60  0001 C CNN "ResonnanceFreq"
	1    4850 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR086
U 1 1 56A18783
P 4450 4050
F 0 "#PWR086" H 4450 3800 50  0001 C CNN
F 1 "GND" H 4450 3900 50  0000 C CNN
F 2 "" H 4450 4050 60  0000 C CNN
F 3 "" H 4450 4050 60  0000 C CNN
	1    4450 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR087
U 1 1 56A18789
P 5400 4050
F 0 "#PWR087" H 5400 3800 50  0001 C CNN
F 1 "GND" H 5400 3900 50  0000 C CNN
F 2 "" H 5400 4050 60  0000 C CNN
F 3 "" H 5400 4050 60  0000 C CNN
	1    5400 4050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR088
U 1 1 56A1878F
P 4450 3150
F 0 "#PWR088" H 4450 2900 50  0001 C CNN
F 1 "GND" H 4450 3000 50  0000 C CNN
F 2 "" H 4450 3150 60  0000 C CNN
F 3 "" H 4450 3150 60  0000 C CNN
	1    4450 3150
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR089
U 1 1 56A187BA
P 4450 1850
F 0 "#PWR089" H 4450 1700 50  0001 C CNN
F 1 "+5V" H 4450 1990 50  0000 C CNN
F 2 "" H 4450 1850 60  0000 C CNN
F 3 "" H 4450 1850 60  0000 C CNN
	1    4450 1850
	1    0    0    -1  
$EndComp
$Comp
L R R23
U 1 1 56AC4A3A
P 4800 3200
F 0 "R23" H 4870 3292 50  0000 L CNN
F 1 "1M" H 4870 3200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" V 4730 3200 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20052/crcw0201e3.pdf" H 4800 3200 30  0001 C CNN
F 4 "Vishay" H 4800 3200 50  0001 C CNN "MFN"
F 5 "CRCW02011M00FNED" H 4800 3200 50  0001 C CNN "MFP"
F 6 "digikey" H 4800 3200 50  0001 C CNN "D1"
F 7 "mouser" H 4800 3200 50  0001 C CNN "D2"
F 8 "541-1.00MAB" H 4800 3200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW02011M00FNED/541-1.00MABTR-ND/1178507" H 4800 3200 50  0001 C CNN "D1PL"
F 10 "_" H 4800 3200 50  0001 C CNN "D2PN"
F 11 "_" H 4800 3200 50  0001 C CNN "D2PL"
F 12 "0201" H 4800 3200 50  0001 C CNN "Package"
F 13 "_" H 4870 3108 50  0000 L CNN "Description"
F 14 "_" H 4800 3200 50  0001 C CNN "Voltage"
F 15 "1/20" H 4800 3200 50  0001 C CNN "Power"
F 16 "1%" H 4800 3200 50  0001 C CNN "Tolerance"
F 17 "_" H 4800 3200 50  0001 C CNN "Temperature"
F 18 "_" H 4800 3200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4800 3200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4800 3200 50  0001 C CNN "Cont.Current"
F 21 "_" H 4800 3200 50  0001 C CNN "Frequency"
F 22 "_" H 4800 3200 50  0001 C CNN "ResonnanceFreq"
	1    4800 3200
	1    0    0    -1  
$EndComp
$Comp
L C C126
U 1 1 56AC4ADD
P 5100 3200
F 0 "C126" H 5215 3292 50  0000 L CNN
F 1 "4.7n" H 5215 3200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5138 3050 50  0001 C CNN
F 3 "https://product.tdk.com/info/en/catalog/spec/mlccspec_commercial_general_midvoltage_en.pdf" H 5100 3200 50  0001 C CNN
F 4 "TDK" H 5100 3200 50  0001 C CNN "MFN"
F 5 "C1005X7S2A472K050BB" H 5100 3200 50  0001 C CNN "MFP"
F 6 "digikey" H 5100 3200 50  0001 C CNN "D1"
F 7 "mouser" H 5100 3200 50  0001 C CNN "D2"
F 8 "445-6026" H 5100 3200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X7S2A472K050BB/445-6026-1-ND/2444067" H 5100 3200 50  0001 C CNN "D1PL"
F 10 "_" H 5100 3200 50  0001 C CNN "D2PN"
F 11 "_" H 5100 3200 50  0001 C CNN "D2PL"
F 12 "0402" H 5100 3200 50  0001 C CNN "Package"
F 13 "_" H 5215 3108 50  0000 L CNN "Description"
F 14 "100" H 5100 3200 50  0001 C CNN "Voltage"
F 15 "_" H 5100 3200 50  0001 C CNN "Power"
F 16 "10%" H 5100 3200 50  0001 C CNN "Tolerance"
F 17 "X7s" H 5100 3200 50  0001 C CNN "Temperature"
F 18 "_" H 5100 3200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5100 3200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5100 3200 50  0001 C CNN "Cont.Current"
F 21 "_" H 5100 3200 50  0001 C CNN "Frequency"
F 22 "_" H 5100 3200 50  0001 C CNN "ResonnanceFreq"
	1    5100 3200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR090
U 1 1 56AC4CB1
P 4950 3350
F 0 "#PWR090" H 4950 3100 50  0001 C CNN
F 1 "GND" H 4958 3176 50  0000 C CNN
F 2 "" H 4950 3350 50  0000 C CNN
F 3 "" H 4950 3350 50  0000 C CNN
	1    4950 3350
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
Text GLabel 4200 3850 0    60   Input ~ 12
SS_TX-
Text GLabel 4200 3950 0    60   Input ~ 12
SS_TX+
Text GLabel 4200 4150 0    60   Input ~ 12
SS_RX-
Text GLabel 4200 4250 0    60   Input ~ 12
SS_RX+
Text GLabel 5550 3850 2    60   Input ~ 12
SS_TX-
Text GLabel 5550 3950 2    60   Input ~ 12
SS_TX+
Text GLabel 5550 4150 2    60   Input ~ 12
SS_RX-
Text GLabel 5550 4250 2    60   Input ~ 12
SS_RX+
Text GLabel 4450 1950 0    60   Input ~ 0
USB_HS_D-
Text GLabel 4450 2050 0    60   Input ~ 0
USB_HS_D+
Wire Wire Line
	4450 2650 4450 3150
Wire Wire Line
	4450 4050 4550 4050
Wire Wire Line
	5400 4050 5250 4050
Wire Wire Line
	4200 4150 4550 4150
Wire Wire Line
	4200 4250 4550 4250
Wire Wire Line
	4200 3850 4550 3850
Wire Wire Line
	4550 3950 4200 3950
Wire Wire Line
	5250 3850 5550 3850
Wire Wire Line
	5250 3950 5550 3950
Wire Wire Line
	5250 4150 5550 4150
Wire Wire Line
	5250 4250 5550 4250
Wire Wire Line
	4800 3050 5100 3050
Wire Wire Line
	4800 3350 5100 3350
Connection ~ 4450 2750
Connection ~ 4950 3050
Connection ~ 4950 3350
NoConn ~ 4450 2150
$EndSCHEMATC
