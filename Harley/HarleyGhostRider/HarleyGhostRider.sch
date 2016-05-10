EESchema Schematic File Version 2
LIBS:connectors
LIBS:conn
LIBS:device
LIBS:artix7
LIBS:OSCILLATOR
LIBS:mt41k128m16
LIBS:DCDC_Converters
LIBS:usb_controller
LIBS:usb3_connector
LIBS:i2c_flash
LIBS:generic_ic
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
LIBS:HarleyGhostRider-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 12
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
S 600  1850 500  150 
U 56A15E51
F0 "Sheet56A15E50" 60
F1 "FX3.sch" 60
$EndSheet
$Sheet
S 600  1000 500  150 
U 56A15E7E
F0 "Sheet56A15E7D" 60
F1 "PowerSupplies.sch" 60
$EndSheet
$Sheet
S 600  6200 500  150 
U 56A15EBE
F0 "Sheet56A15EBD" 60
F1 "Artix7Config.sch" 60
$EndSheet
$Sheet
S 2400 5800 500  150 
U 56A15EDF
F0 "Sheet56A15EDE" 60
F1 "Artix7Bank14.sch" 60
$EndSheet
$Sheet
S 2400 7500 500  150 
U 56A15EED
F0 "Sheet56A15EEC" 60
F1 "Artix7Bank15.sch" 60
$EndSheet
$Sheet
S 600  6850 500  150 
U 56A15EFD
F0 "Sheet56A15EFC" 60
F1 "Artix7Bank16.sch" 60
$EndSheet
$Sheet
S 2350 6550 500  150 
U 56A15F09
F0 "Sheet56A15F08" 60
F1 "Artix7Bank34.sch" 60
$EndSheet
$Sheet
S 600  7550 500  150 
U 56A15F1C
F0 "Sheet56A15F1B" 60
F1 "Artix7Bank35.sch" 60
$EndSheet
$Sheet
S 650  5600 500  150 
U 56A15F2C
F0 "Sheet56A15F2B" 60
F1 "Artix7Power.sch" 60
$EndSheet
$Sheet
S 4800 5700 500  150 
U 56A15F6A
F0 "Sheet56A15F69" 60
F1 "DDR3.sch" 60
$EndSheet
$Sheet
S 600  2600 500  150 
U 56A16009
F0 "Sheet56A16008" 60
F1 "USB3.sch" 60
$EndSheet
$Comp
L GND #PWR01
U 1 1 56A28A7E
P 800 4300
F 0 "#PWR01" H 800 4050 50  0001 C CNN
F 1 "GND" H 808 4126 50  0000 C CNN
F 2 "" H 800 4300 60  0000 C CNN
F 3 "" H 800 4300 60  0000 C CNN
	1    800  4300
	1    0    0    -1  
$EndComp
$Comp
L C C160
U 1 1 56A28A9C
P 800 4100
F 0 "C160" H 700 4200 50  0000 L CNN
F 1 "10n" H 650 4000 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 838 3950 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 800 4100 50  0001 C CNN
F 4 "TDK" H 800 4100 50  0001 C CNN "MFN"
F 5 "C1005X7R1C103K050BA" H 800 4100 50  0001 C CNN "MFP"
F 6 "digikey" H 800 4100 50  0001 C CNN "D1"
F 7 "mouser" H 800 4100 50  0001 C CNN "D2"
F 8 "445-1262" H 800 4100 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X7R1C103K050BA/445-1262-1-ND/567728" H 800 4100 50  0001 C CNN "D1PL"
F 10 "_" H 800 4100 50  0001 C CNN "D2PN"
F 11 "_" H 800 4100 50  0001 C CNN "D2PL"
F 12 "0402" H 800 4100 50  0001 C CNN "Package"
F 13 "_" H 915 4008 50  0000 L CNN "Description"
F 14 "6.3" H 800 4100 50  0001 C CNN "Voltage"
F 15 "_" H 800 4100 50  0001 C CNN "Power"
F 16 "10%" H 800 4100 50  0001 C CNN "Tolerance"
F 17 "X7R" H 800 4100 50  0001 C CNN "Temperature"
F 18 "_" H 800 4100 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 800 4100 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 800 4100 50  0001 C CNN "Cont.Current"
F 21 "_" H 800 4100 50  0001 C CNN "Frequency"
F 22 "_" H 800 4100 50  0001 C CNN "ResonnanceFreq"
	1    800  4100
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR02
U 1 1 56A28C22
P 1450 3750
F 0 "#PWR02" H 1450 3600 50  0001 C CNN
F 1 "+2V5" H 1468 3924 50  0000 C CNN
F 2 "" H 1450 3750 60  0000 C CNN
F 3 "" H 1450 3750 60  0000 C CNN
	1    1450 3750
	1    0    0    -1  
