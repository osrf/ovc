`timescale 1ps/1ps
module sim_clk
#(parameter MHZ=1)
(output reg c);

realtime t_half_cycle;

initial begin
  t_half_cycle = 1000000 / MHZ / 2;
end

initial begin
  c = 0;
  forever begin
    #t_half_cycle c = 0;
    #t_half_cycle c = 1;
  end
end

endmodule
