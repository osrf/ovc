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
S 650  4350 500  150 
U 571FB1F6
F0 "Sheet571FB1F5" 60
F1 "IMU.sch" 60
$EndSheet
Text Notes 700  3600 0    60   ~ 12
Imagers
Text Notes 700  4200 0    60   ~ 12
IMU
Text Notes 9100 700  0    60   ~ 12
Connector
Text Notes 700  4850 0    60   ~ 12
Xilinx JTAG
$Comp
L CONN_02X07 P1
U 1 1 571FBCAF
P 950 5450
F 0 "P1" H 950 5965 50  0000 C CNN
F 1 "CONN_02X07" H 950 5874 50  0000 C CNN
F 2 "Connectors:CustomJTAG" H 950 4250 50  0001 C CNN
F 3 "DNP" H 950 4250 50  0001 C CNN
F 4 "DNP" H 950 5450 60  0001 C CNN "MFN"
F 5 "DNP" H 950 5450 60  0001 C CNN "MFP"
F 6 "digikey" H 950 5450 60  0001 C CNN "D1"
F 7 "mouser" H 950 5450 60  0001 C CNN "D2"
F 8 "DNP" H 950 5450 60  0001 C CNN "D1PN"
F 9 "DNP" H 950 5450 60  0001 C CNN "D1PL"
F 10 "_" H 950 5450 60  0001 C CNN "D2PN"
F 11 "_" H 950 5450 60  0001 C CNN "D2PL"
F 12 "_" H 950 5450 60  0001 C CNN "Package"
F 13 "_" H 950 5450 60  0000 C CNN "Description"
F 14 "_" H 950 5450 60  0001 C CNN "Voltage"
F 15 "_" H 950 5450 60  0001 C CNN "Power"
F 16 "_" H 950 5450 60  0001 C CNN "Tolerance"
F 17 "_" H 950 5450 60  0001 C CNN "Temperature"
F 18 "_" H 950 5450 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 950 5450 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 950 5450 60  0001 C CNN "Cont.Current"
F 21 "_" H 950 5450 60  0001 C CNN "Frequency"
F 22 "_" H 950 5450 60  0001 C CNN "ResonnanceFreq"
	1    950  5450
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X50 P2
U 1 1 571FBEAC
P 9300 3550
F 0 "P2" H 9300 6427 50  0000 C CNN
F 1 "CONN_02X50" H 9300 6336 50  0000 C CNN
F 2 "Hirose:DF40C_100DS_0-4V" H 9300 6237 60  0001 C CNN
F 3 "" H 9300 4050 60  0000 C CNN
F 4 "Hirose" H 9300 3550 60  0001 C CNN "MFN"
F 5 "DF40HC(3.0)-100DS-0.4V(58)" H 9300 3550 60  0001 C CNN "MFP"
F 6 "digikey" H 9300 3550 60  0001 C CNN "D1"
F 7 "mouser" H 9300 3550 60  0001 C CNN "D2"
F 8 "H124602" H 9300 3550 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/hirose-electric-co-ltd/DF40HC%283.0%29-100DS-0.4V%2858%29/H124602CT-ND/5155905" H 9300 3550 60  0001 C CNN "D1PL"
F 10 "_" H 9300 3550 60  0001 C CNN "D2PN"
F 11 "_" H 9300 3550 60  0001 C CNN "D2PL"
F 12 "_" H 9300 3550 60  0001 C CNN "Package"
F 13 "_" H 9300 6131 60  0000 C CNN "Description"
F 14 "_" H 9300 3550 60  0001 C CNN "Voltage"
F 15 "_" H 9300 3550 60  0001 C CNN "Power"
F 16 "_" H 9300 3550 60  0001 C CNN "Tolerance"
F 17 "_" H 9300 3550 60  0001 C CNN "Temperature"
F 18 "_" H 9300 3550 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9300 3550 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9300 3550 60  0001 C CNN "Cont.Current"
F 21 "_" H 9300 3550 60  0001 C CNN "Frequency"
F 22 "_" H 9300 3550 60  0001 C CNN "ResonnanceFreq"
	1    9300 3550
	1    0    0    -1  