$EndComp
$Comp
L M24M02 U12
U 1 1 56A391D7
P 4250 2250
F 0 "U12" H 4300 2682 50  0000 C CNN
F 1 "24LC128T-I/MNY" H 4300 2590 50  0000 C CNN
F 2 "Housings_TDFN:8-TDFN_2x3_1EP" H 4250 2250 50  0001 C CNN
F 3 "http://www.microchip.com/mymicrochip/filehandler.aspx?ddocname=en011851" H 4250 2250 50  0001 C CNN
F 4 "Microchip" H 4250 2250 50  0001 C CNN "MFN"
F 5 "24LC128T-I/MNY" H 4250 2250 50  0001 C CNN "MFP"
F 6 "digikey" H 4250 2250 50  0001 C CNN "D1"
F 7 "mouser" H 4250 2250 50  0001 C CNN "D2"
F 8 "24LC128T-I/MNY" H 4250 2250 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/24LC128T-I%2FMNY/24LC128T-I%2FMNYCT-ND/2385857" H 4250 2250 50  0001 C CNN "D1PL"
F 10 "_" H 4250 2250 50  0001 C CNN "D2PN"
F 11 "_" H 4250 2250 50  0001 C CNN "D2PL"
F 12 "_" H 4250 2250 50  0001 C CNN "Package"
F 13 "_" H 4250 2250 50  0001 C CNN "Description"
F 14 "_" H 4250 2250 50  0001 C CNN "Voltage"
F 15 "_" H 4250 2250 50  0001 C CNN "Power"
F 16 "_" H 4250 2250 50  0001 C CNN "Tolerance"
F 17 "_" H 4250 2250 50  0001 C CNN "Temperature"
F 18 "_" H 4250 2250 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 4250 2250 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 4250 2250 50  0001 C CNN "Cont.Current"
F 21 "_" H 4250 2250 50  0001 C CNN "Frequency"
F 22 "_" H 4250 2250 50  0001 C CNN "ResonnanceFreq"
	1    4250 2250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 56A39901
P 3850 2500
F 0 "#PWR03" H 3850 2250 50  0001 C CNN
F 1 "GND" H 3858 2326 50  0000 C CNN
F 2 "" H 3850 2500 50  0000 C CNN
F 3 "" H 3850 2500 50  0000 C CNN
	1    3850 2500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR04
U 1 1 56A3A17A
P 4800 2500
F 0 "#PWR04" H 4800 2250 50  0001 C CNN
F 1 "GND" H 4808 2326 50  0000 C CNN
F 2 "" H 4800 2500 50  0000 C CNN
F 3 "" H 4800 2500 50  0000 C CNN
	1    4800 2500
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR05
U 1 1 56A3A9E8
P 5100 1900
F 0 "#PWR05" H 5100 1750 50  0001 C CNN
F 1 "+2V5" H 5118 2074 50  0000 C CNN
F 2 "" H 5100 1900 50  0000 C CNN
F 3 "" H 5100 1900 50  0000 C CNN
	1    5100 1900
	1    0    0    -1  
$EndComp
$Comp
L OSCILLATOR U11
U 1 1 56AB2628
P 1500 4200
F 0 "U11" H 1500 4566 50  0000 C CNN
F 1 "OSCILLATOR" H 1500 4474 50  0000 C CNN
F 2 "Oscillator:ASDMB" H 1350 4200 50  0001 C CNN
F 3 "http://www.abracon.com/Oscillators/ASDMB.pdf" H 1350 4300 50  0001 C CNN
F 4 "Abracon" H 1450 4300 50  0001 C CNN "MFN"
F 5 "ASDMB-48.000MHZ-EC-T" H 1450 4300 50  0001 C CNN "MFP"
F 6 "digikey" H 1450 4300 50  0001 C CNN "D1"
F 7 "mouser" H 1450 4300 50  0001 C CNN "D2"
F 8 "535-12100" H 1450 4300 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/abracon-llc/ASDMB-48.000MHZ-EC-T/535-12100-1-ND/4199686" H 1450 4300 50  0001 C CNN "D1PL"
F 10 "_" H 1450 4300 50  0001 C CNN "D2PN"
F 11 "_" H 1450 4300 50  0001 C CNN "D2PL"
F 12 "_" H 1450 4300 50  0001 C CNN "Package"
F 13 "_" H 1450 4300 50  0001 C CNN "Description"
F 14 "_" H 1450 4300 50  0001 C CNN "Voltage"
F 15 "_" H 1450 4300 50  0001 C CNN "Power"
F 16 "_" H 1450 4300 50  0001 C CNN "Tolerance"
F 17 "_" H 1450 4300 50  0001 C CNN "Temperature"
F 18 "_" H 1450 4300 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 1450 4300 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 1450 4300 50  0001 C CNN "Cont.Current"
F 21 "_" H 1450 4300 50  0001 C CNN "Frequency"
F 22 "_" H 1450 4300 50  0001 C CNN "ResonnanceFreq"
	1    1500 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR06
U 1 1 56AA81C5
P 7000 1950
F 0 "#PWR06" H 7000 1700 50  0001 C CNN
F 1 "GND" V 7008 1822 50  0000 R CNN
F 2 "" H 7000 1950 50  0000 C CNN
F 3 "" H 7000 1950 50  0000 C CNN
	1    7000 1950
	0    1    1    0   
