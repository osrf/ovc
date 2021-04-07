# ovc2

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

# how do I run stuff

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


