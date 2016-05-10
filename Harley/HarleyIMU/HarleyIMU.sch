EESchema Schematic File Version 2
LIBS:DCDC_Converters
LIBS:isolators
LIBS:voltage_translators
LIBS:conn
LIBS:connectors
LIBS:IMU
LIBS:power
LIBS:device
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
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
L VN-100 U3
U 1 1 5730BD96
P 9650 2400
F 0 "U3" H 9100 3250 60  0000 L CNN
F 1 "VN-100" H 8950 1550 60  0000 L CNN
F 2 "Housings_DFN_QFN:QFN-30_100milpitch" H 9650 2400 60  0001 C CNN
F 3 "" H 9650 2400 60  0000 C CNN
F 4 "_" H 9650 2400 60  0001 C CNN "MFN"
F 5 "_" H 9650 2400 60  0001 C CNN "MFP"
F 6 "digikey" H 9650 2400 60  0001 C CNN "D1"
F 7 "mouser" H 9650 2400 60  0001 C CNN "D2"
F 8 "_" H 9650 2400 60  0001 C CNN "D1PN"
F 9 "_" H 9650 2400 60  0001 C CNN "D1PL"
F 10 "_" H 9650 2400 60  0001 C CNN "D2PN"
F 11 "_" H 9650 2400 60  0001 C CNN "D2PL"
F 12 "_" H 9650 2400 60  0001 C CNN "Package"
F 13 "_" H 9650 2400 60  0001 C CNN "Description"
F 14 "_" H 9650 2400 60  0001 C CNN "Voltage"
F 15 "_" H 9650 2400 60  0001 C CNN "Power"
F 16 "_" H 9650 2400 60  0001 C CNN "Tolerance"
F 17 "_" H 9650 2400 60  0001 C CNN "Temperature"
F 18 "_" H 9650 2400 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9650 2400 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9650 2400 60  0001 C CNN "Cont.Current"
F 21 "_" H 9650 2400 60  0001 C CNN "Frequency"
F 22 "_" H 9650 2400 60  0001 C CNN "ResonnanceFreq"
	1    9650 2400
	1    0    0    -1  
$EndComp
NoConn ~ 9350 1500
NoConn ~ 9450 1500
NoConn ~ 9550 1500
NoConn ~ 9650 1500
NoConn ~ 9750 1500
NoConn ~ 9850 1500
NoConn ~ 9950 1500
NoConn ~ 10050 1500
NoConn ~ 10150 1500
$Comp
L GND #PWR01
U 1 1 5730BEBF
P 9650 3500
F 0 "#PWR01" H 9650 3250 50  0001 C CNN
F 1 "GND" H 9655 3327 50  0000 C CNN
F 2 "" H 9650 3500 50  0000 C CNN
F 3 "" H 9650 3500 50  0000 C CNN
	1    9650 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	9650 3300 9650 3500
Wire Wire Line
	9450 3300 9450 3400
Wire Wire Line
	9450 3400 10050 3400
Connection ~ 9650 3400
Wire Wire Line
	9550 3300 9550 3400
Connection ~ 9550 3400
Wire Wire Line
	9750 3400 9750 3300
Wire Wire Line
	10050 3400 10050 3300
Connection ~ 9750 3400
Wire Wire Line
	9950 3300 9950 3400
Connection ~ 9950 3400
Wire Wire Line
	9850 3300 9850 3400
Connection ~ 9850 3400
$Comp
L +3V3 #PWR02
U 1 1 5730BF60
P 8700 1900
F 0 "#PWR02" H 8700 1750 50  0001 C CNN
F 1 "+3V3" H 8715 2073 50  0000 C CNN
F 2 "" H 8700 1900 50  0000 C CNN
F 3 "" H 8700 1900 50  0000 C CNN
	1    8700 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8000 1900 8950 1900
Text GLabel 8950 3000 0    60   Input ~ 0
IMU_RST#
NoConn ~ 8950 2800
NoConn ~ 8950 2700
NoConn ~ 8950 2600
NoConn ~ 8950 2500
Text GLabel 10450 2100 2    60   Input ~ 0
IMU_TX
Text GLabel 10450 2200 2    60   Input ~ 0
IMU_RX
NoConn ~ 10450 2300
NoConn ~ 10450 2400
Wire Wire Line
	8950 2100 8700 2100
