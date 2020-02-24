#!/usr/bin/env bash

# Script to recover / update the flash and eMMC remotely
# Hardware constants
DIP_SWITCH=416
GREEN_LED=364
RED_LED=365

# Start by exporting the GPIO pins
cd /sys/class/gpio
echo $DIP_SWITCH > export
echo $GREEN_LED > export
echo $RED_LED > export
echo out > gpio$GREEN_LED/direction
echo out > gpio$RED_LED/direction
echo 0 > gpio$RED_LED/value
echo 0 > gpio$GREEN_LED/value

cd /home/ubuntu/recovery

rootfs_part="$(mount -v | fgrep 'on / ')"

if echo "$rootfs_part" | grep -q "mmcblk1p2"; then
  echo "Booting from SD, checking DIP switch" >> recovery_log;
else
  echo "Booting from QSPI, flashing aborted" >> recovery_log;
  exit 1;
fi

dip_value=$(cat /sys/class/gpio/gpio$DIP_SWITCH/value)

if [ "$dip_value" -eq "1" ]; then
  echo "DIP switch set to 1, flashing..." >> recovery_log;
else
  echo "DIP switch set to 0, aborting..." >> recovery_log;
  exit 2;
fi

# Start update 
# Wait for network to be up
for i in {1..50}; do ping -c1 www.google.com &> /dev/null && break; done
# Hack because we are restarting network, make sure network is really up
sleep 5
for i in {1..50}; do ping -c1 www.google.com &> /dev/null && break; done

rm recovery_log
# To be safe bring down usb0, otherwise we might try to use it to retrieve the images
ifdown usb0

# Signal start flashing
echo 1 > /sys/class/gpio/gpio$RED_LED/value

# Fetch files from remote
# Remove old versions
rm BOOT.bin
rm image.ub
rm rootfs.tar.gz

# BOOT.bin
wget --load-cookies /tmp/cookies.txt --no-check-certificate "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=1p9zbpzwbofOjSXYRU7CubGamKYXTo35n' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1p9zbpzwbofOjSXYRU7CubGamKYXTo35n" -O BOOT.bin && rm -rf /tmp/cookies.txt

# image.ub
wget --load-cookies /tmp/cookies.txt --no-check-certificate "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=1teh2Mk7ZvHFmOHHzIZakdGsFsJ31ETo7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1teh2Mk7ZvHFmOHHzIZakdGsFsJ31ETo7" -O image.ub && rm -rf /tmp/cookies.txt 

# rootfs
wget --load-cookies /tmp/cookies.txt --no-check-certificate "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?export=download&id=1Qft7tI88PBAUmorKi76xcPlfTJmXR6u6' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Qft7tI88PBAUmorKi76xcPlfTJmXR6u6" -O rootfs.tar.gz && rm -rf /tmp/cookies.txt 

# Start flashing
echo 1 > /sys/class/gpio/gpio$GREEN_LED/value

echo "Download completed, flashing BOOT image..." >> recovery_log
flashcp BOOT.bin /dev/mtd0 -v >> recovery_log

echo "Flashing kernel image" >> recovery_log
flashcp image.ub /dev/mtd2 -v >> recovery_log

echo "Clearing rootfs" >> recovery_log
# Clear partition table

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/mmcblk0
  o # clear the in memory partition table
  n # new partition
  p # primary partition
    # partition number default
    # default - start at beginning of disk
    # default - end at end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Create file system
mkfs.ext4 /dev/mmcblk0p1 -F
mount /dev/mmcblk0p1 /mnt/
#rm -rf /mnt/*

echo "Copying rootfs" >> recovery_log
tar -xvpzf rootfs.tar.gz -C /mnt/ --numeric-owner
sleep 5;
umount /dev/mmcblk0p1

echo "Completed" >> recovery_log

# All done
echo 0 > /sys/class/gpio/gpio$RED_LED/value

# Wait for DIP switch to be flipped to poweroff
echo "Waiting for switch to poweroff" >> recovery_log;

while true; do

  dip_value=$(cat /sys/class/gpio/gpio$DIP_SWITCH/value)

  if [ "$dip_value" -eq "0" ]; then
    echo "DIP switch set to 0, shutting down..." >> recovery_log;
    echo 0 > /sys/class/gpio/gpio$GREEN_LED/value
    break;
  fi

done
poweroff
