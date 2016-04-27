EESchema Schematic File Version 2
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
Sheet 1 4
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
Text Notes 1600 750  0    60   ~ 12
Level Shifters
Text Notes 3350 5400 0    60   ~ 12
Clock Distribution
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
F 2 "Connectors_Molex:Connector_MilliGrid_02x07_87832-1420" H 950 4250 50  0001 C CNN
F 3 "http://www.molex.com/pdm_docs/sd/878322620_sd.pdf" H 950 4250 50  0001 C CNN
F 4 "Molex" H 950 5450 60  0001 C CNN "MFN"
F 5 "0878321420" H 950 5450 60  0001 C CNN "MFP"
F 6 "digikey" H 950 5450 60  0001 C CNN "D1"
F 7 "mouser" H 950 5450 60  0001 C CNN "D2"
F 8 "WM18641" H 950 5450 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/molex-llc/0878321420/WM18641-ND/662451" H 950 5450 60  0001 C CNN "D1PL"
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
F 2 "Hirose:DF40C_100DS_0-4V" H 9300 6237 60  0000 C CNN
F 3 "" H 9300 4050 60  0000 C CNN
F 4 "_" H 9300 3550 60  0001 C CNN "MFN"
F 5 "_" H 9300 3550 60  0001 C CNN "MFP"
F 6 "digikey" H 9300 3550 60  0001 C CNN "D1"
F 7 "mouser" H 9300 3550 60  0001 C CNN "D2"
F 8 "_" H 9300 3550 60  0001 C CNN "D1PN"
F 9 "_" H 9300 3550 60  0001 C CNN "D1PL"
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
Text GLabel 9550 1100 2    60   Input ~ 0
SPI_MOSI
Text GLabel 9550 2100 2    60   Input ~ 0
SPI_MISO
Text GLabel 9550 1300 2    60   Input ~ 0
SPI_SCK
Text GLabel 9550 1500 2    60   Input ~ 0
Python1_CS#
Text GLabel 9550 1600 2    60   Input ~ 0
Python2_CS#
Text GLabel 9550 1700 2    60   Input ~ 0
Python3_CS#
Text GLabel 9550 1800 2    60   Input ~ 0
IMU_CS#
Text GLabel 9550 2200 2    60   Input ~ 0
Python1_Monitor
Text GLabel 9550 2300 2    60   Input ~ 0
Python2_Monitor
Text GLabel 9550 2400 2    60   Input ~ 0
Python3_Monitor
$Sheet
S 600  3750 500  150 
U 571FBD4F
F0 "Sheet571FBD4E" 60
F1 "Imagers.sch" 60
$EndSheet
Text GLabel 9550 1900 2    60   Input ~ 0
Python_Trigger
Text GLabel 9550 3000 2    60   Input ~ 0
Python1_DOUT0-
Text GLabel 9550 2900 2    60   Input ~ 0
Python1_DOUT0+
Text GLabel 9550 2700 2    60   Input ~ 0
Python1_SYNC-
Text GLabel 9550 2600 2    60   Input ~ 0
Python1_SYNC+
Text GLabel 9550 3300 2    60   Input ~ 0
Python1_DOUT1-
Text GLabel 9550 3200 2    60   Input ~ 0
Python1_DOUT1+
Text GLabel 9550 3600 2    60   Input ~ 0
Python1_DOUT2-
Text GLabel 9550 3500 2    60   Input ~ 0
Python1_DOUT2+
Text GLabel 9550 3900 2    60   Input ~ 0
Python1_DOUT3-
Text GLabel 9550 3800 2    60   Input ~ 0
Python1_DOUT3+
Text GLabel 9550 4100 2    60   Input ~ 0
Python1_clk_return+
Text GLabel 9550 4200 2    60   Input ~ 0
Python1_clk_return-
Text GLabel 9550 4800 2    60   Input ~ 0
Python3_DOUT0-
Text GLabel 9550 4700 2    60   Input ~ 0
Python3_DOUT0+
Text GLabel 9550 4500 2    60   Input ~ 0
Python3_SYNC-
Text GLabel 9550 4400 2    60   Input ~ 0
Python3_SYNC+
Text GLabel 9550 5100 2    60   Input ~ 0
Python3_DOUT1-
Text GLabel 9550 5000 2    60   Input ~ 0
Python3_DOUT1+
Text GLabel 9550 5400 2    60   Input ~ 0
Python3_DOUT2-
Text GLabel 9550 5300 2    60   Input ~ 0
Python3_DOUT2+
Text GLabel 9550 5700 2    60   Input ~ 0
Python3_DOUT3-
Text GLabel 9550 5600 2    60   Input ~ 0
Python3_DOUT3+
Text GLabel 9550 5900 2    60   Input ~ 0
Python3_clk_return+
Text GLabel 9550 6000 2    60   Input ~ 0
Python3_clk_return-
Text GLabel 9050 4700 0    60   Input ~ 0
Python2_DOUT0-
Text GLabel 9050 4600 0    60   Input ~ 0
Python2_DOUT0+
Text GLabel 9050 4400 0    60   Input ~ 0
Python2_SYNC-
Text GLabel 9050 4300 0    60   Input ~ 0
Python2_SYNC+
Text GLabel 9050 5000 0    60   Input ~ 0
Python2_DOUT1-
Text GLabel 9050 4900 0    60   Input ~ 0
Python2_DOUT1+
Text GLabel 9050 5300 0    60   Input ~ 0
Python2_DOUT2-
Text GLabel 9050 5200 0    60   Input ~ 0
Python2_DOUT2+
Text GLabel 9050 5600 0    60   Input ~ 0
Python2_DOUT3-
Text GLabel 9050 5500 0    60   Input ~ 0
Python2_DOUT3+
Text GLabel 9050 4000 0    60   Input ~ 0
Python2_clk_return+
Text GLabel 9050 4100 0    60   Input ~ 0
Python2_clk_return-
Text GLabel 9050 3500 0    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 9050 3700 0    60   Input ~ 0
FPGA_JTAG_TDO
Text GLabel 9050 3800 0    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 9050 3400 0    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 9050 3200 0    60   Input ~ 0
FPGA_Dbg1
Text GLabel 9050 3100 0    60   Input ~ 0
FPGA_Dbg2
Text GLabel 9050 2900 0    60   Input ~ 0
FPGA_Dbg3
Text GLabel 9050 2800 0    60   Input ~ 0
FPGA_Dbg4
Text GLabel 9050 2600 0    60   Input ~ 0
FPGA_Dbg5
Text GLabel 9050 2500 0    60   Input ~ 0
FPGA_Dbg6
Text GLabel 9050 2200 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 9050 2300 0    60   Input ~ 0
Python_lvds_clk-
Wire Wire Line
	9050 1100 8900 1100