Wire Wire Line
	8700 2100 8700 1900
Text GLabel 8950 2200 0    60   Input ~ 0
IMU_TARE
Text Notes 8350 2350 0    60   ~ 0
Use this ?
$Comp
L +2V5 #PWR03
U 1 1 5730CED7
P 1200 1650
F 0 "#PWR03" H 1200 1500 50  0001 C CNN
F 1 "+2V5" H 1215 1823 50  0000 C CNN
F 2 "" H 1200 1650 50  0000 C CNN
F 3 "" H 1200 1650 50  0000 C CNN
	1    1200 1650
	1    0    0    -1  
$EndComp
$Comp
L +3V3 #PWR04
U 1 1 5730CF08
P 1400 1650
F 0 "#PWR04" H 1400 1500 50  0001 C CNN
F 1 "+3V3" H 1415 1823 50  0000 C CNN
F 2 "" H 1400 1650 50  0000 C CNN
F 3 "" H 1400 1650 50  0000 C CNN
	1    1400 1650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR05
U 1 1 5730CF39
P 1600 1650
F 0 "#PWR05" H 1600 1500 50  0001 C CNN
F 1 "+5V" H 1615 1823 50  0000 C CNN
F 2 "" H 1600 1650 50  0000 C CNN
F 3 "" H 1600 1650 50  0000 C CNN
	1    1600 1650
	1    0    0    -1  
$EndComp
Text Notes 9300 1200 0    300  ~ 60
IMU
Text Notes 700  1000 0    150  ~ 30
To HarleyTandem
$Comp
L C C3
U 1 1 5730D444
P 8000 2050
F 0 "C3" H 8115 2194 50  0000 L CNN
F 1 "100n" H 8115 2103 50  0000 L CNN
F 2 "Dipoles_SMD:C_0603" H 8115 2012 50  0001 L CNN
F 3 "https://product.tdk.com/info/en/catalog/datasheets/mlcc_highreliability_general_en.pdf" H 8000 2050 50  0001 C CNN
F 4 "TDK" H 8000 2050 60  0001 C CNN "MFN"
F 5 "CGJ3E2X7R1C104K080AA" H 8000 2050 60  0001 C CNN "MFP"
F 6 "digikey" H 8000 2050 60  0001 C CNN "D1"
F 7 "mouser" H 8000 2050 60  0001 C CNN "D2"
F 8 "445-8136" H 8000 2050 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/tdk-corporation/CGJ3E2X7R1C104K080AA/445-8136-1-ND/2812154" H 8000 2050 60  0001 C CNN "D1PL"
F 10 "_" H 8000 2050 60  0001 C CNN "D2PN"
F 11 "_" H 8000 2050 60  0001 C CNN "D2PL"
F 12 "_" H 8000 2050 60  0001 C CNN "Package"
F 13 "_" H 8115 1913 60  0000 L CNN "Description"
F 14 "_" H 8000 2050 60  0001 C CNN "Voltage"
F 15 "_" H 8000 2050 60  0001 C CNN "Power"
F 16 "_" H 8000 2050 60  0001 C CNN "Tolerance"
F 17 "_" H 8000 2050 60  0001 C CNN "Temperature"
F 18 "_" H 8000 2050 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 8000 2050 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 8000 2050 60  0001 C CNN "Cont.Current"
F 21 "_" H 8000 2050 60  0001 C CNN "Frequency"
F 22 "_" H 8000 2050 60  0001 C CNN "ResonnanceFreq"
	1    8000 2050
	1    0    0    -1  
$EndComp
Connection ~ 8700 1900
$Comp
L GND #PWR06
U 1 1 5730D4A3
P 8000 2200
F 0 "#PWR06" H 8000 1950 50  0001 C CNN
F 1 "GND" H 8005 2027 50  0000 C CNN
F 2 "" H 8000 2200 50  0000 C CNN
F 3 "" H 8000 2200 50  0000 C CNN
	1    8000 2200
	1    0    0    -1  
