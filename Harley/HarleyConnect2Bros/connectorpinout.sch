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
Sheet 15 15
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
L CONN_02X30 J?
U 1 1 56BABC62
P 2900 3350
F 0 "J?" H 2900 5016 50  0000 C CNN
F 1 "DF40C_60DP_0-4V" H 2900 4924 50  0000 C CNN
F 2 "Hirose:DF40C_60DP_0-4V" H 2900 2850 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 2900 2850 50  0001 C CNN
F 4 "Hirose" H 2900 3350 60  0001 C CNN "MFN"
F 5 "DF40C-60DP-0.4V(51) " H 2900 3350 60  0001 C CNN "MFP"
F 6 "digikey" H 2900 3350 60  0001 C CNN "D1"
F 7 "mouser" H 2900 3350 60  0001 C CNN "D2"
F 8 " H11628CT" H 2900 3350 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40C-60DP-0.4V%2851%29/H11628CT-ND/1969507" H 2900 3350 60  0001 C CNN "D1PL"
F 10 "_" H 2900 3350 60  0001 C CNN "D2PN"
F 11 "_" H 2900 3350 60  0001 C CNN "D2PL"
F 12 "_" H 2900 3350 60  0001 C CNN "Package"
F 13 "_" H 2900 3350 60  0000 C CNN "Description"
F 14 "_" H 2900 3350 60  0001 C CNN "Voltage"
F 15 "_" H 2900 3350 60  0001 C CNN "Power"
F 16 "_" H 2900 3350 60  0001 C CNN "Tolerance"
F 17 "_" H 2900 3350 60  0001 C CNN "Temperature"
F 18 "_" H 2900 3350 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2900 3350 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2900 3350 60  0001 C CNN "Cont.Current"
F 21 "_" H 2900 3350 60  0001 C CNN "Frequency"
F 22 "_" H 2900 3350 60  0001 C CNN "ResonnanceFreq"
	1    2900 3350
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 56BABC69
P 3450 4400
F 0 "#PWR?" H 3450 4250 50  0001 C CNN
F 1 "+5V" H 3468 4574 50  0000 C CNN
F 2 "" H 3450 4400 50  0000 C CNN
F 3 "" H 3450 4400 50  0000 C CNN
	1    3450 4400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56BABC6F
P 3350 2100
F 0 "#PWR?" H 3350 1850 50  0001 C CNN
F 1 "GND" H 3358 1926 50  0000 C CNN
F 2 "" H 3350 2100 50  0000 C CNN
F 3 "" H 3350 2100 50  0000 C CNN
	1    3350 2100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56BABC75
P 1850 4950
F 0 "#PWR?" H 1850 4700 50  0001 C CNN
F 1 "GND" H 1858 4776 50  0000 C CNN
F 2 "" H 1850 4950 50  0000 C CNN
F 3 "" H 1850 4950 50  0000 C CNN
	1    1850 4950
	1    0    0    -1  
$EndComp
Text GLabel 2650 1900 0    60   Input ~ 0
P_LVDS1-
Text GLabel 2650 2000 0    60   Input ~ 0
P_LVDS1+
Text GLabel 2650 2200 0    60   Input ~ 0
P_LVDS2-
Text GLabel 2650 2300 0    60   Input ~ 0
P_LVDS2+
Text GLabel 2650 2500 0    60   Input ~ 0
P_LVDS3-
Text GLabel 2650 2600 0    60   Input ~ 0
P_LVDS3+
Text GLabel 2650 2800 0    60   Input ~ 0
P_LVDS4-
Text GLabel 2650 2900 0    60   Input ~ 0
P_LVDS4+
Text GLabel 2650 3100 0    60   Input ~ 0
P_LVDS5-
Text GLabel 2650 3200 0    60   Input ~ 0
P_LVDS5+
Text GLabel 2650 3400 0    60   Input ~ 0
P_LVDS6-
Text GLabel 2650 3500 0    60   Input ~ 0
P_LVDS6+
Text GLabel 2650 3700 0    60   Input ~ 0
P_LVDS7-
Text GLabel 2650 3800 0    60   Input ~ 0
P_LVDS7+
Text GLabel 2650 4000 0    60   Input ~ 0
P_LVDS8-
Text GLabel 2650 4100 0    60   Input ~ 0
P_LVDS8+
Text GLabel 2650 4300 0    60   Input ~ 0
P_LVDS9-
Text GLabel 2650 4400 0    60   Input ~ 0
P_LVDS9+
Text GLabel 2650 4600 0    60   Input ~ 0
P_LVDS10-
Text GLabel 2650 4700 0    60   Input ~ 0
P_LVDS10+
Text GLabel 3150 2500 2    60   Input ~ 0
P_LVDS11-
Text GLabel 3150 2600 2    60   Input ~ 0
P_LVDS11+
Text GLabel 3150 2800 2    60   Input ~ 0
P_LVDS12-
Text GLabel 3150 2900 2    60   Input ~ 0
P_LVDS12+
Text GLabel 3150 3800 2    60   Input ~ 0
FPGA_SS_INIT_B
Text GLabel 3150 4000 2    60   Input ~ 0
FPGA_SS_DONE
Text GLabel 3150 3900 2    60   Input ~ 0
FPGA_SS_PROGRAM_B
Text GLabel 3150 3600 2    60   Input ~ 0
FPGA_SS_CCLK
Text GLabel 3150 4100 2    60   Input ~ 0
FPGA_SS_DOUT
Text GLabel 3150 3100 2    60   Input ~ 0
P_LVDS13-
Text GLabel 3150 3200 2    60   Input ~ 0
P_LVDS13+
Text GLabel 3150 3400 2    60   Input ~ 0
P_LVDS14-
Text GLabel 3150 3500 2    60   Input ~ 0
P_LVDS14+
Wire Wire Line
	3150 4200 3150 4800
Wire Wire Line
	3150 4400 3450 4400
Wire Wire Line
	3150 2100 3950 2100
Wire Wire Line
	2650 2100 1850 2100
Wire Wire Line
	1850 2100 1850 4950
Wire Wire Line
	2650 2400 1850 2400
Wire Wire Line
	2650 2700 1850 2700
Wire Wire Line
	2650 3000 1850 3000
Wire Wire Line
	2650 3300 1850 3300
Wire Wire Line
	2650 3600 1850 3600
Wire Wire Line
	1850 3900 2650 3900
Wire Wire Line
	2650 4200 1850 4200
Wire Wire Line
	2650 4500 1850 4500
Wire Wire Line
	2650 4800 1850 4800
Wire Wire Line
	3150 1900 3150 2400
Wire Wire Line
	3150 3000 3950 3000
Wire Wire Line
	3150 2700 3950 2700
Connection ~ 3150 4700
Connection ~ 3150 4600
Connection ~ 3150 4500
Connection ~ 3150 4400
Connection ~ 3150 2000
Connection ~ 3150 2100
Connection ~ 3150 2200
Connection ~ 3150 2300
Connection ~ 3150 4300
Connection ~ 1850 2400
Connection ~ 1850 2700
Connection ~ 1850 3000
Connection ~ 1850 3300
Connection ~ 1850 3600
Connection ~ 1850 3900
Connection ~ 1850 4200
Connection ~ 1850 4500
Connection ~ 1850 4800
Connection ~ 3950 3000
Connection ~ 3950 2700
Connection ~ 3350 2100
Wire Wire Line
	3150 3300 3950 3300
Wire Wire Line
	3950 3300 3950 2100
Text GLabel 3150 3700 2    60   Input ~ 0
FPGA_SS_DIN
$EndSCHEMATC
