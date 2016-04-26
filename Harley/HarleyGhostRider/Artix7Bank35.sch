EESchema Schematic File Version 2
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
Sheet 9 12
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
U 6 1 56A04FF9
P 3150 2600
F 0 "U1" H 3100 4266 50  0000 C CNN
F 1 "xc7a100tcsg324pkg" H 3100 4174 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 3150 2600 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 3150 2600 50  0001 C CNN
F 4 "Xilinx" H 3150 2600 50  0001 C CNN "MFN"
F 5 "XC7A100T-2CSG324I" H 3150 2600 50  0001 C CNN "MFP"
F 6 "digikey" H 3150 2600 50  0001 C CNN "D1"
F 7 "_" H 3150 2600 50  0001 C CNN "D2"
F 8 "122-1881" H 3150 2600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/XC7A100T-2CSG324I/122-1881-ND/3925808" H 3150 2600 50  0001 C CNN "D1PL"
F 10 "_" H 3150 2600 50  0001 C CNN "D2PN"
F 11 "_" H 3150 2600 50  0001 C CNN "D2PL"
F 12 "BGA324" H 3150 2600 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 3150 2600 50  0001 C CNN "Description"
F 14 "_" H 3150 2600 50  0001 C CNN "Voltage"
F 15 "_" H 3150 2600 50  0001 C CNN "Power"
F 16 "_" H 3150 2600 50  0001 C CNN "Tolerance"
F 17 "_" H 3150 2600 50  0001 C CNN "Temperature"
F 18 "_" H 3150 2600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3150 2600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3150 2600 50  0001 C CNN "Cont.Current"
F 21 "_" H 3150 2600 50  0001 C CNN "Frequency"
F 22 "_" H 3150 2600 50  0001 C CNN "ResonnanceFreq"
	6    3150 2600
	1    0    0    -1  
$EndComp
$Comp
L C C131
U 1 1 56A272A5
P 5750 4350
F 0 "C131" H 5800 4450 50  0000 L CNN
F 1 "47u" H 5800 4250 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5788 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5750 4350 50  0001 C CNN
F 4 "TDK" H 5750 4350 50  0001 C CNN "MFN"
F 5 "C2012X5R1A476M125AC" H 5750 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 5750 4350 50  0001 C CNN "D1"
F 7 "mouser" H 5750 4350 50  0001 C CNN "D2"
F 8 "445-8239" H 5750 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C2012X5R1A476M125AC/445-8239-1-ND/2812081" H 5750 4350 50  0001 C CNN "D1PL"
F 10 "_" H 5750 4350 50  0001 C CNN "D2PN"
F 11 "_" H 5750 4350 50  0001 C CNN "D2PL"
F 12 "0805" H 5750 4350 50  0001 C CNN "Package"
F 13 "_" H 5865 4258 50  0001 L CNN "Description"
F 14 "10" H 5750 4350 50  0001 C CNN "Voltage"
F 15 "_" H 5750 4350 50  0001 C CNN "Power"
F 16 "20%" H 5750 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5750 4350 50  0001 C CNN "Temperature"
F 18 "_" H 5750 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5750 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5750 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 5750 4350 50  0001 C CNN "Frequency"
F 22 "_" H 5750 4350 50  0001 C CNN "ResonnanceFreq"
	1    5750 4350
	1    0    0    -1  
$EndComp
$Comp
L C C132
U 1 1 56A272BF
P 6100 4350
F 0 "C132" H 6125 4450 50  0000 L CNN
F 1 "4.7u" H 6125 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 6138 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6100 4350 50  0001 C CNN
F 4 "TDK" H 6100 4350 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 6100 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 6100 4350 50  0001 C CNN "D1"
F 7 "avnet" H 6100 4350 50  0001 C CNN "D2"
F 8 "445-5947" H 6100 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 6100 4350 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 6100 4350 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 6100 4350 50  0001 C CNN "D2PL"
F 12 "0402" H 6100 4350 50  0001 C CNN "Package"
F 13 "_" H 6100 4350 50  0000 C CNN "Description"
F 14 "6.3" H 6100 4350 50  0001 C CNN "Voltage"
F 15 "_" H 6100 4350 50  0001 C CNN "Power"
F 16 "10%" H 6100 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6100 4350 50  0001 C CNN "Temperature"
F 18 "_" H 6100 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6100 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6100 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 6100 4350 50  0001 C CNN "Frequency"
F 22 "_" H 6100 4350 50  0001 C CNN "ResonnanceFreq"
	1    6100 4350
	1    0    0    -1  