Wire Wire Line
	8900 1100 8900 1700
Wire Wire Line
	8900 1700 9050 1700
Wire Wire Line
	9050 1600 8900 1600
Connection ~ 8900 1600
Wire Wire Line
	9050 1500 8900 1500
Connection ~ 8900 1500
Wire Wire Line
	8900 1400 9050 1400
Connection ~ 8900 1400
Wire Wire Line
	9050 1300 8900 1300
Connection ~ 8900 1300
Wire Wire Line
	8900 1200 9050 1200
Connection ~ 8900 1200
$Comp
L +5V #PWR01
U 1 1 571FF1AE
P 8900 1100
F 0 "#PWR01" H 8900 950 50  0001 C CNN
F 1 "+5V" H 8915 1273 50  0000 C CNN
F 2 "" H 8900 1100 50  0000 C CNN
F 3 "" H 8900 1100 50  0000 C CNN
	1    8900 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 2000 9050 2000
Wire Wire Line
	8900 1800 8900 2000
Wire Wire Line
	8900 1800 9050 1800
Wire Wire Line
	8700 1900 9050 1900
Connection ~ 8900 1900
Wire Wire Line
	8700 1900 8700 1800
$Comp
L +2V5 #PWR02
U 1 1 571FF205
P 8700 1800
F 0 "#PWR02" H 8700 1650 50  0001 C CNN
F 1 "+2V5" H 8715 1973 50  0000 C CNN
F 2 "" H 8700 1800 50  0000 C CNN
F 3 "" H 8700 1800 50  0000 C CNN
	1    8700 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 1200 10900 1200
