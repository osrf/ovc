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

# Goal

Use the open-source 10G MAC from the NetFPGA project. Forked here for now:
https://github.com/codebot/nfmac10g

```
git submodule init
```