$EndComp
$Comp
L C C137
U 1 1 56A272D9
P 7250 4350
F 0 "C137" H 7275 4450 50  0000 L CNN
F 1 "470n" H 7275 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7288 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7250 4350 50  0001 C CNN
F 4 "TDK" H 7250 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7250 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 7250 4350 50  0001 C CNN "D1"
F 7 "mouser" H 7250 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 7250 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7250 4350 50  0001 C CNN "D1PL"
F 10 "_" H 7250 4350 50  0001 C CNN "D2PN"
F 11 "_" H 7250 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 7250 4350 50  0001 C CNN "Package"
F 13 "_" H 7250 4350 50  0000 C CNN "Description"
F 14 "6.3" H 7250 4350 50  0001 C CNN "Voltage"
F 15 "_" H 7250 4350 50  0001 C CNN "Power"
F 16 "10%" H 7250 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7250 4350 50  0001 C CNN "Temperature"
F 18 "_" H 7250 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7250 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7250 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 7250 4350 50  0001 C CNN "Frequency"
F 22 "_" H 7250 4350 50  0001 C CNN "ResonnanceFreq"
	1    7250 4350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR067
U 1 1 56A272E2
P 6100 4500
F 0 "#PWR067" H 6100 4250 50  0001 C CNN
F 1 "GND" H 6108 4326 50  0000 C CNN
F 2 "" H 6100 4500 50  0000 C CNN
F 3 "" H 6100 4500 50  0000 C CNN
	1    6100 4500
	1    0    0    -1  
$EndComp
$Comp
L C C140
U 1 1 56A27411
P 8000 4350
F 0 "C140" H 8025 4450 50  0000 L CNN
F 1 "10n" H 8025 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 8038 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 8000 4350 50  0001 C CNN
F 4 "TDK" H 8000 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 8000 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 8000 4350 50  0001 C CNN "D1"
F 7 "mouser" H 8000 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 8000 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 8000 4350 50  0001 C CNN "D1PL"
F 10 "_" H 8000 4350 50  0001 C CNN "D2PN"
F 11 "_" H 8000 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 8000 4350 50  0001 C CNN "Package"
F 13 "_" H 8000 4350 50  0000 C CNN "Description"
F 14 "6.3" H 8000 4350 50  0001 C CNN "Voltage"
F 15 "_" H 8000 4350 50  0001 C CNN "Power"
F 16 "10%" H 8000 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 8000 4350 50  0001 C CNN "Temperature"
F 18 "_" H 8000 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 8000 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 8000 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 8000 4350 50  0001 C CNN "Frequency"
F 22 "_" H 8000 4350 50  0001 C CNN "ResonnanceFreq"
	1    8000 4350
	1    0    0    -1  
$EndComp
$Comp
L C C133
U 1 1 56A276B3
P 6300 4350
F 0 "C133" H 6325 4450 50  0000 L CNN
F 1 "4.7u" H 6325 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 6338 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6300 4350 50  0001 C CNN
F 4 "TDK" H 6300 4350 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 6300 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 6300 4350 50  0001 C CNN "D1"
F 7 "avnet" H 6300 4350 50  0001 C CNN "D2"
F 8 "445-5947" H 6300 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 6300 4350 50  0001 C CNN "D1PL"
F 10 "810-C1005X5R0J475K" H 6300 4350 50  0001 C CNN "D2PN"
F 11 "http://www.mouser.fr/ProductDetail/TDK/C1005X5R0J475K050BC/?qs=NRhsANhppD%2frOmlfBttPRA%3d%3d" H 6300 4350 50  0001 C CNN "D2PL"
F 12 "0402" H 6300 4350 50  0001 C CNN "Package"
F 13 "_" H 6300 4350 50  0000 C CNN "Description"
F 14 "6.3" H 6300 4350 50  0001 C CNN "Voltage"
F 15 "_" H 6300 4350 50  0001 C CNN "Power"
F 16 "10%" H 6300 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6300 4350 50  0001 C CNN "Temperature"
F 18 "_" H 6300 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6300 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6300 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 6300 4350 50  0001 C CNN "Frequency"
F 22 "_" H 6300 4350 50  0001 C CNN "ResonnanceFreq"
	1    6300 4350
	1    0    0    -1  
