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
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 10 14
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
U 7 1 56A05411
P 2800 2400
F 0 "U1" H 2800 4266 50  0000 C CNN
F 1 "xc7a100tcsg324pkg" H 2800 4174 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 2800 2400 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 2800 2400 50  0001 C CNN
F 4 "Xilinx" H 2800 2400 50  0001 C CNN "MFN"
F 5 "XC7A100T-2CSG324I" H 2800 2400 50  0001 C CNN "MFP"
F 6 "digikey" H 2800 2400 50  0001 C CNN "D1"
F 7 "_" H 2800 2400 50  0001 C CNN "D2"
F 8 "122-1881" H 2800 2400 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/XC7A100T-2CSG324I/122-1881-ND/3925808" H 2800 2400 50  0001 C CNN "D1PL"
F 10 "_" H 2800 2400 50  0001 C CNN "D2PN"
F 11 "_" H 2800 2400 50  0001 C CNN "D2PL"
F 12 "BGA324" H 2800 2400 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 2800 2400 50  0001 C CNN "Description"
F 14 "_" H 2800 2400 50  0001 C CNN "Voltage"
F 15 "_" H 2800 2400 50  0001 C CNN "Power"
F 16 "_" H 2800 2400 50  0001 C CNN "Tolerance"
F 17 "_" H 2800 2400 50  0001 C CNN "Temperature"
F 18 "_" H 2800 2400 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 2800 2400 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 2800 2400 50  0001 C CNN "Cont.Current"
F 21 "_" H 2800 2400 50  0001 C CNN "Frequency"
F 22 "_" H 2800 2400 50  0001 C CNN "ResonnanceFreq"
	7    2800 2400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR39
U 1 1 56A04CDF
P 4100 1800
F 0 "#PWR39" H 4100 1550 50  0001 C CNN
F 1 "GND" H 4108 1626 50  0000 C CNN
F 2 "" H 4100 1800 50  0000 C CNN
F 3 "" H 4100 1800 50  0000 C CNN
	1    4100 1800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR12
U 1 1 56A04D27
P 1600 4100
F 0 "#PWR12" H 1600 3850 50  0001 C CNN
F 1 "GND" H 1608 3926 50  0000 C CNN
F 2 "" H 1600 4100 50  0000 C CNN
F 3 "" H 1600 4100 50  0000 C CNN
	1    1600 4100
	1    0    0    -1  
$EndComp
$Comp
L +1V0 #PWR41
U 1 1 56A27FDD
P 4150 2600
F 0 "#PWR41" H 4150 2450 50  0001 C CNN
F 1 "+1V0" H 4168 2774 50  0000 C CNN
F 2 "" H 4150 2600 50  0000 C CNN
F 3 "" H 4150 2600 50  0000 C CNN
	1    4150 2600
	1    0    0    -1  
$EndComp
$Comp
L C C107
U 1 1 56A1F139
P 5600 1200
F 0 "C107" H 5625 1300 50  0000 L CNN
F 1 "4.7u" H 5625 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5638 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5600 1200 50  0001 C CNN
F 4 "TDK" H 5600 1200 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5600 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 5600 1200 50  0001 C CNN "D1"
F 7 "avnet" H 5600 1200 50  0001 C CNN "D2"
F 8 "445-5947" H 5600 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5600 1200 50  0001 C CNN "D1PL"
F 10 "C1005X5R0J475K050BC/BKN" H 5600 1200 50  0001 C CNN "D2PN"
F 11 "http://avnetexpress.avnet.com/store/em/EMController?action=products&catalogId=500201&storeId=500201&N=0&defaultCurrency=USD&langId=-1&slnk=e&term=C1005X5R0J475K050BC%252FBKN&mfr=TDK&CMP=KNC-Octopart_VSE&c=USD&l=-1" H 5600 1200 50  0001 C CNN "D2PL"
F 12 "0402" H 5600 1200 50  0001 C CNN "Package"
F 13 "_" H 5600 1200 50  0000 C CNN "Description"
F 14 "6.3" H 5600 1200 50  0001 C CNN "Voltage"
F 15 "_" H 5600 1200 50  0001 C CNN "Power"
F 16 "10%" H 5600 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5600 1200 50  0001 C CNN "Temperature"
F 18 "_" H 5600 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5600 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5600 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 5600 1200 50  0001 C CNN "Frequency"
F 22 "_" H 5600 1200 50  0001 C CNN "ResonnanceFreq"
	1    5600 1200
	1    0    0    -1  
