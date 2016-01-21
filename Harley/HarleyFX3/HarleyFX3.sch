EESchema Schematic File Version 2
LIBS:generic_ic
LIBS:usb_controller
LIBS:OSCILLATOR
LIBS:usb3_connector
LIBS:device
LIBS:DCDC_Converters
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
LIBS:HarleyFX3-cache
EELAYER 25 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 2
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
S 700  10500 500  150 
U 569FEDF8
F0 "Sheet569FEDF7" 60
F1 "FX3.sch" 60
$EndSheet
$Comp
L USB_3.1_microB P3
U 1 1 56A00B19
P 3300 10000
F 0 "P3" H 3527 9873 50  0000 L CNN
F 1 "USB_3.1_microB" H 3527 9781 50  0000 L CNN
F 2 "Connectors:USB3_Micro-B" V 3300 10000 50  0001 C CNN
F 3 "" V 3300 10000 50  0000 C CNN
F 4 "_" H 3300 10000 50  0001 C CNN "MFN"
F 5 "_" H 3300 10000 50  0001 C CNN "MFP"
F 6 "digikey" H 3300 10000 50  0001 C CNN "D1"
F 7 "mouser" H 3300 10000 50  0001 C CNN "D2"
F 8 "_" H 3300 10000 50  0001 C CNN "D1PN"
F 9 "_" H 3300 10000 50  0001 C CNN "D1PL"
F 10 "_" H 3300 10000 50  0001 C CNN "D2PN"
F 11 "_" H 3300 10000 50  0001 C CNN "D2PL"
F 12 "_" H 3300 10000 50  0001 C CNN "Package"
F 13 "_" H 3300 10000 50  0001 C CNN "Description"
F 14 "_" H 3300 10000 50  0001 C CNN "Voltage"
F 15 "_" H 3300 10000 50  0001 C CNN "Power"
F 16 "_" H 3300 10000 50  0001 C CNN "Tolerance"
F 17 "_" H 3300 10000 50  0001 C CNN "Temperature"
F 18 "_" H 3300 10000 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3300 10000 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3300 10000 50  0001 C CNN "Cont.Current"
F 21 "_" H 3300 10000 50  0001 C CNN "Frequency"
F 22 "_" H 3300 10000 50  0001 C CNN "ResonnanceFreq"
	1    3300 10000
	1    0    0    -1  
$EndComp
$Comp
L IC10pins U3
U 1 1 56A00BCC
P 3100 8900
F 0 "U3" H 3150 9332 50  0000 C CNN
F 1 "IC10pins" H 3150 9240 50  0000 C CNN
F 2 "UFDFN:10-UFDFN" H 3100 8900 50  0001 C CNN
F 3 "" H 3100 8900 50  0001 C CNN
F 4 "_" H 3100 8900 50  0001 C CNN "MFN"
F 5 "_" H 3100 8900 50  0001 C CNN "MFP"
F 6 "digikey" H 3100 8900 50  0001 C CNN "D1"
F 7 "mouser" H 3100 8900 50  0001 C CNN "D2"
F 8 "_" H 3100 8900 50  0001 C CNN "D1PN"
F 9 "_" H 3100 8900 50  0001 C CNN "D1PL"
F 10 "_" H 3100 8900 50  0001 C CNN "D2PN"
F 11 "_" H 3100 8900 50  0001 C CNN "D2PL"
F 12 "_" H 3100 8900 50  0001 C CNN "Package"
F 13 "_" H 3100 8900 50  0001 C CNN "Description"
F 14 "_" H 3100 8900 50  0001 C CNN "Voltage"
F 15 "_" H 3100 8900 50  0001 C CNN "Power"
F 16 "_" H 3100 8900 50  0001 C CNN "Tolerance"
F 17 "_" H 3100 8900 50  0001 C CNN "Temperature"
F 18 "_" H 3100 8900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3100 8900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3100 8900 50  0001 C CNN "Cont.Current"
F 21 "_" H 3100 8900 50  0001 C CNN "Frequency"
F 22 "_" H 3100 8900 50  0001 C CNN "ResonnanceFreq"
	1    3100 8900
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X04 P2
U 1 1 56A00C63
P 3250 7950
F 0 "P2" H 3327 7988 50  0000 L CNN
F 1 "CONN_01X04" H 3327 7896 50  0000 L CNN
F 2 "Connectors_Molex:Connector_Molex_PicoBlade_53047-0410" H 3250 7950 50  0001 C CNN
F 3 "" H 3250 7950 50  0000 C CNN
	1    3250 7950
	1    0    0    -1  
