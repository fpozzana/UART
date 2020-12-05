`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_debouncer;

logic RSTn, clk;
logic button_in, button_out;

debouncer #(10) DUT (.clk(clk), .RSTn(RSTn), .button_in(button_in), .button_out(button_out));

initial
begin
  RSTn = 1'b0;
  button_in = 1'b1;
  clk = 1'b0;
  #40us;
  RSTn = 1'b1;
  button_in = 1'b1;
  #60us;
  RSTn = 1'b1;
  button_in = 1'b0;
  #160us;
  RSTn = 1'b1;
  button_in = 1'b1;
end

// Clock generator
always
begin
  #5us clk = 1;
  #5us clk = 0;
end


endmodule
