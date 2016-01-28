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
Sheet 13 14
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
L LSM6DS3 U3
U 1 1 56A18FC9
P 2300 2100
F 0 "U3" H 2050 2800 50  0000 C CNN
F 1 "ST_LSM6DS3" H 1950 1700 50  0000 C CNN
F 2 "Housings_LGA:LGA14_2.5X3X0.86" H 2300 2100 200 0001 C CNN
F 3 "http://www.st.com/web/en/resource/technical/document/datasheet/DM00133076.pdf" H 2300 2100 500 0001 C CNN
F 4 "STMicroelectronics" H 2300 2100 60  0001 C CNN "MFN"
F 5 "LSM6DS3TR" H 2300 2100 60  0001 C CNN "MFP"
F 6 "digikey" H 2300 2100 60  0001 C CNN "D1"
F 7 "mouser" H 2300 2100 60  0001 C CNN "D2"
F 8 "497-15383" H 2300 2100 60  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/LSM6DS3TR/497-15383-1-ND/5180534" H 2300 2100 60  0001 C CNN "D1PL"
F 10 "_" H 2300 2100 60  0001 C CNN "D2PN"
F 11 "_" H 2300 2100 60  0001 C CNN "D2PL"
F 12 "LGA14" H 2300 2100 60  0001 C CNN "Package"
F 13 "_" H 2300 2100 60  0000 C CNN "Description"
F 14 "_" H 2300 2100 60  0001 C CNN "Voltage"
F 15 "_" H 2300 2100 60  0001 C CNN "Power"
F 16 "_" H 2300 2100 60  0001 C CNN "Tolerance"
F 17 "_" H 2300 2100 60  0001 C CNN "Temperature"
F 18 "_" H 2300 2100 60  0001 C CNN "ReverseVoltage"
F 19 "_" H 2300 2100 60  0001 C CNN "ForwardVoltage"
F 20 "_" H 2300 2100 60  0001 C CNN "Cont.Current"
F 21 "_" H 2300 2100 60  0001 C CNN "Frequency"
F 22 "_" H 2300 2100 60  0001 C CNN "ResonnanceFreq"
	1    2300 2100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR21
U 1 1 56A18FCF
P 2300 2600
F 0 "#PWR21" H 2300 2350 50  0001 C CNN
F 1 "GND" H 2300 2450 50  0000 C CNN
F 2 "" H 2300 2600 60  0000 C CNN
F 3 "" H 2300 2600 60  0000 C CNN
	1    2300 2600
	1    0    0    -1  
$EndComp
$Comp
L C C12
U 1 1 56A18FE8
P 2900 1250
F 0 "C12" H 2925 1350 50  0000 L CNN
F 1 "100n" H 2925 1150 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 2938 1100 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 2900 1250 50  0001 C CNN
F 4 "TDK" H 2900 1250 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 2900 1250 50  0001 C CNN "MFP"
F 6 "digikey" H 2900 1250 50  0001 C CNN "D1"
F 7 "mouser" H 2900 1250 50  0001 C CNN "D2"
F 8 "445-1266" H 2900 1250 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 2900 1250 50  0001 C CNN "D1PL"
F 10 "_" H 2900 1250 50  0001 C CNN "D2PN"
F 11 "_" H 2900 1250 50  0001 C CNN "D2PL"
F 12 "0402" H 2900 1250 50  0001 C CNN "Package"
F 13 "_" H 2900 1250 50  0000 C CNN "Description"
F 14 "6.3" H 2900 1250 50  0001 C CNN "Voltage"
F 15 "_" H 2900 1250 50  0001 C CNN "Power"
F 16 "10%" H 2900 1250 50  0001 C CNN "Tolerance"
F 17 "X5R" H 2900 1250 50  0001 C CNN "Temperature"
F 18 "_" H 2900 1250 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 2900 1250 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 2900 1250 50  0001 C CNN "Cont.Current"
F 21 "_" H 2900 1250 50  0001 C CNN "Frequency"
F 22 "_" H 2900 1250 50  0001 C CNN "ResonnanceFreq"
	1    2900 1250
	1    0    0    -1  
$EndComp
$Comp
L +1V8 #PWR15
U 1 1 56A19007
P 1700 1150
F 0 "#PWR15" H 1700 1000 50  0001 C CNN
F 1 "+1V8" H 1700 1290 50  0000 C CNN
F 2 "" H 1700 1150 60  0000 C CNN
F 3 "" H 1700 1150 60  0000 C CNN
	1    1700 1150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR16
