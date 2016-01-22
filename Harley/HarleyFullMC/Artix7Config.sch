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
LIBS:HarleyFullMC-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 14
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
U 1 1 56A03C5F
P 3900 3750
F 0 "U1" H 3850 4516 50  0000 C CNN
F 1 "xc7a50tcsg324pkg" H 3850 4424 50  0000 C CNN
F 2 "BGA:BGA324C80P18X18_1500X1500X150" H 3900 3750 50  0001 C CNN
F 3 "http://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 3900 3750 50  0001 C CNN
F 4 "_" H 3900 3750 50  0001 C CNN "MFN"
F 5 "_" H 3900 3750 50  0001 C CNN "MFP"
F 6 "digikey" H 3900 3750 50  0001 C CNN "D1"
F 7 "mouser" H 3900 3750 50  0001 C CNN "D2"
F 8 "_" H 3900 3750 50  0001 C CNN "D1PN"
F 9 "_" H 3900 3750 50  0001 C CNN "D1PL"
F 10 "_" H 3900 3750 50  0001 C CNN "D2PN"
F 11 "_" H 3900 3750 50  0001 C CNN "D2PL"
F 12 "BGA324" H 3900 3750 50  0001 C CNN "Package"
F 13 "Artix7a50csg324 " H 3900 3750 50  0001 C CNN "Description"
F 14 "_" H 3900 3750 50  0001 C CNN "Voltage"
F 15 "_" H 3900 3750 50  0001 C CNN "Power"
F 16 "_" H 3900 3750 50  0001 C CNN "Tolerance"
F 17 "_" H 3900 3750 50  0001 C CNN "Temperature"
F 18 "_" H 3900 3750 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3900 3750 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3900 3750 50  0001 C CNN "Cont.Current"
F 21 "_" H 3900 3750 50  0001 C CNN "Frequency"
F 22 "_" H 3900 3750 50  0001 C CNN "ResonnanceFreq"
	1    3900 3750
	1    0    0    -1  
$EndComp
$Comp
L C C118
U 1 1 56A2EBA2
P 6150 4000
F 0 "C118" H 6200 4100 50  0000 L CNN
F 1 "47u" H 6200 3900 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 6188 3850 50  0001 C CNN
F 3 "" H 6150 4000 50  0001 C CNN
F 4 "_" H 6150 4000 50  0001 C CNN "MFN"
F 5 "_" H 6150 4000 50  0001 C CNN "MFP"
F 6 "digikey" H 6150 4000 50  0001 C CNN "D1"
F 7 "mouser" H 6150 4000 50  0001 C CNN "D2"
F 8 "_" H 6150 4000 50  0001 C CNN "D1PN"
F 9 "_" H 6150 4000 50  0001 C CNN "D1PL"
F 10 "_" H 6150 4000 50  0001 C CNN "D2PN"
F 11 "_" H 6150 4000 50  0001 C CNN "D2PL"
F 12 "0402" H 6150 4000 50  0001 C CNN "Package"
F 13 "_" H 6265 3908 50  0001 L CNN "Description"
F 14 "6.3" H 6150 4000 50  0001 C CNN "Voltage"
F 15 "_" H 6150 4000 50  0001 C CNN "Power"
F 16 "10%" H 6150 4000 50  0001 C CNN "Tolerance"
F 17 "X5R" H 6150 4000 50  0001 C CNN "Temperature"
F 18 "_" H 6150 4000 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6150 4000 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6150 4000 50  0001 C CNN "Cont.Current"
F 21 "_" H 6150 4000 50  0001 C CNN "Frequency"
F 22 "_" H 6150 4000 50  0001 C CNN "ResonnanceFreq"
	1    6150 4000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3850 6150 3850
$Comp
L GND #PWR75
U 1 1 56A2EBB3
P 6150 4150
F 0 "#PWR75" H 6150 3900 50  0001 C CNN
F 1 "GND" H 6158 3976 50  0000 C CNN
F 2 "" H 6150 4150 50  0000 C CNN
F 3 "" H 6150 4150 50  0000 C CNN
	1    6150 4150
	1    0    0    -1  
$EndComp
$EndSCHEMATC
