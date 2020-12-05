`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_d_ff_chain;

parameter numBit = 10;

logic d, q, RSTn, clk;

d_ff_chain #(numBit) DUT (.d(d), .RSTn(RSTn), .clk(clk), .q(q));

initial
begin
  RSTn = 1'b0;
  d = 1'b1;
  //clk = 1'b0;
  #40us;
  RSTn = 1'b1;
  d = 1'b1;
  #60us;
  RSTn = 1'b1;
  d = 1'b0;
end

// Clock generator
always
begin
  #5us clk = 1;
  #5us clk = 0;
end


endmodule
