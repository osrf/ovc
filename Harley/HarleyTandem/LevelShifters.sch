EESchema Schematic File Version 2
LIBS:isolators
LIBS:DCDC_Converters
LIBS:voltage_translators
LIBS:conn
LIBS:device
LIBS:connectors
LIBS:cameras
LIBS:IMU
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
LIBS:HarleyTandem-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 5
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
L 74AVCH8T245-1EP U1
U 1 1 572C1CFF
P 3600 2500
F 0 "U1" H 3350 3500 60  0000 C CNN
F 1 "74AVCH8T245-1EP" H 4150 1700 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-24-1EP-Pitch0.5-nonSquare" H 3600 2500 60  0001 C CNN
F 3 "http://www.nxp.com/documents/data_sheet/74AVCH8T245.pdf" H 3575 3587 60  0001 C CNN
F 4 "NXP" H 3600 2500 60  0001 C CNN "MFN"
F 5 "74AVCH8T245BQ" H 3600 2500 60  0001 C CNN "MFP"
F 6 "digikey" H 3600 2500 60  0001 C CNN "D1"
F 7 "mouser" H 3600 2500 60  0001 C CNN "D2"
F 8 "568-5418" H 3600 2500 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/74AVCH8T245BQ%2C118/568-5418-1-ND/2530896?WT.z_cid=ref_octopart_dkc_buynow&site=us" H 3600 2500 60  0001 C CNN "D1PL"
F 10 "_" H 3600 2500 60  0001 C CNN "D2PN"
F 11 "_" H 3600 2500 60  0001 C CNN "D2PL"
F 12 "_" H 3600 2500 60  0001 C CNN "Package"
F 13 "_" H 3575 3481 60  0000 C CNN "Description"
F 14 "_" H 3600 2500 60  0001 C CNN "Voltage"
F 15 "_" H 3600 2500 60  0001 C CNN "Power"
F 16 "_" H 3600 2500 60  0001 C CNN "Tolerance"
F 17 "_" H 3600 2500 60  0001 C CNN "Temperature"
F 18 "_" H 3600 2500 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 3600 2500 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 3600 2500 60  0001 C CNN "Cont.Current"
F 21 "_" H 3600 2500 60  0001 C CNN "Frequency"
F 22 "_" H 3600 2500 60  0001 C CNN "ResonnanceFreq"
	1    3600 2500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR066
U 1 1 572C1D06
P 3600 3500
F 0 "#PWR066" H 3600 3250 50  0001 C CNN
F 1 "GND" H 3605 3327 50  0000 C CNN
F 2 "" H 3600 3500 50  0000 C CNN
F 3 "" H 3600 3500 50  0000 C CNN
	1    3600 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 3400 3500 3500
Wire Wire Line
	3600 3500 3600 3400
Wire Wire Line
	3700 3500 3700 3400
Connection ~ 3600 3500
$Comp
L +2V5 #PWR067
U 1 1 572C1D11
P 2850 1700
F 0 "#PWR067" H 2850 1550 50  0001 C CNN
F 1 "+2V5" H 2865 1873 50  0000 C CNN
F 2 "" H 2850 1700 50  0000 C CNN
F 3 "" H 2850 1700 50  0000 C CNN
	1    2850 1700
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR068
U 1 1 572C1D17
P 4200 1700
F 0 "#PWR068" H 4200 1550 50  0001 C CNN
F 1 "+3V3" H 4215 1873 50  0000 C CNN
F 2 "" H 4200 1700 50  0000 C CNN
F 3 "" H 4200 1700 50  0000 C CNN
	1    4200 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 1700 4350 1700
Wire Wire Line
	4050 1800 4200 1800
Wire Wire Line
	4200 1800 4200 1700