$EndComp
$Comp
L C C113
U 1 1 56A1F153
P 6000 1200
F 0 "C113" H 6025 1300 50  0000 L CNN
F 1 "4.7u" H 6025 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 6038 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6000 1200 50  0001 C CNN
F 4 "TDK" H 6000 1200 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 6000 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 6000 1200 50  0001 C CNN "D1"
F 7 "avnet" H 6000 1200 50  0001 C CNN "D2"
F 8 "445-5947" H 6000 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 6000 1200 50  0001 C CNN "D1PL"
F 10 "C1005X5R0J475K050BC/BKN" H 6000 1200 50  0001 C CNN "D2PN"
F 11 "http://avnetexpress.avnet.com/store/em/EMController?action=products&catalogId=500201&storeId=500201&N=0&defaultCurrency=USD&langId=-1&slnk=e&term=C1005X5R0J475K050BC%252FBKN&mfr=TDK&CMP=KNC-Octopart_VSE&c=USD&l=-1" H 6000 1200 50  0001 C CNN "D2PL"
F 12 "0402" H 6000 1200 50  0001 C CNN "Package"
F 13 "_" H 6000 1200 50  0000 C CNN "Description"
F 14 "6.3" H 6000 1200 50  0001 C CNN "Voltage"
F 15 "_" H 6000 1200 50  0001 C CNN "Power"
F 16 "10%" H 6000 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6000 1200 50  0001 C CNN "Temperature"
F 18 "_" H 6000 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6000 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6000 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 6000 1200 50  0001 C CNN "Frequency"
F 22 "_" H 6000 1200 50  0001 C CNN "ResonnanceFreq"
	1    6000 1200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR54
U 1 1 56A1F1A8
P 5300 1350
F 0 "#PWR54" H 5300 1100 50  0001 C CNN
F 1 "GND" H 5300 1200 50  0000 C CNN
F 2 "" H 5300 1350 60  0000 C CNN
F 3 "" H 5300 1350 60  0000 C CNN
	1    5300 1350
	1    0    0    -1  
$EndComp
$Comp
L C C120
U 1 1 56A1F1C1
P 6350 1200
F 0 "C120" H 6375 1300 50  0000 L CNN
F 1 "470n" H 6375 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6388 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6350 1200 50  0001 C CNN
F 4 "TDK" H 6350 1200 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6350 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 6350 1200 50  0001 C CNN "D1"
F 7 "mouser" H 6350 1200 50  0001 C CNN "D2"
F 8 "445-13653" H 6350 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6350 1200 50  0001 C CNN "D1PL"
F 10 "_" H 6350 1200 50  0001 C CNN "D2PN"
F 11 "_" H 6350 1200 50  0001 C CNN "D2PL"
F 12 "0201" H 6350 1200 50  0001 C CNN "Package"
F 13 "_" H 6350 1200 50  0000 C CNN "Description"
F 14 "6.3" H 6350 1200 50  0001 C CNN "Voltage"
F 15 "_" H 6350 1200 50  0001 C CNN "Power"
F 16 "10%" H 6350 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6350 1200 50  0001 C CNN "Temperature"
F 18 "_" H 6350 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6350 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6350 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 6350 1200 50  0001 C CNN "Frequency"
F 22 "_" H 6350 1200 50  0001 C CNN "ResonnanceFreq"
	1    6350 1200
	1    0    0    -1  
$EndComp
$Comp
L C C121
U 1 1 56A1F1DB
P 6550 1200
F 0 "C121" H 6575 1300 50  0000 L CNN
F 1 "470n" H 6575 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6588 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6550 1200 50  0001 C CNN
F 4 "TDK" H 6550 1200 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6550 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 6550 1200 50  0001 C CNN "D1"
F 7 "mouser" H 6550 1200 50  0001 C CNN "D2"
F 8 "445-13653" H 6550 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6550 1200 50  0001 C CNN "D1PL"
F 10 "_" H 6550 1200 50  0001 C CNN "D2PN"
F 11 "_" H 6550 1200 50  0001 C CNN "D2PL"
F 12 "0201" H 6550 1200 50  0001 C CNN "Package"
F 13 "_" H 6550 1200 50  0000 C CNN "Description"
F 14 "6.3" H 6550 1200 50  0001 C CNN "Voltage"
F 15 "_" H 6550 1200 50  0001 C CNN "Power"
F 16 "10%" H 6550 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6550 1200 50  0001 C CNN "Temperature"
F 18 "_" H 6550 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6550 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6550 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 6550 1200 50  0001 C CNN "Frequency"
F 22 "_" H 6550 1200 50  0001 C CNN "ResonnanceFreq"
	1    6550 1200
	1    0    0    -1  
