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
P 1600 4700
F 0 "#PWR01" H 1600 4550 50  0001 C CNN
F 1 "+5V" H 1618 4874 50  0000 C CNN
F 2 "" H 1600 4700 50  0000 C CNN
F 3 "" H 1600 4700 50  0000 C CNN
	1    1600 4700
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 56BACE27
P 1700 2400
F 0 "#PWR02" H 1700 2150 50  0001 C CNN
F 1 "GND" H 1708 2226 50  0000 C CNN
F 2 "" H 1700 2400 50  0000 C CNN
F 3 "" H 1700 2400 50  0000 C CNN
	1    1700 2400
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 56BACE2D
P 3200 5250
F 0 "#PWR03" H 3200 5000 50  0001 C CNN
F 1 "GND" H 3208 5076 50  0000 C CNN
F 2 "" H 3200 5250 50  0000 C CNN
F 3 "" H 3200 5250 50  0000 C CNN
	1    3200 5250
	-1   0    0    -1  
$EndComp
Text GLabel 2400 2300 2    60   Input ~ 0
P_LVDS1-
Text GLabel 2400 2200 2    60   Input ~ 0
P_LVDS1+
Text GLabel 2400 2500 2    60   Input ~ 0
P_LVDS2-
Text GLabel 2400 2600 2    60   Input ~ 0
P_LVDS2+
Text GLabel 1900 2800 0    60   Input ~ 0
P_LVDS3-
Text GLabel 1900 2900 0    60   Input ~ 0
P_LVDS3+
Text GLabel 1900 3100 0    60   Input ~ 0
P_LVDS4-
Text GLabel 1900 3200 0    60   Input ~ 0
P_LVDS4+
Text GLabel 1900 3400 0    60   Input ~ 0
P_LVDS5-
Text GLabel 1900 3500 0    60   Input ~ 0
P_LVDS5+
Text GLabel 1900 3700 0    60   Input ~ 0
P_LVDS6-
Text GLabel 1900 3800 0    60   Input ~ 0
P_LVDS6+
Text GLabel 2400 4000 2    60   Input ~ 0
P_LVDS7-
Text GLabel 2400 4100 2    60   Input ~ 0
P_LVDS7+
Text GLabel 2400 4300 2    60   Input ~ 0
P_LVDS8-
Text GLabel 2400 4400 2    60   Input ~ 0
P_LVDS8+
Text GLabel 2400 4700 2    60   Input ~ 0
P_LVDS9-
Text GLabel 2400 4600 2    60   Input ~ 0
P_LVDS9+
Text GLabel 2400 5000 2    60   Input ~ 0
P_LVDS10-
Text GLabel 2400 4900 2    60   Input ~ 0
P_LVDS10+
Text GLabel 2400 2800 2    60   Input ~ 0
P_LVDS11-
Text GLabel 2400 2900 2    60   Input ~ 0
P_LVDS11+
Text GLabel 2400 3100 2    60   Input ~ 0
P_LVDS12-
Text GLabel 2400 3200 2    60   Input ~ 0
P_LVDS12+
Text GLabel 1900 4100 0    60   Input ~ 0
FPGA_SS_INIT_B
Text GLabel 1900 4300 0    60   Input ~ 0
FPGA_SS_DONE
Text GLabel 1900 4200 0    60   Input ~ 0
FPGA_SS_PROGRAM_B
Text GLabel 1900 3900 0    60   Input ~ 0
FPGA_SS_CCLK
Text GLabel 1900 4400 0    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 2400 3400 2    60   Input ~ 0
P_LVDS13-
Text GLabel 2400 3500 2    60   Input ~ 0
P_LVDS13+
Text GLabel 2400 3700 2    60   Input ~ 0
P_LVDS14-
Text GLabel 2400 3800 2    60   Input ~ 0
P_LVDS14+
Wire Wire Line
	1900 4500 1900 5100
Wire Wire Line
	1900 4700 1600 4700
Wire Wire Line
	1900 2400 1100 2400
Wire Wire Line
	2400 2400 3200 2400
Wire Wire Line
	3200 2400 3200 5250
Wire Wire Line
	2400 2700 3200 2700
Wire Wire Line
	2400 3000 3200 3000
Wire Wire Line
	2400 3300 3200 3300
Wire Wire Line
	2400 3600 3200 3600
Wire Wire Line
	2400 3900 3200 3900
Wire Wire Line
	3200 4200 2400 4200
Wire Wire Line
	2400 4500 3200 4500
Wire Wire Line
	2400 4800 3200 4800
Wire Wire Line
	2400 5100 3200 5100
Wire Wire Line
	1900 2200 1900 2700
Wire Wire Line
	1900 3300 1100 3300
Wire Wire Line
	1900 3000 1100 3000
