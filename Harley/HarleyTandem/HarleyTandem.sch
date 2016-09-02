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
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 5
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 700  3000 500  150 
U 571FB1F6
F0 "Sheet571FB1F5" 60
F1 "IMU.sch" 60
$EndSheet
Text Notes 750  2250 0    60   ~ 12
Imagers
Text Notes 750  2850 0    60   ~ 12
IMU
Text Notes 8300 700  0    60   ~ 12
Connector
$Comp
L CONN_02X50 P2
U 1 1 571FBEAC
P 8500 3550
F 0 "P2" H 8500 6427 50  0000 C CNN
F 1 "CONN_02X50" H 8500 6336 50  0000 C CNN
F 2 "Hirose:DF40C_100DS_0-4V" H 8500 6237 60  0001 C CNN
F 3 "" H 8500 4050 60  0000 C CNN
F 4 "Hirose" H 8500 3550 60  0001 C CNN "MFN"
F 5 "DF40HC(3.0)-100DS-0.4V(58)" H 8500 3550 60  0001 C CNN "MFP"
F 6 "digikey" H 8500 3550 60  0001 C CNN "D1"
F 7 "mouser" H 8500 3550 60  0001 C CNN "D2"
F 8 "H124602" H 8500 3550 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/hirose-electric-co-ltd/DF40HC%283.0%29-100DS-0.4V%2858%29/H124602CT-ND/5155905" H 8500 3550 60  0001 C CNN "D1PL"
F 10 "_" H 8500 3550 60  0001 C CNN "D2PN"
F 11 "_" H 8500 3550 60  0001 C CNN "D2PL"
F 12 "_" H 8500 3550 60  0001 C CNN "Package"
F 13 "_" H 8500 6131 60  0000 C CNN "Description"
F 14 "_" H 8500 3550 60  0001 C CNN "Voltage"
F 15 "_" H 8500 3550 60  0001 C CNN "Power"
F 16 "_" H 8500 3550 60  0001 C CNN "Tolerance"
F 17 "_" H 8500 3550 60  0001 C CNN "Temperature"
F 18 "_" H 8500 3550 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 8500 3550 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 8500 3550 60  0001 C CNN "Cont.Current"
F 21 "_" H 8500 3550 60  0001 C CNN "Frequency"
F 22 "_" H 8500 3550 60  0001 C CNN "ResonnanceFreq"
	1    8500 3550
	1    0    0    -1  