Wire Wire Line
	10900 1200 10900 6100
Wire Wire Line
	9550 1400 10900 1400
Wire Wire Line
	9550 2500 10900 2500
Connection ~ 10900 2500
Wire Wire Line
	9550 2800 10900 2800
Connection ~ 10900 2800
Wire Wire Line
	9550 3100 10900 3100
Connection ~ 10900 3100
Wire Wire Line
	9550 3400 10900 3400
Connection ~ 10900 3400
Wire Wire Line
	9550 3700 10900 3700
Connection ~ 10900 3700
Wire Wire Line
	9550 4000 10900 4000
Connection ~ 10900 4000
Wire Wire Line
	9550 4300 10900 4300
Connection ~ 10900 4300
Wire Wire Line
	9550 4600 10900 4600
Connection ~ 10900 4600
Wire Wire Line
	10900 4900 9550 4900
Connection ~ 10900 4900
Wire Wire Line
	9550 5200 10900 5200
Connection ~ 10900 5200
Wire Wire Line
	9550 5500 10900 5500
Connection ~ 10900 5500
Wire Wire Line
	9550 5800 10900 5800
Connection ~ 10900 5800
$Comp
L GND #PWR03
U 1 1 571FF743
P 10900 6100
F 0 "#PWR03" H 10900 5850 50  0001 C CNN
F 1 "GND" H 10905 5927 50  0000 C CNN
F 2 "" H 10900 6100 50  0000 C CNN
F 3 "" H 10900 6100 50  0000 C CNN
	1    10900 6100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 571FF765
P 8050 6000
F 0 "#PWR04" H 8050 5750 50  0001 C CNN
F 1 "GND" H 8055 5827 50  0000 C CNN
F 2 "" H 8050 6000 50  0000 C CNN
F 3 "" H 8050 6000 50  0000 C CNN
	1    8050 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 6000 9050 6000
Wire Wire Line
	8050 5900 9050 5900
Wire Wire Line
	8050 2100 8050 6000
Wire Wire Line
	8050 5800 9050 5800
Connection ~ 8050 5900
Wire Wire Line
	9050 5700 8050 5700
Connection ~ 8050 5800
Wire Wire Line
	8050 5400 9050 5400
Connection ~ 8050 5700
Wire Wire Line
	9050 5100 8050 5100
Connection ~ 8050 5400
Wire Wire Line
	8050 4800 9050 4800
Connection ~ 8050 5100
Wire Wire Line
	9050 4500 8050 4500
Connection ~ 8050 4800
Wire Wire Line
	8050 4200 9050 4200
Connection ~ 8050 4500
Wire Wire Line
	9050 3900 8050 3900
Connection ~ 8050 4200
Wire Wire Line
	8050 3600 9050 3600
Connection ~ 8050 3900
Wire Wire Line
	9050 2400 8050 2400
Connection ~ 8050 3600
Wire Wire Line
	8050 2100 9050 2100
