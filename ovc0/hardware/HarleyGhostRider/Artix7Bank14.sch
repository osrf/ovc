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
Sheet 5 12
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
U 2 1 56A03D4E
P 4250 2550
F 0 "U1" H 4250 4216 50  0000 C CNN
F 1 "xc7a100tcsg324pkg" H 4250 4124 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 4250 2550 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 4250 2550 50  0001 C CNN
F 4 "Xilinx" H 4250 2550 50  0001 C CNN "MFN"
F 5 "XC7A100T-2CSG324I" H 4250 2550 50  0001 C CNN "MFP"
F 6 "digikey" H 4250 2550 50  0001 C CNN "D1"
F 7 "_" H 4250 2550 50  0001 C CNN "D2"
F 8 "122-1881" H 4250 2550 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/XC7A100T-2CSG324I/122-1881-ND/3925808" H 4250 2550 50  0001 C CNN "D1PL"
F 10 "_" H 4250 2550 50  0001 C CNN "D2PN"
F 11 "_" H 4250 2550 50  0001 C CNN "D2PL"
F 12 "BGA324" H 4250 2550 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 4250 2550 50  0001 C CNN "Description"
F 14 "_" H 4250 2550 50  0001 C CNN "Voltage"
F 15 "_" H 4250 2550 50  0001 C CNN "Power"
F 16 "_" H 4250 2550 50  0001 C CNN "Tolerance"
F 17 "_" H 4250 2550 50  0001 C CNN "Temperature"
F 18 "_" H 4250 2550 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4250 2550 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4250 2550 50  0001 C CNN "Cont.Current"
F 21 "_" H 4250 2550 50  0001 C CNN "Frequency"
F 22 "_" H 4250 2550 50  0001 C CNN "ResonnanceFreq"
	2    4250 2550
	1    0    0    -1  
$EndComp
$Comp
L C C148
U 1 1 56A2A89E
P 7600 3900
F 0 "C148" H 7650 4000 50  0000 L CNN
F 1 "47u" H 7650 3800 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 7638 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7600 3900 50  0001 C CNN
F 4 "TDK" H 7600 3900 50  0001 C CNN "MFN"
F 5 "C2012X5R1A476M125AC" H 7600 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7600 3900 50  0001 C CNN "D1"
F 7 "mouser" H 7600 3900 50  0001 C CNN "D2"
F 8 "445-8239" H 7600 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C2012X5R1A476M125AC/445-8239-1-ND/2812081" H 7600 3900 50  0001 C CNN "D1PL"
F 10 "_" H 7600 3900 50  0001 C CNN "D2PN"
F 11 "_" H 7600 3900 50  0001 C CNN "D2PL"
F 12 "0805" H 7600 3900 50  0001 C CNN "Package"
F 13 "_" H 7715 3808 50  0001 L CNN "Description"
F 14 "10" H 7600 3900 50  0001 C CNN "Voltage"
F 15 "_" H 7600 3900 50  0001 C CNN "Power"
F 16 "20%" H 7600 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7600 3900 50  0001 C CNN "Temperature"
F 18 "_" H 7600 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7600 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7600 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 7600 3900 50  0001 C CNN "Frequency"
F 22 "_" H 7600 3900 50  0001 C CNN "ResonnanceFreq"
	1    7600 3900
	1    0    0    -1  
$EndComp
$Comp
L C C152
U 1 1 56A2A8B8
P 7950 3900
F 0 "C152" H 7975 4000 50  0000 L CNN
F 1 "4.7u" H 7975 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7988 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7950 3900 50  0001 C CNN
F 4 "TDK" H 7950 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 7950 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 7950 3900 50  0001 C CNN "D1"
F 7 "avnet" H 7950 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 7950 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 7950 3900 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 7950 3900 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 7950 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 7950 3900 50  0001 C CNN "Package"
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
$Comp
L C C159
U 1 1 56A2A8D2
P 9100 3900
F 0 "C159" H 9125 4000 50  0000 L CNN
F 1 "470n" H 9125 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 9138 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 9100 3900 50  0001 C CNN
F 4 "TDK" H 9100 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 9100 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 9100 3900 50  0001 C CNN "D1"
F 7 "mouser" H 9100 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 9100 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 9100 3900 50  0001 C CNN "D1PL"
F 10 "_" H 9100 3900 50  0001 C CNN "D2PN"
F 11 "_" H 9100 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 9100 3900 50  0001 C CNN "Package"
F 13 "_" H 9100 3900 50  0000 C CNN "Description"
F 14 "6.3" H 9100 3900 50  0001 C CNN "Voltage"
F 15 "_" H 9100 3900 50  0001 C CNN "Power"
F 16 "10%" H 9100 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 9100 3900 50  0001 C CNN "Temperature"
F 18 "_" H 9100 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 9100 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 9100 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 9100 3900 50  0001 C CNN "Frequency"
F 22 "_" H 9100 3900 50  0001 C CNN "ResonnanceFreq"
	1    9100 3900
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR057
U 1 1 56A2A8DB
P 7950 4050
F 0 "#PWR057" H 7950 3800 50  0001 C CNN
F 1 "GND" H 7958 3876 50  0000 C CNN
F 2 "" H 7950 4050 50  0000 C CNN
F 3 "" H 7950 4050 50  0000 C CNN
	1    7950 4050
	1    0    0    -1  