$EndComp
$Comp
L C C136
U 1 1 56A27707
P 7050 4350
F 0 "C136" H 7075 4450 50  0000 L CNN
F 1 "470n" H 7075 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7088 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7050 4350 50  0001 C CNN
F 4 "TDK" H 7050 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7050 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 7050 4350 50  0001 C CNN "D1"
F 7 "mouser" H 7050 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 7050 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7050 4350 50  0001 C CNN "D1PL"
F 10 "_" H 7050 4350 50  0001 C CNN "D2PN"
F 11 "_" H 7050 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 7050 4350 50  0001 C CNN "Package"
F 13 "_" H 7050 4350 50  0000 C CNN "Description"
F 14 "6.3" H 7050 4350 50  0001 C CNN "Voltage"
F 15 "_" H 7050 4350 50  0001 C CNN "Power"
F 16 "10%" H 7050 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7050 4350 50  0001 C CNN "Temperature"
F 18 "_" H 7050 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7050 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7050 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 7050 4350 50  0001 C CNN "Frequency"
F 22 "_" H 7050 4350 50  0001 C CNN "ResonnanceFreq"
	1    7050 4350
	1    0    0    -1  
$EndComp
$Comp
L C C135
U 1 1 56A2775A
P 6850 4350
F 0 "C135" H 6875 4450 50  0000 L CNN
F 1 "470n" H 6875 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6888 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6850 4350 50  0001 C CNN
F 4 "TDK" H 6850 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6850 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 6850 4350 50  0001 C CNN "D1"
F 7 "mouser" H 6850 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 6850 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6850 4350 50  0001 C CNN "D1PL"
F 10 "_" H 6850 4350 50  0001 C CNN "D2PN"
F 11 "_" H 6850 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 6850 4350 50  0001 C CNN "Package"
F 13 "_" H 6850 4350 50  0000 C CNN "Description"
F 14 "6.3" H 6850 4350 50  0001 C CNN "Voltage"
F 15 "_" H 6850 4350 50  0001 C CNN "Power"
F 16 "10%" H 6850 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6850 4350 50  0001 C CNN "Temperature"
F 18 "_" H 6850 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6850 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6850 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 6850 4350 50  0001 C CNN "Frequency"
F 22 "_" H 6850 4350 50  0001 C CNN "ResonnanceFreq"
	1    6850 4350
	1    0    0    -1  
$EndComp
$Comp
L C C134
U 1 1 56A277AC
P 6650 4350
F 0 "C134" H 6675 4450 50  0000 L CNN
F 1 "470n" H 6675 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6688 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6650 4350 50  0001 C CNN
F 4 "TDK" H 6650 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6650 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 6650 4350 50  0001 C CNN "D1"
F 7 "mouser" H 6650 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 6650 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6650 4350 50  0001 C CNN "D1PL"
F 10 "_" H 6650 4350 50  0001 C CNN "D2PN"
F 11 "_" H 6650 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 6650 4350 50  0001 C CNN "Package"
F 13 "_" H 6650 4350 50  0000 C CNN "Description"
F 14 "6.3" H 6650 4350 50  0001 C CNN "Voltage"
F 15 "_" H 6650 4350 50  0001 C CNN "Power"
F 16 "10%" H 6650 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6650 4350 50  0001 C CNN "Temperature"
F 18 "_" H 6650 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6650 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6650 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 6650 4350 50  0001 C CNN "Frequency"
F 22 "_" H 6650 4350 50  0001 C CNN "ResonnanceFreq"
	1    6650 4350
	1    0    0    -1  
