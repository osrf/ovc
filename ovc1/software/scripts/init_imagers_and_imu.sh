#!/bin/bash
set -o verbose
# enable imager clocks
~/opencam/software/cli/bin/cli pio_set 0 1
~/opencam/software/cli/bin/cli configure_imagers
~/opencam/software/cli/bin/cli align
~/opencam/software/cli/bin/cli imu_configure
