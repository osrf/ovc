EESchema Schematic File Version 2
LIBS:power
LIBS:device
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
LIBS:HarleyConnect1Bro-cache
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
Text Notes 1350 1750 0    60   ~ 12
Connector main board
Text Notes 5400 1750 0    60   ~ 12
Connector next bro
$Comp
L +5V #PWR01
U 1 1 56BACE21
P 2850 4700
F 0 "#PWR01" H 2850 4550 50  0001 C CNN
F 1 "+5V" H 2868 4874 50  0000 C CNN
F 2 "" H 2850 4700 50  0000 C CNN
F 3 "" H 2850 4700 50  0000 C CNN
	1    2850 4700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 56BACE27
P 2750 2400
F 0 "#PWR02" H 2750 2150 50  0001 C CNN
F 1 "GND" H 2758 2226 50  0000 C CNN
F 2 "" H 2750 2400 50  0000 C CNN
F 3 "" H 2750 2400 50  0000 C CNN
	1    2750 2400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 56BACE2D
P 1250 5250
F 0 "#PWR03" H 1250 5000 50  0001 C CNN
F 1 "GND" H 1258 5076 50  0000 C CNN
F 2 "" H 1250 5250 50  0000 C CNN
F 3 "" H 1250 5250 50  0000 C CNN
	1    1250 5250
	1    0    0    -1  
$EndComp
Text GLabel 2050 2200 0    60   Input ~ 0
P_LVDS1-
Text GLabel 2050 2300 0    60   Input ~ 0
P_LVDS1+
Text GLabel 2050 2500 0    60   Input ~ 0
P_LVDS2-
Text GLabel 2050 2600 0    60   Input ~ 0
P_LVDS2+
Text GLabel 2550 2800 2    60   Input ~ 0
P_LVDS3-
Text GLabel 2550 2900 2    60   Input ~ 0
P_LVDS3+
Text GLabel 2550 3100 2    60   Input ~ 0
P_LVDS4-
Text GLabel 2550 3200 2    60   Input ~ 0
P_LVDS4+
Text GLabel 2550 3400 2    60   Input ~ 0
P_LVDS5-
Text GLabel 2550 3500 2    60   Input ~ 0
P_LVDS5+
Text GLabel 2550 3700 2    60   Input ~ 0
P_LVDS6-
Text GLabel 2550 3800 2    60   Input ~ 0
P_LVDS6+
Text GLabel 2050 4000 0    60   Input ~ 0
P_LVDS7-
Text GLabel 2050 4100 0    60   Input ~ 0
P_LVDS7+
Text GLabel 2050 4300 0    60   Input ~ 0
P_LVDS8-
Text GLabel 2050 4400 0    60   Input ~ 0
P_LVDS8+
Text GLabel 2050 5000 0    60   Input ~ 0
P_LVDS9-
Text GLabel 2050 4900 0    60   Input ~ 0
P_LVDS9+
Text GLabel 2050 4700 0    60   Input ~ 0
P_LVDS10-
Text GLabel 2050 4600 0    60   Input ~ 0
P_LVDS10+
Text GLabel 2050 2800 0    60   Input ~ 0
P_LVDS11-
Text GLabel 2050 2900 0    60   Input ~ 0
P_LVDS11+
Text GLabel 2050 3100 0    60   Input ~ 0
P_LVDS12-
Text GLabel 2050 3200 0    60   Input ~ 0
P_LVDS12+
Text GLabel 2550 4100 2    60   Input ~ 0
FPGA_SS_INIT_B
Text GLabel 2550 4300 2    60   Input ~ 0
FPGA_SS_DONE
Text GLabel 2550 4200 2    60   Input ~ 0
FPGA_SS_PROGRAM_B
Text GLabel 2550 3900 2    60   Input ~ 0
FPGA_SS_CCLK
Text GLabel 2550 4400 2    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 2050 3400 0    60   Input ~ 0
P_LVDS13-
Text GLabel 2050 3500 0    60   Input ~ 0
P_LVDS13+
Text GLabel 2050 3700 0    60   Input ~ 0
P_LVDS14-
Text GLabel 2050 3800 0    60   Input ~ 0
P_LVDS14+
Wire Wire Line
	2550 4500 2550 5100
