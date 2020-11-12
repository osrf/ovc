#!/usr/bin/env python3
from nmigen import *
from nmigen.lib import fifo
from e10g_tx import E10G_TX


class UDP_TX(Elaboratable):
    '''
    Buffered UDP blaster

    It has to buffer a packet in order to know how long
    the header should be. Once the packet is complete,
    it starts blasting it out over XGMII.
    '''
    def __init__(self):
        self.e10g_tx = E10G_TX()
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)

        # input port for data blasting
        self.tx_d = Signal(64)
        self.tx_en = Signal()

        # dfifo holds the data stream
        self.dfifo = fifo.AsyncFIFOBuffered(width=64, depth=2048, r_domain="sync", w_domain="write")

        # sfifo holds the packet size of each packet in the dfifo
        self.sfifo = fifo.AsyncFIFOBuffered(width=16, depth=16, r_domain="sync", w_domain="write")


    def elaborate(self, platform):
        m = Module()
        m.submodules.e10g_tx = self.e10g_tx
        m.submodules.dfifo = self.dfifo
        m.submodules.sfifo = self.sfifo

        sfifo_w_data = Signal(16)
        sfifo_w_en = Signal()
        m.d.write += [
            sfifo_w_data.eq(0),
            sfifo_w_en.eq(False)
        ]

        eth_tx_en = Signal()
        eth_tx_d = Signal(64)
        m.d.sync += eth_tx_en.eq(False)
        m.d.comb += [
            self.e10g_tx.dmac.eq(0xffffff_ffffff),
            self.e10g_tx.smac.eq(0x010203_040506),
            self.e10g_tx.ethertype.eq(0x0800),
            self.e10g_tx.tx_d.eq(eth_tx_d),
            self.e10g_tx.tx_en.eq(eth_tx_en),
            self.xgmii_d.eq(self.e10g_tx.xgmii_d),
            self.xgmii_c.eq(self.e10g_tx.xgmii_c),
            self.dfifo.w_data.eq(self.tx_d),
            self.dfifo.w_en.eq(self.tx_en),
            self.sfifo.w_data.eq(sfifo_w_data),
            self.sfifo.w_en.eq(sfifo_w_en)
        ]

        # the write-side FSM counts the length of inbound packets
        wcnt = Signal(16)
        with m.FSM(domain='write'):

            with m.State('IDLE'):
                with m.If(self.tx_en):
                    m.next = 'WRITE'
                    m.d.write += wcnt.eq(1)

            with m.State('WRITE'):
                with m.If(self.tx_en):
                    m.d.write += wcnt.eq(wcnt + 1)
                with m.Else():
                    m.next = 'IDLE'
                    m.d.write += [
                        sfifo_w_data.eq(wcnt),
                        sfifo_w_en.eq(True)
                    ]

        # read side: drain FIFO once a packet is ready
        # todo: craft IPv4 and UDP headers, now that we know the size
        rcnt = Signal(16)
        ifg_cnt = Signal(8)
        m.d.sync += self.sfifo.r_en.eq(False)
        m.d.sync += self.dfifo.r_en.eq(False)
        with m.FSM(domain='sync'):

            with m.State('IDLE'):
                eth_tx_en.eq(False)
                with m.If(self.sfifo.r_rdy):
                    m.next = 'HEADER_0'
                    m.d.sync += rcnt.eq(0)

            with m.State('HEADER_0'):  # ipver, length, id, frag
                m.next = 'HEADER_1'
                m.d.sync += [
                    eth_tx_d.eq(0xaaaaaaaa_aaaaaaaa),  # todo: not this :)
                    eth_tx_en.eq(True),
                ]

            with m.State('HEADER_1'):  # TTL, protocol, header csum, source IP
                m.next = 'HEADER_2'
                m.d.sync += [
                    eth_tx_d.eq(0xbbbbbbbb_bbbbbbbb),  # todo: not this :)
                    eth_tx_en.eq(True),
                ]

            with m.State('HEADER_2'):  # dest IP, source port, dest port
                m.next = 'HEADER_3'
                m.d.sync += [
                    eth_tx_d.eq(0xcccccccc_cccccccc),  # todo: not this :)
                    eth_tx_en.eq(True),
                    self.dfifo.r_en.eq(True)
                ]

            with m.State('HEADER_3'):  # UDP length, UDP checksum, first 1/2 data
                m.next = 'READ'
                m.d.sync += [
                    eth_tx_d.eq(0xdddddddd_cccccccc),  # todo: not this :)
                    eth_tx_en.eq(True),
                    self.dfifo.r_en.eq(True)
                ]

            with m.State('READ'):
                m.d.sync += [
                    rcnt.eq(rcnt + 1),
                    eth_tx_d.eq(self.dfifo.r_data),
                    eth_tx_en.eq(True)
                ]
                with m.If(rcnt + 2 >= self.sfifo.r_data):
                    m.next = 'IFG'
                    m.d.sync += [
                        self.sfifo.r_en.eq(True),
                        ifg_cnt.eq(0)
                    ]
                with m.Else():
                    m.d.sync += self.dfifo.r_en.eq(True)

            with m.State('IFG'):
                # in addition to enforcing an inter-frame gap, this state
                # helps ensure the clock-domain crossing finishes from sfifo
                m.d.sync += ifg_cnt.eq(ifg_cnt + 1)
                with m.If(ifg_cnt == 20):
                    m.next = 'IDLE'


        return m


if __name__ == '__main__':
    from nmigen.sim import *
    dut = UDP_TX()
    sim = Simulator(dut)
    sim.add_clock(1 / (156.25e6))
    sim.add_clock(1 / 50e6, domain='write')

    def send_packet():
        tx_count = 0x0004000300020001
        yield dut.tx_d.eq(tx_count)
        yield dut.tx_en.eq(1)
        yield

        for i in range(3):
            yield dut.tx_d.eq(dut.tx_d + 0x0004000400040004)
            yield

        yield dut.tx_en.eq(0)
        yield dut.tx_d.eq(0)
        yield

        for i in range(30):
            yield


    def test():
        for i in range(10):
            yield

        for i in range(2):
            yield from send_packet()

    sim.add_sync_process(test, domain='write')
    with sim.write_vcd('udp_tx.vcd'):
        sim.run()