$EndComp
Text GLabel 9550 5600 2    60   Input ~ 0
SPI_MOSI
Text GLabel 9550 5700 2    60   Input ~ 0
SPI_MISO
Text GLabel 9550 5400 2    60   Input ~ 0
SPI_SCK
Text GLabel 9550 5100 2    60   Input ~ 0
Python1_CS#
Text GLabel 9550 5200 2    60   Input ~ 0
Python2_CS#
Text GLabel 9550 5000 2    60   Input ~ 0
Python3_CS#
Text GLabel 9550 4900 2    60   Input ~ 0
IMU_CS#
Text GLabel 9550 5800 2    60   Input ~ 0
Python1_Monitor
Text GLabel 9550 5900 2    60   Input ~ 0
Python2_Monitor
Text GLabel 9550 6000 2    60   Input ~ 0
Python3_Monitor
$Sheet
S 650  3750 500  150 
U 571FBD4F
F0 "Sheet571FBD4E" 60
F1 "Imagers.sch" 60
$EndSheet
Text GLabel 9550 4800 2    60   Input ~ 0
Python_Trigger
Text GLabel 9550 3300 2    60   Input ~ 0
Python1_DOUT0-
Text GLabel 9550 3200 2    60   Input ~ 0
Python1_DOUT0+
Text GLabel 9550 4500 2    60   Input ~ 0
Python1_SYNC-
Text GLabel 9550 4400 2    60   Input ~ 0
Python1_SYNC+
Text GLabel 9550 3600 2    60   Input ~ 0
Python1_DOUT1-
Text GLabel 9550 3500 2    60   Input ~ 0
Python1_DOUT1+
Text GLabel 9550 3900 2    60   Input ~ 0
Python1_DOUT2-
Text GLabel 9550 3800 2    60   Input ~ 0
Python1_DOUT2+
Text GLabel 9550 4200 2    60   Input ~ 0
Python1_DOUT3-
Text GLabel 9550 4100 2    60   Input ~ 0
Python1_DOUT3+
Text GLabel 9550 2900 2    60   Input ~ 0
Python1_clk_return+
Text GLabel 9550 3000 2    60   Input ~ 0
Python1_clk_return-
Text GLabel 9550 1500 2    60   Input ~ 0
Python3_DOUT0-
Text GLabel 9550 1400 2    60   Input ~ 0
Python3_DOUT0+
Text GLabel 9550 2000 2    60   Input ~ 0
Python3_SYNC-
Text GLabel 9550 2100 2    60   Input ~ 0
Python3_SYNC+
Text GLabel 9550 1800 2    60   Input ~ 0
Python3_DOUT1-
Text GLabel 9550 1700 2    60   Input ~ 0
Python3_DOUT1+
Text GLabel 9550 2600 2    60   Input ~ 0
Python3_DOUT2-
Text GLabel 9550 2700 2    60   Input ~ 0
Python3_DOUT2+
Text GLabel 9550 2300 2    60   Input ~ 0
Python3_DOUT3-
Text GLabel 9550 2400 2    60   Input ~ 0
Python3_DOUT3+
Text GLabel 9550 1200 2    60   Input ~ 0
Python3_clk_return+
Text GLabel 9550 1100 2    60   Input ~ 0
Python3_clk_return-
Text GLabel 9050 1800 0    60   Input ~ 0
Python2_DOUT0-
Text GLabel 9050 1900 0    60   Input ~ 0
Python2_DOUT0+
Text GLabel 9050 2800 0    60   Input ~ 0
Python2_SYNC-
Text GLabel 9050 2700 0    60   Input ~ 0
Python2_SYNC+
Text GLabel 9050 1500 0    60   Input ~ 0
Python2_DOUT1-
Text GLabel 9050 1600 0    60   Input ~ 0
Python2_DOUT1+
Text GLabel 9050 2200 0    60   Input ~ 0
Python2_DOUT2-
Text GLabel 9050 2100 0    60   Input ~ 0
Python2_DOUT2+
Text GLabel 9050 2500 0    60   Input ~ 0
Python2_DOUT3-
Text GLabel 9050 2400 0    60   Input ~ 0
Python2_DOUT3+
Text GLabel 9050 3000 0    60   Input ~ 0
Python2_clk_return+
Text GLabel 9050 3100 0    60   Input ~ 0
Python2_clk_return-
Text GLabel 9050 3700 0    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 9050 3900 0    60   Input ~ 0
FPGA_JTAG_TDO
Text GLabel 9050 4000 0    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 9050 3600 0    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 9050 4300 0    60   Input ~ 0
FPGA_Signal2
Text GLabel 9050 4600 0    60   Input ~ 0
FPGA_Signal4
Text GLabel 9050 4700 0    60   Input ~ 0
FPGA_Signal5
Text GLabel 9050 4800 0    60   Input ~ 0
FPGA_Signal6
Text GLabel 9050 4900 0    60   Input ~ 0
FPGA_Signal7
Text GLabel 9050 3300 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 9050 3400 0    60   Input ~ 0
Python_lvds_clk-
Wire Wire Line
	8900 6000 9050 6000
