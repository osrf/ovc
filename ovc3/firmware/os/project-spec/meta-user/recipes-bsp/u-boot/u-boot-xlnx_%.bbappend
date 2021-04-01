FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://platform-top.h \
            file://0001-usb-composite-add-BOS-descriptor-support-to-composit.patch \
            file://0001-drivers-usb-dwc3-setup-phy-before-dwc3-core-soft-res.patch \
            "
