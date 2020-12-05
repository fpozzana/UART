module UART_top
(
  input logic               clk,
  input logic               RSTn,
  input logic               start,
  //data to and from the UART
  input logic[7:0]          data_in,
  output logic[7:0]         data_out,
  //UART tx and rx
  input logic               RX,
  output logic              TX
);