Text GLabel 3100 2500 0    60   Input ~ 0
Python1_CS#
Text GLabel 3100 2400 0    60   Input ~ 0
Python2_CS#
Text GLabel 3100 2600 0    60   Input ~ 0
Python3_CS#
Text GLabel 3100 2700 0    60   Input ~ 0
IMU_CS#
Text GLabel 3100 2900 0    60   Input ~ 0
Python_RST#
Text GLabel 3100 2800 0    60   Input ~ 0
Python_Trigger
Text GLabel 3100 2200 0    60   Input ~ 0
SPI_MOSI
Text GLabel 3100 2300 0    60   Input ~ 0
SPI_SCK
Text GLabel 4050 2500 2    60   Input ~ 0
Python1_CS#_3V3
Text GLabel 4050 2400 2    60   Input ~ 0
Python2_CS#_3V3
Text GLabel 4050 2600 2    60   Input ~ 0
Python3_CS#_3V3
Text GLabel 4050 2700 2    60   Input ~ 0
IMU_CS#_3V3
Text GLabel 4050 2900 2    60   Input ~ 0
Python_RST#_3V3
Text GLabel 4050 2800 2    60   Input ~ 0
Python_Trigger_3V3
Text GLabel 4050 2200 2    60   Input ~ 0
SPI_MOSI_3V3
Text GLabel 4050 2300 2    60   Input ~ 0
SPI_SCK_3V3
Text Notes 3250 1350 0    60   ~ 12
Outbound (FPGA-> Sensors)
Wire Wire Line
	2300 1700 3100 1700
Wire Wire Line
	4050 2000 4400 2000
$Comp
L GND #PWR069
U 1 1 572C1D33
P 4400 2000
F 0 "#PWR069" H 4400 1750 50  0001 C CNN
F 1 "GND" V 4405 1872 50  0000 R CNN
F 2 "" H 4400 2000 50  0000 C CNN
F 3 "" H 4400 2000 50  0000 C CNN
	1    4400 2000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3100 2000 2850 2000
Wire Wire Line
	2850 2000 2850 1700
$Comp
L GND #PWR070
U 1 1 572C1D3D
P 2300 2000
F 0 "#PWR070" H 2300 1750 50  0001 C CNN
F 1 "GND" H 2305 1827 50  0000 C CNN
F 2 "" H 2300 2000 50  0000 C CNN
F 3 "" H 2300 2000 50  0000 C CNN
	1    2300 2000
	1    0    0    -1  
$EndComp
$Comp
L C C11
U 1 1 572C1D56
P 2300 1850
F 0 "C11" H 2325 1950 50  0000 L CNN
F 1 "100n" H 2325 1750 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 2338 1700 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 2300 1850 50  0001 C CNN
F 4 "TDK" H 2300 1850 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 2300 1850 50  0001 C CNN "MFP"
F 6 "digikey" H 2300 1850 50  0001 C CNN "D1"
F 7 "mouser" H 2300 1850 50  0001 C CNN "D2"
F 8 "445-1266" H 2300 1850 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 2300 1850 50  0001 C CNN "D1PL"
F 10 "_" H 2300 1850 50  0001 C CNN "D2PN"
F 11 "_" H 2300 1850 50  0001 C CNN "D2PL"
F 12 "0402" H 2300 1850 50  0001 C CNN "Package"
F 13 "_" H 2300 1850 50  0000 C CNN "Description"
F 14 "6.3" H 2300 1850 50  0001 C CNN "Voltage"
F 15 "_" H 2300 1850 50  0001 C CNN "Power"
F 16 "10%" H 2300 1850 50  0001 C CNN "Tolerance"
F 17 "X5R" H 2300 1850 50  0001 C CNN "Temperature"
F 18 "_" H 2300 1850 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 2300 1850 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 2300 1850 50  0001 C CNN "Cont.Current"
F 21 "_" H 2300 1850 50  0001 C CNN "Frequency"
F 22 "_" H 2300 1850 50  0001 C CNN "ResonnanceFreq"
	1    2300 1850
	1    0    0    -1  
