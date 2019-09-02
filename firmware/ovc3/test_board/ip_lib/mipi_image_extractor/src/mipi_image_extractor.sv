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
    input[31:0] corner_data,
    input corner_data_valid,
    output reg mipi_read_enable = 0,
    output reg row_done = 0,
    output reg frame_done = 0,
    output reg new_frame = 0,
    output reg[7:0] pixel_data = 8'b0,
    output reg pixel_data_valid = 0,
    output [7:0] line_data,
    output reg line_valid = 0,
    output reg frame_valid = 0,
    output sending_corners
    );

// REMEMBER, SHIFT RIGHT
localparam frame_start = 32'h0001001A;
localparam frame_end = 32'h0101001D;
localparam row_start = 32'h2C000513;

parameter ROW_NUM = 800; // 800 rows, 2 for data and 2 for statistics
parameter COL_NUM = 1280; // 1280 columns
parameter CORNER_DETECTION_LATENCY = 20;
parameter CORNER_LINES = 4; // How many lines after the image are reserved for corner features
localparam COL_DIV_4 = COL_NUM / 4;
reg[9:0] row_count = 10'b0;
reg[10:0] pixel_count = 11'b0;
reg[2:0] corner_line_count = 3'b0;

enum reg[2:0] {WAIT_FRAME_START=0, WAITING_FOR_ROW_HEADER=1, RX_PIXEL=2, SEND_CORNER_COUNT=3, SEND_CORNERS=4} state = WAIT_FRAME_START;
reg[31:0] rx_buf = 32'b0;
reg[2:0] rx_buf_count = 3'b0;

// Duplicated logic for keeping track of the line burst
reg buffer_rd_en = 1'b0;
reg[10:0] line_pixel_count = 11'b0;
reg frame_valid_signal = 1'b0;