Wire Wire Line
	8900 5400 8900 6000
Wire Wire Line
	8900 5400 9050 5400
Wire Wire Line
	9050 5500 8900 5500
Connection ~ 8900 5500
Wire Wire Line
	9050 5600 8900 5600
Connection ~ 8900 5600
Wire Wire Line
	8900 5700 9050 5700
Connection ~ 8900 5700
Wire Wire Line
	9050 5800 8900 5800
Connection ~ 8900 5800
Wire Wire Line
	8900 5900 9050 5900
Connection ~ 8900 5900
$Comp
L +5V #PWR01
U 1 1 571FF1AE
P 8900 6000
F 0 "#PWR01" H 8900 5850 50  0001 C CNN
F 1 "+5V" H 8915 6173 50  0000 C CNN
F 2 "" H 8900 6000 50  0000 C CNN
F 3 "" H 8900 6000 50  0000 C CNN
	1    8900 6000
	1    0    0    1   
$EndComp
Wire Wire Line
	8900 5100 9050 5100
Wire Wire Line
	8900 5100 8900 5300
Wire Wire Line
	8900 5300 9050 5300
Wire Wire Line
	8700 5200 9050 5200
Connection ~ 8900 5200
Wire Wire Line
	8700 5200 8700 5300
$Comp
L +2V5 #PWR02
U 1 1 571FF205
P 8700 5300
F 0 "#PWR02" H 8700 5150 50  0001 C CNN
F 1 "+2V5" H 8715 5473 50  0000 C CNN
F 2 "" H 8700 5300 50  0000 C CNN
F 3 "" H 8700 5300 50  0000 C CNN
	1    8700 5300
	1    0    0    1   
$EndComp
Wire Wire Line
	10900 5500 9550 5500
Wire Wire Line
	10900 1000 10900 5500
Wire Wire Line
	9550 5300 10900 5300
Wire Wire Line
	9550 4600 10900 4600
Connection ~ 10900 4600
Wire Wire Line
	9550 4300 10900 4300
Connection ~ 10900 4300
Wire Wire Line
	9550 4000 10900 4000
Connection ~ 10900 4000
Wire Wire Line
	9550 3700 10900 3700
Connection ~ 10900 3700
Wire Wire Line
	9550 3400 10900 3400
Connection ~ 10900 3400
Wire Wire Line
	9550 3100 10900 3100
Connection ~ 10900 3100
Wire Wire Line
	9550 2800 10900 2800
Connection ~ 10900 2800
Wire Wire Line
	9550 2500 10900 2500
Connection ~ 10900 2500
Wire Wire Line
	10900 2200 9550 2200
Connection ~ 10900 2200
Wire Wire Line
	9550 1900 10900 1900