$EndComp
Text Notes 4200 1000 0    150  ~ 30
Level shifting
Text GLabel 4550 2750 0    60   Input ~ 0
IMU_TARE_2V5
Text GLabel 4550 3150 0    60   Input ~ 0
IMU_RST#_2V5
Text GLabel 4550 3050 0    60   Input ~ 0
IMU_RX_2V5
Text GLabel 4550 2950 0    60   Input ~ 0
IMU_TX_2V5
Text GLabel 4550 2850 0    60   Input ~ 0
IMU_SYNC_OUT_2V5
Text GLabel 10450 2600 2    60   Input ~ 0
IMU_SYNC_OUT
$Comp
L LED D1
U 1 1 5730DE99
P 9100 4350
F 0 "D1" H 9100 4450 50  0000 C CNN
F 1 "GREEN" H 9100 4250 50  0000 C CNN
F 2 "LEDs:LED_0603" H 9100 4350 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/APT1608CGCK.pdf" H 9100 4350 50  0001 C CNN
F 4 "Kingbright" H 9100 4350 60  0001 C CNN "MFN"
F 5 "APT1608CGCK" H 9100 4350 60  0001 C CNN "MFP"
F 6 "digikey" H 9100 4350 60  0001 C CNN "D1"
F 7 "mouser" H 9100 4350 60  0001 C CNN "D2"
F 8 "754-1116" H 9100 4350 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/APT1608CGCK/754-1116-1-ND/1747833" H 9100 4350 60  0001 C CNN "D1PL"
F 10 "_" H 9100 4350 60  0001 C CNN "D2PN"
F 11 "_" H 9100 4350 60  0001 C CNN "D2PL"
F 12 "_" H 9100 4350 60  0001 C CNN "Package"
F 13 "_" H 9100 4350 60  0000 C CNN "Description"
F 14 "_" H 9100 4350 60  0001 C CNN "Voltage"
F 15 "_" H 9100 4350 60  0001 C CNN "Power"
F 16 "_" H 9100 4350 60  0001 C CNN "Tolerance"
F 17 "_" H 9100 4350 60  0001 C CNN "Temperature"
F 18 "_" H 9100 4350 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9100 4350 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9100 4350 60  0001 C CNN "Cont.Current"
F 21 "_" H 9100 4350 60  0001 C CNN "Frequency"
F 22 "_" H 9100 4350 60  0001 C CNN "ResonnanceFreq"
	1    9100 4350
	1    0    0    -1  
