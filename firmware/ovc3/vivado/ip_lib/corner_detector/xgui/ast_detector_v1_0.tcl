# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CAM_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "COLS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_QV" -parent ${Page_0}


}

proc update_PARAM_VALUE.CAM_ADDR { PARAM_VALUE.CAM_ADDR } {
	# Procedure called to update CAM_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CAM_ADDR { PARAM_VALUE.CAM_ADDR } {
	# Procedure called to validate CAM_ADDR
	return true
}

proc update_PARAM_VALUE.COLS { PARAM_VALUE.COLS } {
	# Procedure called to update COLS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COLS { PARAM_VALUE.COLS } {
	# Procedure called to validate COLS
	return true
}

proc update_PARAM_VALUE.MAX_QV { PARAM_VALUE.MAX_QV } {
	# Procedure called to update MAX_QV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_QV { PARAM_VALUE.MAX_QV } {
	# Procedure called to validate MAX_QV
	return true
}


proc update_MODELPARAM_VALUE.CAM_ADDR { MODELPARAM_VALUE.CAM_ADDR PARAM_VALUE.CAM_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CAM_ADDR}] ${MODELPARAM_VALUE.CAM_ADDR}
}

proc update_MODELPARAM_VALUE.COLS { MODELPARAM_VALUE.COLS PARAM_VALUE.COLS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COLS}] ${MODELPARAM_VALUE.COLS}
}

proc update_MODELPARAM_VALUE.MAX_QV { MODELPARAM_VALUE.MAX_QV PARAM_VALUE.MAX_QV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_QV}] ${MODELPARAM_VALUE.MAX_QV}
}

