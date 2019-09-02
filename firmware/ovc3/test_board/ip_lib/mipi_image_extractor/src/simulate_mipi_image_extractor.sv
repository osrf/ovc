`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2019 02:59:52 PM
// Design Name: 
// Module Name: simulate_mipi_image_extractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simulate_mipi_image_extractor();

reg clk = 0;
reg[7:0] mipi_data = 8'b0;
reg mipi_data_valid = 0;
reg dma_ready = 1'b1;
reg mipi_read_enable = 1'b1;
reg[31:0] corner_data = 32'h12345678;
reg corner_data_valid = 1'b0;
wire row_done;
wire frame_done;
wire new_frame;
wire[7:0] pixel_data;
wire pixel_data_valid;
wire[31:0] line_data;
wire line_valid;
wire frame_valid;

mipi_image_extractor DUT(
    .clk(clk),
    .mipi_data(mipi_data),
    .mipi_data_valid(mipi_data_valid),
    .dma_ready(dma_ready),
    .corner_data(corner_data),
    .corner_data_valid(corner_data_valid),
    .mipi_read_enable(mipi_read_enable),
    .row_done(row_done),
    .frame_done(frame_done),
    .new_frame(new_frame),
    .pixel_data(pixel_data),
    .pixel_data_valid(pixel_data_valid),
    .line_data(line_data),
    .line_valid(line_valid),
    .frame_valid (frame_valid)
    );


// Clock process
initial begin
    forever #5 clk = ~clk;
end

//Reset
//initial begin
//    rst = 1;
//    #20;
//    rst = 0;
//    forever #100;
//end

// Send header first
integer ii=0;
integer pix_i=0;
initial begin
    #55;
    mipi_data_valid = 1;
    mipi_data = 8'h00;
    #10;
    mipi_data = 8'h01;
    #10;
    mipi_data = 8'h00;
    #10;
    mipi_data = 8'h1A;
    #10; // Some bogus
    mipi_data = 8'hFF;
    #100;
    // Send row header, send a bit too many
    
    for (ii=0; ii<1000; ii=ii+1)
    begin
        mipi_data_valid = 1;
        mipi_data = 8'h2C;
        #10;
        mipi_data = 8'h00;
        #10;
        mipi_data = 8'h05;
        #10;
        mipi_data = 8'h13;
        #10;
        // it takes 10 * 1280 time to get the whole row
        // Wait a bit before making DMA read
        //dma_ready = 0;
        //mipi_data_valid = 0;
        //# 100;
        for (pix_i=0; pix_i<1290; pix_i=pix_i+1) begin
            mipi_data = pix_i;
            #10;
        end
        //dma_ready = 1;
        //mipi_data_valid = 1;
        mipi_data_valid = 0;
        #500;
    end
    // New frame start
    mipi_data = 8'h00;
    #10;
    mipi_data = 8'h01;
    #10;
    mipi_data = 8'h00;
    #10;
    mipi_data = 8'h1A;
    forever #10;
end

integer jj=0;
initial begin
    #305;
//    corner_data_valid = 1'b1;
    for (jj=0; jj<31000; jj=jj+1) begin
        #10;
        corner_data = 32'h87654321;
        #10;
        corner_data = 32'h12345678;
    end
//    corner_data_valid = 1'b0;
    forever #10;
end

integer ci=0;
initial begin
    #1305;
    for (ci=0; ci<2000; ci=ci+1) begin
        corner_data_valid = 1'b1;
        #10;
        corner_data_valid = 1'b0;
        #100;
    end;
    forever #10;
end
endmodule