Wire Wire Line
	2550 4700 2850 4700
Wire Wire Line
	2550 2400 3350 2400
Wire Wire Line
	2050 2400 1250 2400
Wire Wire Line
	1250 2400 1250 5250
Wire Wire Line
	2050 2700 1250 2700
Wire Wire Line
	2050 3000 1250 3000
Wire Wire Line
	2050 3300 1250 3300
Wire Wire Line
	2050 3600 1250 3600
Wire Wire Line
	2050 3900 1250 3900
Wire Wire Line
	1250 4200 2050 4200
Wire Wire Line
	2050 4500 1250 4500
Wire Wire Line
	2050 4800 1250 4800
Wire Wire Line
	2050 5100 1250 5100
Wire Wire Line
	2550 2200 2550 2700
Wire Wire Line
	2550 3300 3350 3300
Wire Wire Line
	2550 3000 3350 3000
Connection ~ 2550 5000
Connection ~ 2550 4900
Connection ~ 2550 4800
Connection ~ 2550 4700
Connection ~ 2550 2300
Connection ~ 2550 2400
Connection ~ 2550 2500
Connection ~ 2550 2600
Connection ~ 2550 4600
Connection ~ 1250 2700
Connection ~ 1250 3000
Connection ~ 1250 3300
Connection ~ 1250 3600
Connection ~ 1250 3900
Connection ~ 1250 4200
Connection ~ 1250 4500
Connection ~ 1250 4800
Connection ~ 1250 5100
Connection ~ 3350 3300
Connection ~ 3350 3000
Connection ~ 2750 2400
Wire Wire Line
	2550 3600 3350 3600
Wire Wire Line
	3350 3600 3350 2400
Text GLabel 2550 4000 2    60   Input ~ 0
FPGA_SS_DIN
$Comp
L +5V #PWR04
U 1 1 56BACF79
P 6600 4650
F 0 "#PWR04" H 6600 4500 50  0001 C CNN
F 1 "+5V" H 6618 4824 50  0000 C CNN
F 2 "" H 6600 4650 50  0000 C CNN
F 3 "" H 6600 4650 50  0000 C CNN
	1    6600 4650
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 56BACF7F
P 6500 2350
F 0 "#PWR05" H 6500 2100 50  0001 C CNN
F 1 "GND" H 6508 2176 50  0000 C CNN
F 2 "" H 6500 2350 50  0000 C CNN
F 3 "" H 6500 2350 50  0000 C CNN
	1    6500 2350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 56BACF85
P 5000 5200
F 0 "#PWR06" H 5000 4950 50  0001 C CNN
F 1 "GND" H 5008 5026 50  0000 C CNN
F 2 "" H 5000 5200 50  0000 C CNN
F 3 "" H 5000 5200 50  0000 C CNN
	1    5000 5200
	1    0    0    -1  
