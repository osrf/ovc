# ovc2a Hardware Documentation

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
![ethernet-pinout](https://github.com/osrf/ovc/raw/master/doc/ovc2a_non_standard_ethernet_pinout.jpg "Non-standard Ethernet cable requirement")

Cables in the lab with this pinout are labeled on both ends of the cable as
"ovc2a custom"
