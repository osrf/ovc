#!/bin/bash

MOUNT_DIR=zynqroot
TEMP_PWD=temppwd

help () {
  cat << EOF
This script is meant to set up and SD card to load Debian Buster and the latest
OVC 5 software/firmware into the eMMC on the OVC 5 hardware.

Dependencies:
  apt: schroot qemu-user-static debootstrap
  keyring: ubuntu-archive-keyring.gpg

usage: ./install_sd.sh <device_path> <vitis_project_path>

  device_path: path to device to install to. This is likely /dev/sdX where X is a
    letter. Check with gparted or dmesg to make sure the wrong device is not
    selected (this will re-format the drive so it's preferable to get the right
    device!). Make sure to unmount the drive before running.
  vitis_project_path: path to Vitis system project. This should be a fully built
    project off of an xsa export from Vivado. This will be used to grab BOOT.BIN.
EOF
}

format_sd () {
  sudo dd if=/dev/zero of=$target_device bs=1024 count=1

  # Pulled straight from Stack Exchange with modifications for linux:
  #     https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script
  # to create the partitions programatically (rather than manually)
  # we're going to simulate the manual input to fdisk
  # The sed script strips off all the comments so that we can 
  # document what we're doing in-line with the actual commands
  # Note that a blank line (commented as "defualt" will send a empty
  # line terminated with a newline to take the fdisk default.
  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk ${target_device}
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

  sudo partprobe $target_device
  
  # First, a FAT32 filesystem named boot in the first partition:
  sudo mkfs.vfat -F 32 -n boot ${target_device}1
  # Next, an ext4 filesystem named root in the second partition:
  sudo mkfs.ext4 -L root ${target_device}2
}

copy_bin () {
  # Mount boot partition.
  sudo mkdir -p /mnt/$MOUNT_DIR
  sudo mount ${target_device}1 /mnt/$MOUNT_DIR

  sudo cp $vitis_project_dir/Debug/sd_card/BOOT.BIN /mnt/$MOUNT_DIR

  sudo umount /mnt/$MOUNT_DIR
  sudo rmdir /mnt/$MOUNT_DIR
}

install_debian () {
  # Mount root partition.
  sudo mkdir -p /mnt/$MOUNT_DIR
  sudo mount ${target_device}2 /mnt/$MOUNT_DIR

  sudo apt install qemu-user-static debootstrap debian-archive-keyring schroot
  sudo apt-key add /usr/share/keyrings/debian-archive-keyring.gpg
  # Sets up debian buster arm port on the sd card
  sudo qemu-debootstrap \
    --arch=arm64 \
    --keyring /usr/share/keyrings/debian-archive-keyring.gpg \
    --variant=buildd buster \
    /mnt/$MOUNT_DIR http://ftp.debian.org/debian

  sudo umount /mnt/$MOUNT_DIR
  sudo rmdir /mnt/$MOUNT_DIR
}

setup_ssh () {
  # Mount root partition.
  sudo mkdir -p /mnt/$MOUNT_DIR
  sudo mount ${target_device}2 /mnt/$MOUNT_DIR

  echo "[arm64-debian]
description=Debian Buster (arm64)
directory=/mnt/$MOUNT_DIR
root-users=root
users=root
type=directory" | sudo tee /etc/schroot/chroot.d/arm64-debian

  # Change the nssdatabases file to allow userland to be set up correctly.
  for attribute in passwd shadow group
  do
    sudo sed -e "/$attribute/ s/^#*/#/" -i /etc/schroot/default/nssdatabases
  done

interfaces_text="
auto lo eth0
allow-hotplug eth0
iface lo inet loopback
iface eth0 inet dhcp"

  echo "
echo zynq > /etc/hostname
passwd
$TEMP_PWD
$TEMP_PWD
apt update
apt install -y vim locales openssh-server ifupdown net-tools iputils-ping avahi-autoipd avahi-daemon haveged i2c-tools rsyslog
grep -qxF 'ttyPS0' /etc/securetty || echo 'ttyPS0' >> /etc/securetty
grep -qxF '$interfaces_text' /etc/network/interfaces || echo '$interfaces_text' >> /etc/network/interfaces
egrep -v '^\s*#' /etc/ssh/sshd_config | grep -qxF 'PermitRootLogin yes' || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
egrep -v '^\s*#' /etc/ssh/sshd_config | grep -qxF 'PasswordAuthentication yes' || echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
" | sudo schroot -c arm64-debian -u root

  echo "
Execute and run through (likely using \"158. en_US.UTF-8 UTF-8\"):
  dpkg-reconfigure locales
"

  sudo schroot -c arm64-debian -u root

  sudo umount /mnt/$MOUNT_DIR
  sudo rmdir /mnt/$MOUNT_DIR
}

if [ -z $1 ] || [ -z $2 ] || [ $1 == "-h" ]; then
  help
  exit
fi

target_device=$1
vitis_project_dir=$2

#format_sd
#copy_bin
#install_debian
setup_ssh
