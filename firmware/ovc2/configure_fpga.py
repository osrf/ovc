#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
import time

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
        content = f.read().strip()
    return str(content) == "1"

def get_nstatus():
    with open("/sys/class/gpio/gpio{}/value".format(NSTATUS_GPIO), "r") as f:
        content = f.read().strip()
    return str(content) == "1"

def set_nconfig(on):
    with open("/sys/class/gpio/gpio{}/value".format(NCONFIG_GPIO), "w") as f:
        if on:
            f.write("1")
        else:
            f.write("0")

def configure_fpga(bitstream_filename):
    if not os.path.exists("/dev/ovc_cfg"):
        print("configuration device node /dev/ovc_cfg does not exist.")
        print("please load its kernel module:")
        print("    cd ~/ovc/software/ovc2/modules/cfg")
        print("    sudo ./load")
        return False
    print("setting up TX2 GPIO...")
    #print("bitstream file: {}".format(bitstream_filename))
    #print(get_conf_done())
    export_tx2_gpio(CONF_DONE_GPIO, "in")
    export_tx2_gpio(NSTATUS_GPIO, "in")
    export_tx2_gpio(NCONFIG_GPIO, "out")
    set_nconfig(False)
    time.sleep(0.001)  # anything over 2 microseconds is fine...
    set_nconfig(True)
    for attempt in range(1,10):
        nstatus = get_nstatus()
        print("nstatus: {}".format(nstatus))
        if nstatus:
            break
        else:
            time.sleep(0.01)
    #print("conf_done: {}".format(get_conf_done()))
    if not nstatus:
        print("OH NO, nstatus is not high")
        return False
    with open(bitstream_filename, "rb") as bitstream_file:
        bitstream_data = bitstream_file.read()
    print("bitstream length: {}".format(len(bitstream_data)))
    print("writing to FPGA...")
    with open("/dev/ovc_cfg", "wb") as ovc_cfg_dev:
        ovc_cfg_dev.write(bitstream_data)
    print("conf_done: {}".format(get_conf_done()))
    return True

def main(args):
    if "root" != os.getenv("USER"):
        print("this program must be run as root.")
        sys.exit(1)
    parser = argparse.ArgumentParser(description="configure ovc2 FPGA")
    parser.add_argument('bitstream')
    args = parser.parse_args()
    configure_fpga(args.bitstream)


if __name__ == '__main__':
    main(sys.argv)

########################
## GRAVEYARD
#cp = subprocess.run(['ls', '-l'], stdout=subprocess.PIPE)
#out = cp.stdout.decode('utf-8')
#print(out)
