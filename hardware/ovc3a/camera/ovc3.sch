EESchema Schematic File Version 4
LIBS:ovc3-cache
EELAYER 29 0
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
S 1100 1600 1100 200 
U 5BFA87C9
F0 "imagers" 118
F1 "imagers.sch" 39
$EndSheet
$Sheet
S 1100 2200 1100 200 
U 5BFAB517
F0 "imu" 118
F1 "imu.sch" 39
$EndSheet
$Sheet
S 1100 2800 1100 200 
U 5BFFC89B
F0 "usb3" 118
F1 "usb3.sch" 39
$EndSheet
$Sheet
S 1100 3450 1100 200 
U 5C124FC6
F0 "te0820" 118
F1 "te0820.sch" 50
$EndSheet
$Comp
L Graphic:Logo_Open_Hardware_Small LOGO1
U 1 1 5C46A97F
P 2200 6600
F 0 "LOGO1" H 2200 6875 50  0001 C CNN
F 1 "Logo_Open_Hardware_Small" H 2200 6375 50  0001 C CNN
F 2 "Symbol:OSHW-Symbol_6.7x6mm_SilkScreen" H 2200 6600 50  0001 C CNN
F 3 "~" H 2200 6600 50  0001 C CNN
	1    2200 6600
	1    0    0    -1  
$EndComp
$Sheet
S 1100 4100 1100 200 
U 5C470144
F0 "misc" 118
F1 "misc.sch" 50
$EndSheet
Text Notes 3900 2700 0    118  ~ 24
TODO: linux root console as 3v3 UART header (gnd, tx, rx)
$Sheet
S 1100 4750 1100 200 
U 5C58B8AF
F0 "bonus_cameras" 118
F1 "bonus_cameras.sch" 59
$EndSheet
Text Notes 3900 3100 0    118  ~ 24
TODO: 3v3 -> 1v2 dc/dc, enabled on PGOOD
Text Notes 3900 3500 0    118  ~ 24
TODO: i2c level shifters. TCA980x ?
$EndSCHEMATC
