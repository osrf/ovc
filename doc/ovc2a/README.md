# ovc2a Hardware Documentation

### UARTs and other TX2 peripherals

Here is a rendering of the bottom of the TX2 carrier board:
![tx2-peripherals](https://github.com/osrf/ovc/raw/master/doc/ovc2a/ovc2a_mobo_bottom.png "TX2 peripherals")

The right-hand side (the side with the two buttons) has several UARTs:
 * UART0 is the Linux root console.
 * UART2 is available for userland use
 * UART3 is available for userland use

Those UARTs are all buffered to 3.3v, but should still be treated as
static-sensitive since they do not have ESD clamp diodes.

They should appear in userland as `/dev/ttyTHS2` and `/dev/ttyTHS3`

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
