module d_reg #(integer numBit = 16)
(
    input logic[numBit-1:0]     d,
    input logic                 RSTn,
    input logic                 clk,
    output logic[numBit-1:0]    q
);

//d flip flop with active low async reset
always_ff @(posedge clk or negedge RSTn)
begin
if(!RSTn)
begin
  q <= {numBit{1'b0}};
end
else
begin
  q <= d;
end
end

endmodule
