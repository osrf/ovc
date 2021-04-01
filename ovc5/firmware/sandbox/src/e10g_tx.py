from nmigen import *
from xgmii_fcs_inserter import XGMII_FCS_Inserter


class E10G_TX(Elaboratable):

    def __init__(self):
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)
        # for now, assume dmac/smac are in network byte order already
        self.dmac = Signal(48)
        self.smac = Signal(48)
        self.ethertype = Signal(16)
        self.tx_en = Signal(8)  # one bit per byte
        self.tx_d = Signal(64)
        self.fcs_inserter = XGMII_FCS_Inserter()

    def elaborate(self, platform):
        m = Module()
        m.submodules.fcs_inserter = self.fcs_inserter

        tx_d_shift = Signal(128)  # 2 clock's worth
        tx_en_d1 = Signal(8)

        counter = Signal(8)
        m.d.sync += [
            counter.eq(counter + 1),
            tx_en_d1.eq(self.tx_en),
            tx_d_shift.eq(Cat(tx_d_shift[64:128], self.tx_d))
        ]

        d = Signal(64)  # this is what we'll send to XGMII_FCS_Inserter
        d_valid = Signal(8)
        m.d.comb += [
            self.fcs_inserter.d_in.eq(d),
            self.fcs_inserter.d_valid.eq(d_valid),
            self.xgmii_d.eq(self.fcs_inserter.d_out),
            self.xgmii_c.eq(self.fcs_inserter.c_out)
        ]

        with m.FSM():
            with m.State('IDLE'):
                with m.If(self.tx_en == 0):  # keep sending IDLE
                    m.next = 'IDLE'
                    m.d.sync += [
                        d.eq(0),
                        d_valid.eq(0)
                    ]
                with m.Else():
                    m.next = 'HEADER'
                    m.d.sync += [
                        d.eq(
                            Cat(
                                self.dmac[40:48],
                                self.dmac[32:40],
                                self.dmac[24:32],
                                self.dmac[16:24],
                                self.dmac[ 8:16],
                                self.dmac[ 0: 8],
                                self.smac[40:48],
                                self.smac[32:40])
                            ),
                        d_valid.eq(0xff)
                    ]
            with m.State('HEADER'):
                m.next = 'PAYLOAD'
                payload_start = tx_d_shift[64:80]
                m.d.sync += [
                    d.eq(
                        Cat(
                            self.smac[24:32],
                            self.smac[16:24],
                            self.smac[ 8:16],
                            self.smac[ 0: 8],
                            self.ethertype[8:16],
                            self.ethertype[0:8],
                            payload_start[0:16])
                        ),
                    d_valid.eq(0xff),
                    counter.eq(0)
                ]
            with m.State('PAYLOAD'):
                with m.If(tx_en_d1 == 0xff):  # payload still streaming
                    m.next = 'PAYLOAD'
                    m.d.sync += [
                        d.eq(Cat(tx_d_shift[16:64], tx_d_shift[64:80])),
                        d_valid.eq(tx_en_d1)
                    ]
                with m.Elif(tx_en_d1 == 0x0f):
                    m.next = 'TERM_0F'
                    m.d.sync += [
                        d.eq(Cat(tx_d_shift[16:64], tx_d_shift[64:80])),
                        d_valid.eq(0xff)
                    ]
                with m.Elif(tx_en_d1 == 0x00):
                    m.next = 'IFG'
                    m.d.sync += [
                        d.eq(Cat(tx_d_shift[16:64], 0xbbbb)),
                        d_valid.eq(0x3f)
                    ]
            with m.State('TERM_0F'):
                # need to flush the last 16 bytes
                m.next = 'IFG'
                m.d.sync += [
                    d.eq(Cat(tx_d_shift[16:48], 0xbbbbbbbb)),
                    d_valid.eq(0x03)
                ]

            # todo: pad as necessary so that the frame is >= 64 bytes
            with m.State('IFG'):
                m.next = 'IDLE'
                m.d.sync += [
                    d.eq(0),
                    d_valid.eq(0),
                    counter.eq(0)
                ]

        return m
