FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append += " file://devtool-fragment.cfg"
KERNEL_FEATURES_append = " devtool-fragment.cfg"
SRC_URI_append += "file://0001-Change-bMaxBurst-and-qlen-to-the-highest-number.patch"
IMAGE_INSTALL_append = "kernel-devsrc"
