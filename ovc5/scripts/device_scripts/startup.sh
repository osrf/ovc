#!/bin/bash

if [ ! -f /root/C/a.out ]; then
	echo "USB script not found, compiling"
	g++ /root/C/hub_config.cpp -o /root/C/a.out
fi
/root/C/a.out
/root/ethernet_utils/make_usb_gadget
sleep 5;
/root/ethernet_utils/init_usb_ethernet.sh

# IRQ affinity for USB interrupts on different cores
echo 8 > /proc/irq/72/smp_affinity
echo 4 > /proc/irq/69/smp_affinity
