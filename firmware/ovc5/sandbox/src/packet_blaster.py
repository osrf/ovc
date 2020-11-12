#!/usr/bin/env python3
from nmigen import *
from udp_tx import UDP_TX


class PacketBlaster(Elaboratable):
    '''
    just blasts packets once in a while
    '''

    def __init__(self, blast_interval = 0x20):
        self.udp_tx = UDP_TX()
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)
        self.blast_interval = blast_interval

    def elaborate(self, platform):
        m = Module()
        m.submodules.udp_tx = self.udp_tx

        counter = Signal(26)
        tx_d = Signal(64)
        tx_en = Signal()
        m.d.sync += [
            counter.eq(counter + 1)
        ]

        m.d.comb += [
            self.udp_tx.tx_d.eq(tx_d),
            self.udp_tx.tx_en.eq(tx_en),
            self.xgmii_d.eq(self.udp_tx.xgmii_d),
            self.xgmii_c.eq(self.udp_tx.xgmii_c)
        ]

        with m.FSM():
            with m.State('IDLE'):
                with m.If(counter == self.blast_interval):
                    m.d.sync += [
                        counter.eq(0),
                        tx_en.eq(True),
                        tx_d.eq(0x0004000300020001)
                    ]
                    m.next = 'TX'

            with m.State('TX'):
                m.d.sync += [
                    tx_d.eq(tx_d + 0x0004000400040004)
                ]
                with m.If(counter == 7):
                    m.d.sync += [
                        tx_en.eq(False),
                        tx_d.eq(0),
                        counter.eq(0)
                    ]
                    m.next = 'IDLE'
        return m


if __name__ == '__main__':
    from nmigen.sim import *
    blaster = PacketBlaster()
    sim = Simulator(blaster)
    sim.add_clock(1 / (156.25e6))
    def test():
        for i in range(100):
            yield
    sim.add_sync_process(test)
    with sim.write_vcd('packet_blaster.vcd'):
        sim.run()
