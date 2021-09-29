# OVC Mini Firmware

The prototype module is built on [KaRo's QSXP/QSXM](https://karo-electronics.github.io/docs/hardware-documentation/qsguide/Concept.html) modules.
The tools here are meant to automate the setup process for building a kernel 
for these modules. As the project progresses, there will likely be the addition 
of a custom kernel configuration to meet the needs of the OVC Mini.

## Usage

To begin, run:

```shell
source setup.sh
```

This will automatically set up this directory to be ready to build an image.
Re-source at the beginning of each shell session to collect the necessary 
environment variables.

The build script, unfortunately, does not work due to some unknown issues with 
sourcing karo's scripts from a shell script. The upload script does work.

To build an image, follow karo's guide after changing to the `bsp` directory:
https://karo-electronics.github.io/docs/yocto-guide/nxp/BuildImages.html