Connection ~ 8050 2400
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
NoConn ~ 1200 5750
NoConn ~ 1200 5650
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
Text GLabel 9550 2000 2    60   Input ~ 0
Python_RST#
$Comp
L 74AVCH8T245 U1
U 1 1 57210281
P 1950 2100
F 0 "U1" H 1700 3100 60  0000 C CNN
F 1 "74AVCH8T245" H 2500 1300 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-24-1EP-Pitch0.5-nonSquare" H 1950 2100 60  0001 C CNN
F 3 "http://www.nxp.com/documents/data_sheet/74AVCH8T245.pdf" H 1925 3187 60  0001 C CNN
F 4 "NXP" H 1950 2100 60  0001 C CNN "MFN"
F 5 "74AVCH8T245BQ" H 1950 2100 60  0001 C CNN "MFP"
F 6 "digikey" H 1950 2100 60  0001 C CNN "D1"
F 7 "mouser" H 1950 2100 60  0001 C CNN "D2"
F 8 "568-5418" H 1950 2100 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/74AVCH8T245BQ%2C118/568-5418-1-ND/2530896?WT.z_cid=ref_octopart_dkc_buynow&site=us" H 1950 2100 60  0001 C CNN "D1PL"
F 10 "_" H 1950 2100 60  0001 C CNN "D2PN"
F 11 "_" H 1950 2100 60  0001 C CNN "D2PL"
F 12 "_" H 1950 2100 60  0001 C CNN "Package"
F 13 "_" H 1925 3081 60  0000 C CNN "Description"
F 14 "_" H 1950 2100 60  0001 C CNN "Voltage"
F 15 "_" H 1950 2100 60  0001 C CNN "Power"
F 16 "_" H 1950 2100 60  0001 C CNN "Tolerance"
F 17 "_" H 1950 2100 60  0001 C CNN "Temperature"
F 18 "_" H 1950 2100 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 1950 2100 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 1950 2100 60  0001 C CNN "Cont.Current"
F 21 "_" H 1950 2100 60  0001 C CNN "Frequency"
F 22 "_" H 1950 2100 60  0001 C CNN "ResonnanceFreq"
	1    1950 2100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 57210454
P 1950 3100
F 0 "#PWR07" H 1950 2850 50  0001 C CNN
F 1 "GND" H 1955 2927 50  0000 C CNN
F 2 "" H 1950 3100 50  0000 C CNN
F 3 "" H 1950 3100 50  0000 C CNN
	1    1950 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 3000 1850 3100
Wire Wire Line
	1750 3100 2050 3100
Wire Wire Line
	1950 3100 1950 3000
Wire Wire Line
	2050 3100 2050 3000
Connection ~ 1950 3100
$Comp
L +2V5 #PWR08
U 1 1 57210588
P 1200 1300
F 0 "#PWR08" H 1200 1150 50  0001 C CNN
F 1 "+2V5" H 1215 1473 50  0000 C CNN
F 2 "" H 1200 1300 50  0000 C CNN
F 3 "" H 1200 1300 50  0000 C CNN
	1    1200 1300
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR09
U 1 1 572105A2
P 2550 1300
F 0 "#PWR09" H 2550 1150 50  0001 C CNN
F 1 "+3V3" H 2565 1473 50  0000 C CNN
F 2 "" H 2550 1300 50  0000 C CNN
F 3 "" H 2550 1300 50  0000 C CNN
	1    2550 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 1300 2400 1300
Wire Wire Line
	2400 1400 2550 1400
Wire Wire Line
	2550 1400 2550 1300
