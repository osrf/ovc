# OVC Mini

OVC Mini intends to bring the same open computing platform to a much smaller form factor.
This had been made possible through the extremely small form factor SoMs that are built
around NXP's IMX8M chips. The end goal is a minimalistic footprint camera with the same
screw-on lens, combined with swappable 2-lane or 4-lane mipi camera boards.

## Hardware

Ka-Ro's QSXP/QSXM SoMs are perfectly sized for the pre-existing OVC-lens holder footprint.
Using these modules, it will be possible to create a sandwich of the imager board with the
compute board for minimal wasted space.

## Firmware

This project is running Ka-Ro's custom version of Yocto Hardknott with some additional drivers
added in for camera support.

## Benchmark

There are two benchmarks of interest:
* Latency between the image being read from the sensor to arriving in the host computer
* Reliable transmission bandwidth

Tools to test these are located in the benchmark directory.

## Software

The goal is to re-use much of OVC5's software stack by using udmabufs again for the output of the camera modules. I2C is already the same. This will allow for a simple change of the [yaml configuration file](https://github.com/osrf/ovc/blob/master/ovc5/software/config.yaml) to switch between OVC5 and OVC Mini.

__TODO:__ bring out the gpio settings for line trigger and sample trigger into the configuration file.