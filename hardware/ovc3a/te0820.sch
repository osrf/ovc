EESchema Schematic File Version 4
LIBS:ovc3-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 5
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
L trenz:TE0820 U?
U 1 1 5C12562E
P 8900 1800
AR Path="/5C12562E" Ref="U?"  Part="1" 
AR Path="/5C124FC6/5C12562E" Ref="M1"  Part="1" 
F 0 "M1" H 8887 2025 50  0000 C CNN
F 1 "TE0820" H 8887 1934 50  0000 C CNN
F 2 "Trenz:TE0820" H 8900 1800 50  0001 C CNN
F 3 "" H 8900 1800 50  0001 C CNN
	1    8900 1800
	1    0    0    -1  
$EndComp
Text Notes 1500 1050 0    157  ~ 31
https://wiki.trenz-electronic.de/display/PD/TE0820+TRM
$Comp
L connectors:CONN_02X50 JB1
U 1 1 5C15C5B8
P 2400 4350
F 0 "JB1" H 2400 6923 50  0000 C CNN
F 1 "CONN_02X50" H 2400 6924 50  0001 C CNN
F 2 "Connector_Samtec:Samtec_LSHM-150-xx.x-x-DV-S_2x50-1SH_P0.50mm_Vertical" H 2400 7037 60  0001 C CNN
F 3 "none" H 2400 6931 60  0001 C CNN
	1    2400 4350
	1    0    0    -1  
$EndComp
$Comp
L connectors:CONN_02X50 JB2
U 1 1 5C1604D6
P 5100 4300
F 0 "JB2" H 5100 6873 50  0000 C CNN
F 1 "CONN_02X50" H 5100 6874 50  0001 C CNN
F 2 "Connector_Samtec:Samtec_LSHM-150-xx.x-x-DV-S_2x50-1SH_P0.50mm_Vertical" H 5100 6987 60  0001 C CNN
F 3 "none" H 5100 6881 60  0001 C CNN
	1    5100 4300
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x30_Odd_Even JB3
U 1 1 5C166282
P 7750 3250
F 0 "JB3" H 7800 4775 50  0000 C CNN
F 1 "Conn_02x30_Odd_Even" H 7800 4776 50  0001 C CNN
F 2 "Connector_Samtec:Samtec_LSHM-130-xx.x-x-DV-S_2x30-1SH_P0.50mm_Vertical" H 7750 3250 50  0001 C CNN
F 3 "~" H 7750 3250 50  0001 C CNN
	1    7750 3250
	1    0    0    -1  
$EndComp
Text Notes 7150 2800 0    50   ~ 0
usb3
Text Notes 8250 2800 0    50   ~ 0
usb3
$EndSCHEMATC
