//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.02 
//Created Time: 2024-04-26 09:18:54

// Manually modified 2024-05-05   ===> Do not SAVE in 'Timing Constraints Editor' !!!

create_clock           -name clk_50m   -period 20 -waveform {0 10} [get_ports {clk}]
//set_clock_latency -source 5 [get_clocks {clk_50m}] 

