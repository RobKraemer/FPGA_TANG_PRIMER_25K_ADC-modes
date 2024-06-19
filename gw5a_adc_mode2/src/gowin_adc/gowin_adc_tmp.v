//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.02
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A
//Created Time: Fri May 10 21:37:23 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_ADC your_instance_name(
        .adcrdy(adcrdy_o), //output adcrdy
        .adcvalue(adcvalue_o), //output [13:0] adcvalue
        .mdrp_rdata(mdrp_rdata_o), //output [7:0] mdrp_rdata
        .tlvds_ibuf_adc_i(tlvds_ibuf_adc_i_i), //input tlvds_ibuf_adc_i
        .tlvds_ibuf_adc_ib(tlvds_ibuf_adc_ib_i), //input tlvds_ibuf_adc_ib
        .tlvds_ibuf_adc_adcen(tlvds_ibuf_adc_adcen_i), //input tlvds_ibuf_adc_adcen
        .vsenctl(vsenctl_i), //input [2:0] vsenctl
        .adcen(adcen_i), //input adcen
        .clk(clk_i), //input clk
        .drstn(drstn_i), //input drstn
        .adcreqi(adcreqi_i), //input adcreqi
        .adcmode(adcmode_i), //input adcmode
        .mdrp_clk(mdrp_clk_i), //input mdrp_clk
        .mdrp_wdata(mdrp_wdata_i), //input [7:0] mdrp_wdata
        .mdrp_a_inc(mdrp_a_inc_i), //input mdrp_a_inc
        .mdrp_opcode(mdrp_opcode_i) //input [1:0] mdrp_opcode
    );

//--------Copy end-------------------
