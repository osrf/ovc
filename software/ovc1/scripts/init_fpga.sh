#!/bin/bash
set -o verbose
cd ~/opencam/software/ovc_module
sudo ./ovc_load
sleep 3
cp /home/nvidia/opencam/firmware/ovc/fpga/stable/ovc.core.rbf /dev/ovc_cvp
sleep 3
sudo rmmod ovc
sudo ./ovc_load
