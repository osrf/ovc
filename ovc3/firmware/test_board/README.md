The Vivado project is based on the scripts from Trenz Electronics.
A few parts are not included since they can be downloaded from the Trenz website.

## Running the HW Synthesis and Implementation

The firmware was compiled using Vivado 2019.1. You will need to download this
specific version of the tool from the Xilinx website.

* Download the [reference design](https://shop.trenz-electronic.de/en/Download/?path=Trenz_Electronic/Modules_and_Module_Carriers/4x5/TE0820/Reference_Design/2018.3/test_board) for the TE0820 module from the Trenz website.
* Copy the following folders inside this folder: board\_files, scripts, settings, sw\_lib.
* Customise design\_basic\_settings.sh to match your Vivado installation path and version.
* Run the vivado\_open\_existing\_project\_guimode.sh script and the project with its block design should be opened.
* You should be able to run the synthesis and implementation processes. Keep an
  eye on the warnings, but you may disregard most of them.
* Finally, generate the bitstream for the platform. A successful bitstream
  generation is required for the following steps.

## Creating bootable images

To create the bootable image, these steps are needed:
 - Generate the FSBL
 - Generate the PMUFW
 - Generate the kernel using PetaLinux
 - Create the bootable image

We will provide a high level overview of these steps in this document.

### FSBL Generation
The default FSBL provided by Xilinx doesn't work, use the one provided by Trenz
in their `sw\_lib`:

1. Be sure that you were able to generate the bitstream in Vivado. 
2. Export the hardware by running in Vivado: File > Export > Export Hardware. Be
   sure to include the bitstream into the exported hardware.
3. Launch the SDK from Vivado: File > Launch SDK. The Xilinx SDK app will open.
4. In the SDK, you will need to add Trenz libraries: Xilinx > Repositories. Add
   the `sw_lib` folder that you copied before running HW Implementation.
5. Create a new project in the SDK: File > New > Application Project. Choose a
   project name, and use the template "Zynq MP FSBL (TE modified)".
6. Before building the project, we need to disable Secure Execution in the FSBL.
   For this, go to File > Properties. In C/C++ Build > Settings you need to add
   the defined symbol FSBL_SECURE_EXCLUDE.
7. You should be able to build the FSBL now and generate the elf file. Write
   down the location of this file, as we will need it to generate the bootable
   image.

### PMUFW generation
These steps are extracted from [the Xilinx
wiki](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842462/Build+PMU+Firmware).
We copy them here for reference:

1. Export the hardware in Vivado. You may not need to do this step if you just
   generated the FSBL.
2. Open a terminal and run `hsi`
3. Open the hardware design: `set hwdsgn [open_hw_design <hardware.hdf>]`
4. Generate the PMUFW: `hsi% generate_app -hw $hwdsgn -os standalone -proc
   psu_pmu_0 -app zynqmp_pmufw -compile -sw pmufw -dir <dir_for_new_app>`
5. Write down the location of the generated elf file. We will need it to
   generate the bootable image.

### PetaLinux kernel generation

* Bootable image configured through petalinux doesn't work because of the custom FSBL, create the image manually through Xilinx SDK.

The tested order of boot (and tool used to build it) is, an example boot.bif is provided in the main folder:
1. TE0820 FSBL (XSDK)
2. Standard pmufw (XSDK)
3. FPGA bitfile for configuration (Vivado)
4. bl31.elf (Petalinux)
5. u-boot.elf (Petalinux)

Make sure to export your hardware definition (.hdf) file to petalinux to correctly configure the kernel image and binaries.
