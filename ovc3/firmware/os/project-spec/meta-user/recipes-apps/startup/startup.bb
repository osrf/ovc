#
# This file is the startup recipe.
#

SUMMARY = "Simple startup application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://startup.sh \
  "
INITSCRIPT_NAME = "startup"
INITSCRIPT_PARAMS = "defaults"

S = "${WORKDIR}"

inherit update-rc.d

do_install() {
        install -d ${D}${sysconfdir}/init.d/
        install -m 0755 startup.sh ${D}${sysconfdir}/init.d/startup
}
