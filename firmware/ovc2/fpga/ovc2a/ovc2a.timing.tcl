project_open ovc
#create_timing_netlist -temperature -40 -voltage 1100
create_timing_netlist 
read_sdc ovc.sdc

foreach_in_collection oc [get_available_operating_conditions] {
  set_operating_conditions $oc
  update_timing_netlist
  report_timing -setup -npaths 1 
  report_timing -hold  -npaths 1 
  report_timing -recovery -npaths 1 
  report_timing -removal -npaths 1 
  report_min_pulse_width -nworst 1
}

delete_timing_netlist
project_close