$EndComp
Connection ~ 2850 1700
$Comp
L C C24
U 1 1 572C1D71
P 4350 1850
F 0 "C24" H 4375 1950 50  0000 L CNN
F 1 "100n" H 4375 1750 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 4388 1700 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 4350 1850 50  0001 C CNN
F 4 "TDK" H 4350 1850 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 4350 1850 50  0001 C CNN "MFP"
F 6 "digikey" H 4350 1850 50  0001 C CNN "D1"
F 7 "mouser" H 4350 1850 50  0001 C CNN "D2"
F 8 "445-1266" H 4350 1850 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 4350 1850 50  0001 C CNN "D1PL"
F 10 "_" H 4350 1850 50  0001 C CNN "D2PN"
F 11 "_" H 4350 1850 50  0001 C CNN "D2PL"
F 12 "0402" H 4350 1850 50  0001 C CNN "Package"
F 13 "_" H 4350 1850 50  0000 C CNN "Description"
F 14 "6.3" H 4350 1850 50  0001 C CNN "Voltage"
F 15 "_" H 4350 1850 50  0001 C CNN "Power"
F 16 "10%" H 4350 1850 50  0001 C CNN "Tolerance"
F 17 "X5R" H 4350 1850 50  0001 C CNN "Temperature"
F 18 "_" H 4350 1850 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4350 1850 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4350 1850 50  0001 C CNN "Cont.Current"
F 21 "_" H 4350 1850 50  0001 C CNN "Frequency"
F 22 "_" H 4350 1850 50  0001 C CNN "ResonnanceFreq"
	1    4350 1850
	1    0    0    -1  
$EndComp
Connection ~ 4200 1700
Connection ~ 4350 2000
$Comp
L 74AVCH8T245-1EP U4
U 1 1 572C1D8D
P 7050 2500
F 0 "U4" H 6800 3500 60  0000 C CNN
F 1 "74AVCH8T245-1EP" H 7600 1700 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-24-1EP-Pitch0.5-nonSquare" H 7050 2500 60  0001 C CNN
F 3 "http://www.nxp.com/documents/data_sheet/74AVCH8T245.pdf" H 7025 3587 60  0001 C CNN
F 4 "NXP" H 7050 2500 60  0001 C CNN "MFN"
F 5 "74AVCH8T245BQ" H 7050 2500 60  0001 C CNN "MFP"
F 6 "digikey" H 7050 2500 60  0001 C CNN "D1"
F 7 "mouser" H 7050 2500 60  0001 C CNN "D2"
F 8 "568-5418" H 7050 2500 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/74AVCH8T245BQ%2C118/568-5418-1-ND/2530896?WT.z_cid=ref_octopart_dkc_buynow&site=us" H 7050 2500 60  0001 C CNN "D1PL"
F 10 "_" H 7050 2500 60  0001 C CNN "D2PN"
F 11 "_" H 7050 2500 60  0001 C CNN "D2PL"
F 12 "_" H 7050 2500 60  0001 C CNN "Package"
F 13 "_" H 7025 3481 60  0000 C CNN "Description"
F 14 "_" H 7050 2500 60  0001 C CNN "Voltage"
F 15 "_" H 7050 2500 60  0001 C CNN "Power"
F 16 "_" H 7050 2500 60  0001 C CNN "Tolerance"
F 17 "_" H 7050 2500 60  0001 C CNN "Temperature"
F 18 "_" H 7050 2500 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 7050 2500 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 7050 2500 60  0001 C CNN "Cont.Current"
F 21 "_" H 7050 2500 60  0001 C CNN "Frequency"
F 22 "_" H 7050 2500 60  0001 C CNN "ResonnanceFreq"
	1    7050 2500
	1    0    0    -1  