$EndComp
$Comp
L C C122
U 1 1 56A1F1F5
P 6750 1200
F 0 "C122" H 6775 1300 50  0000 L CNN
F 1 "470n" H 6775 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6788 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6750 1200 50  0001 C CNN
F 4 "TDK" H 6750 1200 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6750 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 6750 1200 50  0001 C CNN "D1"
F 7 "mouser" H 6750 1200 50  0001 C CNN "D2"
F 8 "445-13653" H 6750 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6750 1200 50  0001 C CNN "D1PL"
F 10 "_" H 6750 1200 50  0001 C CNN "D2PN"
F 11 "_" H 6750 1200 50  0001 C CNN "D2PL"
F 12 "0201" H 6750 1200 50  0001 C CNN "Package"
F 13 "_" H 6750 1200 50  0000 C CNN "Description"
F 14 "6.3" H 6750 1200 50  0001 C CNN "Voltage"
F 15 "_" H 6750 1200 50  0001 C CNN "Power"
F 16 "10%" H 6750 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6750 1200 50  0001 C CNN "Temperature"
F 18 "_" H 6750 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6750 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6750 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 6750 1200 50  0001 C CNN "Frequency"
F 22 "_" H 6750 1200 50  0001 C CNN "ResonnanceFreq"
	1    6750 1200
	1    0    0    -1  
$EndComp
$Comp
L C C123
U 1 1 56A1F20F
P 6950 1200
F 0 "C123" H 6975 1300 50  0000 L CNN
F 1 "470n" H 6975 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6988 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6950 1200 50  0001 C CNN
F 4 "TDK" H 6950 1200 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6950 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 6950 1200 50  0001 C CNN "D1"
F 7 "mouser" H 6950 1200 50  0001 C CNN "D2"
F 8 "445-13653" H 6950 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6950 1200 50  0001 C CNN "D1PL"
F 10 "_" H 6950 1200 50  0001 C CNN "D2PN"
F 11 "_" H 6950 1200 50  0001 C CNN "D2PL"
F 12 "0201" H 6950 1200 50  0001 C CNN "Package"
F 13 "_" H 6950 1200 50  0000 C CNN "Description"
F 14 "6.3" H 6950 1200 50  0001 C CNN "Voltage"
F 15 "_" H 6950 1200 50  0001 C CNN "Power"
F 16 "10%" H 6950 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6950 1200 50  0001 C CNN "Temperature"
F 18 "_" H 6950 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6950 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6950 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 6950 1200 50  0001 C CNN "Frequency"
F 22 "_" H 6950 1200 50  0001 C CNN "ResonnanceFreq"
	1    6950 1200
	1    0    0    -1  
$EndComp
$Comp
L C C124
U 1 1 56A1F229
P 7150 1200
F 0 "C124" H 7175 1300 50  0000 L CNN
F 1 "470n" H 7175 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 7188 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7150 1200 50  0001 C CNN
F 4 "TDK" H 7150 1200 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 7150 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 7150 1200 50  0001 C CNN "D1"
F 7 "mouser" H 7150 1200 50  0001 C CNN "D2"
F 8 "445-13653" H 7150 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 7150 1200 50  0001 C CNN "D1PL"
F 10 "_" H 7150 1200 50  0001 C CNN "D2PN"
F 11 "_" H 7150 1200 50  0001 C CNN "D2PL"
F 12 "0201" H 7150 1200 50  0001 C CNN "Package"
F 13 "_" H 7150 1200 50  0000 C CNN "Description"
F 14 "6.3" H 7150 1200 50  0001 C CNN "Voltage"
F 15 "_" H 7150 1200 50  0001 C CNN "Power"
F 16 "10%" H 7150 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7150 1200 50  0001 C CNN "Temperature"
F 18 "_" H 7150 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7150 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7150 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 7150 1200 50  0001 C CNN "Frequency"
F 22 "_" H 7150 1200 50  0001 C CNN "ResonnanceFreq"
	1    7150 1200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR57
U 1 1 56A1F27E
P 5300 2100
F 0 "#PWR57" H 5300 1850 50  0001 C CNN
F 1 "GND" H 5300 1950 50  0000 C CNN
F 2 "" H 5300 2100 60  0000 C CNN
F 3 "" H 5300 2100 60  0000 C CNN
	1    5300 2100
	1    0    0    -1  
