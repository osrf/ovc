EESchema Schematic File Version 4
LIBS:ovc2_stereo-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 7
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
S 1200 1650 1200 200 
U 590F42A0
F0 "fpga_power" 118
F1 "fpga_power.sch" 118
$EndSheet
$Sheet
S 1200 5350 1500 250 
U 590F5214
F0 "imagers" 118
F1 "imagers.sch" 118
$EndSheet
$Sheet
S 1200 2550 1200 200 
U 590F67D7
F0 "fpga_config" 118
F1 "fpga_config.sch" 118
$EndSheet
$Sheet
S 1200 4550 1250 350 
U 596A6D90
F0 "power" 118
F1 "power.sch" 118
$EndSheet
$Sheet
S 1200 3200 1200 300 
U 59F6DCBA
F0 "fpga_pcie" 118
F1 "fpga_pcie.sch" 60
$EndSheet
$Sheet
S 1200 3850 1200 350 
U 5A96DC8F
F0 "fpga_io" 118
F1 "fpga_io.sch" 59
$EndSheet
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 5A999CEF
P 5800 4300
F 0 "J2" H 5850 5417 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 5850 5326 50  0000 C CNN
F 2 "Connectors_OSRF:SAMTEC_ERF8-020" H 5800 4300 50  0001 C CNN
F 3 "~" H 5800 4300 50  0001 C CNN
	1    5800 4300
	1    0    0    -1  
$EndComp
Text GLabel 7150 4150 2    60   Input ~ 0
JETSON_CARRIER_PWR_ON
Text GLabel 7150 4350 2    60   Input ~ 0
JETSON_RESET_OUT
Text GLabel 7150 4550 2    60   Input ~ 0
JETSON_PWR_BAD
Text Notes 4000 4300 0    50   ~ 0
TODO: >=1 uart for IMU and misc
$EndSCHEMATC