$EndComp
Text Notes 6500 1300 0    60   ~ 12
Inbound (Sensors -> FPGA)
Text GLabel 6550 2500 0    60   Input ~ 0
Python1_Monitor
Text GLabel 6550 2400 0    60   Input ~ 0
Python2_Monitor
Text GLabel 6550 2300 0    60   Input ~ 0
Python3_Monitor
Text GLabel 6550 2600 0    60   Input ~ 0
SPI_MISO
Text GLabel 7500 2500 2    60   Input ~ 0
Python1_Monitor_3V3
Text GLabel 7500 2400 2    60   Input ~ 0
Python2_Monitor_3V3
Text GLabel 7500 2300 2    60   Input ~ 0
Python3_Monitor_3V3
Text GLabel 7500 2600 2    60   Input ~ 0
SPI_MISO_3V3
$Comp
L +3V3 #PWR071
U 1 1 572C1D9D
P 7750 1600
F 0 "#PWR071" H 7750 1450 50  0001 C CNN
F 1 "+3V3" H 7765 1773 50  0000 C CNN
F 2 "" H 7750 1600 50  0000 C CNN
F 3 "" H 7750 1600 50  0000 C CNN
	1    7750 1600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5750 1700 6550 1700
$Comp
L +2V5 #PWR072
U 1 1 572C1DA4
P 6400 1600
F 0 "#PWR072" H 6400 1450 50  0001 C CNN
F 1 "+2V5" H 6415 1773 50  0000 C CNN
F 2 "" H 6400 1600 50  0000 C CNN
F 3 "" H 6400 1600 50  0000 C CNN
	1    6400 1600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7500 1700 7950 1700
$Comp
L GND #PWR073
U 1 1 572C1DAB
P 7050 3500
F 0 "#PWR073" H 7050 3250 50  0001 C CNN
F 1 "GND" H 7055 3327 50  0000 C CNN
F 2 "" H 7050 3500 50  0000 C CNN
F 3 "" H 7050 3500 50  0000 C CNN
	1    7050 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6950 3400 6950 3500
Wire Wire Line
	7050 3500 7050 3400
Wire Wire Line
	7150 3500 7150 3400
Connection ~ 7050 3500
Wire Wire Line
	7500 2000 8200 2000
$Comp
L GND #PWR074
U 1 1 572C1DB7
P 8200 2000
F 0 "#PWR074" H 8200 1750 50  0001 C CNN
F 1 "GND" V 8205 1872 50  0000 R CNN
F 2 "" H 8200 2000 50  0000 C CNN
F 3 "" H 8200 2000 50  0000 C CNN
	1    8200 2000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7750 1800 7500 1800
Wire Wire Line
	7750 1600 7750 1800
Connection ~ 6400 1700
Wire Wire Line
	6400 2000 6550 2000
Connection ~ 7750 1700
Connection ~ 7950 2000
$Comp
L GND #PWR075
U 1 1 572C1DC5
P 5750 2000
F 0 "#PWR075" H 5750 1750 50  0001 C CNN
F 1 "GND" H 5755 1827 50  0000 C CNN
F 2 "" H 5750 2000 50  0000 C CNN
F 3 "" H 5750 2000 50  0000 C CNN
	1    5750 2000
	1    0    0    -1  
$EndComp
$Comp
L C C42
U 1 1 572C1DDE
P 5750 1850
F 0 "C42" H 5775 1950 50  0000 L CNN
F 1 "100n" H 5775 1750 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5788 1700 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5750 1850 50  0001 C CNN
F 4 "TDK" H 5750 1850 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 5750 1850 50  0001 C CNN "MFP"
F 6 "digikey" H 5750 1850 50  0001 C CNN "D1"
F 7 "mouser" H 5750 1850 50  0001 C CNN "D2"
F 8 "445-1266" H 5750 1850 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 5750 1850 50  0001 C CNN "D1PL"
F 10 "_" H 5750 1850 50  0001 C CNN "D2PN"
F 11 "_" H 5750 1850 50  0001 C CNN "D2PL"
F 12 "0402" H 5750 1850 50  0001 C CNN "Package"
F 13 "_" H 5750 1850 50  0000 C CNN "Description"
F 14 "6.3" H 5750 1850 50  0001 C CNN "Voltage"
F 15 "_" H 5750 1850 50  0001 C CNN "Power"
F 16 "10%" H 5750 1850 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5750 1850 50  0001 C CNN "Temperature"
F 18 "_" H 5750 1850 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5750 1850 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5750 1850 50  0001 C CNN "Cont.Current"
F 21 "_" H 5750 1850 50  0001 C CNN "Frequency"
F 22 "_" H 5750 1850 50  0001 C CNN "ResonnanceFreq"
	1    5750 1850
	1    0    0    -1  
