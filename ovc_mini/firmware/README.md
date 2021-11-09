# OVC Mini Firmware

The prototype module is built on [KaRo's QSXP/QSXM](https://karo-electronics.github.io/docs/hardware-documentation/qsguide/Concept.html) modules.
The tools here are meant to automate the setup process for building a kernel 
for these modules.

## Usage

To begin, run:

```shell
source setup.sh
```

This will automatically set up this directory to be ready to build an image.
Re-source at the beginning of each shell session to collect the necessary 
environment variables.

After sourcing `setup.sh`, `build` and `upload` should now be available in the
shell's path allowing them to be called from anywhere.

Calling `build` will build the yocto image in the `bsp` directory. Similarly,
`upload` will upload the image that was just built to an availabe Ka-Ro
qsxp/qsxm.

To upload, refer to the pins used for switching boot modes (note that the 
documentation may have the modes backwards w/r/t the jumped pins):
https://karo-electronics.github.io/docs/hardware-documentation/pinouts/qsbase3.html#x2-bootmode

## Custom BSP

The BSP will be downloaded using `repo` on [`ovc-mini-bsp`](https://github.com/gbalke/ovc-mini-bsp).
This repository is a fork of Ka-Ro's BSP that adds in [`meta-ovc`](https://github.com/gbalke/meta-ovc).
