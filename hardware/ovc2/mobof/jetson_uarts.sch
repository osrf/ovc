EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 10 16
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
L tx2:Jetson U3
U 16 1 5989293D
P 1450 2050
F 0 "U3" H 1956 3215 50  0000 C CNN
F 1 "Jetson" H 1956 3124 50  0000 C CNN
F 2 "Jetson:JETSON_TX" H 1450 2050 50  0001 C CNN
F 3 "" H 1450 2050 50  0001 C CNN
F 4 "samtec" H 1450 2050 50  0001 C CNN "D1"
F 5 "SEAM-50-02.0-S-08-2-A-K-TR" H 1450 2050 50  0001 C CNN "D1PN"
F 6 "Samtec" H 1450 2050 50  0001 C CNN "MFN"
F 7 "SEAM-50-02.0-S-08-2-A-K-TR" H 1956 3315 50  0001 C CNN "MPN"
	16   1450 2050
	1    0    0    -1  
$EndComp
Text Label 2500 1650 0    60   ~ 0
UART1_TX
Text Label 2500 1750 0    60   ~ 0
UART1_RX
Text Label 2500 2050 0    60   ~ 0
UART2_TX
Text Label 2500 2150 0    60   ~ 0
UART2_RX
Text Label 2500 1250 0    60   ~ 0
UART0_TX
Text Label 2500 1350 0    60   ~ 0
UART0_RX
Wire Wire Line
	2450 1650 3050 1650
Wire Wire Line
	2450 1750 3050 1750
Wire Wire Line
	2450 2050 3050 2050
Wire Wire Line
	2450 2150 3050 2150
Wire Wire Line
	2450 1250 3050 1250
Wire Wire Line
	2450 1350 3050 1350
Text Notes 3750 1200 0    50   ~ 0
This is the boot console.
Text Notes 3550 1650 0    50   ~ 0
TODO: bring all UARTs to daughterboard connector.
Text GLabel 3050 1250 2    50   Input ~ 0
CONSOLE_TX
Text GLabel 3050 1350 2    50   Input ~ 0
CONSOLE_RX
Text Notes 3650 1350 0    50   ~ 0
TODO: level-shift IC
$EndSCHEMATC