$EndComp
$Comp
L LED D2
U 1 1 5730DEBD
P 9100 4700
F 0 "D2" H 9100 4800 50  0000 C CNN
F 1 "RED" H 9100 4550 50  0000 C CNN
F 2 "LEDs:LED_0603" H 9100 4700 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/APT1608SURCK.pdf" H 9100 4700 50  0001 C CNN
F 4 "Kingbright" H 9100 4700 60  0001 C CNN "MFN"
F 5 "APT1608SURCK" H 9100 4700 60  0001 C CNN "MFP"
F 6 "digikey" H 9100 4700 60  0001 C CNN "D1"
F 7 "mouser" H 9100 4700 60  0001 C CNN "D2"
F 8 "754-1123" H 9100 4700 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/APT1608SURCK/754-1123-1-ND/1747840" H 9100 4700 60  0001 C CNN "D1PL"
F 10 "_" H 9100 4700 60  0001 C CNN "D2PN"
F 11 "_" H 9100 4700 60  0001 C CNN "D2PL"
F 12 "_" H 9100 4700 60  0001 C CNN "Package"
F 13 "_" H 9100 4700 60  0000 C CNN "Description"
F 14 "_" H 9100 4700 60  0001 C CNN "Voltage"
F 15 "_" H 9100 4700 60  0001 C CNN "Power"
F 16 "_" H 9100 4700 60  0001 C CNN "Tolerance"
F 17 "_" H 9100 4700 60  0001 C CNN "Temperature"
F 18 "_" H 9100 4700 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9100 4700 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9100 4700 60  0001 C CNN "Cont.Current"
F 21 "_" H 9100 4700 60  0001 C CNN "Frequency"
F 22 "_" H 9100 4700 60  0001 C CNN "ResonnanceFreq"
	1    9100 4700
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X03 P2
U 1 1 5730DEE7
P 9150 5150
F 0 "P2" H 9228 5191 50  0000 L CNN
F 1 "CONN_01X03" H 9228 5100 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x03" H 9227 5107 50  0001 L CNN
F 3 "" H 9150 5150 50  0000 C CNN
F 4 "_" H 9150 5150 60  0001 C CNN "MFN"
F 5 "_" H 9150 5150 60  0001 C CNN "MFP"
F 6 "digikey" H 9150 5150 60  0001 C CNN "D1"
F 7 "mouser" H 9150 5150 60  0001 C CNN "D2"
F 8 "_" H 9150 5150 60  0001 C CNN "D1PN"
F 9 "_" H 9150 5150 60  0001 C CNN "D1PL"
F 10 "_" H 9150 5150 60  0001 C CNN "D2PN"
F 11 "_" H 9150 5150 60  0001 C CNN "D2PL"
F 12 "_" H 9150 5150 60  0001 C CNN "Package"
F 13 "_" H 9228 5054 60  0001 L CNN "Description"
F 14 "_" H 9150 5150 60  0001 C CNN "Voltage"
F 15 "_" H 9150 5150 60  0001 C CNN "Power"
F 16 "_" H 9150 5150 60  0001 C CNN "Tolerance"
F 17 "_" H 9150 5150 60  0001 C CNN "Temperature"
F 18 "_" H 9150 5150 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9150 5150 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9150 5150 60  0001 C CNN "Cont.Current"
F 21 "_" H 9150 5150 60  0001 C CNN "Frequency"
F 22 "_" H 9150 5150 60  0001 C CNN "ResonnanceFreq"
	1    9150 5150
	1    0    0    -1  
$EndComp
Text GLabel 8950 5050 0    60   Input ~ 0
IMU_TX
Text GLabel 8950 5150 0    60   Input ~ 0
IMU_RX
$Comp
L GND #PWR07
U 1 1 5730DF48
P 8850 5350
F 0 "#PWR07" H 8850 5100 50  0001 C CNN
F 1 "GND" H 8855 5177 50  0000 C CNN
F 2 "" H 8850 5350 50  0000 C CNN
F 3 "" H 8850 5350 50  0000 C CNN
	1    8850 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	8850 5350 8850 5250
Wire Wire Line
	8850 5250 8950 5250
Text GLabel 3000 5300 2    60   Input ~ 0
3V
$Comp
L TPS79318-EP U1
U 1 1 5730F16A
P 2150 5400
F 0 "U1" H 2150 5923 50  0000 C CNN
F 1 "MIC5365-3.0YC5-TR" H 2150 5832 50  0000 C CNN
F 2 "SOT-23-5" H 2150 5923 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/mic5365.pdf" H 2150 5832 50  0001 C CNN
F 4 "Microchip" H 2150 5400 60  0001 C CNN "MFN"
F 5 "MIC5365-3.0YC5-TR" H 2150 5400 60  0001 C CNN "MFP"
F 6 "digikey" H 2150 5400 60  0001 C CNN "D1"
F 7 "mouser" H 2150 5400 60  0001 C CNN "D2"
F 8 "576-3191" H 2150 5400 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/vishay-dale/CRCW0603200RFKEAHP/541-200SCT-ND/5326826" H 2150 5400 60  0001 C CNN "D1PL"
F 10 "_" H 2150 5400 60  0001 C CNN "D2PN"
F 11 "_" H 2150 5400 60  0001 C CNN "D2PL"
F 12 "_" H 2150 5400 60  0001 C CNN "Package"
F 13 "_" H 2150 5733 60  0000 C CNN "Description"
F 14 "_" H 2150 5400 60  0001 C CNN "Voltage"
F 15 "_" H 2150 5400 60  0001 C CNN "Power"
F 16 "_" H 2150 5400 60  0001 C CNN "Tolerance"
F 17 "_" H 2150 5400 60  0001 C CNN "Temperature"
F 18 "_" H 2150 5400 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2150 5400 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2150 5400 60  0001 C CNN "Cont.Current"
F 21 "_" H 2150 5400 60  0001 C CNN "Frequency"
F 22 "_" H 2150 5400 60  0001 C CNN "ResonnanceFreq"
	1    2150 5400
	1    0    0    -1  