$EndComp
$Comp
L CONN_01X04 J3
U 1 1 56AAA1F7
P 7200 2100
F 0 "J3" H 7278 2237 50  0000 L CNN
F 1 "CONN_01X04" H 7278 2145 50  0000 L CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04_Pitch1.27mm" H 7278 2053 50  0001 L CNN
F 3 "DNP" H 7200 2100 50  0001 C CNN
F 4 "DNP" H 7200 2100 60  0001 C CNN "MFN"
F 5 "DNP" H 7200 2100 60  0001 C CNN "MFP"
F 6 "DNP" H 7200 2100 60  0001 C CNN "D1"
F 7 "DNP" H 7200 2100 60  0001 C CNN "D2"
F 8 "DNP" H 7200 2100 60  0001 C CNN "D1PN"
F 9 "DNP" H 7200 2100 60  0001 C CNN "D1PL"
F 10 "_" H 7200 2100 60  0001 C CNN "D2PN"
F 11 "_" H 7200 2100 60  0001 C CNN "D2PL"
F 12 "_" H 7200 2100 60  0001 C CNN "Package"
F 13 "_" H 7278 1954 60  0000 L CNN "Description"
F 14 "_" H 7200 2100 60  0001 C CNN "Voltage"
F 15 "_" H 7200 2100 60  0001 C CNN "Power"
F 16 "_" H 7200 2100 60  0001 C CNN "Tolerance"
F 17 "_" H 7200 2100 60  0001 C CNN "Temperature"
F 18 "_" H 7200 2100 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 7200 2100 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 7200 2100 60  0001 C CNN "Cont.Current"
F 21 "_" H 7200 2100 60  0001 C CNN "Frequency"
F 22 "_" H 7200 2100 60  0001 C CNN "ResonnanceFreq"
	1    7200 2100
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 56AAA273
P 5650 3250
F 0 "D1" H 5650 3558 50  0000 C CNN
F 1 "GREEN" H 5650 3466 50  0000 C CNN
F 2 "LEDs:LED_0603" H 5650 3250 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/APT1608CGCK.pdf" H 5650 3250 50  0001 C CNN
F 4 "Kingbright" H 5650 3250 50  0001 C CNN "MFN"
F 5 "APT1608CGCK" H 5650 3250 50  0001 C CNN "MFP"
F 6 "digikey" H 5650 3250 50  0001 C CNN "D1"
F 7 "mouser" H 5650 3250 50  0001 C CNN "D2"
F 8 "754-1116" H 5650 3250 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/APT1608CGCK/754-1116-1-ND/1747833" H 5650 3250 50  0001 C CNN "D1PL"
F 10 "_" H 5650 3250 50  0001 C CNN "D2PN"
F 11 "_" H 5650 3250 50  0001 C CNN "D2PL"
F 12 "_" H 5650 3250 50  0001 C CNN "Package"
F 13 "_" H 5650 3374 50  0000 C CNN "Description"
F 14 "_" H 5650 3250 50  0001 C CNN "Voltage"
F 15 "_" H 5650 3250 50  0001 C CNN "Power"
F 16 "_" H 5650 3250 50  0001 C CNN "Tolerance"
F 17 "_" H 5650 3250 50  0001 C CNN "Temperature"
F 18 "_" H 5650 3250 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5650 3250 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5650 3250 50  0001 C CNN "Cont.Current"
F 21 "_" H 5650 3250 50  0001 C CNN "Frequency"
F 22 "_" H 5650 3250 50  0001 C CNN "ResonnanceFreq"
	1    5650 3250
	1    0    0    -1  
$EndComp
$Comp
L R R20
U 1 1 56AAA31E
P 6000 3250
F 0 "R20" V 5700 3250 50  0000 C CNN
F 1 "200" V 5792 3250 50  0000 C CNN
F 2 "Dipoles_SMD:R_0402" V 5930 3250 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 6000 3250 30  0001 C CNN
F 4 "Vishay" H 6000 3250 50  0001 C CNN "MFN"
F 5 "CRCW0402200RFKED" H 6000 3250 50  0001 C CNN "MFP"
F 6 "digikey" H 6000 3250 50  0001 C CNN "D1"
F 7 "mouser" H 6000 3250 50  0001 C CNN "D2"
F 8 "541-200L" H 6000 3250 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW0402200RFKED/541-200LCT-ND/1183041" H 6000 3250 50  0001 C CNN "D1PL"
F 10 "_" H 6000 3250 50  0001 C CNN "D2PN"
F 11 "_" H 6000 3250 50  0001 C CNN "D2PL"
F 12 "0402" H 6000 3250 50  0001 C CNN "Package"
F 13 "_" V 5884 3250 50  0000 C CNN "Description"
F 14 "_" H 6000 3250 50  0001 C CNN "Voltage"
F 15 "1/16" H 6000 3250 50  0001 C CNN "Power"
F 16 "1%" H 6000 3250 50  0001 C CNN "Tolerance"
F 17 "_" H 6000 3250 50  0001 C CNN "Temperature"
F 18 "_" H 6000 3250 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6000 3250 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6000 3250 50  0001 C CNN "Cont.Current"
F 21 "_" H 6000 3250 50  0001 C CNN "Frequency"
F 22 "_" H 6000 3250 50  0001 C CNN "ResonnanceFreq"
	1    6000 3250
	0    1    1    0   
