#!/usr/bin/env python3
from e10g_mac_tx import *
from nmigen.back.pysim import *


'''
def wait_led(state):
    while True:
        yield Tick()
        if (yield dut.led) == state:
            return
'''


def test():
    for i in range(100):
        yield


dut = E10G_MAC_TX()
sim = Simulator(dut)
sim.add_clock(1e-6)
sim.add_sync_process(test)
with sim.write_vcd("test.vcd"):
    sim.run()