$EndComp
NoConn ~ 2650 5500
Wire Wire Line
	2650 5300 3000 5300
Wire Wire Line
	1200 5500 1650 5500
Wire Wire Line
	1200 5250 1200 5500
Wire Wire Line
	1000 5300 1650 5300
Connection ~ 1200 5300
$Comp
L +3V3 #PWR08
U 1 1 5730F2D2
P 1200 5250
F 0 "#PWR08" H 1200 5100 50  0001 C CNN
F 1 "+3V3" H 1215 5423 50  0000 C CNN
F 2 "" H 1200 5250 50  0000 C CNN
F 3 "" H 1200 5250 50  0000 C CNN
	1    1200 5250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 5730F2FB
P 2150 5800
F 0 "#PWR09" H 2150 5550 50  0001 C CNN
F 1 "GND" H 2155 5627 50  0000 C CNN
F 2 "" H 2150 5800 50  0000 C CNN
F 3 "" H 2150 5800 50  0000 C CNN
	1    2150 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 5700 2150 5800
Connection ~ 2900 5300
Wire Wire Line
	1000 5600 1000 5750
Wire Wire Line
	1000 5750 2900 5750
Connection ~ 2150 5750
Wire Wire Line
	2900 5750 2900 5600
Text GLabel 5650 2250 2    60   Input ~ 0
3V
$Comp
L TXB0106PWR U2
U 1 1 57310454
P 5050 3050
F 0 "U2" H 5025 4349 60  0000 C CNN
F 1 "TXB0106PWR" H 5025 4243 60  0000 C CNN
F 2 "Housings_SSOP:TSSOP-16_4.4x5mm_Pitch0.65mm" H 5025 4137 60  0000 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/txb0106.pdf" H 5050 3050 60  0001 C CNN
F 4 "Texas Instruments" H 5050 3050 60  0001 C CNN "MFN"
F 5 "TXB0106PWR" H 5050 3050 60  0001 C CNN "MFP"
F 6 "digikey" H 5050 3050 60  0001 C CNN "D1"
F 7 "mouser" H 5050 3050 60  0001 C CNN "D2"
F 8 "296-23759" H 5050 3050 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/texas-instruments/TXB0106PWR/296-23759-2-ND/1951119" H 5050 3050 60  0001 C CNN "D1PL"
F 10 "_" H 5050 3050 60  0001 C CNN "D2PN"
F 11 "_" H 5050 3050 60  0001 C CNN "D2PL"
F 12 "_" H 5050 3050 60  0001 C CNN "Package"
F 13 "_" H 5025 4031 60  0000 C CNN "Description"
F 14 "_" H 5050 3050 60  0001 C CNN "Voltage"
F 15 "_" H 5050 3050 60  0001 C CNN "Power"
F 16 "_" H 5050 3050 60  0001 C CNN "Tolerance"
F 17 "_" H 5050 3050 60  0001 C CNN "Temperature"
F 18 "_" H 5050 3050 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 5050 3050 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 5050 3050 60  0001 C CNN "Cont.Current"
F 21 "_" H 5050 3050 60  0001 C CNN "Frequency"
F 22 "_" H 5050 3050 60  0001 C CNN "ResonnanceFreq"
	1    5050 3050
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR010
U 1 1 57310832
P 4400 2250
F 0 "#PWR010" H 4400 2100 50  0001 C CNN
F 1 "+2V5" H 4415 2423 50  0000 C CNN
F 2 "" H 4400 2250 50  0000 C CNN
F 3 "" H 4400 2250 50  0000 C CNN
	1    4400 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2250 4550 2250