$EndComp
$Comp
L C C50
U 1 1 572C1DF8
P 7950 1850
F 0 "C50" H 7975 1950 50  0000 L CNN
F 1 "100n" H 7975 1750 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 7988 1700 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 7950 1850 50  0001 C CNN
F 4 "TDK" H 7950 1850 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 7950 1850 50  0001 C CNN "MFP"
F 6 "digikey" H 7950 1850 50  0001 C CNN "D1"
F 7 "mouser" H 7950 1850 50  0001 C CNN "D2"
F 8 "445-1266" H 7950 1850 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 7950 1850 50  0001 C CNN "D1PL"
F 10 "_" H 7950 1850 50  0001 C CNN "D2PN"
F 11 "_" H 7950 1850 50  0001 C CNN "D2PL"
F 12 "0402" H 7950 1850 50  0001 C CNN "Package"
F 13 "_" H 7950 1850 50  0000 C CNN "Description"
F 14 "6.3" H 7950 1850 50  0001 C CNN "Voltage"
F 15 "_" H 7950 1850 50  0001 C CNN "Power"
F 16 "10%" H 7950 1850 50  0001 C CNN "Tolerance"
F 17 "X5R" H 7950 1850 50  0001 C CNN "Temperature"
F 18 "_" H 7950 1850 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 7950 1850 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 7950 1850 50  0001 C CNN "Cont.Current"
F 21 "_" H 7950 1850 50  0001 C CNN "Frequency"
F 22 "_" H 7950 1850 50  0001 C CNN "ResonnanceFreq"
	1    7950 1850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR076
U 1 1 572C1DFF
P 6400 2000
F 0 "#PWR076" H 6400 1750 50  0001 C CNN
F 1 "GND" H 6405 1827 50  0000 C CNN
F 2 "" H 6400 2000 50  0000 C CNN
F 3 "" H 6400 2000 50  0000 C CNN
	1    6400 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 1600 6400 1700
NoConn ~ 6550 2700
NoConn ~ 6550 2800
NoConn ~ 6550 2900
Wire Wire Line
	7500 2700 7750 2700
Wire Wire Line
	7750 2200 7750 2950
Wire Wire Line
	7750 2800 7500 2800
Wire Wire Line
	7750 2900 7500 2900
Connection ~ 7750 2800
$Comp
L GND #PWR077
U 1 1 572C1E0E
P 7750 2950
F 0 "#PWR077" H 7750 2700 50  0001 C CNN
F 1 "GND" H 7755 2777 50  0000 C CNN
F 2 "" H 7750 2950 50  0000 C CNN
F 3 "" H 7750 2950 50  0000 C CNN
	1    7750 2950
	1    0    0    -1  
$EndComp
Connection ~ 7750 2900
NoConn ~ 6550 2200
Wire Wire Line
	3400 3500 3700 3500
Wire Wire Line
	6850 3500 7150 3500
Wire Wire Line
	7500 2200 7750 2200
Connection ~ 7750 2700
Wire Wire Line
	6850 3400 6850 3500
Connection ~ 6950 3500
Wire Wire Line
	3400 3400 3400 3500
Connection ~ 3500 3500
$EndSCHEMATC
