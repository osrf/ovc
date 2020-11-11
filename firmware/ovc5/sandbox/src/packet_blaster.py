#!/usr/bin/env python3
from nmigen import *
from e10g_tx import E10G_TX


class PacketBlaster(Elaboratable):
    '''
    just blasts packets once in a while
    '''

    def __init__(self):
        self.e10g_tx = E10G_TX()
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)

    def elaborate(self, platform):
        m = Module()
        m.submodules.e10g_tx = self.e10g_tx

        m.d.comb += [
            self.e10g_tx.dmac.eq(0xffffff_ffffff),
            self.e10g_tx.smac.eq(0x010203_040506),
            self.e10g_tx.ethertype.eq(0x0800),
            self.xgmii_d.eq(self.e10g_tx.xgmii_d),
            self.xgmii_c.eq(self.e10g_tx.xgmii_c)
        ]

        counter = Signal(24)
        tx_d = Signal(64)
        m.d.sync += [
            counter.eq(counter + 1)
        ]

        with m.FSM():
            with m.State('IDLE'):
                with m.If(counter == 0x0000_0000_020):
                    m.d.sync += [
                        counter.eq(0),
                        self.e10g_tx.tx_en.eq(True),
                        tx_d.eq(0x0004000300020001)
                    ]
                    m.next = 'TX'

            with m.State('TX'):
                m.d.sync += [
                    tx_d.eq(tx_d + 0x0004000400040004)
                ]
                with m.If(counter == 7):
                    m.d.sync += [
                        self.e10g_tx.tx_en.eq(False),
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