$EndComp
$Comp
L C C105
U 1 1 56A1F2CB
P 5300 2800
F 0 "C105" H 5325 2900 50  0000 L CNN
F 1 "47u" H 5325 2700 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5338 2650 50  0001 C CNN
F 3 "https://product.tdk.com/info/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5300 2800 50  0001 C CNN
F 4 "TDK" H 5300 2800 50  0001 C CNN "MFN"
F 5 "C2012X5R1A476M125AC" H 5300 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 5300 2800 50  0001 C CNN "D1"
F 7 "mouser" H 5300 2800 50  0001 C CNN "D2"
F 8 "445-8239" H 5300 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C2012X5R1A476M125AC/445-8239-1-ND/2812081" H 5300 2800 50  0001 C CNN "D1PL"
F 10 "_" H 5300 2800 50  0001 C CNN "D2PN"
F 11 "_" H 5300 2800 50  0001 C CNN "D2PL"
F 12 "0805" H 5300 2800 50  0001 C CNN "Package"
F 13 "_" H 5300 2800 50  0000 C CNN "Description"
F 14 "10" H 5300 2800 50  0001 C CNN "Voltage"
F 15 "_" H 5300 2800 50  0001 C CNN "Power"
F 16 "20%" H 5300 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5300 2800 50  0001 C CNN "Temperature"
F 18 "_" H 5300 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5300 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5300 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 5300 2800 50  0001 C CNN "Frequency"
F 22 "_" H 5300 2800 50  0001 C CNN "ResonnanceFreq"
	1    5300 2800
	1    0    0    -1  
$EndComp
$Comp
L C C106
U 1 1 56A1F2E5
P 5550 2800
F 0 "C106" H 5575 2900 50  0000 L CNN
F 1 "4.7u" H 5575 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5588 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5550 2800 50  0001 C CNN
F 4 "TDK" H 5550 2800 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5550 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 5550 2800 50  0001 C CNN "D1"
F 7 "avnet" H 5550 2800 50  0001 C CNN "D2"
F 8 "445-5947" H 5550 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5550 2800 50  0001 C CNN "D1PL"
F 10 "C1005X5R0J475K050BC/BKN" H 5550 2800 50  0001 C CNN "D2PN"
F 11 "http://avnetexpress.avnet.com/store/em/EMController?action=products&catalogId=500201&storeId=500201&N=0&defaultCurrency=USD&langId=-1&slnk=e&term=C1005X5R0J475K050BC%252FBKN&mfr=TDK&CMP=KNC-Octopart_VSE&c=USD&l=-1" H 5550 2800 50  0001 C CNN "D2PL"
F 12 "0402" H 5550 2800 50  0001 C CNN "Package"
F 13 "_" H 5550 2800 50  0000 C CNN "Description"
F 14 "6.3" H 5550 2800 50  0001 C CNN "Voltage"
F 15 "_" H 5550 2800 50  0001 C CNN "Power"
F 16 "10%" H 5550 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5550 2800 50  0001 C CNN "Temperature"
F 18 "_" H 5550 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5550 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5550 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 5550 2800 50  0001 C CNN "Frequency"
F 22 "_" H 5550 2800 50  0001 C CNN "ResonnanceFreq"
	1    5550 2800
	1    0    0    -1  
$EndComp
$Comp
L C C109
U 1 1 56A1F2FF
P 5750 2800
F 0 "C109" H 5775 2900 50  0000 L CNN
F 1 "4.7u" H 5775 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5788 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5750 2800 50  0001 C CNN
F 4 "TDK" H 5750 2800 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5750 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 5750 2800 50  0001 C CNN "D1"
F 7 "avnet" H 5750 2800 50  0001 C CNN "D2"
F 8 "445-5947" H 5750 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5750 2800 50  0001 C CNN "D1PL"
F 10 "C1005X5R0J475K050BC/BKN" H 5750 2800 50  0001 C CNN "D2PN"
F 11 "http://avnetexpress.avnet.com/store/em/EMController?action=products&catalogId=500201&storeId=500201&N=0&defaultCurrency=USD&langId=-1&slnk=e&term=C1005X5R0J475K050BC%252FBKN&mfr=TDK&CMP=KNC-Octopart_VSE&c=USD&l=-1" H 5750 2800 50  0001 C CNN "D2PL"
F 12 "0402" H 5750 2800 50  0001 C CNN "Package"
F 13 "_" H 5750 2800 50  0000 C CNN "Description"
F 14 "6.3" H 5750 2800 50  0001 C CNN "Voltage"
F 15 "_" H 5750 2800 50  0001 C CNN "Power"
F 16 "10%" H 5750 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5750 2800 50  0001 C CNN "Temperature"
F 18 "_" H 5750 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5750 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5750 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 5750 2800 50  0001 C CNN "Frequency"
F 22 "_" H 5750 2800 50  0001 C CNN "ResonnanceFreq"
	1    5750 2800
	1    0    0    -1  