Connection ~ 10900 1900
Wire Wire Line
	9550 1600 10900 1600
Connection ~ 10900 1600
Wire Wire Line
	9550 1300 10900 1300
Connection ~ 10900 1300
$Comp
L GND #PWR03
U 1 1 571FF743
P 10900 1000
F 0 "#PWR03" H 10900 750 50  0001 C CNN
F 1 "GND" H 10905 827 50  0000 C CNN
F 2 "" H 10900 1000 50  0000 C CNN
F 3 "" H 10900 1000 50  0000 C CNN
	1    10900 1000
	1    0    0    1   
$EndComp
$Comp
L GND #PWR04
U 1 1 571FF765
P 8050 1100
F 0 "#PWR04" H 8050 850 50  0001 C CNN
F 1 "GND" H 8055 927 50  0000 C CNN
F 2 "" H 8050 1100 50  0000 C CNN
F 3 "" H 8050 1100 50  0000 C CNN
	1    8050 1100
	1    0    0    1   
$EndComp
Wire Wire Line
	8050 1100 9050 1100
Wire Wire Line
	8050 1200 9050 1200
Wire Wire Line
	8050 1100 8050 5000
Wire Wire Line
	8050 1300 9050 1300
Connection ~ 8050 1200
Wire Wire Line
	9050 1400 8050 1400
Connection ~ 8050 1300
Wire Wire Line
	8050 1700 9050 1700
Connection ~ 8050 1400
Wire Wire Line
	9050 2000 8050 2000
Connection ~ 8050 1700
Wire Wire Line
	8050 2300 9050 2300
Connection ~ 8050 2000
Wire Wire Line
	9050 2600 8050 2600
Connection ~ 8050 2300
Wire Wire Line
	8050 2900 9050 2900
Connection ~ 8050 2600
Wire Wire Line
	9050 3200 8050 3200
Connection ~ 8050 2900
Connection ~ 8050 3200
Connection ~ 8050 3500
Wire Wire Line
	8050 5000 9050 5000
Wire Wire Line
	700  5150 600  5150
Wire Wire Line
	600  5150 600  5750
Wire Wire Line
	600  5750 700  5750
Wire Wire Line
	700  5250 600  5250
Connection ~ 600  5250
Wire Wire Line
	600  5350 700  5350
Connection ~ 600  5350
Wire Wire Line
	700  5450 600  5450
Connection ~ 600  5450
Wire Wire Line
	600  5550 700  5550
Connection ~ 600  5550
Wire Wire Line
	700  5650 600  5650
Connection ~ 600  5650
$Comp
L GND #PWR05
U 1 1 571FFD26
P 600 5750
F 0 "#PWR05" H 600 5500 50  0001 C CNN
F 1 "GND" H 605 5577 50  0000 C CNN
F 2 "" H 600 5750 50  0000 C CNN
F 3 "" H 600 5750 50  0000 C CNN
	1    600  5750
	1    0    0    -1  
$EndComp
Text GLabel 1200 5550 2    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 1200 5250 2    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 1200 5350 2    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 1200 5450 2    60   Input ~ 0
FPGA_JTAG_TDO
$Comp
L +2V5 #PWR06
U 1 1 571FFDAE
P 1400 5050
F 0 "#PWR06" H 1400 4900 50  0001 C CNN
F 1 "+2V5" H 1415 5223 50  0000 C CNN
F 2 "" H 1400 5050 50  0000 C CNN
F 3 "" H 1400 5050 50  0000 C CNN
	1    1400 5050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 5050 1400 5150
Wire Wire Line
	1400 5150 1200 5150
Text GLabel 9550 4700 2    60   Input ~ 0
Python_RST#
Wire Notes Line
	7700 6500 7700 500 
Wire Notes Line
	500  3400 7700 3400
Wire Notes Line
	2000 3400 2000 6000
Wire Notes Line
	2000 6000 450  6000
