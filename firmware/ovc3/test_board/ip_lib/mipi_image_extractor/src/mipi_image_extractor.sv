`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2019 02:08:04 PM
// Design Name: 
// Module Name: mipi_image_extractor
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


module mipi_image_extractor(
    input clk,
    input[7:0] mipi_data,
    input mipi_data_valid,
    input dma_ready,
    output reg mipi_read_enable = 0,
    output reg row_done = 0,
    output reg frame_done = 0,
    output reg new_frame = 0,
    output [7:0] pixel_data,
    output reg pixel_data_valid = 0,
    output [7:0] line_data,
    output reg line_valid = 0,
    output reg frame_valid = 0
    );

// REMEMBER, SHIFT RIGHT
localparam frame_start = 32'h0001001A;
localparam frame_end = 32'h0101001D;
localparam row_start = 32'h2C000513;

assign pixel_data = mipi_data;

parameter ROW_NUM = 800; // 800 rows, 2 for data and 2 for statistics
parameter COL_NUM = 1280; // 1280 columns
reg[9:0] row_count = 10'b0;
reg[10:0] pixel_count = 11'b0;

enum reg[1:0] {WAIT_FRAME_START=0, WAITING_FOR_ROW_HEADER=1, RX_PIXEL=2} state = WAIT_FRAME_START;
reg[31:0] rx_buf = 32'b0;
reg[2:0] rx_buf_count = 3'b0;

// Duplicated logic for keeping track of the line burst
reg buffer_rd_en = 1'b0;
reg[10:0] line_pixel_count = 11'b0;

line_fifo line_buffer (
  .clk(clk),                  // input wire clk
  .srst(),                // Reset
  .din(pixel_data),                  // input wire [7 : 0] din
  .wr_en(pixel_data_valid),              // input wire wr_en
  .rd_en(buffer_rd_en),              // input wire rd_en
  .dout(line_data),                // output wire [7 : 0] dout
  .full(),                // Should never happen
  .empty(),              // Don't care
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

enum reg {BUFFERING_LINE=0, SENDING_LINE=1} linebuf_state = BUFFERING_LINE;

always @(posedge clk) begin
    case (linebuf_state)
        BUFFERING_LINE: begin
            if (row_done == 1'b1) begin
                line_pixel_count <= 11'b0;
                //buffer_rd_en <= 1'b1;
                linebuf_state <= SENDING_LINE;
            end
        end
        SENDING_LINE: begin
            // Latency of one from rd_en assertion, data is now valid
            if (line_pixel_count == COL_NUM) begin
                line_valid <= 1'b0;
                linebuf_state <= BUFFERING_LINE;
                buffer_rd_en <= 1'b0;
            end else begin
                line_valid <= 1'b1;
                buffer_rd_en <= 1'b1;
            end
            line_pixel_count <= line_pixel_count + 1'b1;
        end
        default: linebuf_state <= BUFFERING_LINE;
    endcase


end

always @(posedge clk) begin
    case (state)
        WAIT_FRAME_START: begin
            mipi_read_enable <= 1'b1;
            frame_done <= 1'b0;
            row_count <= 10'b0;
            // Only reset frame_valid when we stop sending data
            if (linebuf_state != SENDING_LINE) begin
                frame_valid <= 1'b0;
            end
            // We have 4 bytes, buffer is full
            if (mipi_data_valid == 1'b1) begin
                rx_buf[31:8] <= rx_buf[23:0];
                rx_buf[7:0] <= mipi_data;
            
                if (rx_buf_count == 3'b100) begin 
                    if(rx_buf == frame_start) begin
                        // Flush buffer
                        new_frame <= 1'b1;
                        rx_buf_count <= 3'b0;
                        state <= WAITING_FOR_ROW_HEADER;
                    end
                end else begin
                    rx_buf_count <= rx_buf_count + 3'b1;
                end
            end
        end
        WAITING_FOR_ROW_HEADER: begin
            mipi_read_enable <= 1'b1;
            new_frame <= 1'b0;
            if (mipi_data_valid == 1'b1) begin
                rx_buf[31:8] <= rx_buf[23:0];
                rx_buf[7:0] <= mipi_data;
                if (rx_buf_count == 3'b100) begin
                    if (rx_buf == row_start) begin
                        // New row TODO check if it is ok not to have [31:0] array indexing
                        rx_buf_count <= 3'b0;
                        pixel_count <= 11'b0;
                        row_count <= row_count + 10'b1; // Add one row
                        state <= RX_PIXEL;
                        pixel_data_valid <= 1'b1;
                        frame_valid <= 1'b1;
                    end
                end else begin
                    rx_buf_count <= rx_buf_count + 3'b1;
                end
            end
        end
        RX_PIXEL: begin
            pixel_data_valid <= (mipi_data_valid & (pixel_count != COL_NUM-1));
            mipi_read_enable <= dma_ready;
            if (mipi_data_valid == 1'b1) begin
                pixel_count <= pixel_count + 11'b1;
                if (pixel_count == COL_NUM-2) begin
                    // Last transaction
                    row_done <= 1'b1;
                end else if (pixel_count == COL_NUM-1) begin
                    if (row_count == ROW_NUM) begin
                        state <= WAIT_FRAME_START;
                        
                        frame_done <= 1'b1;
                    end else begin
                        state <= WAITING_FOR_ROW_HEADER;
                    end
                    pixel_count <= 11'b0;
                    row_done <= 1'b0;
                end
            end
        end
        default: state <= WAIT_FRAME_START;
    endcase  
            
end

endmodule