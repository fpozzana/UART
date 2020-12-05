module debouncer #(parameter stable_time_cc =  10)
(
  input logic               clk,
  input logic               RSTn,
  input logic               button_in,
  output logic              button_out
);

//two flip flop in series to monitor the changing of value for button_in
//supporting signals to the outputs
logic d_ff_out_one;
logic d_ff_out_two;

d_ff first_d_ff (.d(button_in),
                 .RSTn(RSTn),
                 .clk(clk),
                 .q(d_ff_out_one)
);

d_ff second_d_ff (.d(d_ff_out_one),
                 .RSTn(RSTn),
                 .clk(clk),
                 .q(d_ff_out_two)
);

//xor between the two d_ff outs to monitor equality/not equality
logic xor_d_ff;

assign xor_d_ff = d_ff_out_one ^ d_ff_out_two;

//state machine to model the counter that counts for stable data on button_in
parameter COUNT        = 3'b001,
          THRESHOLD    = 3'b010,
          RESET        = 3'b100;

logic[2:0] state, next_state;
logic enable_out;
logic[31:0] counter;

always_comb
begin
  case(state)
    COUNT :
    begin
      if(counter == stable_time_cc - 1)
        next_state = THRESHOLD;
      else if(xor_d_ff == 1'b1)
        next_state = RESET;
      else
        next_state = COUNT;
    end
    THRESHOLD :
    begin
      next_state = COUNT;
    end
    RESET :
    begin
      if(xor_d_ff == 1'b1)
        next_state = RESET;
      else
        next_state = COUNT;
    end
    default :
      next_state = COUNT;
    endcase
end

always_ff @(posedge clk or negedge RSTn)
begin
  if (RSTn == 1'b0)
  begin
    counter     <= 32'b0;
    enable_out  <= 1'b0;
  end
  else
  case(state)
    COUNT :
    begin
      counter     <= counter + 1'b1;
      enable_out  <= 1'b0;
    end
    THRESHOLD :
    begin
      counter     <= 32'b0;
      enable_out  <= 1'b1;
    end
    RESET :
    begin
      counter     <= 32'b0;
      enable_out  <= 1'b0;
    end
    default :
    begin
      counter     <= 32'b0;
      enable_out  <= 1'b0;
    end
  endcase
end

always_ff @(posedge clk or negedge RSTn)
begin
  if (RSTn == 1'b0)
    state <= COUNT;
  else
    state <= next_state;
end

//last d_ff with enable
d_ff_en last_d_ff (.d(d_ff_out_two),
                   .en(enable_out),
                   .RSTn(RSTn),
                   .clk(clk),
                   .q(button_out)
);

endmodule
