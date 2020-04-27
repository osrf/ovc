EESchema Schematic File Version 5
EELAYER 34 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
Comment5 ""
Comment6 ""
Comment7 ""
Comment8 ""
Comment9 ""
$EndDescr
Connection ~ 6750 1500
Connection ~ 6750 1800
Connection ~ 6750 2000
Connection ~ 6750 2300
Connection ~ 6750 2600
Connection ~ 6750 2900
Connection ~ 4600 1500
Connection ~ 4600 1800
Connection ~ 4600 2900
Connection ~ 4600 2300
Connection ~ 4600 2600
Connection ~ 4600 2000
Connection ~ 5350 4600
Connection ~ 5350 5200
Connection ~ 5350 4900
Connection ~ 7500 4900
Connection ~ 7500 5200
Connection ~ 7500 4600
NoConn ~ 2150 3500
NoConn ~ 2150 3600
NoConn ~ 5500 5400
NoConn ~ 7650 5400
NoConn ~ 2150 5700
NoConn ~ 2150 6000
Wire Wire Line
	4500 5700 5500 5700
Wire Wire Line
	4600 1200 4600 1500
Wire Wire Line
	4600 1500 4600 1800
Wire Wire Line
	4600 1500 5500 1500
Wire Wire Line
	4600 1800 4600 2000
Wire Wire Line
	4600 1800 5500 1800
Wire Wire Line
	4600 2000 4600 2300
Wire Wire Line
	4600 2000 5500 2000
Wire Wire Line
	4600 2300 4600 2600
Wire Wire Line
	4600 2300 5500 2300
Wire Wire Line
	4600 2600 4600 2900
Wire Wire Line
	4600 2600 5500 2600
Wire Wire Line
	4600 2900 4600 3600
Wire Wire Line
	4600 2900 5500 2900
Wire Wire Line
	4800 3400 5500 3400
Wire Wire Line
	5200 4400 5500 4400
Wire Wire Line
	5200 4500 5500 4500
Wire Wire Line
	5200 4700 5500 4700
Wire Wire Line
	5200 4800 5500 4800
Wire Wire Line
	5200 5000 5500 5000
Wire Wire Line
	5200 5100 5500 5100
Wire Wire Line
	5200 5300 5500 5300
Wire Wire Line
	5200 5500 5500 5500
Wire Wire Line
	5200 5600 5500 5600
Wire Wire Line
	5350 4300 5350 4600
Wire Wire Line
	5350 4600 5350 4900
Wire Wire Line
	5350 4600 5500 4600
Wire Wire Line
	5350 4900 5350 5200
Wire Wire Line
	5350 4900 5500 4900
Wire Wire Line
	5350 5200 5350 5850
Wire Wire Line
	5350 5200 5500 5200
Wire Wire Line
	5500 1200 4600 1200
Wire Wire Line
	5500 4300 5350 4300
Wire Wire Line
	6650 5700 7650 5700
Wire Wire Line
	6750 1200 6750 1500
Wire Wire Line
	6750 1500 6750 1800
Wire Wire Line
	6750 1500 7650 1500
Wire Wire Line
	6750 1800 6750 2000
Wire Wire Line
	6750 1800 7650 1800
Wire Wire Line
	6750 2000 6750 2300
Wire Wire Line
	6750 2000 7650 2000
Wire Wire Line
	6750 2300 6750 2600
Wire Wire Line
	6750 2300 7650 2300
Wire Wire Line
	6750 2600 6750 2900
Wire Wire Line
	6750 2600 7650 2600
Wire Wire Line
	6750 2900 6750 3600
Wire Wire Line
	6750 2900 7650 2900
Wire Wire Line
	6950 3400 7650 3400
Wire Wire Line
	7350 4400 7650 4400
Wire Wire Line
	7350 4500 7650 4500
Wire Wire Line
	7350 4700 7650 4700
Wire Wire Line
	7350 4800 7650 4800
Wire Wire Line
	7350 5000 7650 5000
Wire Wire Line
	7350 5100 7650 5100
Wire Wire Line
	7350 5300 7650 5300
Wire Wire Line
	7350 5500 7650 5500
Wire Wire Line
	7350 5600 7650 5600
Wire Wire Line
	7500 4300 7500 4600
Wire Wire Line
	7500 4600 7500 4900
Wire Wire Line
	7500 4600 7650 4600
Wire Wire Line
	7500 4900 7500 5200
Wire Wire Line
	7500 4900 7650 4900
Wire Wire Line
	7500 5200 7500 5850
Wire Wire Line
	7500 5200 7650 5200
Wire Wire Line
	7650 1200 6750 1200
Wire Wire Line
	7650 4300 7500 4300
