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
Sheet 5 14
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
U 2 1 56A03D4E
P 3100 2550
F 0 "U1" H 3100 4216 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 3100 4124 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 3100 2550 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 3100 2550 50  0001 C CNN
F 4 "_" H 3100 2550 50  0001 C CNN "MFN"
F 5 "_" H 3100 2550 50  0001 C CNN "MFP"
F 6 "digikey" H 3100 2550 50  0001 C CNN "D1"
F 7 "mouser" H 3100 2550 50  0001 C CNN "D2"
F 8 "_" H 3100 2550 50  0001 C CNN "D1PN"
F 9 "_" H 3100 2550 50  0001 C CNN "D1PL"
F 10 "_" H 3100 2550 50  0001 C CNN "D2PN"
F 11 "_" H 3100 2550 50  0001 C CNN "D2PL"
F 12 "BGA324" H 3100 2550 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 3100 2550 50  0001 C CNN "Description"
F 14 "_" H 3100 2550 50  0001 C CNN "Voltage"
F 15 "_" H 3100 2550 50  0001 C CNN "Power"
F 16 "_" H 3100 2550 50  0001 C CNN "Tolerance"
F 17 "_" H 3100 2550 50  0001 C CNN "Temperature"
F 18 "_" H 3100 2550 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3100 2550 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3100 2550 50  0001 C CNN "Cont.Current"
F 21 "_" H 3100 2550 50  0001 C CNN "Frequency"
F 22 "_" H 3100 2550 50  0001 C CNN "ResonnanceFreq"
	2    3100 2550
	1    0    0    -1  
$EndComp
$Comp
L C C148
U 1 1 56A2A89E
P 6450 3900
F 0 "C148" H 6500 4000 50  0000 L CNN
F 1 "47u" H 6500 3800 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6488 3750 50  0001 C CNN
F 3 "" H 6450 3900 50  0001 C CNN
F 4 "_" H 6450 3900 50  0001 C CNN "MFN"
F 5 "_" H 6450 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6450 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6450 3900 50  0001 C CNN "D2"
F 8 "_" H 6450 3900 50  0001 C CNN "D1PN"
F 9 "_" H 6450 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6450 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6450 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 6450 3900 50  0001 C CNN "Package"
F 13 "_" H 6565 3808 50  0001 L CNN "Description"
F 14 "6.3" H 6450 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6450 3900 50  0001 C CNN "Power"
F 16 "10%" H 6450 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6450 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6450 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6450 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6450 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6450 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6450 3900 50  0001 C CNN "ResonnanceFreq"
	1    6450 3900
	1    0    0    -1  
$EndComp
$Comp
L C C152
U 1 1 56A2A8B8
P 6800 3900
F 0 "C152" H 6825 4000 50  0000 L CNN
F 1 "4.7u" H 6825 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 6838 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6800 3900 50  0001 C CNN
F 4 "TDK" H 6800 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 6800 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6800 3900 50  0001 C CNN "D1"
F 7 "mouser" H 6800 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 6800 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 6800 3900 50  0001 C CNN "D1PL"
F 10 "_" H 6800 3900 50  0001 C CNN "D2PN"
F 11 "_" H 6800 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 6800 3900 50  0001 C CNN "Package"
F 13 "_" H 6800 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6800 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6800 3900 50  0001 C CNN "Power"
F 16 "10%" H 6800 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6800 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6800 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6800 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6800 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6800 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6800 3900 50  0001 C CNN "ResonnanceFreq"
	1    6800 3900
	1    0    0    -1  
$EndComp
$Comp
L C C159
U 1 1 56A2A8D2
P 7950 3900
F 0 "C159" H 7975 4000 50  0000 L CNN
F 1 "470n" H 7975 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7988 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7950 3900 50  0001 C CNN
F 4 "TDK" H 7950 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7950 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7950 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7950 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7950 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7950 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7950 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7950 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7950 3900 50  0001 C CNN "Package"
F 13 "_" H 7950 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7950 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7950 3900 50  0001 C CNN "Power"
F 16 "10%" H 7950 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7950 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7950 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7950 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7950 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7950 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7950 3900 50  0001 C CNN "ResonnanceFreq"
	1    7950 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 4050 7950 4050
