# ovc2a Hardware Documentation

### UARTs and other TX2 peripherals

Here is a rendering of the bottom of the TX2 carrier board:
![tx2-peripherals](https://github.com/osrf/ovc/raw/master/doc/ovc2a/ovc2a_mobo_bottom.png "TX2 peripherals")

Here is a rendering of the right-hand side (the side with two buttons), which
is probably more useful of the OVC2a is already in a case:
![tx2-peripherals-right](https://github.com/osrf/ovc/raw/master/doc/ovc2a/ovc2a_mobo_right.png "TX2 right-side peripherals")

There are several UARTs provided by the TX2:
 * TX2 UART0 (TX0, RX0) is the Linux root console. You can use it to catch the bootloader, fix network issues if DHCP isn't working, enter WiFi credentials, etc.
 * TX2 UART1 is internally connected to the IMU and appears in userland as `/dev/ttyTHS2`
 * TX2 UART2 (TX2, RX2) is available for userland use
 * TX2 UART3 (TX3, RX3) is available for userland use

Those UARTs are all buffered to 3.3v, but should still be treated as
static-sensitive since they do not have ESD clamp diodes. Although there are
device nodes for the "classic" names such as `/dev/ttyS2`, etc., it's much
better to use the DMA-accelerated device nodes instead, which have `THS` in
them, such as `/dev/ttyTHS2`, to avoid unnecessary kernel switches for things
as silly as feeding the next character to the UART.

TX2 UART2 and UART3 should be mapped to `/dev/ttyTHS` nodes, but I can't
remember which ones right now; it's usually a process of trial and error. It's
possible that one (or both) of them will require a device tree modification,
but I can't be sure at the moment.

### Ethernet

Unfortunately we assumed the Ethernet PHY on the TX2 was capable of swapping
pairs and polarity as needed to make the PCB layout more convenient, so the
high-speed routing could fit on a single PCB layer. Sadly this is not the
case, so ovc2a requires a non-standard Ethernet pinout to "unswap" the pairs
we swapped; otherwise the ovc2a will not connect when you plug it into a
network switch.

Here is the required non-standard Ethernet connector pinout:
 1. brown/white
 1. brown
 1. blue/white
 1. orange
 1. orange/white
 1. blue
 1. green/white
 1. green

Here is what a "correct" non-standard Ethernet cable looks like for ovc2a:
![ethernet-pinout](https://github.com/osrf/ovc/raw/master/doc/ovc2a/ovc2a_non_standard_ethernet_pinout.jpg "Non-standard Ethernet cable requirement")

Cables in the lab with this pinout are labeled on both ends of the cable as
"ovc2a custom"
