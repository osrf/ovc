`timescale 1ns/1ns
module sim_imu
#(parameter SPEEDUP=1)
(output sync_out,
 input cs,
 input sck,
 input mosi,
 output reg miso);

wire c;
sim_clk #(1) sim_clk_inst(.c(c));

integer cnt;
initial cnt <= 0;
always @(posedge c)
  cnt <= (cnt == 5000/SPEEDUP ? 0 : cnt + 1);

assign sync_out = cnt < 500/SPEEDUP;

integer sck_cnt, word_cnt;
reg in_request;
reg [7:0] cmd;
reg [7:0] reg_idx;
reg [31:0] miso_word;
reg [31:0] mosi_word;

initial begin
  in_request = 1'b0;
  mosi_word = 32'h0;
  miso_word = 32'h0;
  word_cnt = 0;
  cmd = 8'h0;
  reg_idx = 8'h0;
  miso = 1'b0;
end

always @(negedge cs) begin
  //$display($time, " imu: negedge CS");
  sck_cnt = 0;
  in_request = ~in_request;
  word_cnt = 0;
end

always @(posedge sck) begin
  //$display($time, " posedge sck");
  mosi_word = {mosi_word[30:0], mosi};
  sck_cnt = sck_cnt + 1;
  if (sck_cnt % 32 == 0) begin
    //$display($time, " word received");
    if (in_request) begin
      cmd = mosi_word[31:24];
      reg_idx = mosi_word[23:16];
      //$display($time, " request word received: 0x%08x", mosi_word);
      //$display($time, " cmd: 0x%h  reg_idx: 0x%h", cmd, reg_idx);
      miso_word = 32'h0;
    end
    else begin
      //$display($time, " response word received: 0x%08x", mosi_word);
    end
  end
end

always @(negedge sck) begin
  if (sck_cnt % 32 == 0) begin
    if (word_cnt == 0)
      miso_word = 32'h0;
    else
      miso_word = { reg_idx + {word_cnt[5:0]-6'h1, 2'h0} + 8'h0,
                    reg_idx + {word_cnt[5:0]-6'h1, 2'h0} + 8'h1,
                    reg_idx + {word_cnt[5:0]-6'h1, 2'h0} + 8'h2,
                    reg_idx + {word_cnt[5:0]-6'h1, 2'h0} + 8'h3 };
    word_cnt = word_cnt + 1;
  end
  miso = miso_word[31];
  miso_word = { miso_word[30:0], 1'b0 };

  //miso_word = { reg_idx, reg_idx + 8'h1, reg_idx + 8'h2, reg_idx + 8'h3 };
end

endmodule
