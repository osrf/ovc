#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Mounting Vars
MOUNT_DIR=/mnt/zynq
BOOT_DIR=$MOUNT_DIR/boot
ROOT_DIR=$MOUNT_DIR/root

# System Definition Vars
TEMP_PASSWORD=temppwd
HOSTNAME=zynq

FIRMWARE_DIR=$(realpath $DIR/..)/firmware
# Path to the xsa file exported from Vivado.
VIVADO_PROJECT=$FIRMWARE_DIR/carrier_board
XSA_PATH=$VIVADO_PROJECT/design_1_wrapper.xsa
PETALINUX_DIR=$FIRMWARE_DIR/petalinux
BOOT_FILES_DIR=$PETALINUX_DIR/images/linux

TMP_MOUNT_DIR=/tmp/petalinux_mnt

help () {
  cat << EOF
This script is meant to set up and SD card to load Debian Buster and the latest
OVC 5 software/firmware into the eMMC on the OVC 5 hardware.

THIS WILL INSTALL DEPENDENCIES FROM APT AS IT GOES. MAKE SURE TO REVIEW SCRIPT.

NOTE: Before running this you will need to generate the bitstream in vivado and
  export the xsa file. To do this follow the steps below:

  1. Open Vivado
  2. Top Bar: File > Project > Open
    - $VIVADO_PROJECT/carrier_board.xpr
  3. Flow Navigator: Program and Debug > Generate Bitstream
    - Click through the menu without changing defaults. 
    - This will take a while to complete.
  4. Top Bar: File > Export > Export Hardware...
    - 'Output': Include Bitstream
    - 'Files' should match:
        $XSA_PATH

usage: ./install_sd.sh <device>

  device: /dev/ device to install to. This is likely \"sdX\" where X is a
    letter. Check with gparted or dmesg to make sure the wrong device is not
    selected (this will re-format the drive so it's preferable to get the right
    device!). Make sure to unmount the drive before running.
EOF
}

