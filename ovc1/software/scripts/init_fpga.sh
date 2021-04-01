#!/bin/bash
file=/tmp/ovc_fpga_init

if [ ! -f $file ]; then
  echo "OVC_FPGA_INIT=true" >> /tmp/ovc_fpga_init
  echo "Initializing FPGA..."
  echo "save state at: $file"
  set -o verbose
  cd ~/ovc/software/ovc1/ovc_module
  sudo ./ovc_load
  sleep 3
  cp ~/ovc/firmware/ovc1/fpga/stable/ovc.core.rbf /dev/ovc_cvp
  sleep 3
  sudo rmmod ovc
  sudo ./ovc_load
fi
