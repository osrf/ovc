#!/bin/bash

# Exit when any command fails.
set -e

EXPECTED_SD_DEV=/dev/mmcblk1
SD_DEV=$(cat /proc/cmdline | sed 's/.*\(\/dev\/mmcblk[0-9]\).*/\1/')
SD_MOUNT_DIR=/mnt/sd
SD_BOOT=${SD_DEV}p1

EMMC_DEV=/dev/mmcblk0
EMMC_MOUNT_DIR=/mnt/emmc
EMMC_BOOT=${EMMC_DEV}p1
EMMC_ROOT=${EMMC_DEV}p2

format_emmc () {
  apt-get install dosfstools

  dd if=/dev/zero of=$EMMC_DEV bs=1024 count=1

  # Pulled straight from Stack Exchange with modifications for linux:
  #     https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
  # to create the partitions programatically (rather than manually)
  # we're going to simulate the manual input to fdisk
  # The sed script strips off all the comments so that we can 
  # document what we're doing in-line with the actual commands
  # Note that a blank line (commented as "defualt" will send a empty
  # line terminated with a newline to take the fdisk default.
  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${EMMC_DEV}
    o # clear the in memory partition table
    n # new partition
    p # primary partition
    1 # partition number 1
      # default - start at beginning of disk 
    +200M # 200 MB boot parttion
    n # new partition
    p # primary partition
    2 # partion number 2
      # default, start immediately after preceding partition
      # default, extend partition to end of disk
    a # make a partition bootable
    1 # bootable partition is partition 1 -- /dev/sda1
    t # change partition type
    1 # partition 1
    c # set to FAT32 (LBA)
    t # change partition type
    2 # partition 2
    83 # magic linux partition number
    p # print the in-memory partition table
    w # write the partition table
    q # and we're done
EOF

  # First, a FAT32 filesystem named boot in the first partition:
  mkfs.vfat -F 32 -n boot $EMMC_BOOT
  # Next, an ext4 filesystem named root in the second partition:
  mkfs.ext4 -L root $EMMC_ROOT
}

mount_devices () {
  mkdir -p $SD_MOUNT_DIR/boot
  mkdir -p $EMMC_MOUNT_DIR/boot
  mkdir -p $EMMC_MOUNT_DIR/root

  mount $SD_BOOT $SD_MOUNT_DIR/boot
  mount $EMMC_BOOT $EMMC_MOUNT_DIR/boot
  mount $EMMC_ROOT $EMMC_MOUNT_DIR/root
}

umount_devices () {
  umount $SD_MOUNT_DIR/boot
  umount $EMMC_MOUNT_DIR/boot
  umount $EMMC_MOUNT_DIR/root

  rmdir $SD_MOUNT_DIR/boot
  rmdir $SD_MOUNT_DIR
  rmdir $EMMC_MOUNT_DIR/boot
  rmdir $EMMC_MOUNT_DIR/root
  rmdir $EMMC_MOUNT_DIR
}

copy_files () {
  # This will assume the image has been created using install_sd.sh
  cp --verbose $SD_MOUNT_DIR/boot/emmc/* $EMMC_MOUNT_DIR/boot
  # Referenced: https://tldp.org/HOWTO/Hard-Disk-Upgrade/copy.html
  cp --verbose -ax / $EMMC_MOUNT_DIR/root
}

if [ $EXPECTED_SD_DEV == $SD_DEV ]; then
  echo "Root is mounted on sd card at $SD_DEV as expected. Proceding to format eMMC at $EMMC_DEV"
else
  echo "System is not mounted at $EXPECTED_SD_DEV, got $SD_DEV. Is this booted on eMMC already? Exiting."
  exit
fi

echo "Formatting eMMC to match SD card (boot and root partitions)"
format_emmc

mount_devices

echo "Copying files from sd to eMMC"
copy_files

umount_devices

echo "Finished. Power off device, remove SD card, change boot mode (DIP switches), and power on."