$EndComp
Text Notes 2800 7400 0    200  ~ 40
USB3
Text Notes 850  7400 0    200  ~ 40
FX3
Wire Notes Line
	2050 7500 2050 11200
Wire Notes Line
	500  7500 4350 7500
Wire Notes Line
	4350 7500 4350 11150
Text GLabel 2800 9700 0    60   Input ~ 0
USB_HS_D-
Text GLabel 2800 9800 0    60   Input ~ 0
USB_HS_D+
Text GLabel 2800 10000 0    60   Input ~ 0
SS_TX-
Text GLabel 2800 10100 0    60   Input ~ 0
SS_TX+
Text GLabel 2800 10200 0    60   Input ~ 0
SS_RX-
Text GLabel 2800 10300 0    60   Input ~ 0
SS_RX+
Text GLabel 2800 8700 0    60   Input ~ 0
SS_TX-
Text GLabel 2800 8800 0    60   Input ~ 0
SS_TX+
Text GLabel 2800 9000 0    60   Input ~ 0
SS_RX-
Text GLabel 2800 9100 0    60   Input ~ 0
SS_RX+
Text GLabel 3500 8700 2    60   Input ~ 0
SS_TX-
Text GLabel 3500 8800 2    60   Input ~ 0
SS_TX+
Text GLabel 3500 9000 2    60   Input ~ 0
SS_RX-
Text GLabel 3500 9100 2    60   Input ~ 0
SS_RX+
Text GLabel 3050 7900 0    60   Input ~ 0
USB_HS_D-
Text GLabel 3050 8000 0    60   Input ~ 0
USB_HS_D+
$Comp
L CONN_02X05 P1
U 1 1 56A01069
P 850 8750
F 0 "P1" H 850 9166 50  0000 C CNN
F 1 "CONN_02X05" H 850 9074 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x05_Pitch1.27mm" H 850 7550 50  0001 C CNN
F 3 "" H 850 7550 50  0000 C CNN
	1    850  8750
	1    0    0    -1  
$EndComp
Text GLabel 1100 8550 2    60   Input ~ 0
FX3_JTAG_TMS
Text GLabel 1100 8650 2    60   Input ~ 0
FX3_JTAG_TCK
Text GLabel 1100 8750 2    60   Input ~ 0
FX3_JTAG_TDO
Text GLabel 1100 8850 2    60   Input ~ 0
FX3_JTAG_TDI
Text GLabel 1100 8950 2    60   Input ~ 0
FX3_JTAG_TRST
Wire Wire Line
	600  8650 600  8950
$Comp
L GND #PWR01
U 1 1 56A011B3
P 600 8950
F 0 "#PWR01" H 600 8700 50  0001 C CNN
F 1 "GND" H 608 8776 50  0000 C CNN
F 2 "" H 600 8950 50  0000 C CNN
F 3 "" H 600 8950 50  0000 C CNN
	1    600  8950
	1    0    0    -1  
$EndComp
Connection ~ 600  8850
Connection ~ 600  8750
$Comp
L GND #PWR02
U 1 1 56A01493
P 3150 9250
F 0 "#PWR02" H 3150 9000 50  0001 C CNN
F 1 "GND" H 3158 9076 50  0000 C CNN
F 2 "" H 3150 9250 50  0000 C CNN
F 3 "" H 3150 9250 50  0000 C CNN
	1    3150 9250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 9250 3550 9250
