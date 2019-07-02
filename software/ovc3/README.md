## Setup

OVC 3 is running a full Ubuntu distribution and a ROS node in itself.
On startup, it will configure itself as a USB ethernet gadget with a static IP of 10.0.1.1 and ia DHCP server that will assign an IP of 10.0.1.2 to the connected host, it will then look for a ROS master in 10.0.1.2, once it is found it will start publishing the images and IMU data.

**The board should automatically assign an IP to your machine**, however if this doesn't work you can manually configure your PC to have a static IP.
To do so, edit your /etc/network/interfaces file and add the following:

~~~~
allow-hotplug enp9s0u1
iface enp9s0u1 inet static
  address 10.0.1.2
  netmask 255.255.255.0
  mtu 13500
  pre-up sleep 5 # Hack to wait for ovc networking to restart
~~~~

Please note, the name of the interface (enp9s0u1 in the example) might be different on your machine, to find out the interface name plug the OVC, wait for it to boot up and run

ip a

on your machine.

## Message definitions

If you want to read all the output from the node (i.e. the image corners) you will need the custom message definitions, you can obtain them by building the node on your host machine as well.