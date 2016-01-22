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
Sheet 8 14
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
L xc7a50tcsg324pkg U1
U 5 1 56A0474D
P 2600 2700
F 0 "U1" H 2600 4366 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 2600 4274 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 2600 2700 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 2600 2700 50  0001 C CNN
F 4 "_" H 2600 2700 50  0001 C CNN "MFN"
F 5 "_" H 2600 2700 50  0001 C CNN "MFP"
F 6 "digikey" H 2600 2700 50  0001 C CNN "D1"
F 7 "mouser" H 2600 2700 50  0001 C CNN "D2"
F 8 "_" H 2600 2700 50  0001 C CNN "D1PN"
F 9 "_" H 2600 2700 50  0001 C CNN "D1PL"
F 10 "_" H 2600 2700 50  0001 C CNN "D2PN"
F 11 "_" H 2600 2700 50  0001 C CNN "D2PL"
F 12 "BGA324" H 2600 2700 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 2600 2700 50  0001 C CNN "Description"
F 14 "_" H 2600 2700 50  0001 C CNN "Voltage"
F 15 "_" H 2600 2700 50  0001 C CNN "Power"
F 16 "_" H 2600 2700 50  0001 C CNN "Tolerance"
F 17 "_" H 2600 2700 50  0001 C CNN "Temperature"
F 18 "_" H 2600 2700 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 2600 2700 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 2600 2700 50  0001 C CNN "Cont.Current"
F 21 "_" H 2600 2700 50  0001 C CNN "Frequency"
F 22 "_" H 2600 2700 50  0001 C CNN "ResonnanceFreq"
	5    2600 2700
	1    0    0    -1  
$EndComp
$Comp
L C C141
U 1 1 56A2BB19
P 5450 3900
F 0 "C141" H 5475 4000 50  0000 L CNN
F 1 "4.7u" H 5475 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5488 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5450 3900 50  0001 C CNN
F 4 "TDK" H 5450 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5450 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 5450 3900 50  0001 C CNN "D1"
F 7 "mouser" H 5450 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 5450 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5450 3900 50  0001 C CNN "D1PL"
F 10 "_" H 5450 3900 50  0001 C CNN "D2PN"
F 11 "_" H 5450 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 5450 3900 50  0001 C CNN "Package"
F 13 "_" H 5450 3900 50  0000 C CNN "Description"
F 14 "6.3" H 5450 3900 50  0001 C CNN "Voltage"
F 15 "_" H 5450 3900 50  0001 C CNN "Power"
F 16 "10%" H 5450 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5450 3900 50  0001 C CNN "Temperature"
F 18 "_" H 5450 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5450 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5450 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 5450 3900 50  0001 C CNN "Frequency"
F 22 "_" H 5450 3900 50  0001 C CNN "ResonnanceFreq"
	1    5450 3900
	1    0    0    -1  
$EndComp
$Comp
L C C150
U 1 1 56A2BB33
P 6600 3900
F 0 "C150" H 6625 4000 50  0000 L CNN
F 1 "470n" H 6625 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6638 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6600 3900 50  0001 C CNN
F 4 "TDK" H 6600 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6600 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6600 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6600 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 6600 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6600 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6600 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6600 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 6600 3900 50  0001 C CNN "Package"
F 13 "_" H 6600 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6600 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6600 3900 50  0001 C CNN "Power"
F 16 "10%" H 6600 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6600 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6600 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6600 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6600 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6600 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6600 3900 50  0001 C CNN "ResonnanceFreq"
	1    6600 3900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR67
U 1 1 56A2BB3A
P 5450 4050
F 0 "#PWR67" H 5450 3800 50  0001 C CNN
F 1 "GND" H 5458 3876 50  0000 C CNN
F 2 "" H 5450 4050 50  0000 C CNN
F 3 "" H 5450 4050 50  0000 C CNN
	1    5450 4050
	1    0    0    -1  
