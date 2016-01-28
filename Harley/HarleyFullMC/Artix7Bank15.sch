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
Sheet 6 14
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
U 3 1 56A0415C
P 4500 2400
F 0 "U1" H 4450 4066 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 4450 3974 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 4500 2400 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 4500 2400 50  0001 C CNN
F 4 "_" H 4500 2400 50  0001 C CNN "MFN"
F 5 "_" H 4500 2400 50  0001 C CNN "MFP"
F 6 "digikey" H 4500 2400 50  0001 C CNN "D1"
F 7 "mouser" H 4500 2400 50  0001 C CNN "D2"
F 8 "_" H 4500 2400 50  0001 C CNN "D1PN"
F 9 "_" H 4500 2400 50  0001 C CNN "D1PL"
F 10 "_" H 4500 2400 50  0001 C CNN "D2PN"
F 11 "_" H 4500 2400 50  0001 C CNN "D2PL"
F 12 "BGA324" H 4500 2400 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 4500 2400 50  0001 C CNN "Description"
F 14 "_" H 4500 2400 50  0001 C CNN "Voltage"
F 15 "_" H 4500 2400 50  0001 C CNN "Power"
F 16 "_" H 4500 2400 50  0001 C CNN "Tolerance"
F 17 "_" H 4500 2400 50  0001 C CNN "Temperature"
F 18 "_" H 4500 2400 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4500 2400 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4500 2400 50  0001 C CNN "Cont.Current"
F 21 "_" H 4500 2400 50  0001 C CNN "Frequency"
F 22 "_" H 4500 2400 50  0001 C CNN "ResonnanceFreq"
	3    4500 2400
	1    0    0    -1  
$EndComp
$Comp
L C C143
U 1 1 56A2B61E
P 7450 3600
F 0 "C143" H 7475 3700 50  0000 L CNN
F 1 "4.7u" H 7475 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7488 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7450 3600 50  0001 C CNN
F 4 "TDK" H 7450 3600 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 7450 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 7450 3600 50  0001 C CNN "D1"
F 7 "mouser" H 7450 3600 50  0001 C CNN "D2"
F 8 "445-5947" H 7450 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 7450 3600 50  0001 C CNN "D1PL"
F 10 "_" H 7450 3600 50  0001 C CNN "D2PN"
F 11 "_" H 7450 3600 50  0001 C CNN "D2PL"
F 12 "0402" H 7450 3600 50  0001 C CNN "Package"
F 13 "_" H 7450 3600 50  0000 C CNN "Description"
F 14 "6.3" H 7450 3600 50  0001 C CNN "Voltage"
F 15 "_" H 7450 3600 50  0001 C CNN "Power"
F 16 "10%" H 7450 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7450 3600 50  0001 C CNN "Temperature"
F 18 "_" H 7450 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7450 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7450 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 7450 3600 50  0001 C CNN "Frequency"
F 22 "_" H 7450 3600 50  0001 C CNN "ResonnanceFreq"
	1    7450 3600
	1    0    0    -1  
$EndComp
$Comp
L C C155
U 1 1 56A2B638
P 8600 3600
F 0 "C155" H 8625 3700 50  0000 L CNN
F 1 "470n" H 8625 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8638 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8600 3600 50  0001 C CNN
F 4 "TDK" H 8600 3600 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8600 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 8600 3600 50  0001 C CNN "D1"
F 7 "mouser" H 8600 3600 50  0001 C CNN "D2"
F 8 "445-13653" H 8600 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8600 3600 50  0001 C CNN "D1PL"
F 10 "_" H 8600 3600 50  0001 C CNN "D2PN"
F 11 "_" H 8600 3600 50  0001 C CNN "D2PL"
F 12 "0201" H 8600 3600 50  0001 C CNN "Package"
F 13 "_" H 8600 3600 50  0000 C CNN "Description"
F 14 "6.3" H 8600 3600 50  0001 C CNN "Voltage"
F 15 "_" H 8600 3600 50  0001 C CNN "Power"
F 16 "10%" H 8600 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8600 3600 50  0001 C CNN "Temperature"
F 18 "_" H 8600 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8600 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8600 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 8600 3600 50  0001 C CNN "Frequency"
F 22 "_" H 8600 3600 50  0001 C CNN "ResonnanceFreq"
	1    8600 3600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR82
U 1 1 56A2B641
P 7450 3750
F 0 "#PWR82" H 7450 3500 50  0001 C CNN
F 1 "GND" H 7458 3576 50  0000 C CNN
F 2 "" H 7450 3750 50  0000 C CNN
F 3 "" H 7450 3750 50  0000 C CNN
	1    7450 3750
	1    0    0    -1  
