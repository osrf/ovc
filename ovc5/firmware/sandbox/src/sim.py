#!/usr/bin/env python3
from e10g_tx import *
from nmigen.sim import *


'''
def wait_led(state):
    while True:
        yield Tick()
        if (yield dut.led) == state:
            return
'''


def send_packet():
    tx_count = 0x0004000300020001
    yield dut.tx_d.eq(tx_count)
    yield dut.tx_en.eq(1)
    yield

    for i in range(2):
        yield dut.tx_d.eq(dut.tx_d + 0x0004000400040004)
        yield

    yield dut.tx_en.eq(0)
    yield

    for i in range(100):
        yield


def test():
    yield dut.dmac.eq(0xfedcba987654)
    yield dut.smac.eq(0x0123456789ab)
    yield dut.ethertype.eq(0x0800)
    for i in range(4):
        yield from send_packet()


dut = E10G_TX()
sim = Simulator(dut)
sim.add_clock(1e-6)
sim.add_sync_process(test)
with sim.write_vcd("e10g_tx.vcd"):
    sim.run()