build_boot_image () {
  
  if ! command -v petalinux-boot &> /dev/null
  then
    cat << EOF
Could not find petalinux-boot.

Is petalinux installed? If not, follow these steps:
  1. Download:
    https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html
  2. Install (adjust for version changes):
    ./petalinux-v2020.2-final-installer.run -d petalinux_sdk/ -p "arm aarch64"
  3. Source:
    source petalinux_sdk/settings.sh

If installed, make sure petalinux/settings.sh is sourced.

EOF
    exit
  fi

  save_dir=$pwd

  cp $XSA_PATH $PETALINUX_DIR/system.xsa
  cd $PETALINUX_DIR
  petalinux-config --get-hw-description --silentconfig
  petalinux-build
  petalinux-package \
    --boot \
    --force \
    --fsbl $BOOT_FILES_DIR/zynq_fsbl.elf \
    --fpga \
    --u-boot

  cd $save_dir
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

umount_drive () {
  # Unmount boot partition.
  sudo umount $BOOT_DIR
  sudo rmdir $BOOT_DIR

  # Unmount root partition.
  sudo umount $ROOT_DIR
  sudo rmdir $ROOT_DIR

  # Remove mount directory.
  sudo rmdir $MOUNT_DIR
}

mount_drive () {
  # Mount boot partition.
  sudo mkdir -p $BOOT_DIR
  sudo mount ${target_device}1 $BOOT_DIR

  # Mount root partition.
  sudo mkdir -p $ROOT_DIR
  sudo mount ${target_device}2 $ROOT_DIR
}

copy_bin () {
  sudo cp $BOOT_FILES_DIR/BOOT.BIN $BOOT_DIR/boot.bin
  sudo cp $BOOT_FILES_DIR/image.ub $BOOT_DIR
  sudo cp $BOOT_FILES_DIR/boot.scr $BOOT_DIR
}

install_debian () {
  sudo apt install qemu-user-static debootstrap debian-archive-keyring schroot
  sudo apt-key add /usr/share/keyrings/debian-archive-keyring.gpg
  # Sets up debian buster arm port on the sd card
  sudo qemu-debootstrap \
    --arch=arm64 \
    --keyring /usr/share/keyrings/debian-archive-keyring.gpg \
    --variant=buildd buster \
    $ROOT_DIR http://ftp.debian.org/debian
}

copy_petalinux_fs () {
  # Get rootfs from petalinux
  mkdir -p $TMP_MOUNT_DIR
  gunzip -c $BOOT_FILES_DIR/rootfs.cpio.gz | sh -c 'cd /tmp/petalinux_mnt && cpio -i'
  sudo cp $TMP_MOUNT_DIR/lib/modules $ROOT_DIR/lib -r
  rm $TMP_MOUNT_DIR -rf
}

setup_userland () {
  echo "[arm64-debian]
description=Debian Buster (arm64)
directory=$ROOT_DIR
root-users=root
users=root
type=directory" | sudo tee /etc/schroot/chroot.d/arm64-debian

  # Change the nssdatabases file to prevent copying of local userland.
  for attribute in passwd shadow group services protocols networks hosts
  do
    sudo sed -e "/$attribute/ s/^#*/#/" -i /etc/schroot/default/nssdatabases
  done

interfaces_text="
auto lo eth0
allow-hotplug eth0
iface lo inet loopback
iface eth0 inet dhcp"

subnet_text="subnet 10.0.1.0 netmask 255.255.255.0 {
  interface usb0;
  range 10.0.1.2 10.0.1.2;
  option routers 10.0.1.1;
  option interface-mtu 13500;
}"

  echo "
sed -e \"s/$(hostname)/zynq/\" -i /etc/hosts
echo zynq > /etc/hostname
passwd
$TEMP_PASSWORD
$TEMP_PASSWORD
apt update
apt install -y vim locales openssh-server ifupdown net-tools iputils-ping avahi-autoipd avahi-daemon haveged i2c-tools rsyslog
apt install -y git cmake libi2c-dev isc-dhcp-server libyaml-cpp-dev
grep -qxF 'ttyPS0' /etc/securetty || echo 'ttyPS0' >> /etc/securetty
grep -qxF '$interfaces_text' /etc/network/interfaces || echo '$interfaces_text' >> /etc/network/interfaces
grep -qxF '$subnet_text' /etc/dhcp/dhcpd.conf || echo '$subnet_text' >> /etc/dhcp/dhcpd.conf
egrep -v '^\s*#' /etc/ssh/sshd_config | grep -qxF 'PermitRootLogin yes' || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
egrep -v '^\s*#' /etc/ssh/sshd_config | grep -qxF 'PasswordAuthentication yes' || echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
sed -i 's/INTERFACESv4=\"\"/INTERFACESv4=\"usb0\"/g' /etc/default/isc-dhcp-server
sed -i 's/#OPTIONS=\"\"/OPTIONS=\"-4 -s\"/g' /etc/default/isc-dhcp-server
" | sudo schroot -c arm64-debian -u root

  echo "

--------------------------------------
------------- Manual Step ------------
--- A chroot session will now open ---
--------------------------------------

Execute and run through (likely using \"158. en_US.UTF-8 UTF-8\"):
  dpkg-reconfigure locales
"

  sudo schroot -c arm64-debian -u root

  # Copy in all scripts that the device will use.
  sudo cp $DIR/device_scripts/* $ROOT_DIR/root/
}

if [ -z $1 ] || [ $1 == "-h" ]; then
  help
  exit
fi

target_device=/dev/$1

if [ -b "$target_device" ]; then
  echo "Found device \"$target_device\" at $(find /dev/disk/by-id/ -lname "*$1")"
else
  echo "It appears that the specified sd card \"$target_device\" is not connected."
  exit
fi

echo "
Using Petalinux to build the sd-card boot image.
"
build_boot_image

echo "
Formating the SD with Boot/Root partitions.
"
format_sd

echo "
Mount the newly made partitions.
"
mount_drive

echo "
Copy in the boot files.
"
copy_bin

echo "
Install debian buster arm64 to root.
"
install_debian

echo "
Copy over needed files from petalinux rootfs.
"
copy_petalinux_fs

echo "
Install/configure userland and set up SSH.
"
setup_userland

echo "
Unmount the SD card.
"
umount_drive