$Sheet
S 800  900  500  150 
U 5720222A
F0 "Sheet57202229" 60
F1 "PowerSupplies.sch" 60
$EndSheet
Text Notes 750  700  0    60   ~ 12
Power Supplies
Text Notes 3400 650  0    60   ~ 12
Level Shifters
Text GLabel 9050 4500 0    60   Input ~ 0
FPGA_Signal3
Text GLabel 9050 4200 0    60   Input ~ 0
FPGA_Signal1
Wire Wire Line
	8050 3500 9050 3500
Connection ~ 10900 5300
Text GLabel 6550 2100 0    60   Input ~ 0
FPGA_Signal1
Text GLabel 6550 2300 0    60   Input ~ 0
FPGA_Signal3
Text GLabel 6550 2500 0    60   Input ~ 0
FPGA_Signal5
Text GLabel 6550 2600 0    60   Input ~ 0
FPGA_Signal6
Text GLabel 6550 2700 0    60   Input ~ 0
FPGA_Signal7
Text Notes 4200 5200 0    60   ~ 12
Clock Distribution
$Comp
L SI53306 U2
U 1 1 572BEE76
P 4650 6300
F 0 "U2" H 4650 7353 60  0000 C CNN
F 1 "SI53306" H 4650 7247 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-16-1EP_3x3mm_Pitch0.5mm" H 4650 7247 60  0001 C CNN
F 3 "http://www.silabs.com/Support%20Documents/TechnicalDocs/Si53306.pdf" H 4650 7247 60  0001 C CNN
F 4 "Silicon Labs" H 4650 6300 60  0001 C CNN "MFN"
F 5 "SI53306" H 4650 6300 60  0001 C CNN "MFP"
F 6 "digikey" H 4650 6300 60  0001 C CNN "D1"
F 7 "mouser" H 4650 6300 60  0001 C CNN "D2"
F 8 "336-2497" H 4650 6300 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/silicon-labs/SI53306-B-GM/336-2497-5-ND/4158074" H 4650 6300 60  0001 C CNN "D1PL"
F 10 "_" H 4650 6300 60  0001 C CNN "D2PN"
F 11 "_" H 4650 6300 60  0001 C CNN "D2PL"
F 12 "_" H 4650 6300 60  0001 C CNN "Package"
F 13 "_" H 4650 7141 60  0000 C CNN "Description"
F 14 "_" H 4650 6300 60  0001 C CNN "Voltage"
F 15 "_" H 4650 6300 60  0001 C CNN "Power"
F 16 "_" H 4650 6300 60  0001 C CNN "Tolerance"
F 17 "_" H 4650 6300 60  0001 C CNN "Temperature"
F 18 "_" H 4650 6300 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 4650 6300 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 4650 6300 60  0001 C CNN "Cont.Current"
F 21 "_" H 4650 6300 60  0001 C CNN "Frequency"
F 22 "_" H 4650 6300 60  0001 C CNN "ResonnanceFreq"
	1    4650 6300
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR07
U 1 1 572BEE7D
P 3950 5400
F 0 "#PWR07" H 3950 5250 50  0001 C CNN
F 1 "+2V5" H 3965 5573 50  0000 C CNN
F 2 "" H 3950 5400 50  0000 C CNN
F 3 "" H 3950 5400 50  0000 C CNN
	1    3950 5400
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR08
U 1 1 572BEE83
P 5300 5400
F 0 "#PWR08" H 5300 5250 50  0001 C CNN
F 1 "+2V5" H 5315 5573 50  0000 C CNN
F 2 "" H 5300 5400 50  0000 C CNN
F 3 "" H 5300 5400 50  0000 C CNN
	1    5300 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 5600 5450 5600
Wire Wire Line
	4150 5600 3950 5600
