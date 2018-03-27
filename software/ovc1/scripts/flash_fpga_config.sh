#!/bin/bash
set -o verbose
~/opencam/software/mcu_cli/bin/mcu_cli flash_fpga_image /home/nvidia/opencam/firmware/ovc/fpga/stable/ovc.periph.rbf
