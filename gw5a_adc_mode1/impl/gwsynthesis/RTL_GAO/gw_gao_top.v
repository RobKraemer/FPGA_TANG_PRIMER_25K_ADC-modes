module gw_gao(
    adc_clk,
    adc_start,
    adc_ready,
    \adc_counts[3] ,
    \adc_counts[2] ,
    \adc_counts[1] ,
    \adc_counts[0] ,
    \adc_value[13] ,
    \adc_value[12] ,
    \adc_value[11] ,
    \adc_value[10] ,
    \adc_value[9] ,
    \adc_value[8] ,
    \adc_value[7] ,
    \adc_value[6] ,
    \adc_value[5] ,
    \adc_value[4] ,
    \adc_value[3] ,
    \adc_value[2] ,
    \adc_value[1] ,
    \adc_value[0] ,
    \adc_channel_ind[2] ,
    \adc_channel_ind[1] ,
    \adc_channel_ind[0] ,
    \adc_current_0[13] ,
    \adc_current_0[12] ,
    \adc_current_0[11] ,
    \adc_current_0[10] ,
    \adc_current_0[9] ,
    \adc_current_0[8] ,
    \adc_current_0[7] ,
    \adc_current_0[6] ,
    \adc_current_0[5] ,
    \adc_current_0[4] ,
    \adc_current_0[3] ,
    \adc_current_0[2] ,
    \adc_current_0[1] ,
    \adc_current_0[0] ,
    \clk_count[5] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input adc_clk;
input adc_start;
input adc_ready;
input \adc_counts[3] ;
input \adc_counts[2] ;
input \adc_counts[1] ;
input \adc_counts[0] ;
input \adc_value[13] ;
input \adc_value[12] ;
input \adc_value[11] ;
input \adc_value[10] ;
input \adc_value[9] ;
input \adc_value[8] ;
input \adc_value[7] ;
input \adc_value[6] ;
input \adc_value[5] ;
input \adc_value[4] ;
input \adc_value[3] ;
input \adc_value[2] ;
input \adc_value[1] ;
input \adc_value[0] ;
input \adc_channel_ind[2] ;
input \adc_channel_ind[1] ;
input \adc_channel_ind[0] ;
input \adc_current_0[13] ;
input \adc_current_0[12] ;
input \adc_current_0[11] ;
input \adc_current_0[10] ;
input \adc_current_0[9] ;
input \adc_current_0[8] ;
input \adc_current_0[7] ;
input \adc_current_0[6] ;
input \adc_current_0[5] ;
input \adc_current_0[4] ;
input \adc_current_0[3] ;
input \adc_current_0[2] ;
input \adc_current_0[1] ;
input \adc_current_0[0] ;
input \clk_count[5] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire adc_clk;
wire adc_start;
wire adc_ready;
wire \adc_counts[3] ;
wire \adc_counts[2] ;
wire \adc_counts[1] ;
wire \adc_counts[0] ;
wire \adc_value[13] ;
wire \adc_value[12] ;
wire \adc_value[11] ;
wire \adc_value[10] ;
wire \adc_value[9] ;
wire \adc_value[8] ;
wire \adc_value[7] ;
wire \adc_value[6] ;
wire \adc_value[5] ;
wire \adc_value[4] ;
wire \adc_value[3] ;
wire \adc_value[2] ;
wire \adc_value[1] ;
wire \adc_value[0] ;
wire \adc_channel_ind[2] ;
wire \adc_channel_ind[1] ;
wire \adc_channel_ind[0] ;
wire \adc_current_0[13] ;
wire \adc_current_0[12] ;
wire \adc_current_0[11] ;
wire \adc_current_0[10] ;
wire \adc_current_0[9] ;
wire \adc_current_0[8] ;
wire \adc_current_0[7] ;
wire \adc_current_0[6] ;
wire \adc_current_0[5] ;
wire \adc_current_0[4] ;
wire \adc_current_0[3] ;
wire \adc_current_0[2] ;
wire \adc_current_0[1] ;
wire \adc_current_0[0] ;
wire \clk_count[5] ;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({adc_clk,adc_start,adc_ready,\adc_counts[3] ,\adc_counts[2] ,\adc_counts[1] ,\adc_counts[0] ,\adc_value[13] ,\adc_value[12] ,\adc_value[11] ,\adc_value[10] ,\adc_value[9] ,\adc_value[8] ,\adc_value[7] ,\adc_value[6] ,\adc_value[5] ,\adc_value[4] ,\adc_value[3] ,\adc_value[2] ,\adc_value[1] ,\adc_value[0] ,\adc_channel_ind[2] ,\adc_channel_ind[1] ,\adc_channel_ind[0] ,\adc_current_0[13] ,\adc_current_0[12] ,\adc_current_0[11] ,\adc_current_0[10] ,\adc_current_0[9] ,\adc_current_0[8] ,\adc_current_0[7] ,\adc_current_0[6] ,\adc_current_0[5] ,\adc_current_0[4] ,\adc_current_0[3] ,\adc_current_0[2] ,\adc_current_0[1] ,\adc_current_0[0] }),
    .clk_i(\clk_count[5] )
);

endmodule