$EndComp
$Comp
L C C145
U 1 1 56A2B65A
P 7650 3600
F 0 "C145" H 7675 3700 50  0000 L CNN
F 1 "4.7u" H 7675 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7688 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7650 3600 50  0001 C CNN
F 4 "TDK" H 7650 3600 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 7650 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 7650 3600 50  0001 C CNN "D1"
F 7 "mouser" H 7650 3600 50  0001 C CNN "D2"
F 8 "445-5947" H 7650 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 7650 3600 50  0001 C CNN "D1PL"
F 10 "_" H 7650 3600 50  0001 C CNN "D2PN"
F 11 "_" H 7650 3600 50  0001 C CNN "D2PL"
F 12 "0402" H 7650 3600 50  0001 C CNN "Package"
F 13 "_" H 7650 3600 50  0000 C CNN "Description"
F 14 "6.3" H 7650 3600 50  0001 C CNN "Voltage"
F 15 "_" H 7650 3600 50  0001 C CNN "Power"
F 16 "10%" H 7650 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7650 3600 50  0001 C CNN "Temperature"
F 18 "_" H 7650 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7650 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7650 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 7650 3600 50  0001 C CNN "Frequency"
F 22 "_" H 7650 3600 50  0001 C CNN "ResonnanceFreq"
	1    7650 3600
	1    0    0    -1  
$EndComp
$Comp
L C C153
U 1 1 56A2B674
P 8400 3600
F 0 "C153" H 8425 3700 50  0000 L CNN
F 1 "470n" H 8425 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8438 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8400 3600 50  0001 C CNN
F 4 "TDK" H 8400 3600 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8400 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 8400 3600 50  0001 C CNN "D1"
F 7 "mouser" H 8400 3600 50  0001 C CNN "D2"
F 8 "445-13653" H 8400 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8400 3600 50  0001 C CNN "D1PL"
F 10 "_" H 8400 3600 50  0001 C CNN "D2PN"
F 11 "_" H 8400 3600 50  0001 C CNN "D2PL"
F 12 "0201" H 8400 3600 50  0001 C CNN "Package"
F 13 "_" H 8400 3600 50  0000 C CNN "Description"
F 14 "6.3" H 8400 3600 50  0001 C CNN "Voltage"
F 15 "_" H 8400 3600 50  0001 C CNN "Power"
F 16 "10%" H 8400 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8400 3600 50  0001 C CNN "Temperature"
F 18 "_" H 8400 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8400 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8400 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 8400 3600 50  0001 C CNN "Frequency"
F 22 "_" H 8400 3600 50  0001 C CNN "ResonnanceFreq"
	1    8400 3600
	1    0    0    -1  
$EndComp
$Comp
L C C151
U 1 1 56A2B68E
P 8200 3600
F 0 "C151" H 8225 3700 50  0000 L CNN
F 1 "470n" H 8225 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8238 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8200 3600 50  0001 C CNN
F 4 "TDK" H 8200 3600 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8200 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 8200 3600 50  0001 C CNN "D1"
F 7 "mouser" H 8200 3600 50  0001 C CNN "D2"
F 8 "445-13653" H 8200 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8200 3600 50  0001 C CNN "D1PL"
F 10 "_" H 8200 3600 50  0001 C CNN "D2PN"
F 11 "_" H 8200 3600 50  0001 C CNN "D2PL"
F 12 "0201" H 8200 3600 50  0001 C CNN "Package"
F 13 "_" H 8200 3600 50  0000 C CNN "Description"
F 14 "6.3" H 8200 3600 50  0001 C CNN "Voltage"
F 15 "_" H 8200 3600 50  0001 C CNN "Power"
F 16 "10%" H 8200 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8200 3600 50  0001 C CNN "Temperature"
F 18 "_" H 8200 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8200 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8200 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 8200 3600 50  0001 C CNN "Frequency"
F 22 "_" H 8200 3600 50  0001 C CNN "ResonnanceFreq"
	1    8200 3600
	1    0    0    -1  