$EndComp
$Comp
L C C139
U 1 1 56A27801
P 7800 4350
F 0 "C139" H 7825 4450 50  0000 L CNN
F 1 "10n" H 7825 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7838 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7800 4350 50  0001 C CNN
F 4 "TDK" H 7800 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7800 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 7800 4350 50  0001 C CNN "D1"
F 7 "mouser" H 7800 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 7800 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7800 4350 50  0001 C CNN "D1PL"
F 10 "_" H 7800 4350 50  0001 C CNN "D2PN"
F 11 "_" H 7800 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 7800 4350 50  0001 C CNN "Package"
F 13 "_" H 7800 4350 50  0000 C CNN "Description"
F 14 "6.3" H 7800 4350 50  0001 C CNN "Voltage"
F 15 "_" H 7800 4350 50  0001 C CNN "Power"
F 16 "10%" H 7800 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7800 4350 50  0001 C CNN "Temperature"
F 18 "_" H 7800 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7800 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7800 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 7800 4350 50  0001 C CNN "Frequency"
F 22 "_" H 7800 4350 50  0001 C CNN "ResonnanceFreq"
	1    7800 4350
	1    0    0    -1  
$EndComp
$Comp
L C C138
U 1 1 56A278AB
P 7600 4350
F 0 "C138" H 7625 4450 50  0000 L CNN
F 1 "10n" H 7625 4250 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7638 4200 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7600 4350 50  0001 C CNN
F 4 "TDK" H 7600 4350 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7600 4350 50  0001 C CNN "MFP"
F 6 "digikey" H 7600 4350 50  0001 C CNN "D1"
F 7 "mouser" H 7600 4350 50  0001 C CNN "D2"
F 8 "445-13653" H 7600 4350 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7600 4350 50  0001 C CNN "D1PL"
F 10 "_" H 7600 4350 50  0001 C CNN "D2PN"
F 11 "_" H 7600 4350 50  0001 C CNN "D2PL"
F 12 "0201" H 7600 4350 50  0001 C CNN "Package"
F 13 "_" H 7600 4350 50  0000 C CNN "Description"
F 14 "6.3" H 7600 4350 50  0001 C CNN "Voltage"
F 15 "_" H 7600 4350 50  0001 C CNN "Power"
F 16 "10%" H 7600 4350 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7600 4350 50  0001 C CNN "Temperature"
F 18 "_" H 7600 4350 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7600 4350 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7600 4350 50  0001 C CNN "Cont.Current"
F 21 "_" H 7600 4350 50  0001 C CNN "Frequency"
F 22 "_" H 7600 4350 50  0001 C CNN "ResonnanceFreq"
	1    7600 4350
	1    0    0    -1  
$EndComp
$Comp
L +1V35 #PWR068
U 1 1 56A288FE
P 5150 3600
F 0 "#PWR068" H 5150 3450 50  0001 C CNN
F 1 "+1V35" H 5168 3774 50  0000 C CNN
F 2 "" H 5150 3600 50  0000 C CNN
F 3 "" H 5150 3600 50  0000 C CNN
	1    5150 3600
	1    0    0    -1  
$EndComp
$Comp
L +1V35 #PWR069
U 1 1 56A29C80
P 5750 4200
F 0 "#PWR069" H 5750 4050 50  0001 C CNN
F 1 "+1V35" H 5768 4374 50  0000 C CNN
F 2 "" H 5750 4200 50  0000 C CNN
F 3 "" H 5750 4200 50  0000 C CNN
	1    5750 4200
	1    0    0    -1  
