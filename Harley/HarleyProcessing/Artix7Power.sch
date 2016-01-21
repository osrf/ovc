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
LIBS:DCDC_Converters
LIBS:artix7
LIBS:mt41k128m16
LIBS:OSCILLATOR
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 9
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
L xc7a50tcsg324pkg U1
U 7 1 56A05411
P 2800 2400
F 0 "U1" H 2800 4266 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 2800 4174 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 2800 2400 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 2800 2400 50  0001 C CNN
F 4 "_" H 2800 2400 50  0001 C CNN "MFN"
F 5 "_" H 2800 2400 50  0001 C CNN "MFP"
F 6 "digikey" H 2800 2400 50  0001 C CNN "D1"
F 7 "mouser" H 2800 2400 50  0001 C CNN "D2"
F 8 "_" H 2800 2400 50  0001 C CNN "D1PN"
F 9 "_" H 2800 2400 50  0001 C CNN "D1PL"
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
Wire Wire Line
	1600 800  1600 4100
Wire Wire Line
	4000 800  4000 2000
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
Connection ~ 1550 950 
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
Connection ~ 1600 2250
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
$Comp
L GND #PWR8
U 1 1 56A04CDF
P 4100 1900
F 0 "#PWR8" H 4100 1650 50  0001 C CNN
F 1 "GND" H 4108 1726 50  0000 C CNN
F 2 "" H 4100 1900 50  0000 C CNN
F 3 "" H 4100 1900 50  0000 C CNN
	1    4100 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 1900 4000 1900
$Comp
L GND #PWR1
U 1 1 56A04D27
P 1600 4100
F 0 "#PWR1" H 1600 3850 50  0001 C CNN
F 1 "GND" H 1608 3926 50  0000 C CNN
F 2 "" H 1600 4100 50  0000 C CNN
F 3 "" H 1600 4100 50  0000 C CNN
	1    1600 4100
	1    0    0    -1  
$EndComp
$EndSCHEMATC
