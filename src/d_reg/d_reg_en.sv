module d_reg_en #(integer numBit = 16)
(
    input logic[numBit-1:0]     d,
    input logic                 en,
    input logic                 RSTn,
    input logic                 clk,
    output logic[numBit-1:0]    q
);

//d reg with active low async reset
always_ff @(posedge clk or negedge RSTn)
begin
if(!RSTn)
begin
  q <= {numBit{1'b0}};
end
else if(en == 1'b1)
begin
  q <= d;
end
end

endmodule
