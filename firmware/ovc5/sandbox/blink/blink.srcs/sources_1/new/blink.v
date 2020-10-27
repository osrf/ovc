`timescale 1ns / 1ps

module blink(
    input clk100_p,
    input clk100_n,
    output led_n);

wire clk;
IBUFDS #(
    .DIFF_TERM("FALSE"),
    .IBUF_LOW_PWR("TRUE"),
    .IOSTANDARD("DIFF_SSTL12_DCI")
    ) clk100_buf (
        .I(clk100_p),
        .IB(clk100_n),
        .O(clk)
    );

top top_inst (
    .clk(clk),
    .led(led_n),
    .rst(1'b0)
);

endmodule