$EndComp
Text GLabel 8750 5600 2    60   Input ~ 0
SPI_MOSI
Text GLabel 8750 6000 2    60   Input ~ 0
SPI_MISO
Text GLabel 8750 5400 2    60   Input ~ 0
SPI_SCK
Text GLabel 8750 5000 2    60   Input ~ 0
Python1_CS#
Text GLabel 8750 5200 2    60   Input ~ 0
Python2_CS#
Text GLabel 8750 5100 2    60   Input ~ 0
Python3_CS#
Text GLabel 8750 4900 2    60   Input ~ 0
IMU_CS#
Text GLabel 8750 5700 2    60   Input ~ 0
Python1_Monitor
Text GLabel 8750 5800 2    60   Input ~ 0
Python2_Monitor
Text GLabel 8750 5900 2    60   Input ~ 0
Python3_Monitor
$Sheet
S 700  2400 500  150 
U 571FBD4F
F0 "Sheet571FBD4E" 60
F1 "Imagers.sch" 60
$EndSheet
Text GLabel 8750 4800 2    60   Input ~ 0
Python_Trigger
Text GLabel 8750 3300 2    60   Input ~ 0
Python1_DOUT0-
Text GLabel 8750 3200 2    60   Input ~ 0
Python1_DOUT0+
Text GLabel 8750 4500 2    60   Input ~ 0
Python1_SYNC-
Text GLabel 8750 4400 2    60   Input ~ 0
Python1_SYNC+
Text GLabel 8750 3600 2    60   Input ~ 0
Python1_DOUT1-
Text GLabel 8750 3500 2    60   Input ~ 0
Python1_DOUT1+
Text GLabel 8750 3900 2    60   Input ~ 0
Python1_DOUT2-
Text GLabel 8750 3800 2    60   Input ~ 0
Python1_DOUT2+
Text GLabel 8750 4200 2    60   Input ~ 0
Python1_DOUT3-
Text GLabel 8750 4100 2    60   Input ~ 0
Python1_DOUT3+
Text GLabel 8750 2900 2    60   Input ~ 0
Python1_clk_return+
Text GLabel 8750 3000 2    60   Input ~ 0
Python1_clk_return-
Text GLabel 8750 1500 2    60   Input ~ 0
Python3_DOUT0-
Text GLabel 8750 1400 2    60   Input ~ 0
Python3_DOUT0+
Text GLabel 8750 2000 2    60   Input ~ 0
Python3_SYNC-
Text GLabel 8750 2100 2    60   Input ~ 0
Python3_SYNC+
Text GLabel 8750 1800 2    60   Input ~ 0
Python3_DOUT1-
Text GLabel 8750 1700 2    60   Input ~ 0
Python3_DOUT1+
Text GLabel 8750 2600 2    60   Input ~ 0
Python3_DOUT2-
Text GLabel 8750 2700 2    60   Input ~ 0
Python3_DOUT2+
Text GLabel 8750 2300 2    60   Input ~ 0
Python3_DOUT3-
Text GLabel 8750 2400 2    60   Input ~ 0
Python3_DOUT3+
Text GLabel 8750 1200 2    60   Input ~ 0
Python3_clk_return+
Text GLabel 8750 1100 2    60   Input ~ 0
Python3_clk_return-
Text GLabel 8250 1800 0    60   Input ~ 0
Python2_DOUT0-
Text GLabel 8250 1900 0    60   Input ~ 0
Python2_DOUT0+
Text GLabel 8250 2700 0    60   Input ~ 0
Python2_SYNC-
Text GLabel 8250 2800 0    60   Input ~ 0
Python2_SYNC+
Text GLabel 8250 1500 0    60   Input ~ 0
Python2_DOUT1-
Text GLabel 8250 1600 0    60   Input ~ 0
Python2_DOUT1+
Text GLabel 8250 2200 0    60   Input ~ 0
Python2_DOUT2-
Text GLabel 8250 2100 0    60   Input ~ 0
Python2_DOUT2+
Text GLabel 8250 2500 0    60   Input ~ 0
Python2_DOUT3-
Text GLabel 8250 2400 0    60   Input ~ 0
Python2_DOUT3+
Text GLabel 8250 3000 0    60   Input ~ 0
Python2_clk_return+
Text GLabel 8250 3100 0    60   Input ~ 0
Python2_clk_return-
Text GLabel 8250 3700 0    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 8250 3900 0    60   Input ~ 0
FPGA_JTAG_TDO
Text GLabel 8250 4000 0    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 8250 3600 0    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 8250 4300 0    60   Input ~ 0
FPGA_Signal2
Text GLabel 8250 4600 0    60   Input ~ 0
FPGA_Signal4
Text GLabel 8250 4700 0    60   Input ~ 0
FPGA_Signal5
Text GLabel 8250 4800 0    60   Input ~ 0
FPGA_Signal6
Text GLabel 8250 4900 0    60   Input ~ 0
FPGA_Signal7
Text GLabel 8250 3300 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 8250 3400 0    60   Input ~ 0
Python_lvds_clk-
Wire Wire Line
	8100 6000 8250 6000
Wire Wire Line
	8100 5400 8100 6000
Wire Wire Line
	8100 5400 8250 5400
Wire Wire Line
	8250 5500 8100 5500
Connection ~ 8100 5500
Wire Wire Line
	8250 5600 8100 5600
Connection ~ 8100 5600
Wire Wire Line
	8100 5700 8250 5700
Connection ~ 8100 5700
Wire Wire Line
	8250 5800 8100 5800
Connection ~ 8100 5800
Wire Wire Line
	8100 5900 8250 5900
Connection ~ 8100 5900
$Comp
L +5V #PWR01
U 1 1 571FF1AE
P 8100 6000
F 0 "#PWR01" H 8100 5850 50  0001 C CNN
F 1 "+5V" H 8115 6173 50  0000 C CNN
F 2 "" H 8100 6000 50  0000 C CNN
F 3 "" H 8100 6000 50  0000 C CNN
	1    8100 6000
	1    0    0    1   
$EndComp
Wire Wire Line
	8100 5100 8250 5100
Wire Wire Line
	8100 5100 8100 5300
Wire Wire Line
	8100 5300 8250 5300
Wire Wire Line
	7900 5200 8250 5200
Connection ~ 8100 5200
Wire Wire Line
	7900 5200 7900 5300
