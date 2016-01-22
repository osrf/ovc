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
Sheet 7 14
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
U 4 1 56A04624
P 2950 2800
F 0 "U1" H 2950 3266 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 2950 3174 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 2950 2800 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 2950 2800 50  0001 C CNN
F 4 "_" H 2950 2800 50  0001 C CNN "MFN"
F 5 "_" H 2950 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 2950 2800 50  0001 C CNN "D1"
F 7 "mouser" H 2950 2800 50  0001 C CNN "D2"
F 8 "_" H 2950 2800 50  0001 C CNN "D1PN"
F 9 "_" H 2950 2800 50  0001 C CNN "D1PL"
F 10 "_" H 2950 2800 50  0001 C CNN "D2PN"
F 11 "_" H 2950 2800 50  0001 C CNN "D2PL"
F 12 "BGA324" H 2950 2800 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 2950 2800 50  0001 C CNN "Description"
F 14 "_" H 2950 2800 50  0001 C CNN "Voltage"
F 15 "_" H 2950 2800 50  0001 C CNN "Power"
F 16 "_" H 2950 2800 50  0001 C CNN "Tolerance"
F 17 "_" H 2950 2800 50  0001 C CNN "Temperature"
F 18 "_" H 2950 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 2950 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 2950 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 2950 2800 50  0001 C CNN "Frequency"
F 22 "_" H 2950 2800 50  0001 C CNN "ResonnanceFreq"
	4    2950 2800
	1    0    0    -1  
$EndComp
$Comp
L +3.3V #PWR51
U 1 1 56A25649
P 4950 3000
F 0 "#PWR51" H 4950 2850 50  0001 C CNN
F 1 "+3.3V" H 4968 3174 50  0000 C CNN
F 2 "" H 4950 3000 50  0000 C CNN
F 3 "" H 4950 3000 50  0000 C CNN
	1    4950 3000
	1    0    0    -1  
$EndComp
$Comp
L C C128
U 1 1 56A25D81
P 4950 3150
F 0 "C128" H 5065 3242 50  0000 L CNN
F 1 "47u" H 5065 3150 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 4988 3000 50  0001 C CNN
F 3 "" H 4950 3150 50  0001 C CNN
F 4 "_" H 4950 3150 50  0001 C CNN "MFN"
F 5 "_" H 4950 3150 50  0001 C CNN "MFP"
F 6 "digikey" H 4950 3150 50  0001 C CNN "D1"
F 7 "mouser" H 4950 3150 50  0001 C CNN "D2"
F 8 "_" H 4950 3150 50  0001 C CNN "D1PN"
F 9 "_" H 4950 3150 50  0001 C CNN "D1PL"
F 10 "_" H 4950 3150 50  0001 C CNN "D2PN"
F 11 "_" H 4950 3150 50  0001 C CNN "D2PL"
F 12 "0402" H 4950 3150 50  0001 C CNN "Package"
F 13 "_" H 5065 3058 50  0000 L CNN "Description"
F 14 "6.3" H 4950 3150 50  0001 C CNN "Voltage"
F 15 "_" H 4950 3150 50  0001 C CNN "Power"
F 16 "10%" H 4950 3150 50  0001 C CNN "Tolerance"
F 17 "X5R" H 4950 3150 50  0001 C CNN "Temperature"
F 18 "_" H 4950 3150 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4950 3150 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4950 3150 50  0001 C CNN "Cont.Current"
F 21 "_" H 4950 3150 50  0001 C CNN "Frequency"
F 22 "_" H 4950 3150 50  0001 C CNN "ResonnanceFreq"
	1    4950 3150
	1    0    0    -1  
$EndComp
$Comp
L C C129
U 1 1 56A2606F
P 5300 3150
F 0 "C129" H 5325 3250 50  0000 L CNN
F 1 "4.7u" H 5325 3050 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5338 3000 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5300 3150 50  0001 C CNN
F 4 "TDK" H 5300 3150 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5300 3150 50  0001 C CNN "MFP"
F 6 "digikey" H 5300 3150 50  0001 C CNN "D1"
F 7 "mouser" H 5300 3150 50  0001 C CNN "D2"
F 8 "445-5947" H 5300 3150 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5300 3150 50  0001 C CNN "D1PL"
F 10 "_" H 5300 3150 50  0001 C CNN "D2PN"
F 11 "_" H 5300 3150 50  0001 C CNN "D2PL"
F 12 "0402" H 5300 3150 50  0001 C CNN "Package"
F 13 "_" H 5300 3150 50  0000 C CNN "Description"
F 14 "6.3" H 5300 3150 50  0001 C CNN "Voltage"
F 15 "_" H 5300 3150 50  0001 C CNN "Power"
F 16 "10%" H 5300 3150 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5300 3150 50  0001 C CNN "Temperature"
F 18 "_" H 5300 3150 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5300 3150 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5300 3150 50  0001 C CNN "Cont.Current"
F 21 "_" H 5300 3150 50  0001 C CNN "Frequency"
F 22 "_" H 5300 3150 50  0001 C CNN "ResonnanceFreq"
	1    5300 3150
	1    0    0    -1  
$EndComp
$Comp
L C C130
U 1 1 56A26189
P 5550 3150
F 0 "C130" H 5575 3250 50  0000 L CNN
F 1 "470n" H 5575 3050 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 5588 3000 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5550 3150 50  0001 C CNN
F 4 "TDK" H 5550 3150 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 5550 3150 50  0001 C CNN "MFP"
F 6 "digikey" H 5550 3150 50  0001 C CNN "D1"
F 7 "mouser" H 5550 3150 50  0001 C CNN "D2"
F 8 "445-13653" H 5550 3150 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 5550 3150 50  0001 C CNN "D1PL"
F 10 "_" H 5550 3150 50  0001 C CNN "D2PN"
F 11 "_" H 5550 3150 50  0001 C CNN "D2PL"
F 12 "0201" H 5550 3150 50  0001 C CNN "Package"
F 13 "_" H 5550 3150 50  0000 C CNN "Description"
F 14 "6.3" H 5550 3150 50  0001 C CNN "Voltage"
F 15 "_" H 5550 3150 50  0001 C CNN "Power"
F 16 "10%" H 5550 3150 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5550 3150 50  0001 C CNN "Temperature"
F 18 "_" H 5550 3150 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5550 3150 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5550 3150 50  0001 C CNN "Cont.Current"
F 21 "_" H 5550 3150 50  0001 C CNN "Frequency"
F 22 "_" H 5550 3150 50  0001 C CNN "ResonnanceFreq"
	1    5550 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 3000 5550 3000
Connection ~ 5300 3000
Wire Wire Line
	5550 3300 4950 3300
Connection ~ 5300 3300
$Comp
L GND #PWR62
U 1 1 56A261AA
P 5300 3300
F 0 "#PWR62" H 5300 3050 50  0001 C CNN
F 1 "GND" H 5308 3126 50  0000 C CNN
F 2 "" H 5300 3300 50  0000 C CNN
F 3 "" H 5300 3300 50  0000 C CNN
	1    5300 3300
	1    0    0    -1  
$EndComp
Connection ~ 4950 3000
$EndSCHEMATC