Text GLabel 1450 2300 0    60   Input ~ 0
Python1_CS#
Text GLabel 1450 2200 0    60   Input ~ 0
Python2_CS#
Text GLabel 1450 2100 0    60   Input ~ 0
Python3_CS#
Text GLabel 1450 2000 0    60   Input ~ 0
IMU_CS#
Text GLabel 1450 1800 0    60   Input ~ 0
Python_RST#
Text GLabel 1450 1900 0    60   Input ~ 0
Python_Trigger
Text GLabel 1450 2500 0    60   Input ~ 0
SPI_MOSI
Text GLabel 1450 2400 0    60   Input ~ 0
SPI_SCK
Text GLabel 2400 2300 2    60   Input ~ 0
Python1_CS#_3V3
Text GLabel 2400 2200 2    60   Input ~ 0
Python2_CS#_3V3
Text GLabel 2400 2100 2    60   Input ~ 0
Python3_CS#_3V3
Text GLabel 2400 2000 2    60   Input ~ 0
IMU_CS#_3V3
Text GLabel 2400 1800 2    60   Input ~ 0
Python_RST#_3V3
Text GLabel 2400 1900 2    60   Input ~ 0
Python_Trigger_3V3
Text GLabel 2400 2500 2    60   Input ~ 0
SPI_MOSI_3V3
Text GLabel 2400 2400 2    60   Input ~ 0
SPI_SCK_3V3
$Comp
L 74AVCH8T245 U4
U 1 1 572111C9
P 5050 2150
F 0 "U4" H 4800 3150 60  0000 C CNN
F 1 "74AVCH8T245" H 5600 1350 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-24-1EP-Pitch0.5-nonSquare" H 5050 2150 60  0001 C CNN
F 3 "http://www.nxp.com/documents/data_sheet/74AVCH8T245.pdf" H 5025 3237 60  0001 C CNN
F 4 "NXP" H 5050 2150 60  0001 C CNN "MFN"
F 5 "74AVCH8T245BQ" H 5050 2150 60  0001 C CNN "MFP"
F 6 "digikey" H 5050 2150 60  0001 C CNN "D1"
F 7 "mouser" H 5050 2150 60  0001 C CNN "D2"
F 8 "568-5418" H 5050 2150 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/74AVCH8T245BQ%2C118/568-5418-1-ND/2530896?WT.z_cid=ref_octopart_dkc_buynow&site=us" H 5050 2150 60  0001 C CNN "D1PL"
F 10 "_" H 5050 2150 60  0001 C CNN "D2PN"
F 11 "_" H 5050 2150 60  0001 C CNN "D2PL"
F 12 "_" H 5050 2150 60  0001 C CNN "Package"
F 13 "_" H 5025 3131 60  0000 C CNN "Description"
F 14 "_" H 5050 2150 60  0001 C CNN "Voltage"
F 15 "_" H 5050 2150 60  0001 C CNN "Power"
F 16 "_" H 5050 2150 60  0001 C CNN "Tolerance"
F 17 "_" H 5050 2150 60  0001 C CNN "Temperature"
F 18 "_" H 5050 2150 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 5050 2150 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 5050 2150 60  0001 C CNN "Cont.Current"
F 21 "_" H 5050 2150 60  0001 C CNN "Frequency"
F 22 "_" H 5050 2150 60  0001 C CNN "ResonnanceFreq"
	1    5050 2150
	1    0    0    -1  
$EndComp
Text Notes 1600 950  0    60   ~ 12
Outbound (FPGA-> Sensors)
Text Notes 4500 950  0    60   ~ 12
Inbound (Sensors -> FPGA)
Text GLabel 5500 1950 2    60   Input ~ 0
Python1_Monitor
Text GLabel 5500 2050 2    60   Input ~ 0
Python2_Monitor
Text GLabel 5500 2150 2    60   Input ~ 0
Python3_Monitor
Text GLabel 5500 1850 2    60   Input ~ 0
SPI_MISO
Text GLabel 4550 1950 0    60   Input ~ 0
Python1_Monitor_3V3
Text GLabel 4550 2050 0    60   Input ~ 0
Python2_Monitor_3V3
Text GLabel 4550 2150 0    60   Input ~ 0
Python3_Monitor_3V3
Text GLabel 4550 1850 0    60   Input ~ 0
SPI_MISO_3V3
$Comp
L +3V3 #PWR010
U 1 1 57211510
P 4400 1250
F 0 "#PWR010" H 4400 1100 50  0001 C CNN
F 1 "+3V3" H 4415 1423 50  0000 C CNN
F 2 "" H 4400 1250 50  0000 C CNN
F 3 "" H 4400 1250 50  0000 C CNN
	1    4400 1250
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4550 1350 4400 1350
Wire Wire Line
	4400 1250 4400 1650
