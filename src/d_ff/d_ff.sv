module d_ff
(
    input logic     d,
    input logic     RSTn,
    input logic     clk,
    output logic    q
);

//d flip flop with active low async reset
always_ff @(posedge clk or negedge RSTn)
begin
if(!RSTn)
begin
  q <= 1'b0;
end
else
begin
  q <= d;
end
end

endmodule