Connection ~ 3150 9250
$Comp
L +5V #PWR03
U 1 1 56A01782
P 2800 9600
F 0 "#PWR03" H 2800 9450 50  0001 C CNN
F 1 "+5V" H 2818 9774 50  0000 C CNN
F 2 "" H 2800 9600 50  0000 C CNN
F 3 "" H 2800 9600 50  0000 C CNN
	1    2800 9600
	1    0    0    -1  
$EndComp
NoConn ~ 2800 9900
$Comp
L GND #PWR04
U 1 1 56A017A6
P 2800 10650
F 0 "#PWR04" H 2800 10400 50  0001 C CNN
F 1 "GND" H 2808 10476 50  0000 C CNN
F 2 "" H 2800 10650 50  0000 C CNN
F 3 "" H 2800 10650 50  0000 C CNN
	1    2800 10650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 10400 2800 10650
Connection ~ 2800 10500
Wire Wire Line
	3300 10800 3150 10800
Wire Wire Line
	3150 10800 3150 10650
Wire Wire Line
	3150 10650 2800 10650
$Comp
L +5V #PWR05
U 1 1 56A01825
P 3050 7800
F 0 "#PWR05" H 3050 7650 50  0001 C CNN
F 1 "+5V" H 3068 7974 50  0000 C CNN
F 2 "" H 3050 7800 50  0000 C CNN
F 3 "" H 3050 7800 50  0000 C CNN
	1    3050 7800
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 56A0183C
P 3050 8100
F 0 "#PWR06" H 3050 7850 50  0001 C CNN
F 1 "GND" H 3058 7926 50  0000 C CNN
F 2 "" H 3050 8100 50  0000 C CNN
F 3 "" H 3050 8100 50  0000 C CNN
	1    3050 8100
	1    0    0    -1  
$EndComp
Text Notes 550  8200 0    60   ~ 0
Voltage for JTAG ? 2.5V is OK ?
Text Notes 5250 7300 0    200  ~ 40
Power Supplies
$Comp
L LTM4622 U4
U 1 1 56A01B68
P 6100 8800
F 0 "U4" H 6100 9979 50  0000 C CNN
F 1 "LTM4622" H 6100 9887 50  0000 C CNN
F 2 "Housings_LGA:LGA25_6.25X6.25X1.82" H 6100 8800 50  0001 C CNN
F 3 "http://cds.linear.com/docs/en/datasheet/4622fa.pdf" H 6100 8800 50  0001 C CNN
F 4 "Linear" H 6100 8800 50  0001 C CNN "MFN"
F 5 "LTM4622EV#PBF" H 6100 8800 50  0001 C CNN "MFP"
F 6 "digikey" H 6100 8800 50  0001 C CNN "D1"
F 7 "mouser" H 6100 8800 50  0001 C CNN "D2"
F 8 "LTM4622EV#PBF" H 6100 8800 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/LTM4622EV%23PBF/LTM4622EV%23PBF-ND/5361650" H 6100 8800 50  0001 C CNN "D1PL"
F 10 "_" H 6100 8800 50  0001 C CNN "D2PN"
F 11 "_" H 6100 8800 50  0001 C CNN "D2PL"
F 12 "LGA25" H 6100 8800 50  0001 C CNN "Package"
F 13 "3A Dual Buck converter" H 6100 8800 50  0001 C CNN "Description"
F 14 "_" H 6100 8800 50  0001 C CNN "Voltage"
F 15 "_" H 6100 8800 50  0001 C CNN "Power"
F 16 "_" H 6100 8800 50  0001 C CNN "Tolerance"
F 17 "_" H 6100 8800 50  0001 C CNN "Temperature"
F 18 "_" H 6100 8800 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6100 8800 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6100 8800 50  0001 C CNN "Cont.Current"
F 21 "_" H 6100 8800 50  0001 C CNN "Frequency"
F 22 "_" H 6100 8800 50  0001 C CNN "ResonnanceFreq"
	1    6100 8800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 8900 2750 8900
Wire Wire Line
	2750 8900 2750 9250
Wire Wire Line
	3500 8900 3550 8900
Wire Wire Line
	3550 8900 3550 9250
$EndSCHEMATC