Text GLabel 3400 6050 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 3400 5750 0    60   Input ~ 0
Python_lvds_clk-
Text GLabel 5150 5800 2    60   Input ~ 0
Python1_lvds_clk-
Text GLabel 5150 5900 2    60   Input ~ 0
Python1_lvds_clk+
Text GLabel 5150 6800 2    60   Input ~ 0
Python2_lvds_clk-
Text GLabel 5150 6700 2    60   Input ~ 0
Python2_lvds_clk+
Text GLabel 5150 6100 2    60   Input ~ 0
Python3_lvds_clk-
Text GLabel 5150 6200 2    60   Input ~ 0
Python3_lvds_clk+
$Comp
L GND #PWR09
U 1 1 572BEE99
P 4450 7200
F 0 "#PWR09" H 4450 6950 50  0001 C CNN
F 1 "GND" H 4455 7027 50  0000 C CNN
F 2 "" H 4450 7200 50  0000 C CNN
F 3 "" H 4450 7200 50  0000 C CNN
	1    4450 7200
	1    0    0    -1  
$EndComp
Text Notes 2900 6250 0    60   ~ 0
SFOUT = 00 for LVDS mode
$Comp
L GND #PWR010
U 1 1 572BEEA3
P 3650 5600
F 0 "#PWR010" H 3650 5350 50  0001 C CNN
F 1 "GND" V 3655 5472 50  0000 R CNN
F 2 "" H 3650 5600 50  0000 C CNN
F 3 "" H 3650 5600 50  0000 C CNN
	1    3650 5600
	0    1    1    0   
$EndComp
$Comp
L GND #PWR011
U 1 1 572BEEA9
P 5750 5600
F 0 "#PWR011" H 5750 5350 50  0001 C CNN
F 1 "GND" V 5755 5472 50  0000 R CNN
F 2 "" H 5750 5600 50  0000 C CNN
F 3 "" H 5750 5600 50  0000 C CNN
	1    5750 5600
	0    -1   1    0   
$EndComp
Connection ~ 5300 5600
Connection ~ 3950 5600
Wire Wire Line
	5300 5600 5300 5400
$Comp
L C C96
U 1 1 572BEEC5
P 5600 5600
F 0 "C96" H 5625 5700 50  0000 L CNN
F 1 "1u" H 5625 5500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 5638 5450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 5600 5600 50  0001 C CNN
F 4 "TDK" H 5600 5600 50  0001 C CNN "MFN"
F 5 "C1005X5R0J105K050BB" H 5600 5600 50  0001 C CNN "MFP"
F 6 "digikey" H 5600 5600 50  0001 C CNN "D1"
F 7 "mouser" H 5600 5600 50  0001 C CNN "D2"
F 8 "445-4998" H 5600 5600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J105K050BB/445-4998-1-ND/2093613" H 5600 5600 50  0001 C CNN "D1PL"
F 10 "_" H 5600 5600 50  0001 C CNN "D2PN"
F 11 "_" H 5600 5600 50  0001 C CNN "D2PL"
F 12 "0402" H 5600 5600 50  0001 C CNN "Package"
F 13 "_" H 5600 5600 50  0000 C CNN "Description"
F 14 "16" H 5600 5600 50  0001 C CNN "Voltage"
F 15 "_" H 5600 5600 50  0001 C CNN "Power"
F 16 "10%" H 5600 5600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 5600 5600 50  0001 C CNN "Temperature"
F 18 "_" H 5600 5600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5600 5600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5600 5600 50  0001 C CNN "Cont.Current"
F 21 "_" H 5600 5600 50  0001 C CNN "Frequency"
F 22 "_" H 5600 5600 50  0001 C CNN "ResonnanceFreq"
	1    5600 5600
	0    -1   -1   0   