$EndComp
$Comp
L C C154
U 1 1 56A2A8F4
P 8150 3900
F 0 "C154" H 8175 4000 50  0000 L CNN
F 1 "4.7u" H 8175 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 8188 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8150 3900 50  0001 C CNN
F 4 "TDK" H 8150 3900 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 8150 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 8150 3900 50  0001 C CNN "D1"
F 7 "avnet" H 8150 3900 50  0001 C CNN "D2"
F 8 "445-5947" H 8150 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 8150 3900 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 8150 3900 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 8150 3900 50  0001 C CNN "D2PL"
F 12 "0402" H 8150 3900 50  0001 C CNN "Package"
F 13 "_" H 8150 3900 50  0000 C CNN "Description"
F 14 "6.3" H 8150 3900 50  0001 C CNN "Voltage"
F 15 "_" H 8150 3900 50  0001 C CNN "Power"
F 16 "10%" H 8150 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8150 3900 50  0001 C CNN "Temperature"
F 18 "_" H 8150 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8150 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8150 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 8150 3900 50  0001 C CNN "Frequency"
F 22 "_" H 8150 3900 50  0001 C CNN "ResonnanceFreq"
	1    8150 3900
	1    0    0    -1  
$EndComp
$Comp
L C C158
U 1 1 56A2A90E
P 8900 3900
F 0 "C158" H 8925 4000 50  0000 L CNN
F 1 "470n" H 8925 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8938 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8900 3900 50  0001 C CNN
F 4 "TDK" H 8900 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8900 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 8900 3900 50  0001 C CNN "D1"
F 7 "mouser" H 8900 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 8900 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8900 3900 50  0001 C CNN "D1PL"
F 10 "_" H 8900 3900 50  0001 C CNN "D2PN"
F 11 "_" H 8900 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 8900 3900 50  0001 C CNN "Package"
F 13 "_" H 8900 3900 50  0000 C CNN "Description"
F 14 "6.3" H 8900 3900 50  0001 C CNN "Voltage"
F 15 "_" H 8900 3900 50  0001 C CNN "Power"
F 16 "10%" H 8900 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8900 3900 50  0001 C CNN "Temperature"
F 18 "_" H 8900 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8900 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8900 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 8900 3900 50  0001 C CNN "Frequency"
F 22 "_" H 8900 3900 50  0001 C CNN "ResonnanceFreq"
	1    8900 3900
	1    0    0    -1  
$EndComp
$Comp
L C C157
U 1 1 56A2A928
P 8700 3900
F 0 "C157" H 8725 4000 50  0000 L CNN
F 1 "470n" H 8725 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8738 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8700 3900 50  0001 C CNN
F 4 "TDK" H 8700 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8700 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 8700 3900 50  0001 C CNN "D1"
F 7 "mouser" H 8700 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 8700 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8700 3900 50  0001 C CNN "D1PL"
F 10 "_" H 8700 3900 50  0001 C CNN "D2PN"
F 11 "_" H 8700 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 8700 3900 50  0001 C CNN "Package"
F 13 "_" H 8700 3900 50  0000 C CNN "Description"
F 14 "6.3" H 8700 3900 50  0001 C CNN "Voltage"
F 15 "_" H 8700 3900 50  0001 C CNN "Power"
F 16 "10%" H 8700 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8700 3900 50  0001 C CNN "Temperature"
F 18 "_" H 8700 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8700 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8700 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 8700 3900 50  0001 C CNN "Frequency"
F 22 "_" H 8700 3900 50  0001 C CNN "ResonnanceFreq"
	1    8700 3900
	1    0    0    -1  
$EndComp
$Comp
L C C156
U 1 1 56A2A942
P 8500 3900
F 0 "C156" H 8525 4000 50  0000 L CNN
F 1 "470n" H 8525 3800 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8538 3750 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8500 3900 50  0001 C CNN
F 4 "TDK" H 8500 3900 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8500 3900 50  0001 C CNN "MFP"
F 6 "digikey" H 8500 3900 50  0001 C CNN "D1"
F 7 "mouser" H 8500 3900 50  0001 C CNN "D2"
F 8 "445-13653" H 8500 3900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8500 3900 50  0001 C CNN "D1PL"
F 10 "_" H 8500 3900 50  0001 C CNN "D2PN"
F 11 "_" H 8500 3900 50  0001 C CNN "D2PL"
F 12 "0201" H 8500 3900 50  0001 C CNN "Package"
F 13 "_" H 8500 3900 50  0000 C CNN "Description"
F 14 "6.3" H 8500 3900 50  0001 C CNN "Voltage"
F 15 "_" H 8500 3900 50  0001 C CNN "Power"
F 16 "10%" H 8500 3900 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8500 3900 50  0001 C CNN "Temperature"
F 18 "_" H 8500 3900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8500 3900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8500 3900 50  0001 C CNN "Cont.Current"
F 21 "_" H 8500 3900 50  0001 C CNN "Frequency"
F 22 "_" H 8500 3900 50  0001 C CNN "ResonnanceFreq"
	1    8500 3900
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR058
U 1 1 56A2AA1B
P 7950 3750
F 0 "#PWR058" H 7950 3600 50  0001 C CNN
F 1 "+2V5" H 7968 3924 50  0000 C CNN
F 2 "" H 7950 3750 50  0000 C CNN
F 3 "" H 7950 3750 50  0000 C CNN
	1    7950 3750
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR059
U 1 1 56A2AA9D
P 6600 3550
F 0 "#PWR059" H 6600 3400 50  0001 C CNN
F 1 "+2V5" H 6618 3724 50  0000 C CNN
F 2 "" H 6600 3550 50  0000 C CNN
F 3 "" H 6600 3550 50  0000 C CNN
	1    6600 3550
	1    0    0    -1  
