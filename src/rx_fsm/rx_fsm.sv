//tx_num_bits -> number to be transmitted for each UART trannsmission (usually between 5 and 8)
//parity -> 0 is even parity, 1 is odd parity

module rx_fsm #(parameter divisor = 10,
                parameter rx_num_bits = 8,
                parameter parity = 0)
(
  input logic               clk,
  input logic               RSTn,
  output logic[7:0]         data_out,
  input logic               RX
);

//sampling RX input
logic sampled_RX;

always_ff @(posedge clk or negedge RSTn)
begin
  if (RSTn == 1'b0)
    sampled_RX <= 1'b1;
  else
    sampled_RX <= RX;
end

//parameter assignment
logic[31:0] div_param, half_div_param;
logic[3:0] num_bits;
logic parity_bit;
logic[rx_num_bits-1:0] rx_data;

assign div_param = divisor;
assign half_div_param  = {1'b0, div_param[31:1]};
assign num_bits = rx_num_bits;
//assign rx_data = sampled_data[rx_num_bits-1:0];

if(parity == 0)
  assign parity_bit = ^rx_data;
else
  assign parity_bit = ~(^rx_data);

//fsm for tx operation

parameter IDLE         = 3'b000,
          SYNC         = 3'b001,
          RX_BIT       = 3'b010,
          RX_STOP      = 3'b011,
          RX_START     = 3'b100,
          RX_PARITY    = 3'b101;

logic[2:0] state, next_state;
logic rx_sig;
logic[31:0] baud_count;
logic[3:0] bit_count;
logic start_done;
logic parity_rx_bit;

logic frame_error;
logic parity_error;

always_comb
begin
  case(state)
    IDLE :
    begin
      if(sampled_RX == 1'b1)
        next_state = IDLE;
      else
        next_state = SYNC;
    end
    SYNC :
    begin
      if(bit_count == num_bits)
        if(baud_count == div_param - 32'b1)
          next_state = RX_PARITY;
        else
          next_state = SYNC;
      else if(bit_count == num_bits + 1)
        if(baud_count == div_param - 32'b1)
          next_state = RX_STOP;
        else
          next_state = SYNC;
      else if(start_done == 1'b0)
        if(baud_count == half_div_param - 32'b1)
          next_state = RX_START;
        else
          next_state = SYNC;
      else
        if(baud_count == div_param - 32'b1)
          next_state = RX_BIT;
        else
          next_state = SYNC;
    end
    RX_BIT :
    begin
      next_state = SYNC;
    end
    RX_STOP :
    begin
      next_state = IDLE;
    end
    RX_START :
    begin
      next_state = SYNC;
    end
    RX_PARITY :
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
    baud_count <= 32'b0;
    bit_count  <= 4'b0;
    start_done <= 1'b0;
    rx_data    <= 8'b0;
  end
  else
  case(state)
    IDLE :
    begin
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= 1'b0;
    end
    SYNC :
    begin
      baud_count <= baud_count + 32'b1;
      bit_count  <= bit_count;
      start_done <= start_done;
    end
    RX_BIT :
    begin
      rx_data[bit_count] <= sampled_RX;
      baud_count <= 32'b0;
      bit_count  <= bit_count + 4'b1;
      start_done <= start_done;
    end
    RX_STOP :
    begin
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= start_done;
    end
    RX_START :
    begin
      baud_count <= 32'b0;
      bit_count  <= 4'b0;
      start_done <= 1'b1;
    end
    RX_PARITY :
    begin
      parity_rx_bit <= sampled_RX;
      baud_count <= 32'b0;
      bit_count  <= bit_count + 4'b1;
      start_done <= start_done;
    end
    default :
    begin
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

assign data_out = rx_data;

endmodule
