EESchema Schematic File Version 2
LIBS:connectors
LIBS:conn
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
Sheet 8 12
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
L xc7a100tcsg324pkg U1
U 5 1 56A0474D
P 4100 2700
F 0 "U1" H 4100 4366 50  0000 C CNN
F 1 "xc7a100tcsg324pkg" H 4100 4274 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 4100 2700 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 4100 2700 50  0001 C CNN
F 4 "Xilinx" H 4100 2700 50  0001 C CNN "MFN"
F 5 "XC7A100T-2CSG324I" H 4100 2700 50  0001 C CNN "MFP"
F 6 "digikey" H 4100 2700 50  0001 C CNN "D1"
F 7 "_" H 4100 2700 50  0001 C CNN "D2"
F 8 "122-1881" H 4100 2700 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/XC7A100T-2CSG324I/122-1881-ND/3925808" H 4100 2700 50  0001 C CNN "D1PL"
F 10 "_" H 4100 2700 50  0001 C CNN "D2PN"
F 11 "_" H 4100 2700 50  0001 C CNN "D2PL"
F 12 "BGA324" H 4100 2700 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 4100 2700 50  0001 C CNN "Description"
F 14 "_" H 4100 2700 50  0001 C CNN "Voltage"
F 15 "_" H 4100 2700 50  0001 C CNN "Power"
F 16 "_" H 4100 2700 50  0001 C CNN "Tolerance"
F 17 "_" H 4100 2700 50  0001 C CNN "Temperature"
F 18 "_" H 4100 2700 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4100 2700 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4100 2700 50  0001 C CNN "Cont.Current"
F 21 "_" H 4100 2700 50  0001 C CNN "Frequency"
F 22 "_" H 4100 2700 50  0001 C CNN "ResonnanceFreq"
	5    4100 2700
	1    0    0    -1  
$EndComp
$Comp
L C C141
U 1 1 56A2BB19
P 6950 3900
F 0 "C141" H 6975 4000 50  0000 L CNN
F 1 "4.7u" H 6975 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 6988 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6950 3900 50  0001 C CNN
F 4 "TDK" H 6950 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 6950 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 6950 3900 50  0001 C CNN "D1"
F 7 "avnet" H 6950 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 6950 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 6950 3900 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 6950 3900 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 6950 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 6950 3900 50  0001 C CNN "Package"
F 13 "_" H 6950 3900 50  0000 C CNN "Description"
F 14 "6.3" H 6950 3900 50  0001 C CNN "Voltage"
F 15 "_" H 6950 3900 50  0001 C CNN "Power"
F 16 "10%" H 6950 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6950 3900 50  0001 C CNN "Temperature"
F 18 "_" H 6950 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6950 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6950 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 6950 3900 50  0001 C CNN "Frequency"
F 22 "_" H 6950 3900 50  0001 C CNN "ResonnanceFreq"
	1    6950 3900
	1    0    0    -1  
$EndComp
$Comp
L C C150
U 1 1 56A2BB33
P 8100 3900
F 0 "C150" H 8125 4000 50  0000 L CNN
F 1 "470n" H 8125 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8138 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8100 3900 50  0001 C CNN
F 4 "TDK" H 8100 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8100 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 8100 3900 50  0001 C CNN "D1"
F 7 "mouser" H 8100 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 8100 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8100 3900 50  0001 C CNN "D1PL"
F 10 "_" H 8100 3900 50  0001 C CNN "D2PN"
F 11 "_" H 8100 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 8100 3900 50  0001 C CNN "Package"
F 13 "_" H 8100 3900 50  0000 C CNN "Description"
F 14 "6.3" H 8100 3900 50  0001 C CNN "Voltage"
F 15 "_" H 8100 3900 50  0001 C CNN "Power"
F 16 "10%" H 8100 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8100 3900 50  0001 C CNN "Temperature"
F 18 "_" H 8100 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8100 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8100 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 8100 3900 50  0001 C CNN "Frequency"
F 22 "_" H 8100 3900 50  0001 C CNN "ResonnanceFreq"
	1    8100 3900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR066
U 1 1 56A2BB3A
P 6950 4050
F 0 "#PWR066" H 6950 3800 50  0001 C CNN
F 1 "GND" H 6958 3876 50  0000 C CNN
F 2 "" H 6950 4050 50  0000 C CNN
F 3 "" H 6950 4050 50  0000 C CNN
	1    6950 4050
	1    0    0    -1  
$EndComp
$Comp
L C C142
U 1 1 56A2BB53
P 7150 3900
F 0 "C142" H 7175 4000 50  0000 L CNN
F 1 "4.7u" H 7175 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7188 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7150 3900 50  0001 C CNN
F 4 "TDK" H 7150 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 7150 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7150 3900 50  0001 C CNN "D1"
F 7 "avnet" H 7150 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 7150 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 7150 3900 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 7150 3900 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 7150 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 7150 3900 50  0001 C CNN "Package"
F 13 "_" H 7150 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7150 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7150 3900 50  0001 C CNN "Power"
F 16 "10%" H 7150 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7150 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7150 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7150 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7150 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7150 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7150 3900 50  0001 C CNN "ResonnanceFreq"
	1    7150 3900
	1    0    0    -1  