$EndComp
Text GLabel 5800 2150 0    60   Input ~ 0
P_LVDS1-
Text GLabel 5800 2250 0    60   Input ~ 0
P_LVDS1+
Text GLabel 5800 2450 0    60   Input ~ 0
P_LVDS2-
Text GLabel 5800 2550 0    60   Input ~ 0
P_LVDS2+
Text GLabel 5800 2750 0    60   Input ~ 0
P_LVDS3-
Text GLabel 5800 2850 0    60   Input ~ 0
P_LVDS3+
Text GLabel 5800 3050 0    60   Input ~ 0
P_LVDS4-
Text GLabel 5800 3150 0    60   Input ~ 0
P_LVDS4+
Text GLabel 5800 3350 0    60   Input ~ 0
P_LVDS5-
Text GLabel 5800 3450 0    60   Input ~ 0
P_LVDS5+
Text GLabel 5800 3650 0    60   Input ~ 0
P_LVDS6-
Text GLabel 5800 3750 0    60   Input ~ 0
P_LVDS6+
Text GLabel 5800 3950 0    60   Input ~ 0
P_LVDS7-
Text GLabel 5800 4050 0    60   Input ~ 0
P_LVDS7+
Text GLabel 5800 4250 0    60   Input ~ 0
P_LVDS8-
Text GLabel 5800 4350 0    60   Input ~ 0
P_LVDS8+
Text GLabel 5800 4550 0    60   Input ~ 0
P_LVDS9-
Text GLabel 5800 4650 0    60   Input ~ 0
P_LVDS9+
Text GLabel 5800 4850 0    60   Input ~ 0
P_LVDS10-
Text GLabel 5800 4950 0    60   Input ~ 0
P_LVDS10+
Text GLabel 6300 2750 2    60   Input ~ 0
P_LVDS11-
Text GLabel 6300 2850 2    60   Input ~ 0
P_LVDS11+
Text GLabel 6300 3050 2    60   Input ~ 0
P_LVDS12-
Text GLabel 6300 3150 2    60   Input ~ 0
P_LVDS12+
Text GLabel 6300 4050 2    60   Input ~ 0
FPGA_SS_INIT_B
Text GLabel 6300 4250 2    60   Input ~ 0
FPGA_SS_DONE
Text GLabel 6300 4150 2    60   Input ~ 0
FPGA_SS_PROGRAM_B
Text GLabel 6300 3850 2    60   Input ~ 0
FPGA_SS_CCLK
Text GLabel 6300 4350 2    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 6300 3350 2    60   Input ~ 0
P_LVDS13-
Text GLabel 6300 3450 2    60   Input ~ 0
P_LVDS13+
Text GLabel 6300 3650 2    60   Input ~ 0
P_LVDS14-
Text GLabel 6300 3750 2    60   Input ~ 0
P_LVDS14+
Wire Wire Line
	6300 4450 6300 5050
Wire Wire Line
	6300 4650 6600 4650
Wire Wire Line
	6300 2350 7100 2350
Wire Wire Line
	5800 2350 5000 2350
Wire Wire Line
	5000 2350 5000 5200
Wire Wire Line
	5800 2650 5000 2650
Wire Wire Line
	5800 2950 5000 2950
Wire Wire Line
	5800 3250 5000 3250
Wire Wire Line
	5800 3550 5000 3550
Wire Wire Line
	5800 3850 5000 3850
Wire Wire Line
	5000 4150 5800 4150
Wire Wire Line
	5800 4450 5000 4450
Wire Wire Line
	5800 4750 5000 4750
Wire Wire Line
	5800 5050 5000 5050
Wire Wire Line
	6300 2150 6300 2650
Wire Wire Line
	6300 3250 7100 3250
Wire Wire Line
	6300 2950 7100 2950
Connection ~ 6300 4950
Connection ~ 6300 4850
Connection ~ 6300 4750
Connection ~ 6300 4650
Connection ~ 6300 2250
Connection ~ 6300 2350
Connection ~ 6300 2450
Connection ~ 6300 2550
Connection ~ 6300 4550
Connection ~ 5000 2650
Connection ~ 5000 2950
Connection ~ 5000 3250
Connection ~ 5000 3550
Connection ~ 5000 3850
Connection ~ 5000 4150
Connection ~ 5000 4450
Connection ~ 5000 4750
Connection ~ 5000 5050
Connection ~ 7100 3250
Connection ~ 7100 2950
Connection ~ 6500 2350
Wire Wire Line
	6300 3550 7100 3550
Wire Wire Line
	7100 3550 7100 2350
