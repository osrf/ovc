#!/bin/bash
set -o verbose
~/ovc/software/ovc1/cli/mcu_cli/bin/mcu_cli flash_fpga_image $HOME/ovc/firmware/ovc1/fpga/stable/ovc.periph.rbf