Wire Wire Line
	5650 2250 5500 2250
Text GLabel 5500 2750 2    60   Input ~ 0
IMU_TARE
Text GLabel 5500 3150 2    60   Input ~ 0
IMU_RST#
Text GLabel 5500 3050 2    60   Input ~ 0
IMU_RX
Text GLabel 5500 2950 2    60   Input ~ 0
IMU_TX
Text GLabel 5500 2850 2    60   Input ~ 0
IMU_SYNC_OUT
$Comp
L GND #PWR011
U 1 1 57310C00
P 5150 4150
F 0 "#PWR011" H 5150 3900 50  0001 C CNN
F 1 "GND" H 5155 3977 50  0000 C CNN
F 2 "" H 5150 4150 50  0000 C CNN
F 3 "" H 5150 4150 50  0000 C CNN
	1    5150 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 4150 5150 3950
Text GLabel 1750 2300 0    60   Input ~ 0
IMU_TARE_2V5
Text GLabel 1750 2700 0    60   Input ~ 0
IMU_RST#_2V5
Text GLabel 1750 2600 0    60   Input ~ 0
IMU_RX_2V5
Text GLabel 1750 2500 0    60   Input ~ 0
IMU_TX_2V5
Text GLabel 1750 2400 0    60   Input ~ 0
IMU_SYNC_OUT_2V5
Text GLabel 8900 4700 0    60   Input ~ 0
FPGA_Signal1
Text GLabel 8900 4350 0    60   Input ~ 0
FPGA_Signal2
$Comp
L R R1
U 1 1 573112D6
P 9450 4350
F 0 "R1" V 9350 4250 50  0000 C CNN
F 1 "200" V 9350 4500 50  0000 C CNN
F 2 "Dipoles_SMD:R_0603" H 9520 4358 50  0001 L CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 9520 4312 50  0001 L CNN
F 4 "Vishay" H 9450 4350 60  0001 C CNN "MFN"
F 5 "CRCW0603200RFKEAHP" H 9450 4350 60  0001 C CNN "MFP"
F 6 "digikey" H 9450 4350 60  0001 C CNN "D1"
F 7 "mouser" H 9450 4350 60  0001 C CNN "D2"
F 8 "541-200S" H 9450 4350 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/vishay-dale/CRCW0603200RFKEAHP/541-200SCT-ND/5326826" H 9450 4350 60  0001 C CNN "D1PL"
F 10 "_" H 9450 4350 60  0001 C CNN "D2PN"
F 11 "_" H 9450 4350 60  0001 C CNN "D2PL"
F 12 "0603" H 9450 4350 60  0001 C CNN "Package"
F 13 "_" V 9327 4350 60  0000 C CNN "Description"
F 14 "_" H 9450 4350 60  0001 C CNN "Voltage"
F 15 "1/4" H 9450 4350 60  0001 C CNN "Power"
F 16 "1%" H 9450 4350 60  0001 C CNN "Tolerance"
F 17 "_" H 9450 4350 60  0001 C CNN "Temperature"
F 18 "_" H 9450 4350 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9450 4350 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9450 4350 60  0001 C CNN "Cont.Current"
F 21 "_" H 9450 4350 60  0001 C CNN "Frequency"
F 22 "_" H 9450 4350 60  0001 C CNN "ResonnanceFreq"
	1    9450 4350
	0    1    1    0   
$EndComp
$Comp
L +2V5 #PWR012
U 1 1 573123AE
P 9800 4350
F 0 "#PWR012" H 9800 4200 50  0001 C CNN
F 1 "+2V5" H 9815 4523 50  0000 C CNN
F 2 "" H 9800 4350 50  0000 C CNN
F 3 "" H 9800 4350 50  0000 C CNN
	1    9800 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 4350 9600 4350
Wire Wire Line
	9800 4350 9800 4700
Wire Wire Line
	9800 4700 9600 4700
NoConn ~ 4550 3250
NoConn ~ 5500 3250
Wire Wire Line
	4550 2550 4400 2550
Wire Wire Line
	4400 2550 4400 2250
