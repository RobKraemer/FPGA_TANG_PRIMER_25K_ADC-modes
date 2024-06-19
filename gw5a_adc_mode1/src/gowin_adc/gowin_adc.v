//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.9.02
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A
//Created Time: Fri May 10 21:37:23 2024

//module Gowin_ADC (adcrdy, adcvalue, mdrp_rdata, tlvds_ibuf_adc_i, tlvds_ibuf_adc_ib, tlvds_ibuf_adc_adcen, vsenctl, adcen, clk, drstn, adcreqi, adcmode, mdrp_clk, mdrp_wdata, mdrp_a_inc, mdrp_opcode);
module Gowin_ADC (adcrdy, adcvalue, mdrp_rdata, vsenctl, adcen, clk, drstn, adcreqi, adcmode, mdrp_clk, mdrp_wdata, mdrp_a_inc, mdrp_opcode);

output adcrdy;
output [13:0] adcvalue;
output [7:0] mdrp_rdata;
//input tlvds_ibuf_adc_i;
//input tlvds_ibuf_adc_ib;
//input tlvds_ibuf_adc_adcen;
input [2:0] vsenctl;
input adcen;
input clk;
input drstn;
input adcreqi;
input adcmode;
input mdrp_clk;
input [7:0] mdrp_wdata;
input mdrp_a_inc;
input [1:0] mdrp_opcode;

//TLVDS_IBUF_ADC tlvds_ibuf_adc_inst (
//    .I(tlvds_ibuf_adc_i),
//    .IB(tlvds_ibuf_adc_ib),
//    .ADCEN(tlvds_ibuf_adc_adcen)
//);

ADC adc_inst (
    .ADCRDY(adcrdy),
    .ADCVALUE(adcvalue),
    .MDRP_RDATA(mdrp_rdata),
    .VSENCTL(vsenctl),
    .ADCEN(adcen),
    .CLK(clk),
    .DRSTN(drstn),
    .ADCREQI(adcreqi),
    .ADCMODE(adcmode),
    .MDRP_CLK(mdrp_clk),
    .MDRP_WDATA(mdrp_wdata),
    .MDRP_A_INC(mdrp_a_inc),
    .MDRP_OPCODE(mdrp_opcode)
);

defparam adc_inst.CLK_SEL = 1'b0;
defparam adc_inst.DIV_CTL = 2'd0;
defparam adc_inst.BUF_EN = 12'b010000000000;
defparam adc_inst.BUF_BK0_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK1_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK2_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK3_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK4_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK5_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK6_VREF_EN = 1'b0;
defparam adc_inst.BUF_BK7_VREF_EN = 1'b0;
defparam adc_inst.CSR_ADC_MODE = 1'b1;
defparam adc_inst.CSR_VSEN_CTRL = 3'd0;
defparam adc_inst.CSR_SAMPLE_CNT_SEL = 3'd0;
defparam adc_inst.CSR_RATE_CHANGE_CTRL = 3'd0;
defparam adc_inst.CSR_FSCAL = 10'd653;
defparam adc_inst.CSR_OFFSET = 12'd0;

endmodule //Gowin_ADC