$EndComp
$Comp
L C C95
U 1 1 572BEEDF
P 3800 5600
F 0 "C95" H 3825 5700 50  0000 L CNN
F 1 "1u" H 3825 5500 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 3838 5450 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 3800 5600 50  0001 C CNN
F 4 "TDK" H 3800 5600 50  0001 C CNN "MFN"
F 5 "C1005X5R0J105K050BB" H 3800 5600 50  0001 C CNN "MFP"
F 6 "digikey" H 3800 5600 50  0001 C CNN "D1"
F 7 "mouser" H 3800 5600 50  0001 C CNN "D2"
F 8 "445-4998" H 3800 5600 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J105K050BB/445-4998-1-ND/2093613" H 3800 5600 50  0001 C CNN "D1PL"
F 10 "_" H 3800 5600 50  0001 C CNN "D2PN"
F 11 "_" H 3800 5600 50  0001 C CNN "D2PL"
F 12 "0402" H 3800 5600 50  0001 C CNN "Package"
F 13 "_" H 3800 5600 50  0000 C CNN "Description"
F 14 "16" H 3800 5600 50  0001 C CNN "Voltage"
F 15 "_" H 3800 5600 50  0001 C CNN "Power"
F 16 "10%" H 3800 5600 50  0001 C CNN "Tolerance"
F 17 "X5R" H 3800 5600 50  0001 C CNN "Temperature"
F 18 "_" H 3800 5600 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3800 5600 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3800 5600 50  0001 C CNN "Cont.Current"
F 21 "_" H 3800 5600 50  0001 C CNN "Frequency"
F 22 "_" H 3800 5600 50  0001 C CNN "ResonnanceFreq"
	1    3800 5600
	0    -1   -1   0   
$EndComp
NoConn ~ 5150 6400
NoConn ~ 5150 6500
$Comp
L R R11
U 1 1 572BEEFB
P 3650 5900
F 0 "R11" V 3730 5900 50  0000 C CNN
F 1 "100" V 3650 5900 50  0000 C CNN
F 2 "Dipoles_SMD:R_0402" V 3580 5900 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 3650 5900 30  0001 C CNN
F 4 "Vishay" H 3650 5900 50  0001 C CNN "MFN"
F 5 "CRCW0402100RFKED" H 3650 5900 50  0001 C CNN "MFP"
F 6 "digikey" H 3650 5900 50  0001 C CNN "D1"
F 7 "mouser" H 3650 5900 50  0001 C CNN "D2"
F 8 "541-100L" H 3650 5900 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW0402100RFKED/541-100LCT-ND/1183009" H 3650 5900 50  0001 C CNN "D1PL"
F 10 "_" H 3650 5900 50  0001 C CNN "D2PN"
F 11 "_" H 3650 5900 50  0001 C CNN "D2PL"
F 12 "0402" H 3650 5900 50  0001 C CNN "Package"
F 13 "_" H 3650 5900 50  0000 C CNN "Description"
F 14 "_" H 3650 5900 50  0001 C CNN "Voltage"
F 15 "1/16" H 3650 5900 50  0001 C CNN "Power"
F 16 "1%" H 3650 5900 50  0001 C CNN "Tolerance"
F 17 "_" H 3650 5900 50  0001 C CNN "Temperature"
F 18 "_" H 3650 5900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3650 5900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3650 5900 50  0001 C CNN "Cont.Current"
F 21 "_" H 3650 5900 50  0001 C CNN "Frequency"
F 22 "_" H 3650 5900 50  0001 C CNN "ResonnanceFreq"
	1    3650 5900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 5750 3850 5750
Wire Wire Line
	3400 6050 3850 6050
Wire Wire Line
	3850 6050 3850 5900
Wire Wire Line
	3850 5900 4150 5900
Connection ~ 3650 6050
Wire Wire Line
	4150 5800 3850 5800
Wire Wire Line
	3850 5800 3850 5750