$EndComp
$Comp
L C C115
U 1 1 56A1F333
P 6200 2800
F 0 "C115" H 6225 2900 50  0000 L CNN
F 1 "470n" H 6225 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6238 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6200 2800 50  0001 C CNN
F 4 "TDK" H 6200 2800 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6200 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 6200 2800 50  0001 C CNN "D1"
F 7 "mouser" H 6200 2800 50  0001 C CNN "D2"
F 8 "445-13653" H 6200 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6200 2800 50  0001 C CNN "D1PL"
F 10 "_" H 6200 2800 50  0001 C CNN "D2PN"
F 11 "_" H 6200 2800 50  0001 C CNN "D2PL"
F 12 "0201" H 6200 2800 50  0001 C CNN "Package"
F 13 "_" H 6200 2800 50  0000 C CNN "Description"
F 14 "6.3" H 6200 2800 50  0001 C CNN "Voltage"
F 15 "_" H 6200 2800 50  0001 C CNN "Power"
F 16 "10%" H 6200 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6200 2800 50  0001 C CNN "Temperature"
F 18 "_" H 6200 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6200 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6200 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 6200 2800 50  0001 C CNN "Frequency"
F 22 "_" H 6200 2800 50  0001 C CNN "ResonnanceFreq"
	1    6200 2800
	1    0    0    -1  
$EndComp
$Comp
L C C117
U 1 1 56A1F34D
P 6400 2800
F 0 "C117" H 6425 2900 50  0000 L CNN
F 1 "470n" H 6425 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6438 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6400 2800 50  0001 C CNN
F 4 "TDK" H 6400 2800 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6400 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 6400 2800 50  0001 C CNN "D1"
F 7 "mouser" H 6400 2800 50  0001 C CNN "D2"
F 8 "445-13653" H 6400 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6400 2800 50  0001 C CNN "D1PL"
F 10 "_" H 6400 2800 50  0001 C CNN "D2PN"
F 11 "_" H 6400 2800 50  0001 C CNN "D2PL"
F 12 "0201" H 6400 2800 50  0001 C CNN "Package"
F 13 "_" H 6400 2800 50  0000 C CNN "Description"
F 14 "6.3" H 6400 2800 50  0001 C CNN "Voltage"
F 15 "_" H 6400 2800 50  0001 C CNN "Power"
F 16 "10%" H 6400 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6400 2800 50  0001 C CNN "Temperature"
F 18 "_" H 6400 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6400 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6400 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 6400 2800 50  0001 C CNN "Frequency"
F 22 "_" H 6400 2800 50  0001 C CNN "ResonnanceFreq"
	1    6400 2800
	1    0    0    -1  
$EndComp
$Comp
L C C119
U 1 1 56A1F367
P 6600 2800
F 0 "C119" H 6625 2900 50  0000 L CNN
F 1 "470n" H 6625 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6638 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6600 2800 50  0001 C CNN
F 4 "TDK" H 6600 2800 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6600 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 6600 2800 50  0001 C CNN "D1"
F 7 "mouser" H 6600 2800 50  0001 C CNN "D2"
F 8 "445-13653" H 6600 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6600 2800 50  0001 C CNN "D1PL"
F 10 "_" H 6600 2800 50  0001 C CNN "D2PN"
F 11 "_" H 6600 2800 50  0001 C CNN "D2PL"
F 12 "0201" H 6600 2800 50  0001 C CNN "Package"
F 13 "_" H 6600 2800 50  0000 C CNN "Description"
F 14 "6.3" H 6600 2800 50  0001 C CNN "Voltage"
F 15 "_" H 6600 2800 50  0001 C CNN "Power"
F 16 "10%" H 6600 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6600 2800 50  0001 C CNN "Temperature"
F 18 "_" H 6600 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6600 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6600 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 6600 2800 50  0001 C CNN "Frequency"
F 22 "_" H 6600 2800 50  0001 C CNN "ResonnanceFreq"
	1    6600 2800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR58
U 1 1 56A1F3A2
P 5300 2950
F 0 "#PWR58" H 5300 2700 50  0001 C CNN
F 1 "GND" H 5300 2800 50  0000 C CNN
F 2 "" H 5300 2950 60  0000 C CNN
F 3 "" H 5300 2950 60  0000 C CNN
	1    5300 2950
	1    0    0    -1  
