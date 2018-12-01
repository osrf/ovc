#!/bin/bash
set -o verbose
sudo rmmod ovc
sudo rmmod pci_tegra
sleep 1
~/ovc/software/ovc1/cli/mcu_cli/bin/mcu_cli configure_fpga
sleep 1
sudo modprobe pci_tegra
sleep 2
cd ~/ovc/software/ovc1/ovc_module
sudo ./ovc_load
sleep 3
cp $HOME/ovc/firmware/ovc1/fpga/stable/ovc.core.rbf /dev/ovc_cvp
sleep 3
sudo rmmod ovc
sudo ./ovc_load