line_fifo line_buffer (
  .clk(clk),                  // input wire clk
  .srst(),                // Reset
  .din(pixel_data),                  // input wire [7 : 0] din
  .wr_en(pixel_data_valid & frame_valid_signal),              // input wire wr_en
  .rd_en(buffer_rd_en),              // input wire rd_en
  .dout(line_data),                // output wire [7 : 0] dout
  .full(),                // Should never happen
  .empty(),              // Don't care
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

reg corner_rd_en = 1'b0;
reg[7:0] corner_data_internal;
reg[31:0] corner_data_reg = 32'b0;
reg[2:0] corner_data_counter = 3'b0; // We need 4 clock cycles to shift out a 32 bit variable
reg corner_fifo_valid;

assign sending_corners = (state == SEND_CORNERS);

reg[31:0] corner_count = 31'b0;
reg[5:0] corner_detection_delay = 6'b0;

corner_fifo corner_buffer (
  .clk(clk),                  // input wire clk
  .srst(0),                // input wire srst
  .din(corner_data),                  // input wire [31 : 0] din
  .wr_en(corner_data_valid),              // input wire wr_en
  .rd_en(corner_rd_en),              // input wire rd_en
  .dout(corner_data_internal),                // output wire [31 : 0] dout
  .full(),                // output wire full
  .empty(),              // output wire empty
  .valid(corner_fifo_valid),              // output wire valid
  .wr_rst_busy(),  // output wire wr_rst_busy
  .rd_rst_busy()  // output wire rd_rst_busy
);

enum reg[1:0] {IDLE=0, BUFFERING_LINE=1, SENDING_LINE=2, WAIT_FOR_IDLE=3} linebuf_state = IDLE;
reg[5:0] idle_counter = 6'b0;
localparam FRAME_VALID_DELAY = 30;

always @(posedge clk) begin
    case (linebuf_state)
        IDLE: begin
            frame_valid <= 1'b0;
            idle_counter <= 6'b0;
            if (frame_valid_signal == 1'b1) begin
                linebuf_state <= BUFFERING_LINE;
            end
        end
        BUFFERING_LINE: begin
            frame_valid <= 1'b1;
            if (row_done == 1'b1) begin
                line_pixel_count <= 11'b0;
                linebuf_state <= SENDING_LINE;
            end
        end
        SENDING_LINE: begin
            // Latency of one from rd_en assertion, data is now valid
            if (line_pixel_count == COL_NUM) begin
                line_valid <= 1'b0;
                if (frame_valid_signal == 1'b1) begin
                    linebuf_state <= BUFFERING_LINE;
                end else begin
                    linebuf_state <= WAIT_FOR_IDLE;
                end
                buffer_rd_en <= 1'b0;
            end else begin
                line_valid <= 1'b1;
                buffer_rd_en <= 1'b1;
            end
            line_pixel_count <= line_pixel_count + 1'b1;
        end
        WAIT_FOR_IDLE: begin
            idle_counter <= idle_counter + 1;
            if (idle_counter == FRAME_VALID_DELAY) begin
                linebuf_state <= IDLE;
            end
        end
        default: linebuf_state <= IDLE;
    endcase
end


always @(posedge clk) begin
    if (state == WAIT_FRAME_START) begin
        corner_count <= 32'b0;
    end else begin
        if (corner_data_valid == 1'b1) begin
            corner_count <= corner_count + 1;
        end
    end
end

always @(posedge clk) begin
    case (state)
        WAIT_FRAME_START: begin
            corner_detection_delay <= 6'b0;
            corner_line_count  <= 3'b0;
            corner_rd_en <= 1'b0;
            pixel_data <= 8'b0;
            mipi_read_enable <= 1'b1;
            frame_done <= 1'b0;
            row_count <= 10'b0;
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
            pixel_data <= 8'b0;
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
                        frame_valid_signal <= 1'b1;
                    end
                end else begin
                    rx_buf_count <= rx_buf_count + 3'b1;
                end
            end
            
        end
        RX_PIXEL: begin
            pixel_data <= mipi_data;
            pixel_data_valid <= (mipi_data_valid & (pixel_count != COL_NUM-1));
            mipi_read_enable <= dma_ready;
            if (mipi_data_valid == 1'b1) begin
                pixel_count <= pixel_count + 11'b1;
                if (pixel_count == COL_NUM-2) begin
                    // Last transaction
                    row_done <= 1'b1;
                end else if (pixel_count == COL_NUM-1) begin
                    if (row_count == ROW_NUM) begin
                        state <= SEND_CORNER_COUNT;
                        frame_valid_signal <= 1'b0;
//                        state <= WAIT_FRAME_START;
//                        frame_done <= 1'b1;
                    end else begin
                        state <= WAITING_FOR_ROW_HEADER;
                    end
                    pixel_count <= 11'b0;
                    row_done <= 1'b0;
                end
            end
        end
        SEND_CORNER_COUNT : begin
            // Wait a bit to be sure we took into account the latency of the corner module
            if (corner_detection_delay == CORNER_DETECTION_LATENCY-1) begin
                corner_detection_delay <= corner_detection_delay + 6'b1;
                corner_data_reg <= corner_count;
            end else if (corner_detection_delay == CORNER_DETECTION_LATENCY) begin
                pixel_data_valid <= 1'b1;
                pixel_count <= pixel_count + 1;
                if (pixel_count == 4) begin
                    pixel_data <= corner_data_internal;
                    
                    state <= SEND_CORNERS;
                    corner_data_reg <= corner_data_internal;
                end else begin
                    pixel_data <= corner_data_reg[7:0];
                    corner_data_reg[23:0] <= corner_data_reg[31:8];
                    
                end
            end else begin
                corner_detection_delay <= corner_detection_delay + 6'b1;
            end
            if (pixel_count >= 3) begin
                corner_rd_en <= 1'b1;
            end else begin
                corner_rd_en <= 1'b0;
            end
        end
        SEND_CORNERS: begin
            // Even if no corners are available we need to fill a line with dummy data
            pixel_data <= corner_data_internal;
            corner_rd_en <= 1'b1;            
            pixel_data_valid <= 1'b1;
            pixel_count <= pixel_count + 1;
            // Tlast logic
            if (pixel_count == COL_NUM-1) begin
                row_done <= 1'b1;
                corner_rd_en <= 1'b0;
            end else if (pixel_count == COL_NUM) begin
                pixel_count <= 11'b0;
                row_done <= 1'b0;
                corner_rd_en <= 1'b0;
                pixel_data_valid <= 1'b0;
                if (corner_line_count  == CORNER_LINES-1) begin
                    frame_done <= 1'b1;
                    state <= WAIT_FRAME_START;
                end else begin
                    corner_rd_en <= 1'b1; 
                    corner_line_count <= corner_line_count + 3'b1;
                end
            end
        end
        default: state <= WAIT_FRAME_START;
    endcase  
            
end

endmodule