Connection ~ 6800 4050
$Comp
L GND #PWR77
U 1 1 56A2A8DB
P 6800 4050
F 0 "#PWR77" H 6800 3800 50  0001 C CNN
F 1 "GND" H 6808 3876 50  0000 C CNN
F 2 "" H 6800 4050 50  0000 C CNN
F 3 "" H 6800 4050 50  0000 C CNN
	1    6800 4050
	1    0    0    -1  
$EndComp
$Comp
L C C154
U 1 1 56A2A8F4
P 7000 3900
F 0 "C154" H 7025 4000 50  0000 L CNN
F 1 "4.7u" H 7025 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7038 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7000 3900 50  0001 C CNN
F 4 "TDK" H 7000 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 7000 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7000 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7000 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 7000 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 7000 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7000 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7000 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 7000 3900 50  0001 C CNN "Package"
F 13 "_" H 7000 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7000 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7000 3900 50  0001 C CNN "Power"
F 16 "10%" H 7000 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7000 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7000 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7000 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7000 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7000 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7000 3900 50  0001 C CNN "ResonnanceFreq"
	1    7000 3900
	1    0    0    -1  
$EndComp
$Comp
L C C158
U 1 1 56A2A90E
P 7750 3900
F 0 "C158" H 7775 4000 50  0000 L CNN
F 1 "470n" H 7775 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7788 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7750 3900 50  0001 C CNN
F 4 "TDK" H 7750 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7750 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7750 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7750 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7750 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7750 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7750 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7750 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7750 3900 50  0001 C CNN "Package"
F 13 "_" H 7750 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7750 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7750 3900 50  0001 C CNN "Power"
F 16 "10%" H 7750 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7750 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7750 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7750 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7750 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7750 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7750 3900 50  0001 C CNN "ResonnanceFreq"
	1    7750 3900
	1    0    0    -1  
$EndComp
$Comp
L C C157
U 1 1 56A2A928
P 7550 3900
F 0 "C157" H 7575 4000 50  0000 L CNN
F 1 "470n" H 7575 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7588 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7550 3900 50  0001 C CNN
F 4 "TDK" H 7550 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7550 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7550 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7550 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7550 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7550 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7550 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7550 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7550 3900 50  0001 C CNN "Package"
F 13 "_" H 7550 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7550 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7550 3900 50  0001 C CNN "Power"
F 16 "10%" H 7550 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7550 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7550 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7550 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7550 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7550 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7550 3900 50  0001 C CNN "ResonnanceFreq"
	1    7550 3900
	1    0    0    -1  
$EndComp
$Comp
L C C156
U 1 1 56A2A942
P 7350 3900
F 0 "C156" H 7375 4000 50  0000 L CNN
F 1 "470n" H 7375 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7388 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7350 3900 50  0001 C CNN
F 4 "TDK" H 7350 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7350 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7350 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7350 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7350 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7350 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7350 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7350 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7350 3900 50  0001 C CNN "Package"
F 13 "_" H 7350 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7350 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7350 3900 50  0001 C CNN "Power"
F 16 "10%" H 7350 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7350 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7350 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7350 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7350 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7350 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7350 3900 50  0001 C CNN "ResonnanceFreq"
	1    7350 3900
	1    0    0    -1  
$EndComp
Connection ~ 7000 4050
Connection ~ 7750 4050
Connection ~ 7550 4050
Connection ~ 7350 4050
Wire Wire Line
	6450 3750 7950 3750
Connection ~ 7750 3750
Connection ~ 7550 3750
Connection ~ 7350 3750
Connection ~ 7000 3750
Connection ~ 6800 3750
$Comp
L +2V5 #PWR76
U 1 1 56A2AA1B
P 6800 3750
F 0 "#PWR76" H 6800 3600 50  0001 C CNN
F 1 "+2V5" H 6818 3924 50  0000 C CNN
F 2 "" H 6800 3750 50  0000 C CNN
F 3 "" H 6800 3750 50  0000 C CNN
	1    6800 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 3350 5300 3850
Connection ~ 5300 3450
Connection ~ 5300 3550
Connection ~ 5300 3650
Connection ~ 5300 3750
$Comp
L +2V5 #PWR65
U 1 1 56A2AA9D
P 5450 3550
F 0 "#PWR65" H 5450 3400 50  0001 C CNN
F 1 "+2V5" H 5468 3724 50  0000 C CNN
F 2 "" H 5450 3550 50  0000 C CNN
F 3 "" H 5450 3550 50  0000 C CNN
	1    5450 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 3550 5450 3550
$EndSCHEMATC
