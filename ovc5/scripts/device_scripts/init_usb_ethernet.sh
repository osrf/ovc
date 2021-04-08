#!/bin/bash

ifconfig usb0 10.0.1.1 netmask 255.255.255.0 up
ifconfig usb0 mtu 13500

rm /var/lib/dhcp/dhcpd.leases
systemctl start isc-dhcp-server.service