$Comp
L C C2
U 1 1 57313A6F
P 2900 5450
F 0 "C2" H 3015 5549 50  0000 L CNN
F 1 "1u" H 3015 5458 50  0000 L CNN
F 2 "Dipoles_SMD:C_0603" H 2938 5300 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 2900 5450 50  0001 C CNN
F 4 "TDK" H 2900 5450 60  0001 C CNN "MFN"
F 5 "C1608X6S0J105K080AC" H 2900 5450 60  0001 C CNN "MFP"
F 6 "digikey" H 2900 5450 60  0001 C CNN "D1"
F 7 "mouser" H 2900 5450 60  0001 C CNN "D2"
F 8 "445-14193" H 2900 5450 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/tdk-corporation/C1608X6S0J105K080AC/445-14193-1-ND/3955859" H 2900 5450 60  0001 C CNN "D1PL"
F 10 "_" H 2900 5450 60  0001 C CNN "D2PN"
F 11 "_" H 2900 5450 60  0001 C CNN "D2PL"
F 12 "0603" H 2900 5450 60  0001 C CNN "Package"
F 13 "_" H 3015 5359 60  0000 L CNN "Description"
F 14 "6.3" H 2900 5450 60  0001 C CNN "Voltage"
F 15 "_" H 2900 5450 60  0001 C CNN "Power"
F 16 "10%" H 2900 5450 60  0001 C CNN "Tolerance"
F 17 "_" H 2900 5450 60  0001 C CNN "Temperature"
F 18 "_" H 2900 5450 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2900 5450 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2900 5450 60  0001 C CNN "Cont.Current"
F 21 "_" H 2900 5450 60  0001 C CNN "Frequency"
F 22 "_" H 2900 5450 60  0001 C CNN "ResonnanceFreq"
	1    2900 5450
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X12 P1
U 1 1 5731597E
P 1950 2350
F 0 "P1" H 2028 2444 50  0000 L CNN
F 1 "CONN_01X12" H 2028 2353 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x12" H 2027 2307 50  0001 L CNN
F 3 "" H 1950 2350 50  0000 C CNN
F 4 "_" H 1950 2350 60  0001 C CNN "MFN"
F 5 "_" H 1950 2350 60  0001 C CNN "MFP"
F 6 "digikey" H 1950 2350 60  0001 C CNN "D1"
F 7 "mouser" H 1950 2350 60  0001 C CNN "D2"
F 8 "_" H 1950 2350 60  0001 C CNN "D1PN"
F 9 "_" H 1950 2350 60  0001 C CNN "D1PL"
F 10 "_" H 1950 2350 60  0001 C CNN "D2PN"
F 11 "_" H 1950 2350 60  0001 C CNN "D2PL"
F 12 "_" H 1950 2350 60  0001 C CNN "Package"
F 13 "_" H 2028 2254 60  0000 L CNN "Description"
F 14 "_" H 1950 2350 60  0001 C CNN "Voltage"
F 15 "_" H 1950 2350 60  0001 C CNN "Power"
F 16 "_" H 1950 2350 60  0001 C CNN "Tolerance"
F 17 "_" H 1950 2350 60  0001 C CNN "Temperature"
F 18 "_" H 1950 2350 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 1950 2350 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 1950 2350 60  0001 C CNN "Cont.Current"
F 21 "_" H 1950 2350 60  0001 C CNN "Frequency"
F 22 "_" H 1950 2350 60  0001 C CNN "ResonnanceFreq"
	1    1950 2350
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 1650 1600 1800
Wire Wire Line
	1600 1800 1750 1800
Wire Wire Line
	1750 1900 1400 1900
Wire Wire Line
	1400 1900 1400 1650
Wire Wire Line
	1200 1650 1200 2000
Wire Wire Line
	1200 2000 1750 2000
Wire Wire Line
	1750 2800 1200 2800
Wire Wire Line
	1200 2800 1200 3100
Wire Wire Line
	1200 2900 1750 2900