$EndComp
Text GLabel 2050 3350 0    60   Input ~ 0
FPGA_SS_DIN
Text GLabel 2050 3550 0    60   Input ~ 0
FX3_DQ12
Text GLabel 2050 3950 0    60   Input ~ 0
FX3_DQ13
Text GLabel 2050 2950 0    60   Input ~ 0
FX3_DQ18
Text GLabel 6450 1250 2    60   Input ~ 0
FX3_SLCS#
Text GLabel 2050 2650 0    60   Input ~ 0
FX3_SLWR#
Text GLabel 2050 1250 0    60   Input ~ 0
FX3_SLOE#
Text GLabel 2050 2150 0    60   Input ~ 0
FX3_FLAGC
Text GLabel 6450 1350 2    60   Input ~ 0
FX3_DQ11
Text GLabel 2050 2350 0    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 2050 3750 0    60   Input ~ 0
FX3_DQ9
Text GLabel 2050 3150 0    60   Input ~ 0
FX3_DQ10
Text GLabel 2050 3850 0    60   Input ~ 0
FX3_DQ8
Text GLabel 2050 3050 0    60   Input ~ 0
FX3_DQ16
Text GLabel 2050 2550 0    60   Input ~ 0
FX3_DQ20
Text GLabel 6450 2950 2    60   Input ~ 0
FX3_DQ21
Text GLabel 6450 2450 2    60   Input ~ 0
FX3_DQ22
Text GLabel 2050 2250 0    60   Input ~ 0
FX3_DQ19
Text GLabel 6450 1450 2    60   Input ~ 0
FX3_DQ25
Text GLabel 2050 3250 0    60   Input ~ 0
FX3_DQ23
Text GLabel 6450 1550 2    60   Input ~ 0
FX3_DQ14
Text GLabel 2050 1150 0    60   Input ~ 0
FX3_A1
Text GLabel 2050 3650 0    60   Input ~ 0
FX3_DQ17
Text GLabel 2050 2450 0    60   Input ~ 0
FX3_DQ31
Text GLabel 6450 3150 2    60   Input ~ 0
FX3_DQ29
Text GLabel 6450 1850 2    60   Input ~ 0
FX3_DQ27
Text GLabel 6450 1650 2    60   Input ~ 0
FX3_A0
Wire Wire Line
	7600 4050 9100 4050
Wire Wire Line
	7600 3750 9100 3750
Wire Wire Line
	6450 3350 6450 3850
Wire Wire Line
	6450 3550 6600 3550
Connection ~ 7950 4050
Connection ~ 8150 4050
Connection ~ 8900 4050
Connection ~ 8700 4050
Connection ~ 8500 4050
Connection ~ 8900 3750
Connection ~ 8700 3750
Connection ~ 8500 3750
Connection ~ 8150 3750
Connection ~ 7950 3750
Connection ~ 6450 3450
Connection ~ 6450 3550
Connection ~ 6450 3650
Connection ~ 6450 3750
Text GLabel 2050 1950 0    60   Input ~ 0
Python3_clk_return-
Text GLabel 2050 2050 0    60   Input ~ 0
Python3_clk_return+
Text GLabel 6450 2850 2    60   Input ~ 0
Python3_DOUT1-
Text GLabel 6450 2750 2    60   Input ~ 0
Python3_DOUT1+
Text GLabel 2050 2750 0    60   Input ~ 0
Python3_DOUT0-
Text GLabel 2050 2850 0    60   Input ~ 0
Python3_DOUT0+
Text GLabel 6450 2250 2    60   Input ~ 0
Python3_SYNC+
Text GLabel 6450 2150 2    60   Input ~ 0
Python3_SYNC-
Text GLabel 6450 1950 2    60   Input ~ 0
Python3_DOUT2+
Text GLabel 6450 2050 2    60   Input ~ 0
Python3_DOUT2-
Text GLabel 6450 2550 2    60   Input ~ 0
Python3_DOUT3-
Text GLabel 6450 2650 2    60   Input ~ 0
Python3_DOUT3+
$EndSCHEMATC