$EndComp
$Comp
L C C142
U 1 1 56A2BB53
P 5650 3900
F 0 "C142" H 5675 4000 50  0000 L CNN
F 1 "4.7u" H 5675 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5688 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5650 3900 50  0001 C CNN
F 4 "TDK" H 5650 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5650 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 5650 3900 50  0001 C CNN "D1"
F 7 "mouser" H 5650 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 5650 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5650 3900 50  0001 C CNN "D1PL"
F 10 "_" H 5650 3900 50  0001 C CNN "D2PN"
F 11 "_" H 5650 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 5650 3900 50  0001 C CNN "Package"
F 13 "_" H 5650 3900 50  0000 C CNN "Description"
F 14 "6.3" H 5650 3900 50  0001 C CNN "Voltage"
F 15 "_" H 5650 3900 50  0001 C CNN "Power"
F 16 "10%" H 5650 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5650 3900 50  0001 C CNN "Temperature"
F 18 "_" H 5650 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5650 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5650 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 5650 3900 50  0001 C CNN "Frequency"
F 22 "_" H 5650 3900 50  0001 C CNN "ResonnanceFreq"
	1    5650 3900
	1    0    0    -1  
$EndComp
$Comp
L C C147
U 1 1 56A2BB6D
P 6400 3900
F 0 "C147" H 6425 4000 50  0000 L CNN
F 1 "470n" H 6425 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6438 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6400 3900 50  0001 C CNN
F 4 "TDK" H 6400 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6400 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6400 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6400 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 6400 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6400 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6400 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6400 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 6400 3900 50  0001 C CNN "Package"
F 13 "_" H 6400 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6400 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6400 3900 50  0001 C CNN "Power"
F 16 "10%" H 6400 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6400 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6400 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6400 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6400 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6400 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6400 3900 50  0001 C CNN "ResonnanceFreq"
	1    6400 3900
	1    0    0    -1  
$EndComp
$Comp
L C C146
U 1 1 56A2BB87
P 6200 3900
F 0 "C146" H 6225 4000 50  0000 L CNN
F 1 "470n" H 6225 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6238 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6200 3900 50  0001 C CNN
F 4 "TDK" H 6200 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6200 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6200 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6200 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 6200 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6200 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6200 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6200 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 6200 3900 50  0001 C CNN "Package"
F 13 "_" H 6200 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6200 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6200 3900 50  0001 C CNN "Power"
F 16 "10%" H 6200 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6200 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6200 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6200 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6200 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6200 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6200 3900 50  0001 C CNN "ResonnanceFreq"
	1    6200 3900
	1    0    0    -1  
$EndComp
$Comp
L C C144
U 1 1 56A2BBA1
P 6000 3900
F 0 "C144" H 6025 4000 50  0000 L CNN
F 1 "470n" H 6025 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6038 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6000 3900 50  0001 C CNN
F 4 "TDK" H 6000 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6000 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6000 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6000 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 6000 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6000 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6000 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6000 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 6000 3900 50  0001 C CNN "Package"
F 13 "_" H 6000 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6000 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6000 3900 50  0001 C CNN "Power"
F 16 "10%" H 6000 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6000 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6000 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6000 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6000 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6000 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6000 3900 50  0001 C CNN "ResonnanceFreq"
	1    6000 3900
	1    0    0    -1  
$EndComp
Connection ~ 5650 4050
Connection ~ 6400 4050
Connection ~ 6200 4050
Connection ~ 6000 4050
Connection ~ 6400 3750
Connection ~ 6200 3750
Connection ~ 6000 3750
Connection ~ 5650 3750
$Comp
L +2V5 #PWR66
U 1 1 56A2BBB0
P 5450 3750
F 0 "#PWR66" H 5450 3600 50  0001 C CNN
F 1 "+2V5" H 5468 3924 50  0000 C CNN
F 2 "" H 5450 3750 50  0000 C CNN
F 3 "" H 5450 3750 50  0000 C CNN
	1    5450 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 4050 6600 4050
Wire Wire Line
	6600 3750 5450 3750
Wire Wire Line
	4300 3500 4300 4000
Connection ~ 4300 3600
Connection ~ 4300 3700
Connection ~ 4300 3800
Connection ~ 4300 3900
$Comp
L +2V5 #PWR45
U 1 1 56A2BC20
P 4450 3700
F 0 "#PWR45" H 4450 3550 50  0001 C CNN
F 1 "+2V5" H 4468 3874 50  0000 C CNN
F 2 "" H 4450 3700 50  0000 C CNN
F 3 "" H 4450 3700 50  0000 C CNN
	1    4450 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 3700 4450 3700
$EndSCHEMATC
