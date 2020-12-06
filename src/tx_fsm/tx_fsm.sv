module tx_fsm #(parameter divisor = 10)
(
  input logic               clk,
  input logic               RSTn,
  input logic               start,
  input logic[7:0]          data_in,
  output logic              TX
);

//sampling data_in
logic[7:0] sampled_data;

d_reg #(8) reg_data_in (.d(data_in),
                        .RSTn(RSTn),
                        .clk(clk),
                        .q(sampled_data)
);

//parameter assignment
logic[31:0] div_param, half_div_param;

assign div_param = divisor;
assign half_div_param  = {1'b0, div_param[31:1]};

//fsm for tx operation

parameter IDLE         = 3'b000,
          SYNC         = 3'b001,
          TX_BIT       = 3'b010,
          TX_STOP      = 3'b011,
          TX_START     = 3'b100;

logic[2:0] state, next_state;
logic tx_sig;
logic[31:0] baud_count;
logic[3:0] bit_count;
logic start_done;

always_comb
begin
  case(state)
    IDLE :
    begin
      if(start == 1'b1)
        next_state = SYNC;
      else
        next_state = IDLE;
    end
    SYNC :
    begin
      if(bit_count == 4'b1000)
        if(baud_count == div_param)
          next_state = TX_STOP;
        else
          next_state = SYNC;
      else if(start_done == 1'b0)
        if(baud_count == half_div_param)
          next_state = TX_START;
        else
          next_state = SYNC;
      else
        if(baud_count == div_param)
          next_state = TX_BIT;
        else
          next_state = SYNC;
    end
    TX_BIT :
    begin
      next_state = SYNC;
    end
    TX_STOP :
    begin
      next_state = IDLE;
    end
    TX_START :
    begin
      next_state = SYNC;
    end
    default :
      next_state = IDLE;
    endcase
end

always_ff @(posedge clk or negedge RSTn)
begin
  if (RSTn == 1'b0)
  begin
    tx_sig     <= 1'b1;
    baud_count <= 32'b0;
    bit_count  <= 4'b0;
    start_done <= 1'b0;
  end
  else
  case(state)
    IDLE :
    begin
      tx_sig     <= 1'b1;
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= 1'b0;
    end
    SYNC :
    begin
      tx_sig     <= tx_sig;
      baud_count <= baud_count + 32'b1;
      bit_count  <= bit_count;
      start_done <= start_done;
    end
    TX_BIT :
    begin
      tx_sig     <= sampled_data[bit_count];
      baud_count <= 32'b0;
      bit_count  <= bit_count + 4'b1;
      start_done <= start_done;
    end
    TX_STOP :
    begin
      tx_sig     <= 1'b1;
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= start_done;
    end
    TX_START :
    begin
      tx_sig     <= 1'b0;
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= 1'b1;
    end
    default :
    begin
      tx_sig     <= 1'b1;
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= 1'b0;
    end
  endcase
end

always_ff @(posedge clk or negedge RSTn)
begin
  if (RSTn == 1'b0)
    state <= IDLE;
  else
    state <= next_state;
end

assign TX = tx_sig;

endmodule
