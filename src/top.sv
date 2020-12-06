module UART_top #(parameter clk_freq_Hz = 1000000)
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

//debouncer + one shot for start button in
logic button_debounced, one_shot_out;

debouncer #(clk_freq_Hz)
debouncer (.clk(clk),
                     .RSTn(RSTn),
                     .button_in(start),
                     .button_out(button_debounced)
);

one_shot one_shot (.clk(clk),
                   .RSTn(RSTn),
                   .sig_in(button_debounced),
                   .sig_out(one_shot_out)
);

//TX fsm
tx_fsm tx_fsm (.clk(clk),
               .RSTn(RSTn),
               .start(one_shot_out),
               .data_in(data_in),
               .TX(TX)
);

endmodule
