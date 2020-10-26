# Prerequisites

Download Xilinx Vivado WebPack 2020.1:
https://www.xilinx.com/support/download.html

On Ubuntu 20.04, you have to play some games to install Vivado.
[This forum thread](https://forums.xilinx.com/t5/Installation-and-Licensing/Xilinx-Unified-Installer-2020-1-Exception-in-thread-quot-SPLASH/td-p/1114416) describes the issue and what to (temporarily) stuff in `/etc/os-release` so that the installer doesn't crash.
This will be fixed in Vivado 2020.2, but anyway for the time being, this somewhat "interesting" method of temporarily faking `/etc/os-release` works to get it installed on Ubuntu 20.04.

I found it necessary to install this on my machine. YMMV:
```
sudo apt install libtinfo5
```

Install cable drivers (substitute your Xilinx location as needed)
```
cd $HOME/xilinx/Vivado/2020.1/data/xicom/cable_drivers/lin64/install_script/install_drivers
sudo cp *.rules /etc/udev/rules.d
```

Now let's install `nMigen` to make our lives more joyous:
```
pip3 install --user 'git+https://github.com/nmigen/nmigen.git#egg=nmigen[builtin-yosys]'
```

# Goal

Use nMigen to create a minimal MAC that blasts 10G UDP broadcast packets out a SFP+ interface.

```
git submodule init
git submodule update
```
