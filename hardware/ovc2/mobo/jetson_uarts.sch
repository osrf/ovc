EESchema Schematic File Version 4
LIBS:ovc2_mobo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 13 16
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
Text Label 2500 1850 0    60   ~ 0
UART1_CTS
Text Label 2500 1950 0    60   ~ 0
UART1_RTS
Text Label 2500 2050 0    60   ~ 0
UART2_TX
Text Label 2500 2150 0    60   ~ 0
UART2_RX
Text Label 2500 1250 0    60   ~ 0
UART0_TX
Text Label 2500 1350 0    60   ~ 0
UART0_RX
Text Label 2500 1450 0    60   ~ 0
UART0_CTS
Text Label 2500 1550 0    60   ~ 0
UART0_RTS
Text Label 2500 2850 0    60   ~ 0
UART7_TX
Text Label 2500 2950 0    60   ~ 0
UART7_RX
Wire Wire Line
	2450 1650 3050 1650
Wire Wire Line
	2450 1750 3050 1750
Wire Wire Line
	2450 1850 3050 1850
Wire Wire Line
	2450 1950 3050 1950
Wire Wire Line
	2450 2050 3050 2050
Wire Wire Line
	2450 2150 3050 2150
Wire Wire Line
	2450 1250 3050 1250
Wire Wire Line
	2450 1350 3050 1350
Wire Wire Line
	2450 1450 3050 1450
Wire Wire Line
	2450 1550 3050 1550
Wire Wire Line
	2450 2850 3050 2850
Wire Wire Line
	2450 2950 3050 2950
Text GLabel 1750 3800 2    60   Input ~ 0
FPGA_CONFIG_DCLK
Text GLabel 1750 3700 2    60   Input ~ 0
FPGA_CVP_CONF_DONE
Text GLabel 1750 3900 2    60   Input ~ 0
FPGA_CONF_DONE
Text GLabel 1750 4000 2    60   Input ~ 0
FPGA_NSTATUS
Text GLabel 1750 4100 2    60   Input ~ 0
FPGA_NCONFIG
Text GLabel 1750 4200 2    60   Input ~ 0
FPGA_CONFIG_DATA0
Text Notes 2550 3100 0    50   ~ 0
TODO: select another uart. UART7 has stuff on it.
Text Notes 3200 1400 0    50   ~ 0
This is the boot console.
Text Notes 3500 1700 0    50   ~ 0
TODO: bring all UARTs to daughterboard connector.
$EndSCHEMATC
