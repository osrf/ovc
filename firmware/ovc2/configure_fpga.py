#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys

CONF_DONE_GPIO = 389
NSTATUS_GPIO = 332
NCONFIG_GPIO = 333

def export_tx2_gpio(gpio_num, direction):
    if direction != "in" and direction != "out":
        print("invalid direction: {}".format(direction))
        return False
    gpio = str(gpio_num)
    if os.path.exists("/sys/class/gpio/gpio{}".format(gpio)):
        return True  # already exported
    with open("/sys/class/gpio/export", "w") as f:
        f.write(gpio)
    with open("/sys/class/gpio/gpio{}/direction".format(gpio), "w") as f:
        f.write(direction)
    return True  # todo: see if node was created

def get_conf_done():
    with open("/sys/class/gpio/gpio{}/value".format(CONF_DONE_GPIO), "r") as f:
        content = f.read()
    return str(content) == "1"

def get_nstatus():
    with open("/sys/class/gpio/gpio{}/value".format(NSTATUS_GPIO), "r") as f:
        content = f.read()
    return str(content) == "1"

def set_nconfig(on):
    with open("/sys/class/gpio/gpio{}/value".format(NCONFIG_GPIO), "w") as f:
        if on:
            f.write("1")
        else:
            f.write("0")

def configure_fpga(bitstream_filename):
    print("setting up TX2 GPIO...")
    #print("bitstream file: {}".format(bitstream_filename))
    #print(get_conf_done())
    export_tx2_gpio(CONF_DONE_GPIO, "in")
    export_tx2_gpio(NSTATUS_GPIO, "in")
    export_tx2_gpio(NCONFIG_GPIO, "out")
    set_nconfig(False)
    set_nconfig(True)
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
