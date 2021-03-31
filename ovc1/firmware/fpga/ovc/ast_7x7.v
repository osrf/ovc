`timescale 1ns/1ns
module ast_7x7
(input c,
 input [7:0] t,  // detection threshold
 input [7*7*8-1:0] d, // the window we're testing for corner-ness
 input dv, // window-valid
 output qv, // corner-found
 output [7:0] q);  // corner-score

localparam C = 16; // circumference of detection mask
wire [C*8-1:0] mask;

wire [7:0] center = d[(3*7+3)*8+:8];

assign mask[ 0*8 +:8] = d[(0*7+3)*8+:8]; // (3, 0)
assign mask[ 1*8 +:8] = d[(0*7+4)*8+:8]; // (4, 0)
assign mask[ 2*8 +:8] = d[(1*7+5)*8+:8]; // (5, 1)
assign mask[ 3*8 +:8] = d[(2*7+6)*8+:8]; // (6, 2)
assign mask[ 4*8 +:8] = d[(3*7+6)*8+:8]; // (6, 3)
assign mask[ 5*8 +:8] = d[(4*7+6)*8+:8]; // (6, 4)
assign mask[ 6*8 +:8] = d[(5*7+5)*8+:8]; // (5, 5)
assign mask[ 7*8 +:8] = d[(6*7+4)*8+:8]; // (4, 6)
assign mask[ 8*8 +:8] = d[(6*7+3)*8+:8]; // (3, 6)
assign mask[ 9*8 +:8] = d[(6*7+2)*8+:8]; // (2, 6)
assign mask[10*8 +:8] = d[(5*7+1)*8+:8]; // (1, 5)
assign mask[11*8 +:8] = d[(4*7+0)*8+:8]; // (0, 4)
assign mask[12*8 +:8] = d[(3*7+0)*8+:8]; // (0, 3)
assign mask[13*8 +:8] = d[(2*7+0)*8+:8]; // (0, 2)
assign mask[14*8 +:8] = d[(1*7+1)*8+:8]; // (1, 1)
assign mask[15*8 +:8] = d[(0*7+2)*8+:8]; // (2, 0)

// match OpenCV by using the 9-of-16 corner type
ast_mask #(.C(C), .N(9)) ast_mask_inst
(.c(c), .t(t), .dm(mask), .dc(center), .dv(dv), .q(qv), .score(q));

/*
//`define CORNER_DEBUG
`ifdef CORNER_DEBUG
integer pr, pc;
always begin
  wait(c);
  wait(~c);
  if (dv) begin
    $display("==========");
    for (pr = 0; pr < ROWS; pr = pr + 1) begin: print_rows
      for (pc = 0; pc < COLS; pc = pc + 1) begin: print_cols
        $write("%3x ", d[(pr*COLS+pc)*8 +: 8]);
      end
      $write("\n");
    end
  end
end
`endif
*/

endmodule
