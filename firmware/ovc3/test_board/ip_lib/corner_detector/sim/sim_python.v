`timescale 1ns/1ns
module sim_python
#(parameter COLS=16, ROWS=8, BLACK_ROWS=3,
            INTERFRAME_WORDS=8431,
            USE_TRIGGER=0,
            DATA_RST_VAL=32'h0,
            SIM_ADC_SEQUENCER=1,
            IMAGE_FILE="../sim/squares_64x32.bin")
(input c,
 input trigger,
 output [31:0] data,
 output [7:0] sync,
 input cs,
 input sck,
 input mosi,
 output miso);

reg [31:0] data_cnt;
reg [31:0] data_noninv;
reg [7:0] sync_noninv;
reg kernel_parity_odd;

assign sync = sync_noninv;
assign data = data_noninv;

// todo: something smarter than this to simulate register read/write
assign miso = 1'b0;

integer f;
integer i, row, col, irg;

`include "python_defs.inc"

localparam RST_DATA = 1;
localparam INC_DATA = 2;

reg [7:0] image_data[0:ROWS*COLS-1];

task send;
  input [7:0] word;
  input integer data_action;
  begin
    sync_noninv <= word;
    if (data_action == RST_DATA)
      data_noninv <= DATA_RST_VAL;
    else if (data_action == INC_DATA) 
      if (word == FS) begin
        data_cnt <= 32'h0;
        data_noninv <= 32'h0;
      end else begin
        data_cnt <= data_cnt + 32'h1;
        //data_noninv <= data_cnt + 32'h1;
        data_noninv = { image_data[((data_cnt+1'h1)*4+3'h3)],
                        image_data[((data_cnt+1'h1)*4+3'h2)],
                        image_data[((data_cnt+1'h1)*4+3'h1)],
                        image_data[((data_cnt+1'h1)*4+3'h0)] };
      end
      
      /*
      data <= {data[31:24] + 8'hfe,
               data[23:16] + 8'h02,
               data[15: 8] + 8'hff,
               data[ 7: 0] + 8'h01}; //data + 32'hfe02_ff01;
      */
    @(posedge c);
    kernel_parity_odd <= ~kernel_parity_odd;
  end
endtask

/*
wire next_data = data_noninv + 32'h1;
generate
  if (SIM_ADC_SEQUENCER) begin
    assign data =
      kernel_parity_odd ? { 
                        :
  end else
    assign data = data_noninv;
endgenerate
*/

// TODO: actually model the ADC sequencer someday. It's tricky.
assign data = data_noninv;

integer fd, num_read;
initial begin
  data_noninv <= 32'h0;
  sync_noninv <= 8'h0;
  data_cnt <= 32'h0;
  fd = $fopenr(IMAGE_FILE);
  num_read = $fread(image_data, fd);
  $fclose(fd);
  $display("read %d bytes from %s", num_read, IMAGE_FILE);
  forever begin
    // inter-frame gap
    if (USE_TRIGGER) begin
      wait(~trigger);
      wait(trigger);
      $display($time, " image started via trigger");
    end else begin
      for (i = 0; i < INTERFRAME_WORDS; i = i + 1)
        send(TR, RST_DATA);
    end
    // black calibration lines
    for (row = 0; row < BLACK_ROWS; row = row + 1) begin
      send(LS, RST_DATA);
      send(WN, RST_DATA);
      data_noninv <= 32'h00;
      for (col = 0; col < (COLS/4)-4; col = col + 1)
        send(BL, RST_DATA);
      send(LE, RST_DATA);
      send(WN, RST_DATA);
      send(CS, RST_DATA);
      send(TR, RST_DATA);
      send(TR, RST_DATA);
      send(TR, RST_DATA);
    end
    kernel_parity_odd = 1'b0;
    for (row = 0; row < ROWS; row = row + 1) begin
      //$display($time, "  sim_python.v sending row %d", row);
      if (row == 0)
        send(FS, INC_DATA);
      else
        send(LS, INC_DATA);
      send(WN, INC_DATA);
      for (col = 0; col < (COLS/4)-4; col = col + 1)
        send(IM, INC_DATA);
      if (row == ROWS-1)
        send(FE, INC_DATA);
      else
        send(LE, INC_DATA);
      send(WN, INC_DATA);
      send(CS, RST_DATA);
      for (irg = 0; irg < 300; irg = irg + 1) // irg=3 for zeroROT, 87 otherwise
        send(TR, RST_DATA);
    end
  end
end

endmodule