$EndComp
$Comp
L CP1 C103
U 1 1 56A1F3BB
P 5300 1200
F 0 "C103" H 5325 1300 50  0000 L CNN
F 1 "330u" H 5325 1100 50  0000 L CNN
F 2 "Capacitors_SMD:C_1210" H 5300 1200 50  0001 C CNN
F 3 "http://ds.yuden.co.jp/TYCOMPAS/ut/detail.do?productNo=AMK325ABJ337MM-T&fileName=AMK325ABJ337MM-T_SS&mode=specSheetDownload" H 5300 1200 50  0001 C CNN
F 4 "Taiyo Yuden" H 5300 1200 50  0001 C CNN "MFN"
F 5 "AMK325ABJ337MM-T" H 5300 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 5300 1200 50  0001 C CNN "D1"
F 7 "mouser" H 5300 1200 50  0001 C CNN "D2"
F 8 "587-3977" H 5300 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/AMK325ABJ337MM-T/587-3977-1-ND/4950531" H 5300 1200 50  0001 C CNN "D1PL"
F 10 "_" H 5300 1200 50  0001 C CNN "D2PN"
F 11 "_" H 5300 1200 50  0001 C CNN "D2PL"
F 12 "1210" H 5300 1200 50  0001 C CNN "Package"
F 13 "_" H 5300 1200 50  0000 C CNN "Description"
F 14 "4" H 5300 1200 50  0001 C CNN "Voltage"
F 15 "_" H 5300 1200 50  0001 C CNN "Power"
F 16 "20%" H 5300 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5300 1200 50  0001 C CNN "Temperature"
F 18 "_" H 5300 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5300 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5300 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 5300 1200 50  0001 C CNN "Frequency"
F 22 "_" H 5300 1200 50  0001 C CNN "ResonnanceFreq"
	1    5300 1200
	1    0    0    -1  
$EndComp
$Comp
L C C110
U 1 1 56A1F3D5
P 5800 1200
F 0 "C110" H 5825 1300 50  0000 L CNN
F 1 "4.7u" H 5825 1100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5838 1050 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5800 1200 50  0001 C CNN
F 4 "TDK" H 5800 1200 50  0001 C CNN "MFN"
F 5 "C1005X5R0J475K050BC" H 5800 1200 50  0001 C CNN "MFP"
F 6 "digikey" H 5800 1200 50  0001 C CNN "D1"
F 7 "avnet" H 5800 1200 50  0001 C CNN "D2"
F 8 "445-5947" H 5800 1200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J475K050BC/445-5947-1-ND/2443987" H 5800 1200 50  0001 C CNN "D1PL"
F 10 "C1005X5R0J475K050BC/BKN" H 5800 1200 50  0001 C CNN "D2PN"
F 11 "http://avnetexpress.avnet.com/store/em/EMController?action=products&catalogId=500201&storeId=500201&N=0&defaultCurrency=USD&langId=-1&slnk=e&term=C1005X5R0J475K050BC%252FBKN&mfr=TDK&CMP=KNC-Octopart_VSE&c=USD&l=-1" H 5800 1200 50  0001 C CNN "D2PL"
F 12 "0402" H 5800 1200 50  0001 C CNN "Package"
F 13 "_" H 5800 1200 50  0000 C CNN "Description"
F 14 "6.3" H 5800 1200 50  0001 C CNN "Voltage"
F 15 "_" H 5800 1200 50  0001 C CNN "Power"
F 16 "10%" H 5800 1200 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5800 1200 50  0001 C CNN "Temperature"
F 18 "_" H 5800 1200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5800 1200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5800 1200 50  0001 C CNN "Cont.Current"
F 21 "_" H 5800 1200 50  0001 C CNN "Frequency"
F 22 "_" H 5800 1200 50  0001 C CNN "ResonnanceFreq"
	1    5800 1200
	1    0    0    -1  
$EndComp
$Comp
L CP1 C104
U 1 1 56A1F3EF
P 5300 1950
F 0 "C104" H 5325 2050 50  0000 L CNN
F 1 "100u" H 5325 1850 50  0000 L CNN
F 2 "Dipoles_SMD:C_1206" H 5300 1950 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5300 1950 50  0001 C CNN
F 4 "TDK" H 5300 1950 50  0001 C CNN "MFN"
F 5 "C3216X5R0J107M160AB" H 5300 1950 50  0001 C CNN "MFP"
F 6 "digikey" H 5300 1950 50  0001 C CNN "D1"
F 7 "mouser" H 5300 1950 50  0001 C CNN "D2"
F 8 "445-6008" H 5300 1950 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C3216X5R0J107M160AB/445-6008-1-ND/2444049" H 5300 1950 50  0001 C CNN "D1PL"
F 10 "_" H 5300 1950 50  0001 C CNN "D2PN"
F 11 "_" H 5300 1950 50  0001 C CNN "D2PL"
F 12 "1206" H 5300 1950 50  0001 C CNN "Package"
F 13 "_" H 5300 1950 50  0000 C CNN "Description"
F 14 "6.3" H 5300 1950 50  0001 C CNN "Voltage"
F 15 "_" H 5300 1950 50  0001 C CNN "Power"
F 16 "20%" H 5300 1950 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5300 1950 50  0001 C CNN "Temperature"
F 18 "_" H 5300 1950 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5300 1950 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5300 1950 50  0001 C CNN "Cont.Current"
F 21 "_" H 5300 1950 50  0001 C CNN "Frequency"
F 22 "_" H 5300 1950 50  0001 C CNN "ResonnanceFreq"
	1    5300 1950
	1    0    0    -1  