Connection ~ 3650 5750
$Sheet
S 3400 850  500  150 
U 572C1BAD
F0 "Sheet572C1BAC" 60
F1 "LevelShifters.sch" 60
$EndSheet
Text GLabel 6550 2400 0    60   Input ~ 0
FPGA_Signal4
Text GLabel 6550 2200 0    60   Input ~ 0
FPGA_Signal2
$Comp
L +5V #PWR012
U 1 1 572BF12C
P 6400 1650
F 0 "#PWR012" H 6400 1500 50  0001 C CNN
F 1 "+5V" H 6415 1823 50  0000 C CNN
F 2 "" H 6400 1650 50  0000 C CNN
F 3 "" H 6400 1650 50  0000 C CNN
	1    6400 1650
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR013
U 1 1 572BF150
P 6150 1650
F 0 "#PWR013" H 6150 1500 50  0001 C CNN
F 1 "+3V3" H 6165 1823 50  0000 C CNN
F 2 "" H 6150 1650 50  0000 C CNN
F 3 "" H 6150 1650 50  0000 C CNN
	1    6150 1650
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR014
U 1 1 572BF174
P 5850 1650
F 0 "#PWR014" H 5850 1500 50  0001 C CNN
F 1 "+2V5" H 5865 1823 50  0000 C CNN
F 2 "" H 5850 1650 50  0000 C CNN
F 3 "" H 5850 1650 50  0000 C CNN
	1    5850 1650
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X12 P3
U 1 1 57312C45
P 6750 2350
F 0 "P3" H 6828 2444 50  0000 L CNN
F 1 "CONN_01X12" H 6828 2353 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x12" H 6827 2307 50  0001 L CNN
F 3 "DNP" H 6750 2350 50  0001 C CNN
F 4 "DNP" H 6750 2350 60  0001 C CNN "MFN"
F 5 "DNP" H 6750 2350 60  0001 C CNN "MFP"
F 6 "digikey" H 6750 2350 60  0001 C CNN "D1"
F 7 "mouser" H 6750 2350 60  0001 C CNN "D2"
F 8 "DNP" H 6750 2350 60  0001 C CNN "D1PN"
F 9 "DNP" H 6750 2350 60  0001 C CNN "D1PL"
F 10 "_" H 6750 2350 60  0001 C CNN "D2PN"
F 11 "_" H 6750 2350 60  0001 C CNN "D2PL"
F 12 "_" H 6750 2350 60  0001 C CNN "Package"
F 13 "_" H 6828 2254 60  0001 L CNN "Description"
F 14 "_" H 6750 2350 60  0001 C CNN "Voltage"
F 15 "_" H 6750 2350 60  0001 C CNN "Power"
F 16 "_" H 6750 2350 60  0001 C CNN "Tolerance"
F 17 "_" H 6750 2350 60  0001 C CNN "Temperature"
F 18 "_" H 6750 2350 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 6750 2350 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 6750 2350 60  0001 C CNN "Cont.Current"
F 21 "_" H 6750 2350 60  0001 C CNN "Frequency"
F 22 "_" H 6750 2350 60  0001 C CNN "ResonnanceFreq"
	1    6750 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 1650 6400 1800
Wire Wire Line
	6400 1800 6550 1800
Wire Wire Line
	5850 1650 5850 2000
Wire Wire Line
	5850 2000 6550 2000
$Comp
L GND #PWR015
U 1 1 57313394
P 6200 3100
F 0 "#PWR015" H 6200 2850 50  0001 C CNN
F 1 "GND" H 6205 2927 50  0000 C CNN
F 2 "" H 6200 3100 50  0000 C CNN
F 3 "" H 6200 3100 50  0000 C CNN
	1    6200 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6200 2800 6200 3100
Wire Wire Line
	6200 2800 6550 2800
Wire Wire Line
	6550 2900 6200 2900
Connection ~ 6200 2900
Wire Wire Line
	6150 1650 6150 1900
Wire Wire Line
	6150 1900 6550 1900
NoConn ~ 1200 5650
NoConn ~ 1200 5750
Wire Wire Line
	4450 7200 4450 7100
Wire Wire Line
	4550 7200 4550 7100
Wire Wire Line
	4050 7200 4550 7200
Connection ~ 4450 7200
Wire Wire Line
	3950 5400 3950 6500
Wire Wire Line
	3950 6500 4150 6500
Wire Wire Line
	4150 6300 4050 6300
Wire Wire Line
	4050 6200 4050 7200
Connection ~ 4050 7200
Wire Wire Line
	4150 6200 4050 6200
Connection ~ 4050 6300
$EndSCHEMATC