$Comp
L +2V5 #PWR02
U 1 1 571FF205
P 7900 5300
F 0 "#PWR02" H 7900 5150 50  0001 C CNN
F 1 "+2V5" H 7915 5473 50  0000 C CNN
F 2 "" H 7900 5300 50  0000 C CNN
F 3 "" H 7900 5300 50  0000 C CNN
	1    7900 5300
	1    0    0    1   
$EndComp
Wire Wire Line
	10100 5500 8750 5500
Wire Wire Line
	10100 1000 10100 5500
Wire Wire Line
	8750 5300 10100 5300
Wire Wire Line
	8750 4600 10100 4600
Connection ~ 10100 4600
Wire Wire Line
	8750 4300 10100 4300
Connection ~ 10100 4300
Wire Wire Line
	8750 4000 10100 4000
Connection ~ 10100 4000
Wire Wire Line
	8750 3700 10100 3700
Connection ~ 10100 3700
Wire Wire Line
	8750 3400 10100 3400
Connection ~ 10100 3400
Wire Wire Line
	8750 3100 10100 3100
Connection ~ 10100 3100
Wire Wire Line
	8750 2800 10100 2800
Connection ~ 10100 2800
Wire Wire Line
	8750 2500 10100 2500
Connection ~ 10100 2500
Wire Wire Line
	10100 2200 8750 2200
Connection ~ 10100 2200
Wire Wire Line
	8750 1900 10100 1900
Connection ~ 10100 1900
Wire Wire Line
	8750 1600 10100 1600
Connection ~ 10100 1600
Wire Wire Line
	8750 1300 10100 1300
Connection ~ 10100 1300
$Comp
L GND #PWR03
U 1 1 571FF743
P 10100 1000
F 0 "#PWR03" H 10100 750 50  0001 C CNN
F 1 "GND" H 10105 827 50  0000 C CNN
F 2 "" H 10100 1000 50  0000 C CNN
F 3 "" H 10100 1000 50  0000 C CNN
	1    10100 1000
	1    0    0    1   
$EndComp
$Comp
L GND #PWR04
U 1 1 571FF765
P 7250 1100
F 0 "#PWR04" H 7250 850 50  0001 C CNN
F 1 "GND" H 7255 927 50  0000 C CNN
F 2 "" H 7250 1100 50  0000 C CNN
F 3 "" H 7250 1100 50  0000 C CNN
	1    7250 1100
	1    0    0    1   
$EndComp
Wire Wire Line
	7250 1100 8250 1100
Wire Wire Line
	7250 1200 8250 1200
Wire Wire Line
	7250 1100 7250 5000
Wire Wire Line
	7250 1300 8250 1300
Connection ~ 7250 1200
Wire Wire Line
	8250 1400 7250 1400
Connection ~ 7250 1300
Wire Wire Line
	7250 1700 8250 1700
Connection ~ 7250 1400
Wire Wire Line
	8250 2000 7250 2000
Connection ~ 7250 1700
Wire Wire Line
	7250 2300 8250 2300
Connection ~ 7250 2000
Wire Wire Line
	8250 2600 7250 2600
Connection ~ 7250 2300
Wire Wire Line
	7250 2900 8250 2900
Connection ~ 7250 2600
Wire Wire Line
	8250 3200 7250 3200
Connection ~ 7250 2900
Connection ~ 7250 3200
Connection ~ 7250 3500
Wire Wire Line
	7250 5000 8250 5000
Text GLabel 8750 4700 2    60   Input ~ 0
Python_RST#
Wire Notes Line
	6650 6500 6650 500 
$Sheet
S 700  900  500  150 
U 5720222A
F0 "Sheet57202229" 60
F1 "PowerSupplies.sch" 60
$EndSheet
Text Notes 750  700  0    60   ~ 12
Power Supplies
Text Notes 650  1500 0    60   ~ 12
Level Shifters
Text GLabel 8250 4500 0    60   Input ~ 0
FPGA_Signal3
Text GLabel 8250 4200 0    60   Input ~ 0
FPGA_Signal1
Wire Wire Line
	7250 3500 8250 3500