$EndComp
Text GLabel 4950 1900 2    60   Input ~ 0
DDR_DQL0
Text GLabel 4950 2300 2    60   Input ~ 0
DDR_DQL1
Text GLabel 4950 2200 2    60   Input ~ 0
DDR_DQL2
Text GLabel 4950 1800 2    60   Input ~ 0
DDR_DQL3
Text GLabel 4950 2400 2    60   Input ~ 0
DDR_DQL4
Text GLabel 4950 2600 2    60   Input ~ 0
DDR_DQL5
Text GLabel 4950 2500 2    60   Input ~ 0
DDR_DQL6
Text GLabel 4950 2700 2    60   Input ~ 0
DDR_DQL7
Text GLabel 1250 1400 0    60   Input ~ 0
DDR_DQU0
Text GLabel 1250 1600 0    60   Input ~ 0
DDR_DQU1
Text GLabel 1250 1500 0    60   Input ~ 0
DDR_DQU2
Text GLabel 1250 1700 0    60   Input ~ 0
DDR_DQU3
Text GLabel 4950 2800 2    60   Input ~ 0
DDR_DQU4
Text GLabel 4950 2900 2    60   Input ~ 0
DDR_DQU5
Text GLabel 4950 3000 2    60   Input ~ 0
DDR_DQU6
Text GLabel 4950 3100 2    60   Input ~ 0
DDR_DQU7
Text GLabel 4950 2100 2    60   Input ~ 0
DDR_DQSL+
Text GLabel 4950 2000 2    60   Input ~ 0
DDR_DQSL-
Text GLabel 4950 3300 2    60   Input ~ 0
DDR_DQSU+
Text GLabel 4950 3200 2    60   Input ~ 0
DDR_DQSU-
Text GLabel 1250 2400 0    60   Input ~ 0
DDR_A0
Text GLabel 4950 1600 2    60   Input ~ 0
DDR_A1
Text GLabel 1250 3600 0    60   Input ~ 0
DDR_A2
Text GLabel 1250 2500 0    60   Input ~ 0
DDR_A3
Text GLabel 1250 3900 0    60   Input ~ 0
DDR_A4
Text GLabel 1250 4000 0    60   Input ~ 0
DDR_A5
Text GLabel 1250 3300 0    60   Input ~ 0
DDR_A6
Text GLabel 4950 1400 2    60   Input ~ 0
DDR_A7
Text GLabel 4950 1700 2    60   Input ~ 0
DDR_A8
Text GLabel 4950 1300 2    60   Input ~ 0
DDR_A9
Text GLabel 1250 3200 0    60   Input ~ 0
DDR_A10
Text GLabel 1250 3800 0    60   Input ~ 0
DDR_A11
Text GLabel 1250 3700 0    60   Input ~ 0
DDR_A12
Text GLabel 1250 2100 0    60   Input ~ 0
DDR_CLK+
Text GLabel 1250 2000 0    60   Input ~ 0
DDR_CLK-
Text GLabel 1250 2900 0    60   Input ~ 0
DDR_CKE
Text GLabel 1250 2700 0    60   Input ~ 0
DDR_RAS#
Text GLabel 1250 2600 0    60   Input ~ 0
DDR_CAS#
Text GLabel 1250 2200 0    60   Input ~ 0
DDR_WE#
Text GLabel 1250 3000 0    60   Input ~ 0
DDR_BA0
Text GLabel 1250 2800 0    60   Input ~ 0
DDR_BA1
Text GLabel 1250 3100 0    60   Input ~ 0
DDR_BA2
Text GLabel 1250 2300 0    60   Input ~ 0
DDR_ODT
Text GLabel 4950 1500 2    60   Input ~ 0
DDR_A13
Text GLabel 1250 1300 0    60   Input ~ 0
DDR_RST#
Wire Wire Line
	5750 4500 8000 4500
Wire Wire Line
	5750 4200 8000 4200
Wire Wire Line
	4950 3400 4950 3900
Wire Wire Line
	5150 3600 4950 3600
Connection ~ 6100 4500
Connection ~ 6300 4500
Connection ~ 7800 4500
Connection ~ 7600 4500
Connection ~ 7250 4500
Connection ~ 7050 4500
Connection ~ 6850 4500
Connection ~ 6650 4500
Connection ~ 7800 4200
Connection ~ 7600 4200
Connection ~ 7250 4200
Connection ~ 7050 4200
Connection ~ 6850 4200
Connection ~ 6650 4200
Connection ~ 6300 4200
Connection ~ 6100 4200
Connection ~ 4950 3800
Connection ~ 4950 3700
Connection ~ 4950 3600
Connection ~ 4950 3500
$EndSCHEMATC
