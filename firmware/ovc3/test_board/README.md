The Vivado project is based on the scripts from Trenz Electronics.
A few parts are not included since they can be downloaded from the Trenz website.

## Getting started
* Download the [reference design](https://shop.trenz-electronic.de/en/Download/?path=Trenz_Electronic/Modules_and_Module_Carriers/4x5/TE0820/Reference_Design/2018.3/test_board) for the TE0820 module from the Trenz website.
* Copy the following folders inside this folder: board\_files, scripts, settings, sw\_lib.
* Customise design\_basic\_settings.sh to match your Vivado installation path and version.
* Run the vivado\_open\_existing\_project\_guimode.sh script and the project with its block design should be opened.

## Creating bootable images
Explaining the flow of bootable image creation is out of the scope of this readme, the steps recommended by Xilinx apply with the following quirks:

* The default FSBL provided by Xilinx doesn't work, use the one provided by Trenz in their sw\_lib.
* Bootable image configured through petalinux doesn't work because of the custom FSBL, create the image manually through Xilinx SDK.

The tested order of boot (and tool used to build it) is:
1. TE0820 FSBL (XSDK)
2. Standard pmufw (XSDK)
3. FPGA bitfile for configuration (Vivado)
4. bl31.elf (Petalinux)
5. u-boot.elf (Petalinux)

Make sure to export your hardware definition (.hdf) file to petalinux to correctly configure the kernel image and binaries.

### Final quirks
The Petalinux project is version 2018.3 while the Vivado project is in Vivado 2019.1. This works but is unsupported behavior. Interrupts temporarily don't work if the kernel is compiled with Petalinux 2019.1, currently being investigated and once solved the whole design will be migrated to 2019.1
