module d_ff_en
(
    input logic          d,
    input logic          en,
    input logic          RSTn,
    input logic          clk,
    output logic         q
);

//d flip flop with active low async reset
always_ff @(posedge clk or negedge RSTn)
begin
if(!RSTn)
begin
  q <= 1'b0;
end
else if(en == 1'b1)
begin
  q <= d;
end
end

endmodule
