#!/bin/bash

USB_GADGETS=/sys/kernel/config/usb_gadget

create_gadget () {
  cd $USB_GADGETS

  # create gadget directory and enter it
  mkdir g1
  cd g1

  # USB ids
  echo 0x1d6b > idVendor
  echo 0x104 > idProduct

  # USB strings, optional
  mkdir strings/0x409 # US English, others rarely seen
  echo "Collabora" > strings/0x409/manufacturer
  echo "ECM" > strings/0x409/product

  # create the (only) configuration
  mkdir configs/c.1 # dot and number mandatory

  # create the (only) function
  mkdir functions/ecm.usb0 # .

  # assign function to configuration
  ln -s functions/ecm.usb0/ configs/c.1/

  # bind!
  echo fe300000.dwc3 > UDC # ls /sys/class/udc to see available UDCs
}

add_subnet () {
subnet_text="
subnet 10.0.1.0 netmask 255.255.255.0 {
  interface usb0;
  range 10.0.1.2 10.0.1.200;
  #option routers 10.0.1.1;
  option interface-mtu 13500;
}"

  grep -qxF "$subnet_text" /etc/dhcp/dhcpd.conf || echo "$subnet_text" >> /etc/dhcp/dhcpd.conf
}

if [ -z $USB_GADGETS/g1 ]; then
  create_gadget
fi

add_subnet
