#!/bin/bash
set -o verbose
sudo rmmod ovc
sudo rmmod pci_tegra
sleep 1
~/opencam/software/mcu_cli/bin/mcu_cli configure_fpga
sleep 1
sudo modprobe pci_tegra
sleep 2
cd ~/opencam/software/ovc_module
sudo ./ovc_load
sleep 3
cp /home/nvidia/opencam/firmware/ovc/fpga/stable/ovc.core.rbf /dev/ovc_cvp
sleep 3
sudo rmmod ovc
sudo ./ovc_load