Connection ~ 1900 5000
Connection ~ 1900 4900
Connection ~ 1900 4800
Connection ~ 1900 4700
Connection ~ 1900 2300
Connection ~ 1900 2400
Connection ~ 1900 2500
Connection ~ 1900 2600
Connection ~ 1900 4600
Connection ~ 3200 2700
Connection ~ 3200 3000
Connection ~ 3200 3300
Connection ~ 3200 3600
Connection ~ 3200 3900
Connection ~ 3200 4200
Connection ~ 3200 4500
Connection ~ 3200 4800
Connection ~ 3200 5100
Connection ~ 1100 3300
Connection ~ 1100 3000
Connection ~ 1700 2400
Wire Wire Line
	1900 3600 1100 3600
Wire Wire Line
	1100 3600 1100 2400
Text GLabel 1900 4000 0    60   Input ~ 0
FPGA_SS_DIN
$Comp
L +5V #PWR04
U 1 1 56BACF79
P 5150 4650
F 0 "#PWR04" H 5150 4500 50  0001 C CNN
F 1 "+5V" H 5168 4824 50  0000 C CNN
F 2 "" H 5150 4650 50  0000 C CNN
F 3 "" H 5150 4650 50  0000 C CNN
	1    5150 4650
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 56BACF7F
P 5250 2350
F 0 "#PWR05" H 5250 2100 50  0001 C CNN
F 1 "GND" H 5258 2176 50  0000 C CNN
F 2 "" H 5250 2350 50  0000 C CNN
F 3 "" H 5250 2350 50  0000 C CNN
	1    5250 2350
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 56BACF85
P 6750 5200
F 0 "#PWR06" H 6750 4950 50  0001 C CNN
F 1 "GND" H 6758 5026 50  0000 C CNN
F 2 "" H 6750 5200 50  0000 C CNN
F 3 "" H 6750 5200 50  0000 C CNN
	1    6750 5200
	-1   0    0    -1  
$EndComp
Text GLabel 5950 2150 2    60   Input ~ 0
P_LVDS1-
Text GLabel 5950 2250 2    60   Input ~ 0
P_LVDS1+
Text GLabel 5950 2450 2    60   Input ~ 0
P_LVDS2-
Text GLabel 5950 2550 2    60   Input ~ 0
P_LVDS2+
Text GLabel 5950 2750 2    60   Input ~ 0
P_LVDS3-
Text GLabel 5950 2850 2    60   Input ~ 0
P_LVDS3+
Text GLabel 5950 3050 2    60   Input ~ 0
P_LVDS4-
Text GLabel 5950 3150 2    60   Input ~ 0
P_LVDS4+
Text GLabel 5950 3350 2    60   Input ~ 0
P_LVDS5-
Text GLabel 5950 3450 2    60   Input ~ 0
P_LVDS5+
Text GLabel 5950 3650 2    60   Input ~ 0
P_LVDS6-
Text GLabel 5950 3750 2    60   Input ~ 0
P_LVDS6+
Text GLabel 5950 3950 2    60   Input ~ 0
P_LVDS7-
Text GLabel 5950 4050 2    60   Input ~ 0
P_LVDS7+
Text GLabel 5950 4250 2    60   Input ~ 0
P_LVDS8-
Text GLabel 5950 4350 2    60   Input ~ 0
P_LVDS8+
Text GLabel 5950 4650 2    60   Input ~ 0
P_LVDS9-
Text GLabel 5950 4550 2    60   Input ~ 0
P_LVDS9+
Text GLabel 5950 4850 2    60   Input ~ 0
P_LVDS10-
Text GLabel 5950 4950 2    60   Input ~ 0
P_LVDS10+
Text GLabel 5450 2750 0    60   Input ~ 0
P_LVDS11-
Text GLabel 5450 2850 0    60   Input ~ 0
P_LVDS11+
Text GLabel 5450 3050 0    60   Input ~ 0
P_LVDS12-
Text GLabel 5450 3150 0    60   Input ~ 0
P_LVDS12+
Text GLabel 5450 4050 0    60   Input ~ 0
FPGA_SS_INIT_B
Text GLabel 5450 4250 0    60   Input ~ 0
FPGA_SS_DONE
Text GLabel 5450 4150 0    60   Input ~ 0
FPGA_SS_PROGRAM_B
Text GLabel 5450 3850 0    60   Input ~ 0
FPGA_SS_CCLK
Text GLabel 5450 4350 0    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 5450 3350 0    60   Input ~ 0
P_LVDS13-
Text GLabel 5450 3450 0    60   Input ~ 0
P_LVDS13+
Text GLabel 5450 3650 0    60   Input ~ 0
P_LVDS14-
Text GLabel 5450 3750 0    60   Input ~ 0
P_LVDS14+
Wire Wire Line
	5450 4450 5450 5050
Wire Wire Line
	5450 4650 5150 4650
Wire Wire Line
	5450 2350 4650 2350
Wire Wire Line
	5950 2350 6750 2350
Wire Wire Line
	6750 2350 6750 5200
Wire Wire Line
	5950 2650 6750 2650
Wire Wire Line
	5950 2950 6750 2950
Wire Wire Line
	5950 3250 6750 3250
Wire Wire Line
	5950 3550 6750 3550
Wire Wire Line
	5950 3850 6750 3850
Wire Wire Line
	6750 4150 5950 4150
Wire Wire Line
	5950 4450 6750 4450