$EndComp
$Comp
L +2V5 #PWR07
U 1 1 56AAA428
P 6150 3250
F 0 "#PWR07" H 6150 3100 50  0001 C CNN
F 1 "+2V5" H 6168 3424 50  0000 C CNN
F 2 "" H 6150 3250 50  0000 C CNN
F 3 "" H 6150 3250 50  0000 C CNN
	1    6150 3250
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR08
U 1 1 56AAAEA0
P 6150 3700
F 0 "#PWR08" H 6150 3550 50  0001 C CNN
F 1 "+2V5" H 6168 3874 50  0000 C CNN
F 2 "" H 6150 3700 50  0000 C CNN
F 3 "" H 6150 3700 50  0000 C CNN
	1    6150 3700
	1    0    0    -1  
$EndComp
$Comp
L LED D2
U 1 1 56AAB830
P 5650 3700
F 0 "D2" H 5650 4008 50  0000 C CNN
F 1 "RED" H 5650 3916 50  0000 C CNN
F 2 "LEDs:LED_0603" H 5650 3700 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/APT1608SURCK.pdf" H 5650 3700 50  0001 C CNN
F 4 "Kingbright" H 5650 3700 50  0001 C CNN "MFN"
F 5 "APT1608SURCK" H 5650 3700 50  0001 C CNN "MFP"
F 6 "digikey" H 5650 3700 50  0001 C CNN "D1"
F 7 "mouser" H 5650 3700 50  0001 C CNN "D2"
F 8 "754-1123" H 5650 3700 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/APT1608SURCK/754-1123-1-ND/1747840" H 5650 3700 50  0001 C CNN "D1PL"
F 10 "_" H 5650 3700 50  0001 C CNN "D2PN"
F 11 "_" H 5650 3700 50  0001 C CNN "D2PL"
F 12 "_" H 5650 3700 50  0001 C CNN "Package"
F 13 "_" H 5650 3824 50  0000 C CNN "Description"
F 14 "_" H 5650 3700 50  0001 C CNN "Voltage"
F 15 "_" H 5650 3700 50  0001 C CNN "Power"
F 16 "_" H 5650 3700 50  0001 C CNN "Tolerance"
F 17 "_" H 5650 3700 50  0001 C CNN "Temperature"
F 18 "_" H 5650 3700 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5650 3700 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5650 3700 50  0001 C CNN "Cont.Current"
F 21 "_" H 5650 3700 50  0001 C CNN "Frequency"
F 22 "_" H 5650 3700 50  0001 C CNN "ResonnanceFreq"
	1    5650 3700
	1    0    0    -1  
$EndComp
$Comp
L R R22
U 1 1 56AAB977
P 6000 3700
F 0 "R22" V 5700 3700 50  0000 C CNN
F 1 "200" V 5792 3700 50  0000 C CNN
F 2 "Dipoles_SMD:R_0402" V 5930 3700 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 6000 3700 30  0001 C CNN
F 4 "Vishay" H 6000 3700 50  0001 C CNN "MFN"
F 5 "CRCW0402200RFKED" H 6000 3700 50  0001 C CNN "MFP"
F 6 "digikey" H 6000 3700 50  0001 C CNN "D1"
F 7 "mouser" H 6000 3700 50  0001 C CNN "D2"
F 8 "541-200L" H 6000 3700 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW0402200RFKED/541-200LCT-ND/1183041" H 6000 3700 50  0001 C CNN "D1PL"
F 10 "_" H 6000 3700 50  0001 C CNN "D2PN"
F 11 "_" H 6000 3700 50  0001 C CNN "D2PL"
F 12 "0402" H 6000 3700 50  0001 C CNN "Package"
F 13 "_" V 5884 3700 50  0000 C CNN "Description"
F 14 "_" H 6000 3700 50  0001 C CNN "Voltage"
F 15 "1/16" H 6000 3700 50  0001 C CNN "Power"
F 16 "1%" H 6000 3700 50  0001 C CNN "Tolerance"
F 17 "_" H 6000 3700 50  0001 C CNN "Temperature"
F 18 "_" H 6000 3700 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 6000 3700 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 6000 3700 50  0001 C CNN "Cont.Current"
F 21 "_" H 6000 3700 50  0001 C CNN "Frequency"
F 22 "_" H 6000 3700 50  0001 C CNN "ResonnanceFreq"
	1    6000 3700
	0    1    1    0   
