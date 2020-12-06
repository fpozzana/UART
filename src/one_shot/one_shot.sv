//transform an input pulse (longer than one clock cycle) into a pulse one clock cycle long

module one_shot
(
  input logic               clk,
  input logic               RSTn,
  input logic               sig_in,
  output logic              sig_out
);

//three d_ff in series and an AND gate between the out of the second d_ff and the inverted out of the third d_ff
logic first_out, second_out, third_out, inverted_third;

d_ff first_d_ff (.d(sig_in),
                 .RSTn(RSTn),
                 .clk(clk),
                 .q(first_out)
);

d_ff second_d_ff (.d(first_out),
                 .RSTn(RSTn),
                 .clk(clk),
                 .q(second_out)
);

d_ff third_d_ff (.d(second_out),
                 .RSTn(RSTn),
                 .clk(clk),
                 .q(third_out)
);

assign inverted_third = ~third_out;

assign sig_out = inverted_third & second_out;

endmodule