$EndComp
$Comp
L +1V0 #PWR55
U 1 1 56A2E7B1
P 5300 1800
F 0 "#PWR55" H 5300 1650 50  0001 C CNN
F 1 "+1V0" H 5318 1974 50  0000 C CNN
F 2 "" H 5300 1800 50  0000 C CNN
F 3 "" H 5300 1800 50  0000 C CNN
	1    5300 1800
	1    0    0    -1  
$EndComp
$Comp
L +1V0 #PWR53
U 1 1 56A2E80A
P 5300 1050
F 0 "#PWR53" H 5300 900 50  0001 C CNN
F 1 "+1V0" H 5318 1224 50  0000 C CNN
F 2 "" H 5300 1050 50  0000 C CNN
F 3 "" H 5300 1050 50  0000 C CNN
	1    5300 1050
	1    0    0    -1  
$EndComp
$Comp
L C C112
U 1 1 56A2F1B7
P 6000 2800
F 0 "C112" H 6025 2900 50  0000 L CNN
F 1 "470n" H 6025 2700 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 6038 2650 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 6000 2800 50  0001 C CNN
F 4 "TDK" H 6000 2800 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 6000 2800 50  0001 C CNN "MFP"
F 6 "digikey" H 6000 2800 50  0001 C CNN "D1"
F 7 "mouser" H 6000 2800 50  0001 C CNN "D2"
F 8 "445-13653" H 6000 2800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 6000 2800 50  0001 C CNN "D1PL"
F 10 "_" H 6000 2800 50  0001 C CNN "D2PN"
F 11 "_" H 6000 2800 50  0001 C CNN "D2PL"
F 12 "0201" H 6000 2800 50  0001 C CNN "Package"
F 13 "_" H 6000 2800 50  0000 C CNN "Description"
F 14 "6.3" H 6000 2800 50  0001 C CNN "Voltage"
F 15 "_" H 6000 2800 50  0001 C CNN "Power"
F 16 "10%" H 6000 2800 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6000 2800 50  0001 C CNN "Temperature"
F 18 "_" H 6000 2800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6000 2800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6000 2800 50  0001 C CNN "Cont.Current"
F 21 "_" H 6000 2800 50  0001 C CNN "Frequency"
F 22 "_" H 6000 2800 50  0001 C CNN "ResonnanceFreq"
	1    6000 2800
	1    0    0    -1  
$EndComp
$Comp
L C C111
U 1 1 56A1F2B1
P 5650 1950
F 0 "C111" H 5675 2050 50  0000 L CNN
F 1 "470n" H 5675 1850 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" H 5688 1800 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5650 1950 50  0001 C CNN
F 4 "TDK" H 5650 1950 50  0001 C CNN "MFN"
F 5 "C0603X5R0J474K030BC" H 5650 1950 50  0001 C CNN "MFP"
F 6 "digikey" H 5650 1950 50  0001 C CNN "D1"
F 7 "mouser" H 5650 1950 50  0001 C CNN "D2"
F 8 "445-13653" H 5650 1950 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C0603X5R0J474K030BC/445-13653-1-ND/3955319" H 5650 1950 50  0001 C CNN "D1PL"
F 10 "_" H 5650 1950 50  0001 C CNN "D2PN"
F 11 "_" H 5650 1950 50  0001 C CNN "D2PL"
F 12 "0201" H 5650 1950 50  0001 C CNN "Package"
F 13 "_" H 5650 1950 50  0000 C CNN "Description"
F 14 "6.3" H 5650 1950 50  0001 C CNN "Voltage"
F 15 "_" H 5650 1950 50  0001 C CNN "Power"
F 16 "10%" H 5650 1950 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5650 1950 50  0001 C CNN "Temperature"
F 18 "_" H 5650 1950 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5650 1950 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5650 1950 50  0001 C CNN "Cont.Current"
F 21 "_" H 5650 1950 50  0001 C CNN "Frequency"
F 22 "_" H 5650 1950 50  0001 C CNN "ResonnanceFreq"
	1    5650 1950
	1    0    0    -1  
