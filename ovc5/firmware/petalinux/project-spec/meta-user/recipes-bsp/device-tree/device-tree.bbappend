FILESEXTRAPATHS_prepend := "${THISDIR}/files:${SYSCONFIG_PATH}:"

SRC_URI_append += " file://config"
SRC_URI_append += " file://system-user.dtsi"
SRC_URI_append += " file://zynqmp_enclustra_common.dtsi"
SRC_URI_append += " file://zynqmp_enclustra_mercury_xu9.dtsi"
SRC_URI_append += " file://zynqmp_enclustra_mercury_xu5.dtsi"
SRC_URI_append += " file://zynqmp_enclustra_mercury_st1.dtsi"
SRC_URI_append += " file://ovc5_overrides.dtsi"

python () {
    if d.getVar("CONFIG_DISABLE"):
        d.setVarFlag("do_configure", "noexec", "1")
}

export PETALINUX
do_configure_append () {
	script="${PETALINUX}/etc/hsm/scripts/petalinux_hsm_bridge.tcl"
	data=${PETALINUX}/etc/hsm/data/
	eval xsct -sdx -nodisp ${script} -c ${WORKDIR}/config \
	-hdf ${DT_FILES_PATH}/hardware_description.${HDF_EXT} -repo ${S} \
	-data ${data} -sw ${DT_FILES_PATH} -o ${DT_FILES_PATH} -a "soc_mapping"
}
