#!/bin/bash
set -o verbose
sudo rmmod ovc2_core
sudo rmmod pci_tegra
cd ~/ovc/software/ovc2/modules/ovc2_cfg
sudo ./load
sudo $HOME/ovc/firmware/ovc2/configure_fpga.py $HOME/ovc2a.rbf
sudo modprobe pci_tegra
sleep 3
cd ~/ovc/software/ovc2/modules/ovc2_core
sudo ./load
