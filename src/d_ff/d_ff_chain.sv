module d_ff_chain #(integer numBit = 16)
(
  input logic     d,
  input logic     RSTn,
  input logic     clk,
  output logic    q
);

//support signal
logic[numBit:0] support;

//loop to instantiate a chain of d flip flops
genvar i;

generate
for(i = 0; i < numBit; i = i + 1)
begin
  d_ff d_ff_i (.d(support[i]), .RSTn(RSTn), .clk(clk), .q(support[i+1]));
end
endgenerate

//final assignment
assign support[0] = d;
assign q = support[numBit];

endmodule
