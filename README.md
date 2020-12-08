# UART
![](https://img.shields.io/badge/Development-Ongoing-green)

Implementation of a UART peripheral.

## Portmap
clk      - system clock  
RSTn     - system reset - active low  
start    - button to press to start a TX transmission  
data_in  - data input for TX transmission  
data_out - data sampled from an RX transmission  
RX       - RX pin  
TX       - TX pin  

## Parameters
debounce_period_Hz - debounce period for button start  
clk_divisor        - system clock divisor for correct baud clock  
num_bits           - number of bits for each transmission  
parity             - even or odd parity selection  
