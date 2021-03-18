SUMMARY = "Recipe for  build an external udmabuf Linux kernel module"
SECTION = "PETALINUX/modules"
LICENSE = "BSDv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=bebf0492502927bef0741aa04d1f35f5"

inherit module

INHIBIT_PACKAGE_STRIP = "1"

SRC_URI = "file://Makefile \
           file://u-dma-buf.c \
           file://LICENSE \
          "

S = "${WORKDIR}"

# The inherit of module.bbclass will automatically name module packages with
# "kernel-module-" prefix as required by the oe-core build environment.
