# Open Vision Computer (OVC)

Here is an outdated-but-maybe-interesting [overview presentation of the project](https://docs.google.com/presentation/d/1NCimNJTRP6g3ESWhmaqi4t3dOprq7Yvne_JLeCTt3io/edit?usp=sharing) (March 2018).

This repo contains hardware, firmware, and software for an open-source embedded
vision system: the Open Vision Computer (OVC). The goal is to connect state of
the art open hardware with open firmware and software. There are a few revs:

 * ovc0: three Python1300 imagers, an Artix-7 FPGA, DRAM, and USB3 via a Cypress FX3 controller.
 * ovc1: two Python1300 imagers, a Jetson TX2 (6x ARMv8, GPU, etc.) connected to a Cyclone-V GT FPGA over PCIe.
 * [ovc2](doc/ovc2a/README.md): two Python1300 imagers, a Jetson TX2 (6x ARMv8, GPU, etc.) connected to a Cyclone 10 GX FPGA over PCIe Gen 2.0 x4
 * ovc3: three ON Semi AR0144CS imagers, USB Type-C peripheral, Trenz TE0820 module with Xilinx Zynq UltraScale+, RAM, flash, etc. Up to four optional external camera boards, each of which add a pair of AR0144CS imagers.
 * ovc4: A Jetson Xavier NX carrier board with an NXP MCU, USB Type-C interface and six Picam compatible connectors.
 * ovc5 (current work): based on Zynq UltraScale+ modules from Enclustra, with up to six external MIPI camera boards. Both Zynq USB SuperSpeed (5 Gbps) transceivers connect to an onboard USB-SS+ (10 Gbps) hub controller IC, which multiplexes them upstream via a USB type-C connector. Also has three Qwiic/STEMMA connectors and some random FPGA GPIO for low-speed expansion.

# Where do I find stuff

Each camera family has its own directory in this repository that contains its relevant hardware, firmware, and software.

# Hardware Design

We are using the very latest KiCAD: the nightly development builds.
Installation instructions are here: https://www.kicad.org/download/ubuntu/

Once you have installed `kicad-nightly` on your machine, then you will
need to set up the repos as follows:

```
mkdir ~/hw
cd ~/hw
git clone ssh://git@github.com/osrf/osrf_hw
git clone ssh://git@github.com/osrf/ovc
```

Add the following line to your .bashrc file to set the KIWORKSPACE environment variable to point at your hardware folder:

```
export KIWORKSPACE=~/hw
```

Then you should be able to view the latest developments:
```
cd ~/hw/ovc/ovc5/hardware/carrier
kicad-nightly ovc5.kicad_pro
```

---

#### Software License
[Apache Version 2.0](https://github.com/osrf/ovc/blob/master/LICENSE)

#### Hardware License
[CERN-OHL-P](https://github.com/osrf/ovc/blob/master/LICENSE_HARDWARE)

#### Documentation License
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
