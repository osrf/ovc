`timescale 1ns/1ns
module imu_reader
#(parameter SPEEDUP=1)
(input c,
 input sync,
 input [63:0] t,  // system timestamp
 output [7:0] ram_addr,
 output ram_wr,
 output [31:0] ram_d,
 input [31:0] ram_q,
 output cs,
 output sck,
 output mosi,
 input miso,
 output irq
);

`ifndef SIM
// we want SPI clk = 4 MHz ~= 125 / (16*2)
localparam SPI_SCLK_DIV = 8'd16;
`else
localparam SPI_SCLK_DIV = 8'd4;  // go faster in sim
`endif

// imu_sync is pulsed high whenever a new measurement is ready for us to grab

// we have a 1 KB RAM organized as 256 words of 32 bits

// every time the sync pulse fires, we need to read the following:
//   16 bytes: quaternion
//     register 9 bytes 0-15
//   24 bytes: imu (calibrated but uncompensated gyro and accel)
//     register 54 bytes 12-35
//   20 bytes: magpres (calib+comp magnetic, temperature, and pressure)
//     compensated mags = register 17 bytes 0-11
//     calibrated temp+pres = register 54 bytes 36-43

// combining: we need to read the following:
//   register 54 bytes 12-43  (32 bytes = 8 words, starting on 4th word)
//   register  9 bytes  0-15  (16 bytes = 4 words)
//   register 17 bytes  0-11  (12 bytes = 3 words)

// total = 32+16+12 = 60 bytes * 8 = 480 bits (1/8e6 mbps) = 60 usec
// but we have to insert lots of wait states that will dominate the time

localparam CW = 6+8+8+8, SW = 4;
localparam ST_IDLE    = 4'd0;
localparam ST_TIME_HI = 4'd1;
localparam ST_TIME_LO = 4'd2;
localparam ST_IMU     = 4'd3;
localparam ST_MAG     = 4'd4;
localparam ST_QTN     = 4'd5;
localparam ST_DONE    = 4'd6;

reg [CW+SW-1:0] ctrl;
wire [SW-1:0] state;
wire [SW-1:0] next_state = ctrl[CW+SW-1:CW];
r #(SW) state_r
(.c(c), .d(next_state), .rst(1'b0), .en(1'b1), .q(state));

wire read_done;

wire sync_happened, sync_happened_rst;
r sync_happened_r
(.c(c), .en(sync), .rst(sync_happened_rst),
 .d(1'b1), .q(sync_happened));

//////////////////////////////////////////////////////// IDX    LEN    START
always @* begin
  case (state)
    ST_IDLE:
      if (sync_happened) ctrl = { ST_TIME_HI, 6'b001010, 8'd00, 8'd00, 8'd00 };
      else               ctrl = { ST_IDLE   , 6'b100000, 8'd00, 8'd00, 8'd00 };
    ST_TIME_HI:          ctrl = { ST_TIME_LO, 6'b000000, 8'd00, 8'd00, 8'd00 };
    ST_TIME_LO:          ctrl = { ST_IMU    , 6'b001001, 8'd54, 8'd11, 8'd03 };
    ST_IMU:
      if (read_done)     ctrl = { ST_MAG    , 6'b001001, 8'd17, 8'd03, 8'd00 };
      else               ctrl = { ST_IMU    , 6'b001000, 8'd54, 8'd11, 8'd03 };
    ST_MAG:
      if (read_done)     ctrl = { ST_QTN    , 6'b001001, 8'd09, 8'd04, 8'd00 };
      else               ctrl = { ST_MAG    , 6'b001000, 8'd17, 8'd03, 8'd00 };
    ST_QTN:
      if (read_done)     ctrl = { ST_DONE   , 6'b001000, 8'd00, 8'd00, 8'd00 };
      else               ctrl = { ST_QTN    , 6'b001000, 8'd09, 8'd04, 8'd00 };
    ST_DONE:
      if (~sync)         ctrl = { ST_IDLE   , 6'b001100, 8'd00, 8'd00, 8'd00 };
      else               ctrl = { ST_DONE   , 6'b001000, 8'd00, 8'd00, 8'd00 };
    default:             ctrl = { ST_IDLE   , 6'b001000, 8'd00, 8'd00, 8'd00 };
  endcase
end

// save the inbound clock when we capture the sync pulse edge
wire [63:0] t_q;
r #(64) t_r(.c(c), .rst(1'b0), .en(state == ST_IDLE), .d(t), .q(t_q));

wire read_start = ctrl[24];
wire word_cnt_rst = ctrl[25];

//assign irq = ctrl[26];
wire irq_d1;
d1 irq_d1_r(.c(c), .d(ctrl[26]), .q(irq));

assign sync_happened_rst = ctrl[27];

/////////////////////////////////////////////////////////

wire [7:0] reg_idx = ctrl[23:16];
wire [7:0] reg_len = ctrl[15:08];
wire [7:0] reg_start_word = ctrl[7:0];
wire reg_reader_busy;

wire [31:0] imu_reg_reader_d;
wire imu_reg_reader_dv;
imu_reg_reader #(.SPEEDUP(SPEEDUP),
                 .SPI_SCLK_DIV(SPI_SCLK_DIV)) imu_reg_reader_inst
(.c(c), .start(read_start), .done(read_done),
 .reg_idx(reg_idx), .reg_len(reg_len), .reg_start_word(reg_start_word),
 .reg_d(imu_reg_reader_d), .reg_dv(imu_reg_reader_dv),
 .cs(cs), .sck(sck), .mosi(mosi), .miso(miso));

wire [31:0] reg_d = state == ST_TIME_HI ? t_q[63:32] :
                    (state == ST_TIME_LO ? t_q[31:0] :
                     imu_reg_reader_d);
wire reg_dv = (state == ST_TIME_HI) | (state == ST_TIME_LO) ? 1'b1 :
              imu_reg_reader_dv;

wire [7:0] word_cnt;
r #(8) word_cnt_r
(.c(c), .rst(word_cnt_rst), .en(reg_dv), .d(word_cnt+1'b1), .q(word_cnt));

// insert a delay cycle to help signals propagate towards the PCIe block
wire [7:0] word_cnt_d1;
d1 #(8) word_cnt_d1_r(.c(c), .d(word_cnt), .q(word_cnt_d1));

wire [31:0] reg_d_d1;
d1 #(32) reg_d_d1_r(.c(c), .d(reg_d), .q(reg_d_d1));

wire reg_dv_d1;
d1 reg_dv_d1_r(.c(c), .d(reg_dv), .q(reg_dv_d1));

assign ram_addr = word_cnt_d1 + 8'h4;  // save lowest 4 addr for future stuff
assign ram_d = reg_d_d1;
assign ram_wr = reg_dv_d1;

///////////////////

/*
d1 cs_d1_r(.c(c), .d(auto_cs), .q(cs));
d1 sck_d1_r(.c(c), .d(auto_sck), .q(sck));
d1 mosi_d1_r(.c(c), .d(auto_mosi), .q(mosi));
*/

endmodule
