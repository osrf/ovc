#!/bin/bash
set -o verbose
cd ~/ovc/software/ovc1/ovc_module
sudo ./ovc_load
sleep 3
cp /home/nvidia/ovc/firmware/ovc1/fpga/stable/ovc.core.rbf /dev/ovc_cvp
sleep 3
sudo rmmod ovc
sudo ./ovc_load
