`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_rx_fsm;

logic RSTn, clk;
logic start, TX;
logic[7:0] data_in;
logic[7:0] data_out;

tx_fsm #(10, 5, 1) DUT_TX (.clk(clk), .RSTn(RSTn), .start(start), .TX(TX), .data_in(data_in));
rx_fsm #(10, 5, 1) DUT_RX (.clk(clk), .RSTn(RSTn), .RX(TX), .data_out(data_out));

initial
begin
  RSTn = 1'b0;
  start = 1'b0;
  clk = 1'b0;
  data_in = 8'b01001010;
  #40us;
  RSTn = 1'b1;
  start = 1'b1;
  data_in = 8'b01001010;
  #10us;
  RSTn = 1'b1;
  start = 1'b0;
  data_in = 8'b01001010;
end

// Clock generator
always
begin
  #5us clk = 1;
  #5us clk = 0;
end


endmodule