$Comp
L +2V5 #PWR011
U 1 1 57211527
P 5750 1350
F 0 "#PWR011" H 5750 1200 50  0001 C CNN
F 1 "+2V5" H 5765 1523 50  0000 C CNN
F 2 "" H 5750 1350 50  0000 C CNN
F 3 "" H 5750 1350 50  0000 C CNN
	1    5750 1350
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5750 1350 5500 1350
Wire Wire Line
	1200 1300 1450 1300
$Comp
L GND #PWR012
U 1 1 5721163F
P 5050 3150
F 0 "#PWR012" H 5050 2900 50  0001 C CNN
F 1 "GND" H 5055 2977 50  0000 C CNN
F 2 "" H 5050 3150 50  0000 C CNN
F 3 "" H 5050 3150 50  0000 C CNN
	1    5050 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 3050 4950 3150
Wire Wire Line
	4850 3150 5150 3150
Wire Wire Line
	5050 3150 5050 3050
Wire Wire Line
	5150 3150 5150 3050
Connection ~ 5050 3150
NoConn ~ 4550 2250
NoConn ~ 4550 2350
NoConn ~ 4550 2450
NoConn ~ 4550 2550
NoConn ~ 5500 2550
NoConn ~ 5500 2450
NoConn ~ 5500 2350
NoConn ~ 5500 2250
Wire Wire Line
	5500 1650 5850 1650
$Comp
L GND #PWR013
U 1 1 57211A34
P 5850 1650
F 0 "#PWR013" H 5850 1400 50  0001 C CNN
F 1 "GND" V 5855 1522 50  0000 R CNN
F 2 "" H 5850 1650 50  0000 C CNN
F 3 "" H 5850 1650 50  0000 C CNN
	1    5850 1650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2400 1600 2750 1600
$Comp
L GND #PWR014
U 1 1 57211A63
P 2750 1600
F 0 "#PWR014" H 2750 1350 50  0001 C CNN
F 1 "GND" V 2755 1472 50  0000 R CNN
F 2 "" H 2750 1600 50  0000 C CNN
F 3 "" H 2750 1600 50  0000 C CNN
	1    2750 1600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	1450 1600 1200 1600
Wire Wire Line
	1200 1600 1200 1300
Wire Notes Line
	7700 6500 7700 500 
Wire Notes Line
	500  3400 7700 3400
Wire Notes Line
	2000 3400 2000 6000
Wire Notes Line
	2000 6000 450  6000