U 1 1 56A1900D
P 1700 1450
F 0 "#PWR16" H 1700 1200 50  0001 C CNN
F 1 "GND" H 1700 1300 50  0000 C CNN
F 2 "" H 1700 1450 60  0000 C CNN
F 3 "" H 1700 1450 60  0000 C CNN
	1    1700 1450
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR13
U 1 1 56A19013
P 1650 2050
F 0 "#PWR13" H 1650 1800 50  0001 C CNN
F 1 "GND" H 1650 1900 50  0000 C CNN
F 2 "" H 1650 2050 60  0000 C CNN
F 3 "" H 1650 2050 60  0000 C CNN
	1    1650 2050
	1    0    0    -1  
$EndComp
$Comp
L C C16
U 1 1 56A19001
P 1700 1300
F 0 "C16" H 1725 1400 50  0000 L CNN
F 1 "100n" H 1725 1200 50  0000 L CNN
F 2 "Dipoles_SMD:C_0402" H 1738 1150 50  0001 C CNN
F 3 "http://product.tdk.com/en/catalog/datasheets/mlcc_commercial_general_en.pdf" H 1700 1300 50  0001 C CNN
F 4 "TDK" H 1700 1300 50  0001 C CNN "MFN"
F 5 "C1005X5R0J104K050BA" H 1700 1300 50  0001 C CNN "MFP"
F 6 "digikey" H 1700 1300 50  0001 C CNN "D1"
F 7 "mouser" H 1700 1300 50  0001 C CNN "D2"
F 8 "445-1266" H 1700 1300 50  0001 C CNN "D1PN"
F 9 "http://www.digikey.com/product-detail/en/C1005X5R0J104K050BA/445-1266-1-ND/567731" H 1700 1300 50  0001 C CNN "D1PL"
F 10 "_" H 1700 1300 50  0001 C CNN "D2PN"
F 11 "_" H 1700 1300 50  0001 C CNN "D2PL"
F 12 "0402" H 1700 1300 50  0001 C CNN "Package"
F 13 "_" H 1700 1300 50  0000 C CNN "Description"
F 14 "6.3" H 1700 1300 50  0001 C CNN "Voltage"
F 15 "_" H 1700 1300 50  0001 C CNN "Power"
F 16 "10%" H 1700 1300 50  0001 C CNN "Tolerance"
F 17 "X5R" H 1700 1300 50  0001 C CNN "Temperature"
F 18 "_" H 1700 1300 50  0001 C CNN "ReverseVoltage"
F 19 "_" H 1700 1300 50  0001 C CNN "ForwardVoltage"
F 20 "_" H 1700 1300 50  0001 C CNN "Cont.Current"
F 21 "_" H 1700 1300 50  0001 C CNN "Frequency"
F 22 "_" H 1700 1300 50  0001 C CNN "ResonnanceFreq"
	1    1700 1300
	1    0    0    -1  
$EndComp
$Comp
L +2V5 #PWR27
U 1 1 56A871D3
P 2900 1100
F 0 "#PWR27" H 2900 950 50  0001 C CNN
F 1 "+2V5" H 2918 1274 50  0000 C CNN
F 2 "" H 2900 1100 50  0000 C CNN
F 3 "" H 2900 1100 50  0000 C CNN
	1    2900 1100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR28
U 1 1 56A871ED
P 2900 1400
F 0 "#PWR28" H 2900 1150 50  0001 C CNN
F 1 "GND" H 2908 1226 50  0000 C CNN
F 2 "" H 2900 1400 50  0000 C CNN
F 3 "" H 2900 1400 50  0000 C CNN
	1    2900 1400
	1    0    0    -1  
$EndComp
Text Notes 1200 800  0    60   ~ 0
Use both IMU and Camera on same SPI 
Text GLabel 2800 1800 2    60   Input ~ 0
IMU_SS#
Text GLabel 1800 1700 0    60   Input ~ 0
IMU_INT1
Text GLabel 1800 1800 0    60   Input ~ 0
IMU_INT2
Text GLabel 1800 1900 0    60   Input ~ 0
SPI_MISO
Text GLabel 2800 2000 2    60   Input ~ 0
SPI_MOSI
Text GLabel 2800 1900 2    60   Input ~ 0
SPI_SCK
Wire Wire Line
	2300 2600 2400 2600
Wire Wire Line
	1800 2000 1800 2100
Wire Wire Line
	1800 2050 1650 2050
Wire Wire Line
	2300 1300 2300 1150
Wire Wire Line
	2300 1150 1700 1150
Wire Wire Line
	2400 1300 2400 1100
Wire Wire Line
	2400 1100 2900 1100
Connection ~ 1800 2050
NoConn ~ 2500 1300
NoConn ~ 1800 2200
$EndSCHEMATC
