#!/usr/bin/env python3
from blink import *
from nmigen.back.pysim import *


'''
def wait_led(state):
    while True:
        yield Tick()
        if (yield dut.led) == state:
            return
'''


def test():
    for i in range(10000):
        yield


dut = Blink()
sim = Simulator(dut)
sim.add_clock(1e-6)
sim.add_sync_process(test)
with sim.write_vcd("test.vcd"):
    sim.run()
