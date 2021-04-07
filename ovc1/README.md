# ovc1

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

# Software development

For a typical software-development session (unless you need to re-flash and reconfigure the FPGA) you just need to load the kernel module. We'll automate this eventually, once it gets more stable, but for now (to avoid boot loops) let's leave the module-loading as a manual step...
```
~/scripts/init_fpga.sh
```
That script will load the OVC kernel module, configure the FPGA core using the blob in `~/ovc/firmware/ovc1/fpga/stable/ovc.core.rbf`, and re-load the OVC module to allocate DMA buffers.

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


