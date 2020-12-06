`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_one_shot;

logic RSTn, clk;
logic sig_in, sig_out;

one_shot DUT (.clk(clk), .RSTn(RSTn), .sig_in(sig_in), .sig_out(sig_out));

initial
begin
  RSTn = 1'b0;
  sig_in = 1'b1;
  clk = 1'b0;
  #40us;
  RSTn = 1'b1;
  sig_in = 1'b1;
  #60us;
  RSTn = 1'b1;
  sig_in = 1'b0;
  #160us;
  RSTn = 1'b1;
  sig_in = 1'b1;
  #180us;
  RSTn = 1'b1;
  sig_in = 1'b0;
  #10us;
  RSTn = 1'b1;
  sig_in = 1'b1;
  #10us;
  RSTn = 1'b1;
  sig_in = 1'b0;
  #50us;
  RSTn = 1'b1;
  sig_in = 1'b1;
  #5us;
  RSTn = 1'b1;
  sig_in = 1'b0;
end

// Clock generator
always
begin
  #5us clk = 1;
  #5us clk = 0;
end


endmodule
