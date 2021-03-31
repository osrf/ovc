#
# This file is the webfwu recipe.
#

SUMMARY = "Simple webfwu application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
FILES_${PN} += "/srv/www/*"

SRC_URI = "file://index.html \
		file://reboot.cgi \
		file://mtd0.cgi \
		file://mtd1.cgi \
		file://mtd2.cgi \
		file://mtd3.cgi \
		file://erase_flash_all.cgi \
		file://mmcblk0p1.cgi \
		file://mmcblk1p1.cgi \
        file://wwwlogo.png \
	"

S = "${WORKDIR}"

do_compile() {
}

do_install() {
         install -d ${D}/srv
         install -d ${D}/srv/www
         install -d ${D}/srv/www/cgi-bin
         install -m 0644 index.html ${D}/srv/www
         install -m 0644 wwwlogo.png ${D}/srv/www
         install -m 0755 mtd0.cgi ${D}/srv/www/cgi-bin
         install -m 0755 mtd1.cgi ${D}/srv/www/cgi-bin
         install -m 0755 mtd2.cgi ${D}/srv/www/cgi-bin
         install -m 0755 mtd3.cgi ${D}/srv/www/cgi-bin
         install -m 0755 mmcblk0p1.cgi ${D}/srv/www/cgi-bin
         install -m 0755 mmcblk1p1.cgi ${D}/srv/www/cgi-bin
          install -m 0755 erase_flash_all.cgi ${D}/srv/www/cgi-bin
          install -m 0755 reboot.cgi ${D}/srv/www/cgi-bin
}

