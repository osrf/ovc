## Getting started
In order to get the OVC up and running you will need to set up the boot medium, choosing between eMMC and SD card. We have observed better performance and reliability from the embedded eMMC module so it is suggested. SD boot should be used for the first setup and eventual recovery if it becomes impossible to boot from eMMC.

The first step suggested is to create an Ubuntu SD card that can be used to boot the module, and to flash the eMMC and onboard QSPI flash.
All the necessary files can be found [here](https://drive.google.com/drive/u/0/folders/1-6HdKNJr4VVOgUUyit0nssR-HQKv6Tt5).

### Creating the recovery SD card
* Follow the [Xilinx guide](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841655/Prepare+Boot+Medium) to partition the SD card, then copy the image.ub and BOOT.bin files in the SD images into the boot partition.
* Extract the rootfs.tar.gz archive into the root partition (assuming the root was mounted under /media):
`tar -xvpzf rootfs.tar.gz -C /media/root --numeric-owner`.

Now it should be possible to boot through the SD card.

### Flashing the QSPI and eMMC
The rootfs image includes a script that will run on boot and will check the position of the user DIP switches and, if the flashing configuration is selected (booting from SD card - pin 2 HIGH and flashing enabled, pin 4 LOW) it will flash the eMMC with the latest bootable images available in the shared folder.
For the process to be successful, it is necessary that the OVC is connected to the internet, it is configured for DHCP on the ethernet port so connecting the Ethernet port to your router should be enough.

On SD boot the LEDs next to the RGB camera will be used to communicate to the user the status of the update in the following sequence:
1. Only red LED turned on: Flashing mode was detected, waiting for internet connection and downloading files from shared folder.
2. Red and green LEDs turned on: Images downloaded, flashing. Can take quite long (up to 30 minutes in our experiments).
3. Only green LED turned on: Flashing completed, when this happens flip the switch 4 back to HIGH and the board should poweroff (green LED turning off).

### Booting from eMMC
If the above process is successful it should be possible to boot from the onboard QSPI and eMMC without the need to have an SD card. Remove the SD card, flip switch 2 for eMMC boot (LOW) and turn on the board.
If the red LED on the trenz module turns off boot was successful and it should be possible to use the module.

Keep an eye on the shared drive for changes in boot images and rootfs for new features!

## Accessing the board
If anything goes wrong it might be useful to access the board, this can be done in two ways, through the root linux console (exposed in the expansion pin header in the back of the board) or through ssh.
Try one of the following steps (start from 1 and proceed down if they fail):
1. SSH from the usb ethernet interface: `ssh ubuntu@10.0.1.1`
2. Connect the board to your router and ssh through host name `ssh ubuntu@arm.local`
3. Same as above but use the IP that you should be able to see in your router control panel.
4. Use the root console exposed in the pin header behind, useful to debug early boot failures.

## Hacking the board
This folder contains all the source files needed to build the project, except the root file system itself (which is a custom version of Ubuntu 18.04 for the armv7 architecture and is only available in the shared drive).

The Vivado project including all the FPGA design can be found in the test_board folder, while the Petalinux project containing the kernel and device-tree customizations can be found in the os folder.

## Board version pinout
**The pinout of the OVC3a is incompatible with the pinout of the OVC3b**. The
table below explains the differences:

|PIN   |TE0820 PIN|FPGA PIN|OVC 3A        |OVC 3B        |
|------|----------|--------|--------------|--------------|
|JB1.69|B66 L24 P |C9      |BONUS1_RESET  |BONUS4_EXTCLK |
|JB1.71|B66 L24 N |B9      |BONUS1_FLASH  |BONUS4_SCL0   |
|JB1.79|B66 L21 P |A7      |AUX0          |BONUS4_SDA0   |
|JB1.81|B66 L21 N |A6      |AUX1          |BONUS4_SCL1   |
|JB1.85|B66 L19 N |A5      |NC            |BONUS4_SDA1   |
|JB1.87|B66 L19 P |B5      |NC            |BONUS4_FLASH  |
|JB1.97|B66 L9 N  |A3      |AUX2          |BONUS4_RESET  |
|JB1.99|B66 L9P   |B3      |AUX 3         |BONUS4_TRIGGER|
|JB2.76|B64 L10 P |AG6     |BONUS4_EXTCLK |BONUS1_RESET  |
|JB2.78|B64 L10 N |AG5     |BONUS4_SCL0   |BONUS1_FLASH  |
|JB2.85|B64 L6 P  |AB6     |BONUS4_SDA0   |FRONT_AUX0    |
|JB2.87|B64 L6 N  |AC6     |BONUS4_SCL1   |FRONT_AUX1    |
|JB2.90|B64 T0    |AD6     |BONUS4_SDA1   |FRONT_AUX5    |
|JB2.91|B64 L24 P |AF1     |BONUS4_RESET  |FRONT_AUX2    |
|JB2.93|B64 L24 N |AG1     |BONUS4_FLASH  |FRONT_AUX3    |
|JB2.99|B64_T1    |AH6     |BONUS4_TRIGGER|FRONT_AUX4    |
|JB3.41|B65 L5 P  |R7      |NC            |GPIO18        |
|JB3.43|B65 L5 N  |T7      |NC            |GPIO19        |