$EndComp
Text Notes 600  1650 0    200  ~ 40
FX3
Text Notes 600  850  0    200  ~ 40
PowerSupplies
Text Notes 550  5150 0    200  ~ 40
FPGA Banks
Text Notes 4750 5600 0    200  ~ 40
DDR3s
Text Notes 550  2450 0    200  ~ 40
USB3
Text Notes 5950 1000 0    200  ~ 40
JTAG/DEBUG
Text Notes 9100 1000 0    200  ~ 40
ToNextBiker
Text GLabel 2350 4300 2    60   Input ~ 0
FPGA_CLK
Text Notes 650  5450 0    100  ~ 20
Power
Text Notes 600  7350 0    100  ~ 20
DDR3L1 Bank (1V35)
Text Notes 600  6050 0    100  ~ 20
Config
Text Notes 2400 7350 0    100  ~ 20
LVDS Bank (Python1 and 2)
Text Notes 2350 6350 0    100  ~ 20
FX3 Bank
Text GLabel 5400 2350 2    60   Input ~ 0
FLASH_SDA
Text GLabel 5400 2250 2    60   Input ~ 0
FLASH_SCL
Text GLabel 5450 3250 0    60   Input ~ 0
FX3_LED/DEBUG
Text GLabel 7000 2250 0    60   Input ~ 0
FX3_UART_TX
Text GLabel 7000 2150 0    60   Input ~ 0
FX3_UART_RX
Text GLabel 7000 2050 0    60   Input ~ 0
FX3_RST#
Text GLabel 5450 3700 0    60   Input ~ 0
FPGA_LED
Wire Wire Line
	800  4250 800  4300
Wire Wire Line
	800  3750 800  3950
Wire Notes Line
	500  5250 4450 5250
Wire Notes Line
	4450 5250 4450 7800
Wire Wire Line
	4750 2250 5400 2250
Wire Wire Line
	4750 2350 5400 2350
Wire Wire Line
	4750 2050 4750 1900
Wire Wire Line
	4750 1900 5300 1900
Wire Wire Line
	5300 1900 5300 1950
Wire Wire Line
	5100 2050 5100 1900
Wire Wire Line
	3850 2250 3850 2500
Wire Wire Line
	4750 2150 4800 2150
Wire Wire Line
	4800 2150 4800 2500
Wire Wire Line
	1900 4300 2350 4300
Wire Wire Line
	1100 4100 1100 3750
Wire Wire Line
	1900 3750 1900 4100
Wire Wire Line
	800  3750 1900 3750
Wire Wire Line
	800  4300 1100 4300
Connection ~ 1450 3750
Connection ~ 5300 2250
Connection ~ 5100 2350
Connection ~ 5100 1900
Connection ~ 3850 2350
Connection ~ 1100 3750
NoConn ~ 3850 2050
NoConn ~ 3850 2150
Text Notes 600  6700 0    100  ~ 20
CMOS Bank
Text Notes 2350 5550 0    100  ~ 20
FX3 + Python3 LVDS Bank
Text GLabel 9600 3500 0    60   Input ~ 0
Python1_DOUT0+
Text GLabel 9600 3600 0    60   Input ~ 0
Python1_DOUT0-
Text GLabel 9600 3800 0    60   Input ~ 0
Python1_DOUT1+
Text GLabel 9600 3900 0    60   Input ~ 0
Python1_DOUT1-
Text GLabel 9600 4100 0    60   Input ~ 0
Python1_DOUT2+
Text GLabel 9600 4200 0    60   Input ~ 0
Python1_DOUT2-
Text GLabel 9600 4400 0    60   Input ~ 0
Python1_DOUT3+
Text GLabel 9600 4500 0    60   Input ~ 0
Python1_DOUT3-
Text GLabel 9600 3300 0    60   Input ~ 0
Python1_clk_return-
Text GLabel 9600 3200 0    60   Input ~ 0
Python1_clk_return+
Text GLabel 10100 2200 2    60   Input ~ 0
Python2_DOUT0+
Text GLabel 10100 2100 2    60   Input ~ 0
Python2_DOUT0-
Text GLabel 10100 1900 2    60   Input ~ 0
Python2_DOUT1+
Text GLabel 10100 1800 2    60   Input ~ 0
Python2_DOUT1-
Text GLabel 10100 2400 2    60   Input ~ 0
Python2_DOUT2+
Text GLabel 10100 2500 2    60   Input ~ 0
Python2_DOUT2-
Text GLabel 10100 2700 2    60   Input ~ 0
Python2_DOUT3+
Text GLabel 10100 2800 2    60   Input ~ 0
Python2_DOUT3-
Text GLabel 10100 3400 2    60   Input ~ 0
Python2_clk_return-
Text GLabel 10100 3300 2    60   Input ~ 0
Python2_clk_return+
Text GLabel 9600 1700 0    60   Input ~ 0
Python3_DOUT0+
Text GLabel 9600 1800 0    60   Input ~ 0
Python3_DOUT0-
Text GLabel 9600 2000 0    60   Input ~ 0
Python3_DOUT1+
Text GLabel 9600 2100 0    60   Input ~ 0
Python3_DOUT1-
Text GLabel 9600 3000 0    60   Input ~ 0
Python3_DOUT2+
Text GLabel 9600 2900 0    60   Input ~ 0
Python3_DOUT2-
Text GLabel 9600 2700 0    60   Input ~ 0
Python3_DOUT3+
Text GLabel 9600 2600 0    60   Input ~ 0
Python3_DOUT3-
Text GLabel 9600 1400 0    60   Input ~ 0
Python3_clk_return-
Text GLabel 9600 1500 0    60   Input ~ 0
Python3_clk_return+
Text GLabel 10100 3600 2    60   Input ~ 0
Python_lvds_clk+
Text GLabel 10100 3700 2    60   Input ~ 0
Python_lvds_clk-
Text GLabel 9600 4700 0    60   Input ~ 0
Python1_SYNC+
Text GLabel 9600 4800 0    60   Input ~ 0
Python1_SYNC-
Text GLabel 10100 3000 2    60   Input ~ 0
Python2_SYNC+
Text GLabel 10100 3100 2    60   Input ~ 0
Python2_SYNC-
Text GLabel 9600 2400 0    60   Input ~ 0
Python3_SYNC+
Text GLabel 9600 2300 0    60   Input ~ 0
Python3_SYNC-
Wire Wire Line
	10100 5700 10100 6300