Text Notes 4150 6525 2    50   ~ 0
TODO CAM_I2C Shared with onboard device, should be fine since Pi cam is supported\nCarrier board uses a MUX for two pi cams, consider adding for out of the box support
Text Notes 7900 1000 2    50   ~ 0
TODO decide how to use only GPIO (or use ENABLE as gpio as well)
Text GLabel 2150 1400 2    50   Input ~ 0
PICAM0_CLK-
Text GLabel 2150 1500 2    50   Input ~ 0
PICAM0_CLK+
Text GLabel 2150 1600 2    50   Input ~ 0
PICAM0_DAT0-
Text GLabel 2150 1700 2    50   Input ~ 0
PICAM0_DAT0+
Text GLabel 2150 1800 2    50   Input ~ 0
PICAM0_DAT1-
Text GLabel 2150 1900 2    50   Input ~ 0
PICAM0_DAT1+
Text GLabel 2150 2100 2    50   Input ~ 0
PICAM1_CLK-
Text GLabel 2150 2200 2    50   Input ~ 0
PICAM1_CLK+
Text GLabel 2150 2300 2    50   Input ~ 0
PICAM1_DAT0-
Text GLabel 2150 2400 2    50   Input ~ 0
PICAM1_DAT0+
Text GLabel 2150 2500 2    50   Input ~ 0
PICAM1_DAT1-
Text GLabel 2150 2600 2    50   Input ~ 0
PICAM1_DAT1+
Text GLabel 2150 2800 2    50   Input ~ 0
CAM0_CLK0-
Text GLabel 2150 2900 2    50   Input ~ 0
CAM0_CLK0+
Text GLabel 2150 3000 2    50   Input ~ 0
CAM0_DAT0-
Text GLabel 2150 3100 2    50   Input ~ 0
CAM0_DAT0+
Text GLabel 2150 3200 2    50   Input ~ 0
CAM0_DAT1-
Text GLabel 2150 3300 2    50   Input ~ 0
CAM0_DAT1+
Text GLabel 2150 3700 2    50   Input ~ 0
CAM0_DAT2-
Text GLabel 2150 3800 2    50   Input ~ 0
CAM0_DAT2+
Text GLabel 2150 3900 2    50   Input ~ 0
CAM0_DAT3-
Text GLabel 2150 4000 2    50   Input ~ 0
CAM0_DAT3+
Text GLabel 2150 4200 2    50   Input ~ 0
CAM1_CLK0-
Text GLabel 2150 4300 2    50   Input ~ 0
CAM1_CLK0+
Text GLabel 2150 4400 2    50   Input ~ 0
CAM1_DAT0-
Text GLabel 2150 4500 2    50   Input ~ 0
CAM1_DAT0+
Text GLabel 2150 4600 2    50   Input ~ 0
CAM1_DAT1-
Text GLabel 2150 4700 2    50   Input ~ 0
CAM1_DAT1+
Text GLabel 2150 4800 2    50   Input ~ 0
CAM1_DAT2-
Text GLabel 2150 4900 2    50   Input ~ 0
CAM1_DAT2+
Text GLabel 2150 5000 2    50   Input ~ 0
CAM1_DAT3-
Text GLabel 2150 5100 2    50   Input ~ 0
CAM1_DAT3+
Text GLabel 2150 5300 2    50   Input ~ 0
PICAM0_SCL
Text GLabel 2150 5400 2    50   Input ~ 0
PICAM0_SDA
Text GLabel 2150 5600 2    50   Input ~ 0
PICAM0_ENABLE
Text GLabel 2150 5900 2    50   Input ~ 0
PICAM1_ENABLE
Text GLabel 5200 4400 0    50   Input ~ 0
PICAM0_DAT0-
Text GLabel 5200 4500 0    50   Input ~ 0
PICAM0_DAT0+
Text GLabel 5200 4700 0    50   Input ~ 0
PICAM0_DAT1-
Text GLabel 5200 4800 0    50   Input ~ 0
PICAM0_DAT1+
Text GLabel 5200 5000 0    50   Input ~ 0
PICAM0_CLK-
Text GLabel 5200 5100 0    50   Input ~ 0
PICAM0_CLK+
Text GLabel 5200 5300 0    50   Input ~ 0
PICAM0_ENABLE
Text GLabel 5200 5500 0    50   Input ~ 0
PICAM0_SCL
Text GLabel 5200 5600 0    50   Input ~ 0
PICAM0_SDA
Text GLabel 5500 1300 0    50   Input ~ 0
CAM0_DAT3-
Text GLabel 5500 1400 0    50   Input ~ 0
CAM0_DAT3+
Text GLabel 5500 1600 0    50   Input ~ 0
CAM0_DAT2-
Text GLabel 5500 1700 0    50   Input ~ 0
CAM0_DAT2+
Text GLabel 5500 2100 0    50   Input ~ 0
CAM0_DAT0-
Text GLabel 5500 2200 0    50   Input ~ 0
CAM0_DAT0+
Text GLabel 5500 2400 0    50   Input ~ 0
CAM0_DAT1-
Text GLabel 5500 2500 0    50   Input ~ 0
CAM0_DAT1+
Text GLabel 5500 2700 0    50   Input ~ 0
CAM0_CLK-
Text GLabel 5500 2800 0    50   Input ~ 0
CAM0_CLK+
Text GLabel 5500 3100 0    50   Input ~ 0
CAM0_TRIGGER
Text GLabel 5500 3200 0    50   Input ~ 0
CAM0_SCL
Text GLabel 5500 3300 0    50   Input ~ 0
CAM0_SDA
Text GLabel 7350 4400 0    50   Input ~ 0
PICAM1_DAT0-
Text GLabel 7350 4500 0    50   Input ~ 0
PICAM1_DAT0+
Text GLabel 7350 4700 0    50   Input ~ 0
PICAM1_DAT1-
Text GLabel 7350 4800 0    50   Input ~ 0
PICAM1_DAT1+
Text GLabel 7350 5000 0    50   Input ~ 0
PICAM1_CLK-
Text GLabel 7350 5100 0    50   Input ~ 0
PICAM1_CLK+
Text GLabel 7350 5300 0    50   Input ~ 0
PICAM1_ENABLE
Text GLabel 7350 5500 0    50   Input ~ 0
PICAM1_SCL
Text GLabel 7350 5600 0    50   Input ~ 0
PICAM1_SDA
Text GLabel 7650 1300 0    50   Input ~ 0
CAM1_DAT3-
Text GLabel 7650 1400 0    50   Input ~ 0
CAM1_DAT3+
Text GLabel 7650 1600 0    50   Input ~ 0
CAM1_DAT2-
Text GLabel 7650 1700 0    50   Input ~ 0
CAM1_DAT2+
Text GLabel 7650 2100 0    50   Input ~ 0
CAM1_DAT0-
Text GLabel 7650 2200 0    50   Input ~ 0
CAM1_DAT0+
Text GLabel 7650 2400 0    50   Input ~ 0
CAM1_DAT1-
Text GLabel 7650 2500 0    50   Input ~ 0
CAM1_DAT1+
Text GLabel 7650 2700 0    50   Input ~ 0
CAM1_CLK-
Text GLabel 7650 2800 0    50   Input ~ 0
CAM1_CLK+
Text GLabel 7650 3100 0    50   Input ~ 0
CAM1_TRIGGER
Text GLabel 7650 3200 0    50   Input ~ 0
CAM1_SCL
Text GLabel 7650 3300 0    50   Input ~ 0
CAM1_SDA
$Comp
L power:+3V3 #PWR0170
U 1 1 5EAFC299
P 4500 5700
F 0 "#PWR0170" H 4500 5550 50  0001 C CNN
F 1 "+3V3" H 4515 5873 50  0000 C CNN
F 2 "" H 4500 5700 50  0001 C CNN
F 3 "" H 4500 5700 50  0001 C CNN
	1    4500 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0167
