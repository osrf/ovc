FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://0001-BOARD-zcu102-Fix-the-compatible-string-for-eeprom.patch \
            file://system-user.dtsi \
            "
