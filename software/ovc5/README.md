# OVC5 software

The first quest is to set up a microSD card to boot the Zynq chip.
Because the Zynq has a complex many-tiered boot process that starts with on-chip ROM, the microSD card must be set up very carefully to match what the first-stage ROM loader needs to see when it boots.
The following sections will walk through all of these steps exactly.

### Set up microSD card partitions

This guide follows along a [Xilinx guide](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841655/Prepare+Boot+Medium) which has more details.

First make very very very very sure that you know the device name of your SD card when it's plugged into your host machine.
Mine shows up as `/dev/sdc` but this will depend on how many disks are in your machine.
These instructions will use `/dev/sdX` to prevent accidental copy-paste-pray from utterly destroying your filesystem; you must replace `/dev/sdX` with the actual device name for your microSD card.
The easiest way is usually to insert the card, then run `dmesg | tail` and read a few lines to see what's going on.

Let's blow away the partition table:

```
sudo dd if=/dev/zero of=/dev/sdX bs=1024 count=1
```

Now let's create some partitions:
```
sudo fdisk /dev/sdX
```

Here are the steps within `fdisk` to create the partitions we need:
* `n` create new partition
* `p` primary partition
* `1` first partition
* `[ENTER]` select automatic first available starting position for this partition
* `+200M` set size to 200 megabytes

* `n` create another new partition
* `p` primary parition
* `2` second partition
* `[ENTER]` select automatic next available starting position for this partition
* `[ENTER]` select automatic maximum available size for this partition

* `a` toggle bootable flag
* `1` partition 1

* `t` change partition type
* `1` partition 1
* `c` set to FAT32 (LBA)

* `t` change partition type
* `2` partition 2
* `83` the magic number for a Linux partition

Now you can type `p` in the `fdisk` terminal to print the partition table.
It should look something like this, but depending on the size of your microSD card, the numbers may vary somewhat:
```
Command (m for help): p
Disk /dev/sdc: 29.74 GiB, 31914983424 bytes, 62333952 sectors
Disk model: SD/MMC
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb5acc679

Device     Boot  Start      End  Sectors  Size Id Type
/dev/sdc1  *      2048   411647   409600  200M  c W95 FAT32 (LBA)
/dev/sdc2       411648 62333951 61922304 29.5G 83 Linux
```

If all looks well, type `w` to write the partition table and exit `fdisk`

### Set up microSD card partitions

As before, you'll need to substitute the exact device name on your system in place of `/dev/sdX` in the following terminal snippets.

First, a FAT32 filesystem named `boot` in the first partition:
```
sudo mkfs.vfat -F 32 -n boot /dev/sdX1
```

Next, an `ext4` filesystem named `root` in the second partition:
```
sudo mkfs.ext4 -L root /dev/sdX2
```

### Populate the boot partition
Mount the boot partition and copy in the magic `boot.bin` file, which contains the first stage (FSBL) and second stage (u-boot) bootloader images and various helper files.
Then we'll install the u-boot script `boot.scr` and finally the actual kernel image `image.ub`
Adjust paths/filenames as needed for your setup:
```
sudo mkdir -p /mnt/boot
sudo mount /dev/sdX1 /mnt/boot
sudo cp boot.bin /mnt/boot/
sudo cp boot.scr /mnt/boot/
sudo cp image.ub /mnt/boot/
sudo umount /mnt/boot
```

### Create root filesystem
Let's create a debian userland:
```
sudo mount /dev/sdX2 /mnt/zynqroot
sudo apt install qemu-user-static debootstrap debian-archive-keyring schroot
sudo apt-key add /usr/share/keyrings/debian-archive-keyring.gpg
sudo qemu-debootstrap --arch=arm64 --keyring /usr/share/keyrings/debian-archive-keyring.gpg --variant=buildd buster /mnt/zynqroot http://ftp.debian.org/debian
```

Now we need to go inside the userland and configure some stuff.
We'll use `schroot` following along from [this doc](http://logan.tw/posts/2017/01/21/introduction-to-qemu-debootstrap/)
```
echo "[arm64-debian]
description=Debian Buster (arm64)
directory=/mnt/zynqroot
root-users=$(whoami)
users=$(whoami)
type=directory" | sudo tee /etc/schroot/chroot.d/arm64-debian
```
IMPORTANT!!! You have to go into `/etc/schroot/default/nssdatabases` and comment out the following lines, in order to be able to set root password, create user, etc., inside the chroot:
```
#passwd
#shadow
#group
```

Now, let's enter the debian userland we're creating and install some stuff:
```
schroot -c arm64-debian -u root
echo zynq > /etc/hostname
passwd  # now enter a root password
apt install vim locales openssh-server ifupdown net-tools iputils-ping avahi-autoipd avahi-daemon haveged i2c-tools rsyslog
dpkg-reconfigure locales  # this is interactive; en_US.UTF-8 was number 158 for me
#systemctl enable serial-getty@ttyPS0.service
# append ttyPS0 to /etc/securetty
# append this to /etc/network/interfaces:
#   auto lo eth0
#   allow-hotplug eth0
#   iface lo inet loopback
#   iface eth0 inet dhcp
```

Allow root login via password by editing this file:
```
vim /etc/ssh/sshd_config
```
Change the line `PermitRootLogin` so that it looks like:
```
PermitRootLogin yes
```
Also, must uncomment `PermitRootLogin yes`

Now exit `schroot`:
```
exit
```

Unmount the rootfs:
```
sudo umount /mnt/zynqroot
```