Connection ~ 10100 5300
Text Notes 4050 900  0    60   ~ 12
Clock Distribution
$Comp
L SI53306 U2
U 1 1 572BEE76
P 4500 2000
F 0 "U2" H 4500 3053 60  0000 C CNN
F 1 "SI53306" H 4500 2947 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-16-1EP_3x3mm_Pitch0.5mm" H 4500 2947 60  0001 C CNN
F 3 "http://www.silabs.com/Support%20Documents/TechnicalDocs/Si53306.pdf" H 4500 2947 60  0001 C CNN
F 4 "Silicon Labs" H 4500 2000 60  0001 C CNN "MFN"
F 5 "SI53306" H 4500 2000 60  0001 C CNN "MFP"
F 6 "digikey" H 4500 2000 60  0001 C CNN "D1"
F 7 "mouser" H 4500 2000 60  0001 C CNN "D2"
F 8 "336-2497" H 4500 2000 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/silicon-labs/SI53306-B-GM/336-2497-5-ND/4158074" H 4500 2000 60  0001 C CNN "D1PL"
F 10 "_" H 4500 2000 60  0001 C CNN "D2PN"
F 11 "_" H 4500 2000 60  0001 C CNN "D2PL"
F 12 "_" H 4500 2000 60  0001 C CNN "Package"
F 13 "_" H 4500 2841 60  0000 C CNN "Description"
F 14 "_" H 4500 2000 60  0001 C CNN "Voltage"
F 15 "_" H 4500 2000 60  0001 C CNN "Power"
F 16 "_" H 4500 2000 60  0001 C CNN "Tolerance"
F 17 "_" H 4500 2000 60  0001 C CNN "Temperature"
F 18 "_" H 4500 2000 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 4500 2000 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 4500 2000 60  0001 C CNN "Cont.Current"
F 21 "_" H 4500 2000 60  0001 C CNN "Frequency"
F 22 "_" H 4500 2000 60  0001 C CNN "ResonnanceFreq"
	1    4500 2000
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR05
U 1 1 572BEE7D
P 3800 1100
F 0 "#PWR05" H 3800 950 50  0001 C CNN
F 1 "+2V5" H 3815 1273 50  0000 C CNN
F 2 "" H 3800 1100 50  0000 C CNN
F 3 "" H 3800 1100 50  0000 C CNN
	1    3800 1100
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR06
U 1 1 572BEE83
P 5150 1100
F 0 "#PWR06" H 5150 950 50  0001 C CNN
F 1 "+2V5" H 5165 1273 50  0000 C CNN
F 2 "" H 5150 1100 50  0000 C CNN
F 3 "" H 5150 1100 50  0000 C CNN
	1    5150 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 1300 5300 1300
Wire Wire Line
	4000 1300 3800 1300
Text GLabel 3250 1750 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 3250 1450 0    60   Input ~ 0
Python_lvds_clk-
Text GLabel 5000 1500 2    60   Input ~ 0
Python1_lvds_clk-
Text GLabel 5000 1600 2    60   Input ~ 0
Python1_lvds_clk+
Text GLabel 5000 2500 2    60   Input ~ 0
Python2_lvds_clk-
Text GLabel 5000 2400 2    60   Input ~ 0
Python2_lvds_clk+
Text GLabel 5000 1800 2    60   Input ~ 0
Python3_lvds_clk-
Text GLabel 5000 1900 2    60   Input ~ 0
Python3_lvds_clk+
$Comp
L GND #PWR07
U 1 1 572BEE99
P 4300 2900
F 0 "#PWR07" H 4300 2650 50  0001 C CNN
F 1 "GND" H 4305 2727 50  0000 C CNN
F 2 "" H 4300 2900 50  0000 C CNN
F 3 "" H 4300 2900 50  0000 C CNN
	1    4300 2900
	1    0    0    -1  
$EndComp
Text Notes 2500 2000 0    60   ~ 0
SFOUT = 00 for LVDS mode
$Comp
L GND #PWR08
U 1 1 572BEEA3
P 3500 1300
F 0 "#PWR08" H 3500 1050 50  0001 C CNN
F 1 "GND" V 3505 1172 50  0000 R CNN
F 2 "" H 3500 1300 50  0000 C CNN
F 3 "" H 3500 1300 50  0000 C CNN
	1    3500 1300
	0    1    1    0   
$EndComp
$Comp
L GND #PWR09
U 1 1 572BEEA9
P 5600 1300
F 0 "#PWR09" H 5600 1050 50  0001 C CNN
F 1 "GND" V 5605 1172 50  0000 R CNN
F 2 "" H 5600 1300 50  0000 C CNN
F 3 "" H 5600 1300 50  0000 C CNN
	1    5600 1300
	0    -1   1    0   
$EndComp
Connection ~ 5150 1300
Connection ~ 3800 1300
Wire Wire Line
	5150 1300 5150 1100
