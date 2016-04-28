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
Sheet 7 12
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
U 4 1 56A04624
P 2950 2800
F 0 "U1" H 2950 3266 50  0000 C CNN
F 1 "xc7a100tcsg324pkg" H 2950 3174 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 2950 2800 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 2950 2800 50  0001 C CNN
F 4 "Xilinx" H 2950 2800 50  0001 C CNN "MFN"
F 5 "XC7A100T-2CSG324I" H 2950 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 2950 2800 50  0001 C CNN "D1"
F 7 "_" H 2950 2800 50  0001 C CNN "D2"
F 8 "122-1881" H 2950 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/XC7A100T-2CSG324I/122-1881-ND/3925808" H 2950 2800 50  0001 C CNN "D1PL"
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
L C C114
U 1 1 56A2F8FA
P 5650 3950
F 0 "C114" H 5675 4050 50  0000 L CNN
F 1 "4.7u" H 5675 3850 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5688 3800 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5650 3950 50  0001 C CNN
F 4 "TDK" H 5650 3950 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5650 3950 50  0001 C CNN "MFP"
F 6 "digikey" H 5650 3950 50  0001 C CNN "D1"
F 7 "avnet" H 5650 3950 50  0001 C CNN "D2"
F 8 "445-5947" H 5650 3950 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5650 3950 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 5650 3950 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 5650 3950 50  0001 C CNN "D2PL"
F 12 "0402" H 5650 3950 50  0001 C CNN "Package"
F 13 "_" H 5650 3950 50  0000 C CNN "Description"
F 14 "6.3" H 5650 3950 50  0001 C CNN "Voltage"
F 15 "_" H 5650 3950 50  0001 C CNN "Power"
F 16 "10%" H 5650 3950 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5650 3950 50  0001 C CNN "Temperature"
F 18 "_" H 5650 3950 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5650 3950 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5650 3950 50  0001 C CNN "Cont.Current"
F 21 "_" H 5650 3950 50  0001 C CNN "Frequency"
F 22 "_" H 5650 3950 50  0001 C CNN "ResonnanceFreq"
	1    5650 3950
	1    0    0    -1  
$EndComp
$Comp
L C C128
U 1 1 56A2F914
P 5850 3950
F 0 "C128" H 5875 4050 50  0000 L CNN
F 1 "470n" H 5875 3850 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 5888 3800 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5850 3950 50  0001 C CNN
F 4 "TDK" H 5850 3950 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 5850 3950 50  0001 C CNN "MFP"
F 6 "digikey" H 5850 3950 50  0001 C CNN "D1"
F 7 "mouser" H 5850 3950 50  0001 C CNN "D2"
F 8 "445-13653" H 5850 3950 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 5850 3950 50  0001 C CNN "D1PL"
F 10 "_" H 5850 3950 50  0001 C CNN "D2PN"
F 11 "_" H 5850 3950 50  0001 C CNN "D2PL"
F 12 "0201" H 5850 3950 50  0001 C CNN "Package"
F 13 "_" H 5850 3950 50  0000 C CNN "Description"
F 14 "6.3" H 5850 3950 50  0001 C CNN "Voltage"
F 15 "_" H 5850 3950 50  0001 C CNN "Power"
F 16 "10%" H 5850 3950 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5850 3950 50  0001 C CNN "Temperature"
F 18 "_" H 5850 3950 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5850 3950 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5850 3950 50  0001 C CNN "Cont.Current"
F 21 "_" H 5850 3950 50  0001 C CNN "Frequency"
F 22 "_" H 5850 3950 50  0001 C CNN "ResonnanceFreq"
	1    5850 3950
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR063
U 1 1 56A2F91D
P 5650 4100
F 0 "#PWR063" H 5650 3850 50  0001 C CNN
F 1 "GND" H 5658 3926 50  0000 C CNN
F 2 "" H 5650 4100 50  0000 C CNN
F 3 "" H 5650 4100 50  0000 C CNN
	1    5650 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4650 3000 5050 3000
$Comp
L +2V5 #PWR064
U 1 1 571ADFCB
P 5050 3000
F 0 "#PWR064" H 5050 2850 50  0001 C CNN
F 1 "+2V5" H 5065 3173 50  0000 C CNN
F 2 "" H 5050 3000 50  0000 C CNN
F 3 "" H 5050 3000 50  0000 C CNN
	1    5050 3000
	-1   0    0    1   
$EndComp
$Comp
L +2V5 #PWR065
U 1 1 571AE007
P 5650 3800
F 0 "#PWR065" H 5650 3650 50  0001 C CNN
F 1 "+2V5" H 5665 3973 50  0000 C CNN
F 2 "" H 5650 3800 50  0000 C CNN
F 3 "" H 5650 3800 50  0000 C CNN
	1    5650 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4100 5850 4100
Wire Wire Line
	5850 3800 5650 3800
Text GLabel 1250 2800 0    60   Input ~ 0
SPI_MOSI
Text GLabel 1250 2900 0    60   Input ~ 0
SPI_SCK
Text GLabel 4650 2600 2    60   Input ~ 0
Python1_CS#
Text GLabel 4650 2700 2    60   Input ~ 0
Python3_CS#
Text GLabel 1250 2600 0    60   Input ~ 0
Python2_CS#
Text GLabel 1250 2700 0    60   Input ~ 0
FPGA_DEBUG1
Text GLabel 4650 2800 2    60   Input ~ 0
FPGA_DEBUG2
Text GLabel 4650 2900 2    60   Input ~ 0
Python3_Monitor
Text GLabel 1250 3000 0    60   Input ~ 0
FPGA_Ddg5
$EndSCHEMATC