Connection ~ 10100 6200
Connection ~ 10100 6100
Connection ~ 10100 6000
Connection ~ 10100 5900
Connection ~ 10100 5800
Wire Wire Line
	10100 6200 10300 6200
Wire Wire Line
	10300 6200 10300 6300
$Comp
L +5V #PWR09
U 1 1 571B7103
P 10300 6300
F 0 "#PWR09" H 10300 6150 50  0001 C CNN
F 1 "+5V" H 10315 6473 50  0000 C CNN
F 2 "" H 10300 6300 50  0000 C CNN
F 3 "" H 10300 6300 50  0000 C CNN
	1    10300 6300
	1    0    0    1   
$EndComp
Wire Wire Line
	10100 5400 10100 5600
Connection ~ 10100 5500
Wire Wire Line
	10100 5500 10350 5500
Wire Wire Line
	10350 5500 10350 5600
$Comp
L +2V5 #PWR010
U 1 1 571B7521
P 10350 5600
F 0 "#PWR010" H 10350 5450 50  0001 C CNN
F 1 "+2V5" H 10365 5773 50  0000 C CNN
F 2 "" H 10350 5600 50  0000 C CNN
F 3 "" H 10350 5600 50  0000 C CNN
	1    10350 5600
	1    0    0    1   
$EndComp
$Comp
L CONN_02X50 P1
U 1 1 571C0741
P 9850 3850
F 0 "P1" H 9850 6465 50  0000 C CNN
F 1 "CONN_02X50" H 9850 6374 50  0000 C CNN
F 2 "Hirose:DF40C_100DP_0-4V" H 9850 4300 50  0001 C CNN
F 3 "http://www.hirose.co.jp/cataloge_hp/ed_DF40_20140305.pdf" H 9850 4300 50  0001 C CNN
F 4 "Hirose" H 9850 3850 60  0001 C CNN "MFN"
F 5 "DF40C-100DP-0.4V(51)" H 9850 3850 60  0001 C CNN "MFP"
F 6 "digikey" H 9850 3850 60  0001 C CNN "D1"
F 7 "mouser" H 9850 3850 60  0001 C CNN "D2"
F 8 "H11614" H 9850 3850 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/DF40C-100DP-0.4V%2851%29/H11614CT-ND/1969494" H 9850 3850 60  0001 C CNN "D1PL"
F 10 "_" H 9850 3850 60  0001 C CNN "D2PN"
F 11 "_" H 9850 3850 60  0001 C CNN "D2PL"
F 12 "_" H 9850 3850 60  0001 C CNN "Package"
F 13 "_" H 9850 3850 60  0000 C CNN "Description"
F 14 "_" H 9850 3850 60  0001 C CNN "Voltage"
F 15 "_" H 9850 3850 60  0001 C CNN "Power"
F 16 "_" H 9850 3850 60  0001 C CNN "Tolerance"
F 17 "_" H 9850 3850 60  0001 C CNN "Temperature"
F 18 "_" H 9850 3850 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 9850 3850 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 9850 3850 60  0001 C CNN "Cont.Current"
F 21 "_" H 9850 3850 60  0001 C CNN "Frequency"
F 22 "_" H 9850 3850 60  0001 C CNN "ResonnanceFreq"
	1    9850 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 4600 9600 4600
Wire Wire Line
	8500 1300 8500 5800
Wire Wire Line
	8500 3700 9600 3700
Connection ~ 8500 4300
Wire Wire Line
	8500 4000 9600 4000
Connection ~ 8500 4000
Wire Wire Line
	8500 4300 9600 4300
Connection ~ 8500 3700
Wire Wire Line
	8500 3400 9600 3400
Connection ~ 8500 3400
Wire Wire Line
	8500 3100 9600 3100
Connection ~ 8500 3100
Wire Wire Line
	8500 2800 9600 2800
Connection ~ 8500 2800
Wire Wire Line
	8500 2500 9600 2500
Connection ~ 8500 2500
Wire Wire Line
	8500 2200 9600 2200
Connection ~ 8500 2200
Wire Wire Line
	8500 1900 9600 1900
Connection ~ 8500 1900
Wire Wire Line
	8500 1600 9600 1600
Connection ~ 8500 1600
Wire Wire Line
	11000 5300 10100 5300
Wire Wire Line
	11000 1350 11000 5300
Connection ~ 11000 5000
Wire Wire Line
	10100 3800 11000 3800
Wire Wire Line
	10100 3500 11000 3500