Wire Wire Line
	5950 4750 6750 4750
Wire Wire Line
	5950 5050 6750 5050
Wire Wire Line
	5450 2150 5450 2650
Wire Wire Line
	5450 3250 4650 3250
Wire Wire Line
	5450 2950 4650 2950
Connection ~ 5450 4950
Connection ~ 5450 4850
Connection ~ 5450 4750
Connection ~ 5450 4650
Connection ~ 5450 2250
Connection ~ 5450 2350
Connection ~ 5450 2450
Connection ~ 5450 2550
Connection ~ 5450 4550
Connection ~ 6750 2650
Connection ~ 6750 2950
Connection ~ 6750 3250
Connection ~ 6750 3550
Connection ~ 6750 3850
Connection ~ 6750 4150
Connection ~ 6750 4450
Connection ~ 6750 4750
Connection ~ 6750 5050
Connection ~ 4650 3250
Connection ~ 4650 2950
Connection ~ 5250 2350
Wire Wire Line
	5450 3550 4650 3550
Wire Wire Line
	4650 3550 4650 2350
Text GLabel 5450 3950 0    60   Input ~ 0
FPGA_SS_DIN
$Comp
L CONN_02X30 J2
U 1 1 56BAD2B1
P 5700 3600
F 0 "J2" H 5700 5266 50  0000 C CNN
F 1 "DDF40HC(4.0)_60DS_0-4V" H 5700 5174 50  0000 C CNN
F 2 "Hirose:DF40HC(4.0)_60DS_0-4V" H 5700 3100 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 5700 3100 50  0001 C CNN
F 4 "Hirose" H 5700 3600 60  0001 C CNN "MFN"
F 5 "DF40HC(4.0)-60DS-0.4V(51)" H 5700 3600 60  0001 C CNN "MFP"
F 6 "digikey" H 5700 3600 60  0001 C CNN "D1"
F 7 "mouser" H 5700 3600 60  0001 C CNN "D2"
F 8 "H11918" H 5700 3600 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40HC%284.0%29-60DS-0.4V%2851%29/H11918CT-ND/2530300" H 5700 3600 60  0001 C CNN "D1PL"
F 10 "_" H 5700 3600 60  0001 C CNN "D2PN"
F 11 "_" H 5700 3600 60  0001 C CNN "D2PL"
F 12 "_" H 5700 3600 60  0001 C CNN "Package"
F 13 "_" H 5700 3600 60  0000 C CNN "Description"
F 14 "_" H 5700 3600 60  0001 C CNN "Voltage"
F 15 "_" H 5700 3600 60  0001 C CNN "Power"
F 16 "_" H 5700 3600 60  0001 C CNN "Tolerance"
F 17 "_" H 5700 3600 60  0001 C CNN "Temperature"
F 18 "_" H 5700 3600 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 5700 3600 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 5700 3600 60  0001 C CNN "Cont.Current"
F 21 "_" H 5700 3600 60  0001 C CNN "Frequency"
F 22 "_" H 5700 3600 60  0001 C CNN "ResonnanceFreq"
	1    5700 3600
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X30 J1
U 1 1 56BB7E44
P 2150 3650
F 0 "J1" H 2150 5316 50  0000 C CNN
F 1 "DDF40HC(4.0)_60DS_0-4V" H 2150 5224 50  0000 C CNN
F 2 "Hirose:DF40HC(4.0)_60DS_0-4V" H 2150 3150 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 2150 3150 50  0001 C CNN
F 4 "Hirose" H 2150 3650 60  0001 C CNN "MFN"
F 5 "DF40HC(4.0)-60DS-0.4V(51)" H 2150 3650 60  0001 C CNN "MFP"
F 6 "digikey" H 2150 3650 60  0001 C CNN "D1"
F 7 "mouser" H 2150 3650 60  0001 C CNN "D2"
F 8 "H11918" H 2150 3650 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40HC%284.0%29-60DS-0.4V%2851%29/H11918CT-ND/2530300" H 2150 3650 60  0001 C CNN "D1PL"
F 10 "_" H 2150 3650 60  0001 C CNN "D2PN"
F 11 "_" H 2150 3650 60  0001 C CNN "D2PL"
F 12 "_" H 2150 3650 60  0001 C CNN "Package"
F 13 "_" H 2150 3650 60  0000 C CNN "Description"
F 14 "_" H 2150 3650 60  0001 C CNN "Voltage"
F 15 "_" H 2150 3650 60  0001 C CNN "Power"
F 16 "_" H 2150 3650 60  0001 C CNN "Tolerance"
F 17 "_" H 2150 3650 60  0001 C CNN "Temperature"
F 18 "_" H 2150 3650 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2150 3650 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2150 3650 60  0001 C CNN "Cont.Current"
F 21 "_" H 2150 3650 60  0001 C CNN "Frequency"
F 22 "_" H 2150 3650 60  0001 C CNN "ResonnanceFreq"
	1    2150 3650
	1    0    0    -1  
$EndComp
Text Notes 3150 850  0    60   ~ 0
USE 10 mil traces with 7mil interspace
$EndSCHEMATC
