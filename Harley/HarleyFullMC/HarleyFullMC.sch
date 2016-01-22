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
Sheet 1 14
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
S 600  950  500  150 
U 56A15E51
F0 "Sheet56A15E50" 60
F1 "FX3.sch" 60
$EndSheet
Text Notes 600  750  0    200  ~ 40
FX3
Text Notes 650  1700 0    200  ~ 40
PowerSupplies
$Sheet
S 650  1850 500  150 
U 56A15E7E
F0 "Sheet56A15E7D" 60
F1 "PowerSupplies.sch" 60
$EndSheet
Text Notes 650  2550 0    200  ~ 40
FPGA Banks
$Sheet
S 650  2650 500  150 
U 56A15EBE
F0 "Sheet56A15EBD" 60
F1 "Artix7Config.sch" 60
$EndSheet
$Sheet
S 650  3100 500  150 
U 56A15EDF
F0 "Sheet56A15EDE" 60
F1 "Artix7Bank14.sch" 60
$EndSheet
$Sheet
S 650  3450 500  150 
U 56A15EED
F0 "Sheet56A15EEC" 60
F1 "Artix7Bank15.sch" 60
$EndSheet
$Sheet
S 650  3800 500  150 
U 56A15EFD
F0 "Sheet56A15EFC" 60
F1 "Artix7Bank16.sch" 60
$EndSheet
$Sheet
S 650  4150 500  150 
U 56A15F09
F0 "Sheet56A15F08" 60
F1 "Artix7Bank34.sch" 60
$EndSheet
$Sheet
S 650  4500 500  150 
U 56A15F1C
F0 "Sheet56A15F1B" 60
F1 "Artix7Bank35.sch" 60
$EndSheet
$Sheet
S 650  4850 500  150 
U 56A15F2C
F0 "Sheet56A15F2B" 60
F1 "Artix7Power.sch" 60
$EndSheet
Text Notes 650  5550 0    200  ~ 40
DDR3
$Sheet
S 700  5650 500  150 
U 56A15F6A
F0 "Sheet56A15F69" 60
F1 "DDR3.sch" 60
$EndSheet
Text Notes 650  6250 0    200  ~ 40
Imager
$Sheet
S 700  6450 500  150 
U 56A15F8B
F0 "Sheet56A15F8A" 60
F1 "Imager.sch" 60
$EndSheet
Text Notes 650  7000 0    200  ~ 40
IMU
$Sheet
S 700  7150 500  150 
U 56A15FB2
F0 "Sheet56A15FB1" 60
F1 "IMU.sch" 60
$EndSheet
Text Notes 2250 7000 0    200  ~ 40
USB3
$Sheet
S 2300 7150 500  150 
U 56A16009
F0 "Sheet56A16008" 60
F1 "USB3.sch" 60
$EndSheet
$Comp
L CONN_02X30 P5
U 1 1 56A16099
P 7650 3400
F 0 "P5" H 7650 5066 50  0000 C CNN
F 1 "CONN_02X30" H 7650 4974 50  0000 C CNN
F 2 "Hirose:DF40C_60DP_0-4V" H 7650 2900 50  0001 C CNN
F 3 "" H 7650 2900 50  0000 C CNN
F 4 "_" H 7650 3400 60  0001 C CNN "MFN"
F 5 "_" H 7650 3400 60  0001 C CNN "MFP"
F 6 "digikey" H 7650 3400 60  0001 C CNN "D1"
F 7 "mouser" H 7650 3400 60  0001 C CNN "D2"
F 8 "_" H 7650 3400 60  0001 C CNN "D1PN"
F 9 "_" H 7650 3400 60  0001 C CNN "D1PL"
F 10 "_" H 7650 3400 60  0001 C CNN "D2PN"
F 11 "_" H 7650 3400 60  0001 C CNN "D2PL"
F 12 "_" H 7650 3400 60  0001 C CNN "Package"
F 13 "_" H 7650 3400 60  0000 C CNN "Description"
F 14 "_" H 7650 3400 60  0001 C CNN "Voltage"
F 15 "_" H 7650 3400 60  0001 C CNN "Power"
F 16 "_" H 7650 3400 60  0001 C CNN "Tolerance"
F 17 "_" H 7650 3400 60  0001 C CNN "Temperature"
F 18 "_" H 7650 3400 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 7650 3400 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 7650 3400 60  0001 C CNN "Cont.Current"
F 21 "_" H 7650 3400 60  0001 C CNN "Frequency"
F 22 "_" H 7650 3400 60  0001 C CNN "ResonnanceFreq"
	1    7650 3400
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X05 P3
U 1 1 56A1614E
P 5300 6600
F 0 "P3" H 5300 7016 50  0000 C CNN
F 1 "CONN_02X05" H 5300 6924 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x05_Pitch1.27mm" H 5300 5400 50  0001 C CNN
F 3 "" H 5300 5400 50  0000 C CNN
	1    5300 6600
	1    0    0    -1  
$EndComp
$Comp
L CONN_02X05 P4
U 1 1 56A16236
P 5300 7350
F 0 "P4" H 5300 7766 50  0000 C CNN
F 1 "CONN_02X05" H 5300 7674 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x05_Pitch1.27mm" H 5300 6150 50  0001 C CNN
F 3 "" H 5300 6150 50  0000 C CNN
	1    5300 7350
	1    0    0    -1  
