from nmigen import *


class E10G_TX(Elaboratable):

    def __init__(self):
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)
        # for now, assume dmac/smac are in network byte order already
        self.dmac = Signal(48)
        self.smac = Signal(48)
        self.ethertype = Signal(16)
        self.tx_en = Signal()
        self.tx_d = Signal(64)

    def elaborate(self, platform):
        m = Module()
        I = 0x07
        S = 0xfb
        T = 0xfd
        E = 0xfe
        #ethertype = 0x0800

        tx_d_shift = Signal(192)  # 3 clock's worth
        tx_en_d1 = Signal()
        tx_en_d2 = Signal()

        counter = Signal(8)
        m.d.sync += [
            counter.eq(counter + 1),
            tx_en_d1.eq(self.tx_en),
            tx_en_d2.eq(tx_en_d1),
            tx_d_shift.eq(Cat(tx_d_shift[64:192], self.tx_d))
        ]
        #m.d.comb += self.led.eq(self.counter[2])

        with m.FSM():
            with m.State('IDLE'):
                with m.If(~self.tx_en):  # keep sending IDLE
                    m.next = 'IDLE'
                    m.d.sync += [
                        self.xgmii_d.eq(0x07070707_07070707),
                        self.xgmii_c.eq(0xff)
                    ]
                with m.Else():  # tx_en is asserted; let's start a packet!
                    m.next = 'DMAC'
                    m.d.sync += [
                        self.xgmii_d.eq(0xd5555555_555555fb),
                        self.xgmii_c.eq(0x01)
                    ]
            with m.State('DMAC'):
                m.next = 'SMAC'
                m.d.sync += [
                    self.xgmii_d.eq(Cat(self.dmac, self.smac[0:16])),
                    self.xgmii_c.eq(0x00)
                ]
            with m.State('SMAC'):
                m.next = 'PAYLOAD'
                payload_start = tx_d_shift[64:80]
                m.d.sync += [
                    self.xgmii_d.eq(
                        ((self.smac >> 16) & 0xffffffff) |
                        (self.ethertype << 32) |
                        (payload_start << 48)),
                    self.xgmii_c.eq(0x00),
                    counter.eq(0)
                ]
            with m.State('PAYLOAD'):
                with m.If(tx_en_d2):  # more payload still on the way
                    m.next = 'PAYLOAD'
                    m.d.sync += [
                        self.xgmii_d.eq(Cat(tx_d_shift[16:64], tx_d_shift[64:80])),
                        self.xgmii_c.eq(0x00)
                    ]
                with m.Else():
                    fcs = C(0x99999999)
                    m.next = 'FCS'
                    m.d.sync += [
                        self.xgmii_d.eq(Cat(tx_d_shift[16:64], fcs[0:16])),
                        self.xgmii_c.eq(0x00)
                    ]
            # todo: pad as necessary so that the frame is >= 64 bytes
            with m.State('FCS'):
                m.next = 'TERMINATE'
                m.d.sync += [
                ]
            with m.State('TERMINATE'):
                m.next = 'IDLE'
                m.d.sync += [
                    self.xgmii_d.eq(0x07070707_070707fd),
                    self.xgmii_c.eq(0xff),
                    counter.eq(0)
                ]

        return m