Connection ~ 1200 2900
$Comp
L GND #PWR013
U 1 1 57315D32
P 1200 3100
F 0 "#PWR013" H 1200 2850 50  0001 C CNN
F 1 "GND" H 1205 2927 50  0000 C CNN
F 2 "" H 1200 3100 50  0000 C CNN
F 3 "" H 1200 3100 50  0000 C CNN
	1    1200 3100
	1    0    0    -1  
$EndComp
Text GLabel 1750 2100 0    60   Input ~ 0
FPGA_Signal1
Text GLabel 1750 2200 0    60   Input ~ 0
FPGA_Signal2
$Comp
L C C1
U 1 1 573212F3
P 1000 5450
F 0 "C1" H 1115 5549 50  0000 L CNN
F 1 "1u" H 1115 5458 50  0000 L CNN
F 2 "Dipoles_SMD:C_0603" H 1038 5300 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 1000 5450 50  0001 C CNN
F 4 "TDK" H 1000 5450 60  0001 C CNN "MFN"
F 5 "C1608X6S0J105K080AC" H 1000 5450 60  0001 C CNN "MFP"
F 6 "digikey" H 1000 5450 60  0001 C CNN "D1"
F 7 "mouser" H 1000 5450 60  0001 C CNN "D2"
F 8 "445-14193" H 1000 5450 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/tdk-corporation/C1608X6S0J105K080AC/445-14193-1-ND/3955859" H 1000 5450 60  0001 C CNN "D1PL"
F 10 "_" H 1000 5450 60  0001 C CNN "D2PN"
F 11 "_" H 1000 5450 60  0001 C CNN "D2PL"
F 12 "0603" H 1000 5450 60  0001 C CNN "Package"
F 13 "_" H 1115 5359 60  0000 L CNN "Description"
F 14 "6.3" H 1000 5450 60  0001 C CNN "Voltage"
F 15 "_" H 1000 5450 60  0001 C CNN "Power"
F 16 "10%" H 1000 5450 60  0001 C CNN "Tolerance"
F 17 "_" H 1000 5450 60  0001 C CNN "Temperature"
F 18 "_" H 1000 5450 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 1000 5450 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 1000 5450 60  0001 C CNN "Cont.Current"
F 21 "_" H 1000 5450 60  0001 C CNN "Frequency"
F 22 "_" H 1000 5450 60  0001 C CNN "ResonnanceFreq"
	1    1000 5450
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 57321A9B
P 9450 4700
F 0 "R2" V 9350 4600 50  0000 C CNN
F 1 "200" V 9350 4850 50  0000 C CNN
F 2 "Dipoles_SMD:R_0603" H 9520 4708 50  0001 L CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 9520 4662 50  0001 L CNN
F 4 "Vishay" H 9450 4700 60  0001 C CNN "MFN"
F 5 "CRCW0603200RFKEAHP" H 9450 4700 60  0001 C CNN "MFP"
F 6 "digikey" H 9450 4700 60  0001 C CNN "D1"
F 7 "mouser" H 9450 4700 60  0001 C CNN "D2"
F 8 "541-200S" H 9450 4700 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/vishay-dale/CRCW0603200RFKEAHP/541-200SCT-ND/5326826" H 9450 4700 60  0001 C CNN "D1PL"
F 10 "_" H 9450 4700 60  0001 C CNN "D2PN"
F 11 "_" H 9450 4700 60  0001 C CNN "D2PL"
F 12 "0603" H 9450 4700 60  0001 C CNN "Package"
F 13 "_" V 9327 4700 60  0000 C CNN "Description"
F 14 "_" H 9450 4700 60  0001 C CNN "Voltage"
F 15 "1/4" H 9450 4700 60  0001 C CNN "Power"
F 16 "1%" H 9450 4700 60  0001 C CNN "Tolerance"
F 17 "_" H 9450 4700 60  0001 C CNN "Temperature"
F 18 "_" H 9450 4700 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9450 4700 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9450 4700 60  0001 C CNN "Cont.Current"
F 21 "_" H 9450 4700 60  0001 C CNN "Frequency"
F 22 "_" H 9450 4700 60  0001 C CNN "ResonnanceFreq"
	1    9450 4700
	0    1    1    0   
$EndComp
$EndSCHEMATC
