`timescale 1ns/1ns
//`include "clog2.inc"
// this is terrible... but this fifo is faster (less latency)
// than my previous one, so it's "ffifo" instead of just "fifo"
module ffifo
#(parameter W = 8,      // width of data words
  parameter L = 1024,   // length, in words
  parameter A = $clog2(L))   // width of length
(input wire wc,              // write clock
 input wire [W-1:0] d,       // write data
 input wire wr,              // write command/flag
 input wire rc,              // read clock
 output wire [W-1:0] q,      // read data
 input wire rd,              // read command/flag
 output wire empty,          // empty flag (in read-clock domain)
 output wire almost_empty,   // almost-empty flag (in read-clock domain)
 output wire [$clog2(L)-1:0] count,     // count in the read-clock domain
 output wire [$clog2(L)-1:0] count_wc); // count in the write-clock domain

wire [A-1:0] rptr;
wire [A-1:0] rptr_next = (rd & ~empty) ? rptr + 1'b1 : rptr;
d1 #(A) rptr_r(.c(rc), .d(rptr_next), .q(rptr));

wire [A-1:0] wptr;
wire wptr_en;
r #(A) wptr_r(.c(wc), .rst(1'b0), .en(wptr_en), .d(wptr+1'b1), .q(wptr));

// convert read and write pointers to gray code and cross clock domains
wire [A-1:0] wptr_gray, rptr_gray;
bin2gray #(A) wptr_b2g_inst(.c(wc), .d(wptr), .q(wptr_gray));
bin2gray #(A) rptr_b2g_inst(.c(rc), .d(rptr), .q(rptr_gray));

wire [A-1:0] wptr_gray_rc, rptr_gray_wc;
s #(A) wptr_gray_rc_s(.c(rc), .d(wptr_gray), .q(wptr_gray_rc));
s #(A) rptr_gray_wc_s(.c(wc), .d(rptr_gray), .q(rptr_gray_wc));

wire [A-1:0] wptr_rc, rptr_wc;
gray2bin #(A) wptr_g2b_inst(.c(rc), .d(wptr_gray_rc), .q(wptr_rc));
gray2bin #(A) rptr_g2b_inst(.c(wc), .d(rptr_gray_wc), .q(rptr_wc));

wire [A-1:0] space_remaining_wc = rptr_wc - wptr;
wire [A-1:0] words_available_rc = wptr_rc - rptr;

assign count_wc = wptr - rptr_wc;
assign count = words_available_rc;

wire full;
d1 full_r(.c(wc), .d(|space_remaining_wc & space_remaining_wc < 4), .q(full));

assign empty = ~|words_available_rc;
assign almost_empty = empty | words_available_rc == 1;

wire q_valid;

wire rd_int = ~empty & (~q_valid | rd); // the internal read signal, used to stuff the output

r q_valid_r
(.c(rc), .rst(1'b0),
 .en(rd | rd_int),
 .d(rd_int ? 1'b1 : (rd ? 1'b0 : q_valid)), 
 .q(q_valid));

assign wptr_en = wr & ~full;
//assign rptr_en = rd & ~empty;

reg [W-1:0] mem[L-1:0];

always @(posedge wc) begin
  if (wptr_en)
    mem[wptr] <= d;
end

reg [W-1:0] q_next;
always @(posedge rc)
  q_next <= mem[rptr_next];

// whenever it's available, pop the first element into our output
assign q = q_next;

//r #(W) q_r(.c(rc), .rst(1'b0), .en(1'b1), .d(q_next), .q(q));

/*
always @(posedge rc)
  q <= mem[rptr];  // todo: add option for 1-cycle delay to help timing
*/

endmodule

/////////////////////////////////////////////////////////////////////////////

`ifdef test_ffifo

module ffifo_tb();

wire wc;
sim_clk #(100) wc_inst(.c(wc));

reg [7:0] d;
reg wr;

wire rc;
sim_clk #(39) rd_inst(.c(rc));

wire [7:0] q;
reg rd;

wire empty, almost_empty;

wire [9:0] count, count_wc;

ffifo f(.*);

task push;
  begin
    wr = 1'b1;
    d = d + 1;
    @(posedge wc);
    wr = 1'b0;
  end
endtask

task pop;
  begin
    rd = 1'b1;
    @(posedge rc);
    rd = 1'b0;
    $display("read %x", q);
  end
endtask

integer i;
initial begin
	//$display("%d", f.A);
  $dumpfile("test_ffifo.lxt");
  $dumpvars();
  d = 8'h0;
  wr = 1'b0;
  rd = 1'b0;
	#100;
  @(posedge wc);
  //#1;
  for (i = 0; i < 8; i = i + 1)
    push();
  @(posedge wc);
  @(posedge wc);
  @(posedge wc);
  @(posedge rc);
  for (i = 0; i < 6; i = i + 1)
    pop();
  @(posedge rc);
  @(posedge rc);
  @(posedge rc);
  for (i = 0; i < 2; i = i + 1)
    pop();
  @(posedge wc);
  @(posedge wc);
  @(posedge wc);
  @(posedge wc);
  for (i = 0; i < 8; i = i + 1)
    push();
  //wr = 1'b0;
  //#100;
  // keep writing to fifo while reading
  @(posedge rc);
  @(posedge rc);
  for (i = 0; i < 7; i = i + 1)
    pop();
  //rd = 1'b0;
  @(posedge wc);
  @(posedge wc);
  @(posedge wc);
  @(posedge wc);
 
	$finish();
end

endmodule

`endif