Connection ~ 11000 3800
Wire Wire Line
	10100 3200 11000 3200
Connection ~ 11000 3500
Wire Wire Line
	10100 2900 11000 2900
Connection ~ 11000 3200
Wire Wire Line
	10100 2600 11000 2600
Connection ~ 11000 2900
Connection ~ 11000 2600
$Comp
L GND #PWR011
U 1 1 571C1841
P 11000 1350
F 0 "#PWR011" H 11000 1100 50  0001 C CNN
F 1 "GND" H 11005 1177 50  0000 C CNN
F 2 "" H 11000 1350 50  0000 C CNN
F 3 "" H 11000 1350 50  0000 C CNN
	1    11000 1350
	1    0    0    1   
$EndComp
$Comp
L GND #PWR012
U 1 1 571C18CC
P 8500 1300
F 0 "#PWR012" H 8500 1050 50  0001 C CNN
F 1 "GND" H 8505 1127 50  0000 C CNN
F 2 "" H 8500 1300 50  0000 C CNN
F 3 "" H 8500 1300 50  0000 C CNN
	1    8500 1300
	1    0    0    1   
$EndComp
Text GLabel 9600 5900 0    60   Input ~ 0
SPI_MOSI
Text GLabel 9600 6000 0    60   Input ~ 0
SPI_MISO
Text GLabel 9600 5700 0    60   Input ~ 0
SPI_SCK
Text GLabel 9600 5400 0    60   Input ~ 0
Python1_CS#
Text GLabel 9600 5500 0    60   Input ~ 0
Python2_CS#
Text GLabel 9600 5300 0    60   Input ~ 0
Python3_CS#
Text GLabel 9600 5200 0    60   Input ~ 0
IMU_CS#
Text GLabel 9600 6100 0    60   Input ~ 0
Python1_Monitor
Text GLabel 9600 6200 0    60   Input ~ 0
Python2_Monitor
Text GLabel 9600 6300 0    60   Input ~ 0
Python3_Monitor
Text GLabel 9600 5100 0    60   Input ~ 0
Python_Trigger
Connection ~ 8500 4600
Connection ~ 8500 4900
Wire Wire Line
	8500 4900 9600 4900
Wire Wire Line
	8500 5600 9600 5600
Wire Wire Line
	8500 5800 9600 5800
Wire Wire Line
	10100 2300 11000 2300
Connection ~ 11000 2300
Wire Wire Line
	10100 2000 11000 2000
Connection ~ 11000 2000
Wire Wire Line
	10100 1700 11000 1700
Connection ~ 11000 1700
Wire Wire Line
	10100 1600 11000 1600
Connection ~ 11000 1600
Wire Wire Line
	10100 1500 11000 1500
Connection ~ 11000 1500
Wire Wire Line
	10100 1400 11000 1400
Connection ~ 11000 1400
Text GLabel 10100 3900 2    60   Input ~ 0
FPGA_JTAG_TMS
Text GLabel 10100 4200 2    60   Input ~ 0
FPGA_JTAG_TDO
Text GLabel 10100 4000 2    60   Input ~ 0
FPGA_JTAG_TCK
Text GLabel 10100 4300 2    60   Input ~ 0
FPGA_JTAG_TDI
Text GLabel 7100 4050 2    60   Input ~ 0
FPGA_DEBUG1
Text GLabel 6600 4050 0    60   Input ~ 0
FPGA_DEBUG2
$Comp
L R R18
U 1 1 571FCF58
P 5300 2100
F 0 "R18" H 5370 2192 50  0000 L CNN
F 1 "10k" H 5370 2100 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" V 5230 2100 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 5300 2100 30  0001 C CNN
F 4 "Vishay" H 5300 2100 50  0001 C CNN "MFN"
F 5 "CRCW020110K0FNED" H 5300 2100 50  0001 C CNN "MFP"
F 6 "digikey" H 5300 2100 50  0001 C CNN "D1"
F 7 "mouser" H 5300 2100 50  0001 C CNN "D2"
F 8 "541-10.0KABTR" H 5300 2100 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW020110K0FNED/541-10.0KABTR-ND/1178493" H 5300 2100 50  0001 C CNN "D1PL"
F 10 "_" H 5300 2100 50  0001 C CNN "D2PN"
F 11 "_" H 5300 2100 50  0001 C CNN "D2PL"
F 12 "0201" H 5300 2100 50  0001 C CNN "Package"
F 13 "_" H 5370 2008 50  0000 L CNN "Description"
F 14 "_" H 5300 2100 50  0001 C CNN "Voltage"
F 15 "1/20" H 5300 2100 50  0001 C CNN "Power"
F 16 "1%" H 5300 2100 50  0001 C CNN "Tolerance"
F 17 "_" H 5300 2100 50  0001 C CNN "Temperature"
F 18 "_" H 5300 2100 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5300 2100 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5300 2100 50  0001 C CNN "Cont.Current"
F 21 "_" H 5300 2100 50  0001 C CNN "Frequency"
F 22 "_" H 5300 2100 50  0001 C CNN "ResonnanceFreq"
	1    5300 2100
	1    0    0    -1  
