`timescale 1ns / 1ns
module crc32
(input c,  // clock
 input r,  // reset
 input dv, // data-valid
 input [7:0] d, // data
 output [31:0] crc);

// buffer everything here to help it make timing.
wire dv_d1;
r #(1) dv_d1_r(.c(c), .d(dv), .rst(1'b0), .en(1'b1), .q(dv_d1));

wire [7:0] A; // latched input data
r #(8) din_r(.c(c), .d(d), .rst(1'b0), .en(1'b1), .q(A));

wire [31:0] crc_int;
wire [31:0] new_crc;
wire crc_reg_en = dv_d1;
r #(32, 32'h1e6a_2c48) crc_reg(.c(c), .rst(r), .en(crc_reg_en), 
                               .d(new_crc), .q(crc_int));

// flip the bits and bytes around 
genvar i, j;
generate
  for (j = 0; j < 4; j = j + 1) begin: bytes
    for (i = 0; i < 8; i = i + 1) begin: bits
      assign crc[j*8+i] = ~crc_int[(4-j)*8-1-i];
    end
  end
endgenerate

// hooray for CRC auto-generators.
wire [31:0] C = crc_int;
assign new_crc[0]  = C[24]^C[30]^A[1]^A[7];
assign new_crc[1]  = C[25]^C[31]^A[0]^A[6]^C[24]^C[30]^A[1]^A[7];
assign new_crc[2]  = C[26]^A[5]^C[25]^C[31]^A[0]^A[6]^C[24]^C[30]^A[1]^A[7];
assign new_crc[3]  = C[27]^A[4]^C[26]^A[5]^C[25]^C[31]^A[0]^A[6];
assign new_crc[4]  = C[28]^A[3]^C[27]^A[4]^C[26]^A[5]^C[24]^C[30]^A[1]^A[7];
assign new_crc[5]  = C[29]^A[2]^C[28]^A[3]^C[27]^A[4]^C[25]^C[31]^A[0]^A[6]^C[24]^C[30]^A[1]^A[7];
assign new_crc[6]  = C[30]^A[1]^C[29]^A[2]^C[28]^A[3]^C[26]^A[5]^C[25]^C[31]^A[0]^A[6];
assign new_crc[7]  = C[31]^A[0]^C[29]^A[2]^C[27]^A[4]^C[26]^A[5]^C[24]^A[7];
assign new_crc[8]  = C[0]^C[28]^A[3]^C[27]^A[4]^C[25]^A[6]^C[24]^A[7];
assign new_crc[9]  = C[1]^C[29]^A[2]^C[28]^A[3]^C[26]^A[5]^C[25]^A[6];
assign new_crc[10] = C[2]^C[29]^A[2]^C[27]^A[4]^C[26]^A[5]^C[24]^A[7];
assign new_crc[11] = C[3]^C[28]^A[3]^C[27]^A[4]^C[25]^A[6]^C[24]^A[7];
assign new_crc[12] = C[4]^C[29]^A[2]^C[28]^A[3]^C[26]^A[5]^C[25]^A[6]^C[24]^C[30]^A[1]^A[7];
assign new_crc[13] = C[5]^C[30]^A[1]^C[29]^A[2]^C[27]^A[4]^C[26]^A[5]^C[25]^C[31]^A[0]^A[6];
assign new_crc[14] = C[6]^C[31]^A[0]^C[30]^A[1]^C[28]^A[3]^C[27]^A[4]^C[26]^A[5];
assign new_crc[15] = C[7]^C[31]^A[0]^C[29]^A[2]^C[28]^A[3]^C[27]^A[4];
assign new_crc[16] = C[8]^C[29]^A[2]^C[28]^A[3]^C[24]^A[7];
assign new_crc[17] = C[9]^C[30]^A[1]^C[29]^A[2]^C[25]^A[6];
assign new_crc[18] = C[10]^C[31]^A[0]^C[30]^A[1]^C[26]^A[5];
assign new_crc[19] = C[11]^C[31]^A[0]^C[27]^A[4];
assign new_crc[20] = C[12]^C[28]^A[3];
assign new_crc[21] = C[13]^C[29]^A[2];
assign new_crc[22] = C[14]^C[24]^A[7];
assign new_crc[23] = C[15]^C[25]^A[6]^C[24]^C[30]^A[1]^A[7];
assign new_crc[24] = C[16]^C[26]^A[5]^C[25]^C[31]^A[0]^A[6];
assign new_crc[25] = C[17]^C[27]^A[4]^C[26]^A[5];
assign new_crc[26] = C[18]^C[28]^A[3]^C[27]^A[4]^C[24]^C[30]^A[1]^A[7];
assign new_crc[27] = C[19]^C[29]^A[2]^C[28]^A[3]^C[25]^C[31]^A[0]^A[6];
assign new_crc[28] = C[20]^C[30]^A[1]^C[29]^A[2]^C[26]^A[5];
assign new_crc[29] = C[21]^C[31]^A[0]^C[30]^A[1]^C[27]^A[4];
assign new_crc[30] = C[22]^C[31]^A[0]^C[28]^A[3];
assign new_crc[31] = C[23]^C[29]^A[2];

endmodule

