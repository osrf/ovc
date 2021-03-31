#!/bin/sh
sh build_release.sh
toolchain=~/gcc-arm-none-eabi-9-2019-q4-major/bin/
basename=release/dev_cdc_vcom_lite_bm
${toolchain}arm-none-eabi-size "${basename}.elf"
${toolchain}arm-none-eabi-objcopy -v -O ihex "${basename}.elf" "${basename}.hex"
sudo /usr/local/mcuxpressoide-11.1.1_3241/ide/plugins/com.nxp.mcuxpresso.tools.bin.linux_11.1.0.202002241259/binaries/blhost -u 0x1fc9,0x0021 flash-image release/dev_cdc_vcom_lite_bm.hex erase