$Comp
L C C96
U 1 1 572BEEC5
P 5450 1300
F 0 "C96" H 5475 1400 50  0000 L CNN
F 1 "1u" H 5475 1200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5488 1150 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5450 1300 50  0001 C CNN
F 4 "TDK" H 5450 1300 50  0001 C CNN "MFN"
F 5 "C1005X5R0J105K050BB" H 5450 1300 50  0001 C CNN "MFP"
F 6 "digikey" H 5450 1300 50  0001 C CNN "D1"
F 7 "mouser" H 5450 1300 50  0001 C CNN "D2"
F 8 "445-4998" H 5450 1300 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J105K050BB/445-4998-1-ND/2093613" H 5450 1300 50  0001 C CNN "D1PL"
F 10 "_" H 5450 1300 50  0001 C CNN "D2PN"
F 11 "_" H 5450 1300 50  0001 C CNN "D2PL"
F 12 "0402" H 5450 1300 50  0001 C CNN "Package"
F 13 "_" H 5450 1300 50  0000 C CNN "Description"
F 14 "16" H 5450 1300 50  0001 C CNN "Voltage"
F 15 "_" H 5450 1300 50  0001 C CNN "Power"
F 16 "10%" H 5450 1300 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5450 1300 50  0001 C CNN "Temperature"
F 18 "_" H 5450 1300 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5450 1300 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5450 1300 50  0001 C CNN "Cont.Current"
F 21 "_" H 5450 1300 50  0001 C CNN "Frequency"
F 22 "_" H 5450 1300 50  0001 C CNN "ResonnanceFreq"
	1    5450 1300
	0    -1   -1   0   
$EndComp
$Comp
L C C95
U 1 1 572BEEDF
P 3650 1300
F 0 "C95" H 3675 1400 50  0000 L CNN
F 1 "1u" H 3675 1200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 3688 1150 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 3650 1300 50  0001 C CNN
F 4 "TDK" H 3650 1300 50  0001 C CNN "MFN"
F 5 "C1005X5R0J105K050BB" H 3650 1300 50  0001 C CNN "MFP"
F 6 "digikey" H 3650 1300 50  0001 C CNN "D1"
F 7 "mouser" H 3650 1300 50  0001 C CNN "D2"
F 8 "445-4998" H 3650 1300 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J105K050BB/445-4998-1-ND/2093613" H 3650 1300 50  0001 C CNN "D1PL"
F 10 "_" H 3650 1300 50  0001 C CNN "D2PN"
F 11 "_" H 3650 1300 50  0001 C CNN "D2PL"
F 12 "0402" H 3650 1300 50  0001 C CNN "Package"
F 13 "_" H 3650 1300 50  0000 C CNN "Description"
F 14 "16" H 3650 1300 50  0001 C CNN "Voltage"
F 15 "_" H 3650 1300 50  0001 C CNN "Power"
F 16 "10%" H 3650 1300 50  0001 C CNN "Tolerance"
F 17 "X5R" H 3650 1300 50  0001 C CNN "Temperature"
F 18 "_" H 3650 1300 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3650 1300 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3650 1300 50  0001 C CNN "Cont.Current"
F 21 "_" H 3650 1300 50  0001 C CNN "Frequency"
F 22 "_" H 3650 1300 50  0001 C CNN "ResonnanceFreq"
	1    3650 1300
	0    -1   -1   0   
$EndComp
NoConn ~ 5000 2100
NoConn ~ 5000 2200
$Comp
L R R11
U 1 1 572BEEFB
P 3500 1600
F 0 "R11" V 3580 1600 50  0000 C CNN
F 1 "100" V 3500 1600 50  0000 C CNN
F 2 "Dipoles_SMD:R_0402" V 3430 1600 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 3500 1600 30  0001 C CNN
F 4 "Vishay" H 3500 1600 50  0001 C CNN "MFN"
F 5 "CRCW0402100RFKED" H 3500 1600 50  0001 C CNN "MFP"
F 6 "digikey" H 3500 1600 50  0001 C CNN "D1"
F 7 "mouser" H 3500 1600 50  0001 C CNN "D2"
F 8 "541-100L" H 3500 1600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW0402100RFKED/541-100LCT-ND/1183009" H 3500 1600 50  0001 C CNN "D1PL"
F 10 "_" H 3500 1600 50  0001 C CNN "D2PN"
F 11 "_" H 3500 1600 50  0001 C CNN "D2PL"
F 12 "0402" H 3500 1600 50  0001 C CNN "Package"
F 13 "_" H 3500 1600 50  0000 C CNN "Description"
F 14 "_" H 3500 1600 50  0001 C CNN "Voltage"
F 15 "1/16" H 3500 1600 50  0001 C CNN "Power"
F 16 "1%" H 3500 1600 50  0001 C CNN "Tolerance"
F 17 "_" H 3500 1600 50  0001 C CNN "Temperature"
F 18 "_" H 3500 1600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3500 1600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3500 1600 50  0001 C CNN "Cont.Current"
F 21 "_" H 3500 1600 50  0001 C CNN "Frequency"
F 22 "_" H 3500 1600 50  0001 C CNN "ResonnanceFreq"
	1    3500 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 1450 3700 1450
