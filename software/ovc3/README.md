## Setup

OVC 3 is running a full Ubuntu distribution and a ROS node in itself.
On startup, it will configure itself as a USB ethernet gadget with a static IP of 10.0.1.1 and ia DHCP server that will assign an IP of 10.0.1.2 to the connected host, it will then look for a ROS master in 10.0.1.2, once it is found it will start publishing images, IMU data, corner features and calibration data.

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

`ip a`

on your machine.

### Message definitions

If you want to read all the output from the node (i.e. the image corners) you will need the custom message definitions, you can obtain them by building the node on your host machine as well.

## Calibrating the sensor

The OVC is running a camera_info_manager, hence it exposes services to calibrate the camera and store the parameters in non volatile memory (they will be saved in the calibration subfolder of the driver).

To calibrate run the following command for the two monochrome sensors:

`rosrun camera_calibration cameracalibrator.py --size 8x6 --square 0.072 right:=/ovc/right/image_raw left:=/ovc/left/image_raw right_camera:=/ovc/right left_camera:=/ovc/left`

And the following for the RGB sensor:

`rosrun camera_calibration cameracalibrator.py --size 8x6 --square 0.072 image:=/ovc/rgb/image_raw -c rgb camera:=/ovc/rgb`

With the size and square parameters adapted to your checkerboard.