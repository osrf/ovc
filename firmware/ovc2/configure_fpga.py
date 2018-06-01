#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys

CONF_DONE_GPIO = 389
NSTATUS_GPIO   = 332
NCONFIG_GPIO   = 333

def export_tx2_gpio(gpio_num):
    if os.path.exists("/sys/class/gpio/gpio{}".format(str(gpio_num))):
        return True  # already exported
    with open("/sys/class/gpio/export", "w") as f:
        f.write(str(gpio_num))
    return True  # todo: see if node was created

def configure_fpga(bitstream_filename):
    print("setting up TX2 GPIO...")
    export_tx2_gpio(CONF_DONE_GPIO)
    export_tx2_gpio(NSTATUS_GPIO)
    export_tx2_gpio(NCONFIG_GPIO)
    print("bitstream file: {}".format(bitstream_filename))

    return 0

def main(args):
    if "root" != os.getenv("USER"):
        print("this program must be run as root.")
        sys.exit(1)
    parser = argparse.ArgumentParser(description="configure ovc2 FPGA")
    parser.add_argument('bitstream')
    args = parser.parse_args()
    return configure_fpga(args.bitstream)

if __name__ == '__main__':
    main(sys.argv)

########################
## GRAVEYARD
#cp = subprocess.run(['ls', '-l'], stdout=subprocess.PIPE)
#out = cp.stdout.decode('utf-8')
#print(out)