U 1 1 5EB5706A
P 4800 3400
F 0 "#PWR0167" H 4800 3250 50  0001 C CNN
F 1 "+3V3" H 4815 3573 50  0000 C CNN
F 2 "" H 4800 3400 50  0001 C CNN
F 3 "" H 4800 3400 50  0001 C CNN
	1    4800 3400
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0173
U 1 1 5EB00BB6
P 6650 5700
F 0 "#PWR0173" H 6650 5550 50  0001 C CNN
F 1 "+3V3" H 6665 5873 50  0000 C CNN
F 2 "" H 6650 5700 50  0001 C CNN
F 3 "" H 6650 5700 50  0001 C CNN
	1    6650 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0171
U 1 1 5EB27C8C
P 6950 3400
F 0 "#PWR0171" H 6950 3250 50  0001 C CNN
F 1 "+3V3" H 6965 3573 50  0000 C CNN
F 2 "" H 6950 3400 50  0001 C CNN
F 3 "" H 6950 3400 50  0001 C CNN
	1    6950 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0168
U 1 1 5EB57076
P 4600 3600
F 0 "#PWR0168" H 4600 3350 50  0001 C CNN
F 1 "GND" H 4605 3427 50  0001 C CNN
F 2 "" H 4600 3600 50  0001 C CNN
F 3 "" H 4600 3600 50  0001 C CNN
	1    4600 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0169