$EndComp
$Comp
L R R17
U 1 1 571FD000
P 5100 2200
F 0 "R17" H 5170 2292 50  0000 L CNN
F 1 "10k" H 5170 2200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0201" V 5030 2200 30  0001 C CNN
F 3 "http://www.vishay.com/docs/20035/dcrcwe3.pdf" H 5100 2200 30  0001 C CNN
F 4 "Vishay" H 5100 2200 50  0001 C CNN "MFN"
F 5 "CRCW020110K0FNED" H 5100 2200 50  0001 C CNN "MFP"
F 6 "digikey" H 5100 2200 50  0001 C CNN "D1"
F 7 "mouser" H 5100 2200 50  0001 C CNN "D2"
F 8 "541-10.0KABTR" H 5100 2200 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/CRCW020110K0FNED/541-10.0KABTR-ND/1178493" H 5100 2200 50  0001 C CNN "D1PL"
F 10 "_" H 5100 2200 50  0001 C CNN "D2PN"
F 11 "_" H 5100 2200 50  0001 C CNN "D2PL"
F 12 "0201" H 5100 2200 50  0001 C CNN "Package"
F 13 "_" H 5170 2108 50  0000 L CNN "Description"
F 14 "_" H 5100 2200 50  0001 C CNN "Voltage"
F 15 "1/20" H 5100 2200 50  0001 C CNN "Power"
F 16 "1%" H 5100 2200 50  0001 C CNN "Tolerance"
F 17 "_" H 5100 2200 50  0001 C CNN "Temperature"
F 18 "_" H 5100 2200 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 5100 2200 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 5100 2200 50  0001 C CNN "Cont.Current"
F 21 "_" H 5100 2200 50  0001 C CNN "Frequency"
F 22 "_" H 5100 2200 50  0001 C CNN "ResonnanceFreq"
	1    5100 2200
	1    0    0    -1  
$EndComp
Text GLabel 10100 4600 2    60   Input ~ 0
FPGA_Signal2
Text GLabel 10100 4900 2    60   Input ~ 0
FPGA_Signal4
Text GLabel 10100 5000 2    60   Input ~ 0
FPGA_Signal5
Text GLabel 10100 4800 2    60   Input ~ 0
FPGA_Signal3
Text GLabel 10100 5100 2    60   Input ~ 0
FPGA_Signal6
Text GLabel 10100 5200 2    60   Input ~ 0
FPGA_Signal7
$Comp
L CONN_02X02 P2
U 1 1 57200EE6
P 6850 4000
F 0 "P2" H 6850 4461 50  0000 C CNN
F 1 "CONN_02X02" H 6850 4370 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x02_Pitch1.27mm" H 6850 4279 50  0001 C CNN
F 3 "" H 6850 2800 50  0000 C CNN
F 4 "_" H 6850 4000 60  0001 C CNN "MFN"
F 5 "_" H 6850 4000 60  0001 C CNN "MFP"
F 6 "digikey" H 6850 4000 60  0001 C CNN "D1"
F 7 "mouser" H 6850 4000 60  0001 C CNN "D2"
F 8 "_" H 6850 4000 60  0001 C CNN "D1PN"
F 9 "_" H 6850 4000 60  0001 C CNN "D1PL"
F 10 "_" H 6850 4000 60  0001 C CNN "D2PN"
F 11 "_" H 6850 4000 60  0001 C CNN "D2PL"
F 12 "_" H 6850 4000 60  0001 C CNN "Package"
F 13 "_" H 6850 4180 60  0000 C CNN "Description"
F 14 "_" H 6850 4000 60  0001 C CNN "Voltage"
F 15 "_" H 6850 4000 60  0001 C CNN "Power"
F 16 "_" H 6850 4000 60  0001 C CNN "Tolerance"
F 17 "_" H 6850 4000 60  0001 C CNN "Temperature"
F 18 "_" H 6850 4000 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 6850 4000 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 6850 4000 60  0001 C CNN "Cont.Current"
F 21 "_" H 6850 4000 60  0001 C CNN "Frequency"
F 22 "_" H 6850 4000 60  0001 C CNN "ResonnanceFreq"
	1    6850 4000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 57200F80
P 6600 3950
F 0 "#PWR013" H 6600 3700 50  0001 C CNN
F 1 "GND" H 6605 3777 50  0000 C CNN
F 2 "" H 6600 3950 50  0000 C CNN
F 3 "" H 6600 3950 50  0000 C CNN
	1    6600 3950
	-1   0    0    1   
$EndComp
$Comp
L +2V5 #PWR014
U 1 1 57200FC4
P 7100 3950
F 0 "#PWR014" H 7100 3800 50  0001 C CNN
F 1 "+2V5" H 7115 4123 50  0000 C CNN
F 2 "" H 7100 3950 50  0000 C CNN
F 3 "" H 7100 3950 50  0000 C CNN
	1    7100 3950
	1    0    0    -1  
$EndComp
Text GLabel 9600 5000 0    60   Input ~ 0
Python_RST#
Text GLabel 10100 4500 2    60   Input ~ 0
FPGA_Signal1
Connection ~ 8500 5600
$EndSCHEMATC
