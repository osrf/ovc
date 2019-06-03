# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "COL_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ROW_NUM" -parent ${Page_0}


}

proc update_PARAM_VALUE.COL_NUM { PARAM_VALUE.COL_NUM } {
	# Procedure called to update COL_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COL_NUM { PARAM_VALUE.COL_NUM } {
	# Procedure called to validate COL_NUM
	return true
}

proc update_PARAM_VALUE.ROW_NUM { PARAM_VALUE.ROW_NUM } {
	# Procedure called to update ROW_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROW_NUM { PARAM_VALUE.ROW_NUM } {
	# Procedure called to validate ROW_NUM
	return true
}


proc update_MODELPARAM_VALUE.ROW_NUM { MODELPARAM_VALUE.ROW_NUM PARAM_VALUE.ROW_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROW_NUM}] ${MODELPARAM_VALUE.ROW_NUM}
}

proc update_MODELPARAM_VALUE.COL_NUM { MODELPARAM_VALUE.COL_NUM PARAM_VALUE.COL_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COL_NUM}] ${MODELPARAM_VALUE.COL_NUM}
}