$Comp
L SI53306 U2
U 1 1 5721268A
P 3800 6500
F 0 "U2" H 3800 7553 60  0000 C CNN
F 1 "SI53306" H 3800 7447 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-16-1EP_3x3mm_Pitch0.5mm" H 3800 7447 60  0001 C CNN
F 3 "http://www.silabs.com/Support%20Documents/TechnicalDocs/Si53306.pdf" H 3800 7447 60  0001 C CNN
F 4 "Silicon Labs" H 3800 6500 60  0001 C CNN "MFN"
F 5 "SI53306" H 3800 6500 60  0001 C CNN "MFP"
F 6 "digikey" H 3800 6500 60  0001 C CNN "D1"
F 7 "mouser" H 3800 6500 60  0001 C CNN "D2"
F 8 "336-2497" H 3800 6500 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/silicon-labs/SI53306-B-GM/336-2497-5-ND/4158074" H 3800 6500 60  0001 C CNN "D1PL"
F 10 "_" H 3800 6500 60  0001 C CNN "D2PN"
F 11 "_" H 3800 6500 60  0001 C CNN "D2PL"
F 12 "_" H 3800 6500 60  0001 C CNN "Package"
F 13 "_" H 3800 7341 60  0000 C CNN "Description"
F 14 "_" H 3800 6500 60  0001 C CNN "Voltage"
F 15 "_" H 3800 6500 60  0001 C CNN "Power"
F 16 "_" H 3800 6500 60  0001 C CNN "Tolerance"
F 17 "_" H 3800 6500 60  0001 C CNN "Temperature"
F 18 "_" H 3800 6500 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 3800 6500 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 3800 6500 60  0001 C CNN "Cont.Current"
F 21 "_" H 3800 6500 60  0001 C CNN "Frequency"
F 22 "_" H 3800 6500 60  0001 C CNN "ResonnanceFreq"
	1    3800 6500
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR015
U 1 1 572126ED
P 3100 5800
F 0 "#PWR015" H 3100 5650 50  0001 C CNN
F 1 "+2V5" H 3115 5973 50  0000 C CNN
F 2 "" H 3100 5800 50  0000 C CNN
F 3 "" H 3100 5800 50  0000 C CNN
	1    3100 5800
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR016
U 1 1 5721270E
P 4450 5800
F 0 "#PWR016" H 4450 5650 50  0001 C CNN
F 1 "+2V5" H 4465 5973 50  0000 C CNN
F 2 "" H 4450 5800 50  0000 C CNN
F 3 "" H 4450 5800 50  0000 C CNN
	1    4450 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 5800 4450 5800
Wire Wire Line
	3300 5800 3100 5800
Text GLabel 3300 6000 0    60   Input ~ 0
Python_lvds_clk+
Text GLabel 3300 6100 0    60   Input ~ 0
Python_lvds_clk-
Text GLabel 4300 6100 2    60   Input ~ 0
Python1_lvds_clk-
Text GLabel 4300 6000 2    60   Input ~ 0
Python1_lvds_clk+
Text GLabel 4300 6400 2    60   Input ~ 0
Python2_lvds_clk-
Text GLabel 4300 6300 2    60   Input ~ 0
Python2_lvds_clk+
Text GLabel 4300 6700 2    60   Input ~ 0
Python3_lvds_clk-
Text GLabel 4300 6600 2    60   Input ~ 0
Python3_lvds_clk+
Wire Wire Line
	3300 6700 3100 6700
Wire Wire Line
	3100 6700 3100 5800
Wire Wire Line
	3300 6400 3200 6400
Wire Wire Line
	3200 6400 3200 7350
Wire Wire Line
	3300 6500 3200 6500
Connection ~ 3200 6500
$Comp
L GND #PWR017
U 1 1 5721305D
P 3200 7350
F 0 "#PWR017" H 3200 7100 50  0001 C CNN
F 1 "GND" H 3205 7177 50  0000 C CNN
F 2 "" H 3200 7350 50  0000 C CNN
F 3 "" H 3200 7350 50  0000 C CNN
	1    3200 7350
	1    0    0    -1  
$EndComp
Text Notes 2050 6450 0    60   ~ 0
SFOUT = 00 for LVDS mode
NoConn ~ 4300 6900
NoConn ~ 4300 7000
Text Notes 4400 6950 0    60   ~ 0
Leave unconnected ?
Wire Wire Line
	1750 3000 1750 3100
Connection ~ 1850 3100
Wire Wire Line
	4850 3050 4850 3150
Connection ~ 4950 3150
Wire Wire Line
	3200 7300 3600 7300
Connection ~ 3200 7300
$Sheet
S 3400 3950 500  150 
U 5720222A
F0 "Sheet57202229" 60
F1 "PowerSupplies.sch" 60
$EndSheet
Text Notes 3350 3750 0    60   ~ 12
Power Supplies
Wire Wire Line
	5500 1450 5750 1450
Wire Wire Line
	5750 1450 5750 1350
Connection ~ 4400 1350
Wire Wire Line
	4400 1650 4550 1650
Connection ~ 10900 1400
$EndSCHEMATC