Wire Wire Line
	3250 1750 3700 1750
Wire Wire Line
	3700 1750 3700 1600
Wire Wire Line
	3700 1600 4000 1600
Connection ~ 3500 1750
Wire Wire Line
	4000 1500 3700 1500
Wire Wire Line
	3700 1500 3700 1450
Connection ~ 3500 1450
$Sheet
S 700  1700 500  150 
U 572C1BAD
F0 "Sheet572C1BAC" 60
F1 "LevelShifters.sch" 60
$EndSheet
Wire Wire Line
	4300 2900 4300 2800
Wire Wire Line
	4400 2900 4400 2800
Wire Wire Line
	3900 2900 4400 2900
Connection ~ 4300 2900
Wire Wire Line
	3800 1100 3800 2200
Wire Wire Line
	3800 2200 4000 2200
Wire Wire Line
	4000 2000 3900 2000
Wire Wire Line
	3900 1900 3900 2900
Wire Wire Line
	4000 1900 3900 1900
Connection ~ 3900 2000
Wire Notes Line
	2050 3350 2050 500 
Wire Notes Line
	500  3350 6650 3350
$Comp
L CONN_01X11 P7
U 1 1 57CC5496
P 2000 4200
F 0 "P7" H 2078 4339 50  0000 L CNN
F 1 "CONN_01X11" H 2078 4248 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x11_Pitch2.00mm" H 2078 4157 50  0000 L CNN
F 3 "" H 2000 4200 50  0000 C CNN
F 4 "_" H 2000 4200 60  0001 C CNN "MFN"
F 5 "_" H 2000 4200 60  0001 C CNN "MFP"
F 6 "digikey" H 2000 4200 60  0001 C CNN "D1"
F 7 "mouser" H 2000 4200 60  0001 C CNN "D2"
F 8 "_" H 2000 4200 60  0001 C CNN "D1PN"
F 9 "_" H 2000 4200 60  0001 C CNN "D1PL"
F 10 "_" H 2000 4200 60  0001 C CNN "D2PN"
F 11 "_" H 2000 4200 60  0001 C CNN "D2PL"
F 12 "_" H 2000 4200 60  0001 C CNN "Package"
F 13 "_" H 2078 4058 60  0000 L CNN "Description"
F 14 "_" H 2000 4200 60  0001 C CNN "Voltage"
F 15 "_" H 2000 4200 60  0001 C CNN "Power"
F 16 "_" H 2000 4200 60  0001 C CNN "Tolerance"
F 17 "_" H 2000 4200 60  0001 C CNN "Temperature"
F 18 "_" H 2000 4200 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2000 4200 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2000 4200 60  0001 C CNN "Cont.Current"
F 21 "_" H 2000 4200 60  0001 C CNN "Frequency"
F 22 "_" H 2000 4200 60  0001 C CNN "ResonnanceFreq"
	1    2000 4200
	1    0    0    -1  
$EndComp
Text Notes 1900 3550 0    60   ~ 12
Debug
Text GLabel 1800 3800 0    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 1800 3900 0    60   Input ~ 0
FPGA_JTAG_TDO
Text GLabel 1800 4000 0    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 1800 3700 0    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 1800 4200 0    60   Input ~ 0
FPGA_Signal2
Text GLabel 1800 4400 0    60   Input ~ 0
FPGA_Signal4
Text GLabel 1800 4500 0    60   Input ~ 0
FPGA_Signal5
Text GLabel 1800 4600 0    60   Input ~ 0
FPGA_Signal6
Text GLabel 1800 4700 0    60   Input ~ 0
FPGA_Signal7
Text GLabel 1800 4300 0    60   Input ~ 0
FPGA_Signal3
Text GLabel 1800 4100 0    60   Input ~ 0
FPGA_Signal1
$EndSCHEMATC