U 1 1 5EADCC62
P 5350 5850
F 0 "#PWR0169" H 5350 5600 50  0001 C CNN
F 1 "GND" H 5355 5677 50  0001 C CNN
F 2 "" H 5350 5850 50  0001 C CNN
F 3 "" H 5350 5850 50  0001 C CNN
	1    5350 5850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0166
U 1 1 5EB5705E
P 5900 3600
F 0 "#PWR0166" H 5900 3350 50  0001 C CNN
F 1 "GND" H 5905 3427 50  0001 C CNN
F 2 "" H 5900 3600 50  0001 C CNN
F 3 "" H 5900 3600 50  0001 C CNN
	1    5900 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0165
U 1 1 5EB397F4
P 6750 3600
F 0 "#PWR0165" H 6750 3350 50  0001 C CNN
F 1 "GND" H 6755 3427 50  0001 C CNN
F 2 "" H 6750 3600 50  0001 C CNN
F 3 "" H 6750 3600 50  0001 C CNN
	1    6750 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0174
U 1 1 5EB00BA1
P 7500 5850
F 0 "#PWR0174" H 7500 5600 50  0001 C CNN
F 1 "GND" H 7505 5677 50  0001 C CNN
F 2 "" H 7500 5850 50  0001 C CNN
F 3 "" H 7500 5850 50  0001 C CNN
	1    7500 5850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0172
U 1 1 5EB2520D
P 8050 3600
F 0 "#PWR0172" H 8050 3350 50  0001 C CNN
F 1 "GND" H 8055 3427 50  0001 C CNN
F 2 "" H 8050 3600 50  0001 C CNN
F 3 "" H 8050 3600 50  0001 C CNN
	1    8050 3600
	1    0    0    -1  
$EndComp
$Comp
L connectors:PICAM U13
U 1 1 5EAF3149
P 5900 4950
F 0 "U13" H 6228 4914 50  0000 L CNN
F 1 "PICAM" H 6228 4824 50  0000 L CNN
F 2 "Connectors_OSRF:AMPHENOL_SFW15R" H 6550 3950 50  0001 C CNN
F 3 "" H 6550 3950 50  0001 C CNN
	1    5900 4950
	1    0    0    -1  
$EndComp
$Comp
L connectors:PICAM U15
U 1 1 5EAF4B7F
P 8050 4950
F 0 "U15" H 8378 4914 50  0000 L CNN
F 1 "PICAM" H 8378 4824 50  0000 L CNN
F 2 "Connectors_OSRF:AMPHENOL_SFW15R" H 8700 3950 50  0001 C CNN
F 3 "" H 8700 3950 50  0001 C CNN
	1    8050 4950
	1    0    0    -1  
$EndComp
$Comp
L connectors:PICAM_Expandable U?
U 1 1 5EB57008
P 5900 2500
AR Path="/5EB57008" Ref="U?"  Part="1" 
AR Path="/5EA124C3/5EB57008" Ref="U12"  Part="1" 
F 0 "U12" H 5078 1439 50  0000 L CNN
F 1 "PICAM_Expandable" H 5078 1349 50  0000 L CNN
F 2 "Connectors_OSRF:AMPHENOL_SFW15R+SFW21R" H 6550 1350 50  0001 C CNN
F 3 "" H 6550 1350 50  0001 C CNN
	1    5900 2500
	1    0    0    -1  
$EndComp
$Comp
L connectors:PICAM_Expandable U?
U 1 1 5EB23575
P 8050 2500
AR Path="/5EB23575" Ref="U?"  Part="1" 
AR Path="/5EA124C3/5EB23575" Ref="U14"  Part="1" 
F 0 "U14" H 7178 1489 50  0000 L CNN
F 1 "PICAM_Expandable" H 7178 1399 50  0000 L CNN
F 2 "Connectors_OSRF:AMPHENOL_SFW15R+SFW21R" H 8700 1350 50  0001 C CNN
F 3 "" H 8700 1350 50  0001 C CNN
	1    8050 2500
	1    0    0    -1  
$EndComp
$Comp
L nvidia_jetson:Jetson_Nano U1
U 2 1 5E9ED0B1
P 1650 3700
F 0 "U1" H 1755 6364 50  0000 C CNN
F 1 "Jetson_Nano" H 1755 6273 50  0000 C CNN
F 2 "Connectors_OSRF:TE_2309413-1" H 1750 1400 50  0001 C CNN
F 3 "" H 2550 1900 50  0001 C CNN
	2    1650 3700
	1    0    0    -1  
$EndComp
$EndSCHEMATC