$EndComp
$Comp
L C C149
U 1 1 56A2B6A8
P 8000 3600
F 0 "C149" H 8025 3700 50  0000 L CNN
F 1 "470n" H 8025 3500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8038 3450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8000 3600 50  0001 C CNN
F 4 "TDK" H 8000 3600 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8000 3600 50  0001 C CNN "MFP"
F 6 "digikey" H 8000 3600 50  0001 C CNN "D1"
F 7 "mouser" H 8000 3600 50  0001 C CNN "D2"
F 8 "445-13653" H 8000 3600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8000 3600 50  0001 C CNN "D1PL"
F 10 "_" H 8000 3600 50  0001 C CNN "D2PN"
F 11 "_" H 8000 3600 50  0001 C CNN "D2PL"
F 12 "0201" H 8000 3600 50  0001 C CNN "Package"
F 13 "_" H 8000 3600 50  0000 C CNN "Description"
F 14 "6.3" H 8000 3600 50  0001 C CNN "Voltage"
F 15 "_" H 8000 3600 50  0001 C CNN "Power"
F 16 "10%" H 8000 3600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8000 3600 50  0001 C CNN "Temperature"
F 18 "_" H 8000 3600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8000 3600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8000 3600 50  0001 C CNN "Cont.Current"
F 21 "_" H 8000 3600 50  0001 C CNN "Frequency"
F 22 "_" H 8000 3600 50  0001 C CNN "ResonnanceFreq"
	1    8000 3600
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR81
U 1 1 56A2B6B9
P 7450 3450
F 0 "#PWR81" H 7450 3300 50  0001 C CNN
F 1 "+2V5" H 7468 3624 50  0000 C CNN
F 2 "" H 7450 3450 50  0000 C CNN
F 3 "" H 7450 3450 50  0000 C CNN
	1    7450 3450
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR75
U 1 1 56A2B717
P 6550 3400
F 0 "#PWR75" H 6550 3250 50  0001 C CNN
F 1 "+2V5" H 6568 3574 50  0000 C CNN
F 2 "" H 6550 3400 50  0000 C CNN
F 3 "" H 6550 3400 50  0000 C CNN
	1    6550 3400
	1    0    0    -1  
$EndComp
Text GLabel 6400 2100 2    60   Input ~ 0
CAM_DOUT0-
Text GLabel 6400 2000 2    60   Input ~ 0
CAM_DOUT0+
Text GLabel 6400 3100 2    60   Input ~ 0
CAM_DOUT1-
Text GLabel 6400 3000 2    60   Input ~ 0
CAM_DOUT1+
Text GLabel 6400 2900 2    60   Input ~ 0
CAM_DOUT2-
Text GLabel 6400 2800 2    60   Input ~ 0
CAM_DOUT2+
Text GLabel 6400 2700 2    60   Input ~ 0
CAM_DOUT3-
Text GLabel 6400 2600 2    60   Input ~ 0
CAM_DOUT3+
Text GLabel 2500 1200 0    60   Input ~ 0
CAM_SYNC-
Text GLabel 2500 1300 0    60   Input ~ 0
CAM_SYNC+
Text GLabel 2500 2000 0    60   Input ~ 0
CAM_CLK_OUT-
Text GLabel 2500 2100 0    60   Input ~ 0
CAM_CLK_OUT+
Text GLabel 6400 1600 2    60   Input ~ 0
CAM_CLK_IN-
Text GLabel 6400 1700 2    60   Input ~ 0
CAM_CLK_IN+
Text GLabel 2500 3600 0    60   Input ~ 0
P_LVDS1-
Text GLabel 2500 3700 0    60   Input ~ 0
P_LVDS1+
Text GLabel 2500 3800 0    60   Input ~ 0
P_LVDS2-
Text GLabel 6400 1100 2    60   Input ~ 0
P_LVDS2+
Text GLabel 6400 1200 2    60   Input ~ 0
P_LVDS3-
Text GLabel 6400 1300 2    60   Input ~ 0
P_LVDS3+
Text GLabel 2500 2200 0    60   Input ~ 0
P_LVDS5-
Text GLabel 2500 2300 0    60   Input ~ 0
P_LVDS5+
Text GLabel 2500 1800 0    60   Input ~ 0
P_LVDS4-
Text GLabel 2500 1900 0    60   Input ~ 0
P_LVDS4+
Text GLabel 2500 2500 0    60   Input ~ 0
P_LVDS11-
Text GLabel 2500 2400 0    60   Input ~ 0
P_LVDS11+
Text GLabel 2500 3500 0    60   Input ~ 0
FPGADebug1
Text GLabel 2500 3400 0    60   Input ~ 0
FPGADebug2
Wire Wire Line
	7450 3750 8600 3750
Wire Wire Line
	8600 3450 7450 3450
Wire Wire Line
	6400 3200 6400 3700
Wire Wire Line
	6400 3400 6550 3400
Connection ~ 7650 3750
Connection ~ 8400 3750
Connection ~ 8200 3750
Connection ~ 8000 3750
Connection ~ 8400 3450
Connection ~ 8200 3450
Connection ~ 8000 3450
Connection ~ 7650 3450
Connection ~ 6400 3300
Connection ~ 6400 3400
Connection ~ 6400 3500
Connection ~ 6400 3600
$EndSCHEMATC