Text GLabel 6300 3950 2    60   Input ~ 0
FPGA_SS_DIN
$Comp
L CONN_02X30 J1
U 1 1 56BAD293
P 2300 3650
F 0 "J1" H 2300 5316 50  0000 C CNN
F 1 "DF40HC(4.0)-60DS-0.4V(51)" H 2300 5224 50  0000 C CNN
F 2 "Hirose:DF40C_60DS_0-4V" H 2300 3150 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 2300 3150 50  0001 C CNN
F 4 "Hirose" H 2300 3650 60  0001 C CNN "MFN"
F 5 "DF40HC(4.0)-60DS-0.4V(51)" H 2300 3650 60  0001 C CNN "MFP"
F 6 "digikey" H 2300 3650 60  0001 C CNN "D1"
F 7 "mouser" H 2300 3650 60  0001 C CNN "D2"
F 8 "H11918" H 2300 3650 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40HC%284.0%29-60DS-0.4V%2851%29/H11918CT-ND/2530300" H 2300 3650 60  0001 C CNN "D1PL"
F 10 "_" H 2300 3650 60  0001 C CNN "D2PN"
F 11 "_" H 2300 3650 60  0001 C CNN "D2PL"
F 12 "_" H 2300 3650 60  0001 C CNN "Package"
F 13 "_" H 2300 3650 60  0000 C CNN "Description"
F 14 "_" H 2300 3650 60  0001 C CNN "Voltage"
F 15 "_" H 2300 3650 60  0001 C CNN "Power"
F 16 "_" H 2300 3650 60  0001 C CNN "Tolerance"
F 17 "_" H 2300 3650 60  0001 C CNN "Temperature"
F 18 "_" H 2300 3650 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2300 3650 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2300 3650 60  0001 C CNN "Cont.Current"
F 21 "_" H 2300 3650 60  0001 C CNN "Frequency"
F 22 "_" H 2300 3650 60  0001 C CNN "ResonnanceFreq"
	1    2300 3650
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X30 J2
U 1 1 56BAD2B1
P 6050 3600
F 0 "J2" H 6050 5266 50  0000 C CNN
F 1 "DF40HC(4.0)-60DS-0.4V(51)" H 6050 5174 50  0000 C CNN
F 2 "Hirose:DF40C_60DS_0-4V" H 6050 3100 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 6050 3100 50  0001 C CNN
F 4 "Hirose" H 6050 3600 60  0001 C CNN "MFN"
F 5 "DF40HC(4.0)-60DS-0.4V(51)" H 6050 3600 60  0001 C CNN "MFP"
F 6 "digikey" H 6050 3600 60  0001 C CNN "D1"
F 7 "mouser" H 6050 3600 60  0001 C CNN "D2"
F 8 "H11918" H 6050 3600 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40HC%284.0%29-60DS-0.4V%2851%29/H11918CT-ND/2530300" H 6050 3600 60  0001 C CNN "D1PL"
F 10 "_" H 6050 3600 60  0001 C CNN "D2PN"
F 11 "_" H 6050 3600 60  0001 C CNN "D2PL"
F 12 "_" H 6050 3600 60  0001 C CNN "Package"
F 13 "_" H 6050 3600 60  0000 C CNN "Description"
F 14 "_" H 6050 3600 60  0001 C CNN "Voltage"
F 15 "_" H 6050 3600 60  0001 C CNN "Power"
F 16 "_" H 6050 3600 60  0001 C CNN "Tolerance"
F 17 "_" H 6050 3600 60  0001 C CNN "Temperature"
F 18 "_" H 6050 3600 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 6050 3600 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 6050 3600 60  0001 C CNN "Cont.Current"
F 21 "_" H 6050 3600 60  0001 C CNN "Frequency"
F 22 "_" H 6050 3600 60  0001 C CNN "ResonnanceFreq"
	1    6050 3600
	1    0    0    -1  
$EndComp
$EndSCHEMATC