$EndComp
$Comp
L C C147
U 1 1 56A2BB6D
P 7900 3900
F 0 "C147" H 7925 4000 50  0000 L CNN
F 1 "470n" H 7925 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7938 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7900 3900 50  0001 C CNN
F 4 "TDK" H 7900 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7900 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7900 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7900 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7900 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7900 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7900 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7900 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7900 3900 50  0001 C CNN "Package"
F 13 "_" H 7900 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7900 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7900 3900 50  0001 C CNN "Power"
F 16 "10%" H 7900 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7900 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7900 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7900 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7900 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7900 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7900 3900 50  0001 C CNN "ResonnanceFreq"
	1    7900 3900
	1    0    0    -1  
$EndComp
$Comp
L C C146
U 1 1 56A2BB87
P 7700 3900
F 0 "C146" H 7725 4000 50  0000 L CNN
F 1 "470n" H 7725 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7738 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7700 3900 50  0001 C CNN
F 4 "TDK" H 7700 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7700 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7700 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7700 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7700 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7700 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7700 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7700 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7700 3900 50  0001 C CNN "Package"
F 13 "_" H 7700 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7700 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7700 3900 50  0001 C CNN "Power"
F 16 "10%" H 7700 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7700 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7700 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7700 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7700 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7700 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7700 3900 50  0001 C CNN "ResonnanceFreq"
	1    7700 3900
	1    0    0    -1  
$EndComp
$Comp
L C C144
U 1 1 56A2BBA1
P 7500 3900
F 0 "C144" H 7525 4000 50  0000 L CNN
F 1 "470n" H 7525 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7538 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7500 3900 50  0001 C CNN
F 4 "TDK" H 7500 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7500 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7500 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7500 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 7500 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7500 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7500 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7500 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 7500 3900 50  0001 C CNN "Package"
F 13 "_" H 7500 3900 50  0000 C CNN "Description"
F 14 "6.3" H 7500 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7500 3900 50  0001 C CNN "Power"
F 16 "10%" H 7500 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7500 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7500 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7500 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7500 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7500 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7500 3900 50  0001 C CNN "ResonnanceFreq"
	1    7500 3900
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR067
U 1 1 56A2BBB0
P 6950 3750
F 0 "#PWR067" H 6950 3600 50  0001 C CNN
F 1 "+2V5" H 6968 3924 50  0000 C CNN
F 2 "" H 6950 3750 50  0000 C CNN
F 3 "" H 6950 3750 50  0000 C CNN
	1    6950 3750
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR068
U 1 1 56A2BC20
P 5950 3700
F 0 "#PWR068" H 5950 3550 50  0001 C CNN
F 1 "+2V5" H 5968 3874 50  0000 C CNN
F 2 "" H 5950 3700 50  0000 C CNN
F 3 "" H 5950 3700 50  0000 C CNN
	1    5950 3700
	1    0    0    -1  
$EndComp
Text GLabel 2400 3800 0    60   Input ~ 0
FX3_DQ0
Text GLabel 2400 1800 0    60   Input ~ 0
FX3_DQ1
Text GLabel 2400 2500 0    60   Input ~ 0
FX3_DQ2
Text GLabel 2400 1500 0    60   Input ~ 0
FX3_DQ3
Text GLabel 2400 1900 0    60   Input ~ 0
FX3_DQ4
Text GLabel 2400 1700 0    60   Input ~ 0
FX3_DQ5
Text GLabel 2400 3900 0    60   Input ~ 0
FX3_DQ6
Text GLabel 2400 4100 0    60   Input ~ 0
FX3_DQ7
Text GLabel 2400 2000 0    60   Input ~ 0
FX3_DQ15
Text GLabel 2400 2100 0    60   Input ~ 0
FX3_DQ24
Text GLabel 5800 1800 2    60   Input ~ 0
FX3_DQ26
Text GLabel 5800 2900 2    60   Input ~ 0
FX3_DQ30
Text GLabel 5800 3200 2    60   Input ~ 0
FX3_DQ28
Text GLabel 2400 2300 0    60   Input ~ 0
Artix_FX3_CLK
Text GLabel 2400 4000 0    60   Input ~ 0
FX3_FLAGB
Text GLabel 5800 1700 2    60   Input ~ 0
FX3_FLAGD
Text GLabel 2400 3400 0    60   Input ~ 0
FX3_SLRD#
Text GLabel 2400 3300 0    60   Input ~ 0
FX3_PKT_END#
Text GLabel 2400 3700 0    60   Input ~ 0
FX3_FLAGA
Text GLabel 2400 2200 0    60   Input ~ 0
FPGA_CLK
Wire Wire Line
	6950 4050 8100 4050
Wire Wire Line
	6950 3750 8100 3750
Wire Wire Line
	5800 3500 5800 4000
Wire Wire Line
	5800 3700 5950 3700
Connection ~ 7150 4050
Connection ~ 7900 4050
Connection ~ 7700 4050
Connection ~ 7500 4050
Connection ~ 7900 3750
Connection ~ 7700 3750
Connection ~ 7500 3750
Connection ~ 7150 3750
Connection ~ 5800 3600
Connection ~ 5800 3700
Connection ~ 5800 3800
Connection ~ 5800 3900
$EndSCHEMATC
