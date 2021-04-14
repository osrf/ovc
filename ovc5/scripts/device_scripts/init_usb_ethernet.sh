#!/bin/bash

service isc-dhcp-server stop
ifconfig usb0 down

killall dhcpd
rm -f /var/run/dhcpd.pid
rm -f /var/lib/dhcp/dhcpd.leases

ifconfig usb0 10.0.1.1 netmask 255.255.255.0 up
ifconfig usb0 mtu 13500

ifconfig usb0 up
service isc-dhcp-server start