$EndComp
$Comp
L +1V8 #PWR40
U 1 1 56A3B81E
P 4100 2300
F 0 "#PWR40" H 4100 2150 50  0001 C CNN
F 1 "+1V8" H 4118 2474 50  0000 C CNN
F 2 "" H 4100 2300 50  0000 C CNN
F 3 "" H 4100 2300 50  0000 C CNN
	1    4100 2300
	1    0    0    -1  
$EndComp
$Comp
L +1V8 #PWR52
U 1 1 56A3B86C
P 5200 2650
F 0 "#PWR52" H 5200 2500 50  0001 C CNN
F 1 "+1V8" H 5218 2824 50  0000 C CNN
F 2 "" H 5200 2650 50  0000 C CNN
F 3 "" H 5200 2650 50  0000 C CNN
	1    5200 2650
	1    0    0    -1  
$EndComp
Text Label 5500 1050 2    60   ~ 0
VDD
Text Notes 5600 850  0    60   ~ 0
VCCINT
Text Notes 5600 1650 0    60   ~ 0
VCCBRAM
Text Label 5450 1800 2    60   ~ 0
VDD
Text Notes 5700 2450 0    60   ~ 0
VCCAUX
Text Label 5650 2650 2    60   ~ 0
VCCAUX
Wire Wire Line
	1600 800  1600 4100
Wire Wire Line
	4000 800  4000 2000
Wire Wire Line
	4000 2500 4000 4000
Wire Wire Line
	4100 1800 4000 1800
Wire Wire Line
	4000 2100 4000 2400
Wire Wire Line
	4000 2300 4100 2300
Wire Wire Line
	4150 2600 4000 2600
Wire Wire Line
	5300 2100 5650 2100
Wire Wire Line
	5300 1800 5650 1800
Wire Wire Line
	5300 2950 6600 2950
Wire Wire Line
	5200 2650 6600 2650
Wire Wire Line
	5300 1050 7150 1050
Wire Wire Line
	5300 1350 7150 1350
Connection ~ 4000 1900
Connection ~ 4000 1800
Connection ~ 4000 1700
Connection ~ 4000 1600
Connection ~ 4000 1500
Connection ~ 4000 1400
Connection ~ 4000 1300
Connection ~ 4000 1200
Connection ~ 4000 1100
Connection ~ 4000 1000
Connection ~ 4000 900 
Connection ~ 1600 900 
Connection ~ 1600 1000
Connection ~ 1600 1100
Connection ~ 1600 1200
Connection ~ 1600 1300
Connection ~ 1600 1400
Connection ~ 1600 1500
Connection ~ 1600 1600
Connection ~ 1600 1700
Connection ~ 1600 1800
Connection ~ 1600 1900
Connection ~ 1600 2000
Connection ~ 1600 2100
Connection ~ 1600 2200
Connection ~ 1600 2300
Connection ~ 1600 2400
Connection ~ 1600 2500
Connection ~ 1600 2600
Connection ~ 1600 2700
Connection ~ 1600 2800
Connection ~ 1600 2900
Connection ~ 1600 3000
Connection ~ 1600 3100
Connection ~ 1600 3200
Connection ~ 1600 3300
Connection ~ 1600 3400
Connection ~ 1600 3500
Connection ~ 1600 3600
Connection ~ 1600 3700
Connection ~ 1600 3800
Connection ~ 1600 3900
Connection ~ 1600 4000
Connection ~ 4000 2800
Connection ~ 4000 2900
Connection ~ 4000 3000
Connection ~ 4000 3100
Connection ~ 4000 3200
Connection ~ 4000 3300
Connection ~ 4000 3400
Connection ~ 4000 3500
Connection ~ 4000 3600
Connection ~ 4000 3700
Connection ~ 4000 3800
Connection ~ 4000 3900
Connection ~ 4000 2300
Connection ~ 4000 2200
Connection ~ 4000 2700
Connection ~ 4000 2600
Connection ~ 6750 1050
Connection ~ 6550 1050
Connection ~ 6350 1050
Connection ~ 6000 1050
Connection ~ 5800 1050
Connection ~ 5600 1050
Connection ~ 6750 1350
Connection ~ 6550 1350
Connection ~ 6350 1350
Connection ~ 5600 1350
Connection ~ 5800 1350
Connection ~ 6000 1350
Connection ~ 6950 1050
Connection ~ 6950 1350
Connection ~ 6400 2650
Connection ~ 6200 2650
Connection ~ 6000 2650
Connection ~ 5750 2650
Connection ~ 5550 2650
Connection ~ 5550 2950
Connection ~ 5750 2950
Connection ~ 6200 2950
Connection ~ 6400 2950
Connection ~ 6000 2950
Connection ~ 5300 2650
$EndSCHEMATC