$EndComp
Text Notes 5000 5950 0    200  ~ 40
JTAG
Text Notes 6800 1550 0    200  ~ 40
ToNextBiker
$Comp
L OSCILLATOR U11
U 1 1 56A274A0
P 3850 5800
F 0 "U11" H 3850 6166 50  0000 C CNN
F 1 "OSCILLATOR" H 3850 6074 50  0000 C CNN
F 2 "Oscillator:8y" H 3700 5800 50  0001 C CNN
F 3 "http://www.abracon.com/Oscillators/ASFL1.pdf" H 3700 5900 50  0001 C CNN
F 4 "_" H 3800 5900 50  0001 C CNN "MFN"
F 5 "_" H 3800 5900 50  0001 C CNN "MFP"
F 6 "digikey" H 3800 5900 50  0001 C CNN "D1"
F 7 "mouser" H 3800 5900 50  0001 C CNN "D2"
F 8 "_" H 3800 5900 50  0001 C CNN "D1PN"
F 9 "_" H 3800 5900 50  0001 C CNN "D1PL"
F 10 "_" H 3800 5900 50  0001 C CNN "D2PN"
F 11 "_" H 3800 5900 50  0001 C CNN "D2PL"
F 12 "_" H 3800 5900 50  0001 C CNN "Package"
F 13 "_" H 3800 5900 50  0001 C CNN "Description"
F 14 "_" H 3800 5900 50  0001 C CNN "Voltage"
F 15 "_" H 3800 5900 50  0001 C CNN "Power"
F 16 "_" H 3800 5900 50  0001 C CNN "Tolerance"
F 17 "_" H 3800 5900 50  0001 C CNN "Temperature"
F 18 "_" H 3800 5900 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3800 5900 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3800 5900 50  0001 C CNN "Cont.Current"
F 21 "_" H 3800 5900 50  0001 C CNN "Frequency"
F 22 "_" H 3800 5900 50  0001 C CNN "ResonnanceFreq"
	1    3850 5800
	1    0    0    -1  
$EndComp
Text Notes 3150 4050 0    60   ~ 0
Different Oscillator for DDR and FPGA ?
Text GLabel 4250 5900 2    60   Input ~ 0
FPGA_CLK
$Comp
L GND #PWR1
U 1 1 56A28A7E
P 3450 5900
F 0 "#PWR1" H 3450 5650 50  0001 C CNN
F 1 "GND" H 3458 5726 50  0000 C CNN
F 2 "" H 3450 5900 60  0000 C CNN
F 3 "" H 3450 5900 60  0000 C CNN
	1    3450 5900
	1    0    0    -1  
$EndComp
$Comp
L C C160
U 1 1 56A28A9C
P 3250 5750
F 0 "C160" H 3150 5850 50  0000 L CNN
F 1 "10n" H 3100 5650 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 3288 5600 50  0001 C CNN
F 3 "" H 3250 5750 50  0001 C CNN
F 4 "_" H 3250 5750 50  0001 C CNN "MFN"
F 5 "_" H 3250 5750 50  0001 C CNN "MFP"
F 6 "digikey" H 3250 5750 50  0001 C CNN "D1"
F 7 "mouser" H 3250 5750 50  0001 C CNN "D2"
F 8 "_" H 3250 5750 50  0001 C CNN "D1PN"
F 9 "_" H 3250 5750 50  0001 C CNN "D1PL"
F 10 "_" H 3250 5750 50  0001 C CNN "D2PN"
F 11 "_" H 3250 5750 50  0001 C CNN "D2PL"
F 12 "0402" H 3250 5750 50  0001 C CNN "Package"
F 13 "_" H 3365 5658 50  0000 L CNN "Description"
F 14 "6.3" H 3250 5750 50  0001 C CNN "Voltage"
F 15 "_" H 3250 5750 50  0001 C CNN "Power"
F 16 "10%" H 3250 5750 50  0001 C CNN "Tolerance"
F 17 "X5R" H 3250 5750 50  0001 C CNN "Temperature"
F 18 "_" H 3250 5750 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 3250 5750 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 3250 5750 50  0001 C CNN "Cont.Current"
F 21 "_" H 3250 5750 50  0001 C CNN "Frequency"
F 22 "_" H 3250 5750 50  0001 C CNN "ResonnanceFreq"
	1    3250 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 5900 3450 5900
Wire Wire Line
	3450 5700 3450 5400
Wire Wire Line
	3250 5400 4250 5400
Wire Wire Line
	3250 5400 3250 5600
Wire Wire Line
	4250 5400 4250 5700
Connection ~ 3450 5400
$Comp
L +2V5 #PWR2
U 1 1 56A28C22
P 3900 5400
F 0 "#PWR2" H 3900 5250 50  0001 C CNN
F 1 "+2V5" H 3918 5574 50  0000 C CNN
F 2 "" H 3900 5400 60  0000 C CNN
F 3 "" H 3900 5400 60  0000 C CNN
	1    3900 5400
	1    0    0    -1  
$EndComp
Connection ~ 3900 5400
$EndSCHEMATC
