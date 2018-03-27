`timescale 1ns/1ns
module imu_host_spi
#(parameter SPI_SCLK_DIV=4)
(input c,
 output auto_enable,
 output [7:0] ram_addr, output ram_wr,
 output [31:0] ram_d, input [31:0] ram_q,
 output req, input grant, input ram_grant,
 output cs, output sck, output mosi, input miso
);

localparam CW = 8, SW = 4;
localparam ST_IDLE  = 4'd0;
localparam ST_WAIT  = 4'd1;  // wait for host_req to be asserted in ctrl reg
localparam ST_HGRNT = 4'd2;  // wait for auto-poll machinery to grant us access
localparam ST_SAVE  = 4'd3;  // save TXD and set busy bit
localparam ST_START = 4'd4;  // now that TXD is saved, start SPI tx/rx
localparam ST_SPI   = 4'd5;  // wait for SPI tx/rx. write RXD when done
localparam ST_DONE  = 4'd6;  // write status as "not busy"
localparam ST_CTRL  = 4'd7;  // read CTRL
localparam ST_NSTRT = 4'd8;  // wait for ~start (host ack) before continuing

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[CW+SW-1:CW];
r #(SW) state_r
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));

wire host_req, start, spi_done;

always @* begin
  case (state)
    ST_IDLE:            ctrl = { ST_WAIT , 8'b0000_0_0_00 };  // address ctrl
    ST_WAIT:
      if (~host_req)    ctrl = { ST_WAIT , 8'b0010_0_0_00 };  // stay here
      else              ctrl = { ST_HGRNT, 8'b0010_1_0_00 };  // assert REQ
    ST_HGRNT:
      if (~host_req)    ctrl = { ST_WAIT , 8'b0010_0_0_00 };
      else
        if (~grant)     ctrl = { ST_HGRNT, 8'b0010_1_0_00 };  // stay here
        else
          if (start)    ctrl = { ST_SAVE , 8'b0000_1_0_01 };  // address txd
          else          ctrl = { ST_HGRNT, 8'b0010_1_0_00 };  // wait for host
    ST_SAVE:            ctrl = { ST_START, 8'b0100_1_0_00 };  // save txd
    ST_START:           ctrl = { ST_SPI  , 8'b0001_1_0_00 };  // start spi txrx
    ST_SPI:
      if (~spi_done)    ctrl = { ST_SPI  , 8'b1000_1_1_11 };  // write status
      else              ctrl = { ST_DONE , 8'b0000_1_1_10 };  // write rxd
    ST_DONE:            ctrl = { ST_CTRL , 8'b0000_1_1_11 };  // write status
    ST_CTRL:            ctrl = { ST_NSTRT, 8'b0000_1_0_00 };  // address ctrl
    ST_NSTRT:
      if (start)        ctrl = { ST_NSTRT, 8'b0010_1_0_00 };  // wait for ~strt
      else
        if (host_req)   ctrl = { ST_HGRNT, 8'b0000_1_0_00 };  // wait for next
        else            ctrl = { ST_WAIT , 8'b0000_0_0_00 };  // release REQ
    default:            ctrl = { ST_IDLE , 8'b0000_0_0_00 };
  endcase
end

assign ram_addr = { 6'h0, ctrl[1:0] };
assign ram_wr   = ctrl[2];
assign req = ctrl[3];
wire spi_start = ctrl[4];
wire status_busy = ctrl[7];

// save the control register
wire ram_ctrl_reg_en = ctrl[5] & ram_grant;
wire [31:0] ram_ctrl_reg;
r #(32) ram_ctrl_reg_r
(.c(c), .rst(1'b0), .en(ram_ctrl_reg_en), .d(ram_q), .q(ram_ctrl_reg));

// save the txd data
wire spi_txd_en = ctrl[6];
wire [31:0] spi_txd;
r #(32) spi_txd_r
(.c(c), .rst(1'b0), .en(spi_txd_en), .d(ram_q), .q(spi_txd));

assign start = ram_ctrl_reg[0];
wire hold_cs = ram_ctrl_reg[1];
assign host_req = ram_ctrl_reg[2];
assign auto_enable = ram_ctrl_reg[24];  // this enables auto-poll

wire [31:0] spi_rxd;
assign ram_d = ctrl[1:0] == 2'h3 ? {30'h0, spi_done, status_busy} : spi_rxd;
 
spi_master #(.SCLK_DIV(SPI_SCLK_DIV), .W(32)) spi_master_inst
(.c(c), .start(spi_start), .done(spi_done), .hold_cs(hold_cs),
 .txd(spi_txd), .rxd(spi_rxd),
 .cs(cs), .sclk(sck), .mosi(mosi), .miso(miso));

endmodule
