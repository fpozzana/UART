`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_d_reg;

parameter numBit = 10;

logic RSTn, clk;
logic[numBit-1:0] d, q;

d_reg #(numBit) DUT (.d(d), .RSTn(RSTn), .clk(clk), .q(q));

initial
begin
  RSTn = 1'b0;
  d = {numBit{1'b1}};
  clk = 1'b0;
  #40us;
  RSTn = 1'b1;
  d = {numBit{1'b1}};
  #60us;
  RSTn = 1'b1;
  d = {numBit{1'b0}};
end

// Clock generator
always
begin
  #5us clk = 1;
  #5us clk = 0;
end


endmodule
