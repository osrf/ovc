# Open Vision Computer (OVC)

Here is an [overview presentation of the project](https://docs.google.com/presentation/d/1NCimNJTRP6g3ESWhmaqi4t3dOprq7Yvne_JLeCTt3io/edit?usp=sharing) (March 2018).

This repo contains hardware, firmware, and software for an open-source embedded
vision system: the Open Vision Computer (OVC). The goal is to connect state of
the art open hardware with open firmware and software. There are a few revs:

 * ovc0: three Python1300 imagers, an Artix-7 FPGA, DRAM, and USB3 via a Cypress FX3 controller.
 * ovc1: two Python1300 imagers, a Jetson TX2 (6x ARMv8, GPU, etc.) connected to a Cyclone-V GT FPGA over PCIe.
 * [ovc2](doc/ovc2a/README.md): two Python1300 imagers, a Jetson TX2 (6x ARMv8, GPU, etc.) connected to a Cyclone 10 GX FPGA over PCIe Gen 2.0 x4 (current work)

# where do I find hardware stuff

 * ovc1 hardware currently lives in 'hardware/ovc1' as a single KiCAD PCB.
   * schematics are provided as [PDF](https://github.com/osrf/ovc/raw/master/hardware/ovc1/ovc.pdf) or native KiCAD files
 * ovc2 hardware lives in 'hardware/ovc2'

# where do I find other stuff

 * Firmware and software for ovc1 and ovc2 are in the 'firmware' and 'software'
directories in this repo.

# how do I update everything

## ovc2

On the OVC2, the TX2 simply configures the FPGA over SPI. Because there are
no flash memories outside the TX2, the update process is considerably simpler
than on the OVC1.

#### Update source tree
```
cd ~/ovc
git pull
```

#### Compile kernel module
```
cd ~/ovc/software/ovc2/modules/ovc2_core
make
cd ~/ovc/software/ovc2/modules/ovc2_cfg
make
```
In case there is a compilation error for ovc2_core, try
```
cd /usr/src/linux-headers-4.4.38-tegra/
sudo make modules_prepare
```

#### Compile ROS package (userland)
```
mkdir -p ~/ros/src
ln -s ~/ovc/software/ovc2/ros/ovc2 ~/ros/src
cd ~/ros
catkin build
```

## ovc1

#### Update source tree
```
cd ~/ovc
git pull
```

#### Compile kernel module
```
cd ~/ovc/software/ovc1/ovc_module
make
```

#### Flash FPGA i/o image and reconfigure FPGA
The OVC1 uses a configuration microcontroller to set up the FPGA I/O ring to
allow PCIe-based configuration. This is great because it's super-fast, but it's
a bit more complicated because the FPGA image lives partly in the
microcontroller flash memory, and partly in the TX2 filesystem. As such, there
are a multiple steps to updating the FPGA image. Fortunately, the FPGA I/O
image should only change infrequently. Note that the microcontroller-flash
script only needs to be run when the FPGA I/O image changes; most updates
affect only the FPGA core, not the I/O ring.

```
cd ~/scripts
./flash_fpga_config.sh
./reconfigure_fpga.sh
```

#### Compile ROS package (userland)
```
mkdir -p ~/ros/src
ln -s ~/ovc/software/ovc1/ros/ovc ~/ros/src
cd ~/ros
catkin build
```

# how do I run stuff

## ovc2

For convenience, the `~/.bashrc` of the default `nvidia` user adds
`~/ovc/software/ovc2/scripts` to `$PATH`. Create a link for the `ovc2a.rbf` file (located at `~/ovc/firmware/ovc2/stable`) at the home folder.

Typically, all you need to run is the `ovc2_reconfigure` script, which does
the following:
 * unloads modules which use PCIe
 * loads the `ovc2_cfg` module, which creates a device node `/dev/ovc2_cfg` to expose a configuration interface to userland
 * writes the FPGA configuration from userland to the `/dev/ovc2_cfg` device, which in turn uses the TX2 SPI interface to configure the FPGA
 * loads the `pcie_tegra` module, which enumerates the PCIe bus and finds our newly-configured FPGA on it
 * loads the `ovc2_core` module, which provides a userland driver for ovc2 on three device nodes: `/dev/ovc2_core` `/dev/ovc2_cam` `/dev/ovc2_imu`

For a typical software-development session, you typically just type
`ovc2_reconfigure` and it's all automatic.

Then, you can run the ROS image streamer and feature-visualizer nodes:

Terminal 1:
```
roscore
```

Terminal 2:
```
cd ~/ros
source devel/setup.bash
rosrun ovc2 ovc2_node
```

Terminal 3:
```
rosrun ovc2 corner_viewer
```

I'm usually shelling into the camera, so "Terminal 1" and "Terminal 2" are
remote shells on the camera, and "Terminal 3" is running locally on my
workstation, setting `ROS_MASTER_URI` as needed to point to the camera (adjust
the camera hostname as needed):

```
export ROS_MASTER_URI=http://ovc2a3.local:11311
rosrun ovc corner_viewer
```

#### Powering Down

For reasons unknown at the moment, if you try to power down the TX2 without
first unloading the `ovc2_core` kernel module, the system will hang during
the shutdown process, requiring you to then hold the TX2 power button down
until the PMIC finally does a hard-shutdown.

If you run this script instead:
```
ovc2_poweroff
```
It will first unload the `ovc2_core` module and then run `poweroff`. It just
saves one step to type `ovc2_poweroff` instead.

## ovc1

For a typical software-development session (unless you need to re-flash and reconfigure the FPGA) you just need to load the kernel module. We'll automate this eventually, once it gets more stable, but for now (to avoid boot loops) let's leave the module-loading as a manual step...
```
~/scripts/init_fpga.sh
```
That script will load the OVC kernel module, configure the FPGA core using the blob in `~/opencam/firmware/ovc/fpga/stable/ovc.core.rbf`, and re-load the OVC module to allocate DMA buffers.

Then, you can run the ROS image streamer and feature-visualizer nodes:

Terminal 1:
```
roscore
```

Terminal 2:
```
cd ~/ros
source devel/setup.bash
rosrun ovc ovc_node
```

Terminal 3:
```
rosrun ovc corner_viewer
```

I'm usually shelling into the camera and run "Terminal 3" on my workstation,
setting `ROS_MASTER_URI` as needed to point to the camera (adjust the camera
hostname as needed, if you have changed it from the default `tegra-ubuntu`):
```
export ROS_MASTER_URI=http://ovc.local:11311
rosrun ovc corner_viewer
```

#### Re-flashing MCU (uncommon)
In the event that the MCU is somehow horribly messed up and needs a total
re-flash, you can do the following actions to restore it, using the handy
`stm32flash` program. Unfortunately, because we're using a relatively new
MCU (STM32L452) we need to build it from souce, but it's not hard:
```
mkdir ~/mcu
cd ~/mcu
git clone https://git.code.sf.net/p/stm32flash/code stm32flash
cd stm32flash
make
```

First, we need to do a "button dance" in order to boot the MCU into its
bootloader. Note that the buttons are tiny. Be sure to ground yourself using
either a wrist-strap or diligently touching the HDMI connector shield before
risking unloading your body's static charge into the tiny components near
the buttons!
 * press and hold the `MCU_RESET` button
 * press and hold the `MCU_BOOT` button
 * release `MCU_RESET`
 * release `MCU_BOOT`
If done correctly, the MCU LED should light up. You can verify that the MCU
is in bootloader mode by querying it with `stm32flash`:
```
~/mcu/stm32flash/stm32flash /dev/ttyTHS1
```
If the MCU is alive and in bootloader mode, that command should print out some
information about the memory banks of the STM32.

Now, we can restore the MCU flash bank. First, make sure your checkout of the
`ovc` repo is up-to-date. On a TX2 shell:
```
cd ~/ovc
git pull
```
There should be a MCU firmware blob sitting in `~/ovc/firmware/ovc1/mcu/stable`
that we will now flash to the MCU:
```
~/mcu/stm32flash/stm32flash -v -w ~/ovc/firmware/ovc1/mcu/stable/ovc1_mcu.bin /dev/ttyTHS1
```
Once that operation has completed, you can push the `MCU_RESET` button and then
flash the FPGA I/O ring configuration:
```
~/ovc/software/ovc1/scripts/flash_fpga_config.sh
```
Then you should be able to configure the FPGA:
```
~/ovc/software/ovc1/scripts/reconfigure_fpga.sh
```
If all goes well, `lspci` should show the FPGA connected as device `1234:5678`

Hooray!
