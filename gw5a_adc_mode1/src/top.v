
//
// ADC demo for Gowin GW5A FPGA
// 1.1 
//
// There are two ways to measure external voltages using the GW5A's ADC:
/*
  1) Using alternating 'vsenctl' modes 'glo_left' and 'glo_right'; this realizes exactly two ADC inputs.
     The input signals have to be specified in the .cst file using 'USE_ADC_SRC <bus> <loc>' statements, e.g. :
  USE_ADC_SRC bus0 IOT56;  // For 'glo_left' use differential signal IOT56 on pins J8 (A) and K8 (B) of BANK0 for bus0.
  USE_ADC_SRC bus1 IOB26;  // For 'glo_right' use differential signal IOB26 on pins F2 (A) and F1 (B) of BANK5 for bus1.  

  2) Using 'vsenctl' mode 'loc_left'; this allows selection of up to five signals from BANK1 (IOT61, 63, 66, 68, 72).
     The input signals have to be specified alternating using the 'tlvds_ibuf_adc_*' arguments to the ADC IP.
*/

// ADC mode 1, two channels
// Alternating vsenctl between 'glo_left' and 'glo_right'.
`define ADC_MODE_1 1

// ADC mode 2, up to five channels
// With 'vsenctl' fixed at 'loc_left', alternating the 'tlvds_ibuf_adc_*' arguments.
//`define ADC_MODE_2 1



`define CLK_FREQ      50_000_000
`define COUNT_WIDTH   24



// The TOP module.
// ( The name of the TOP module can be specified in 'Project - Configuration - Synthesize - General';
//   otherwise the SW seems to consider the first module which is not called in another module as the TOP module! )

module top #(parameter CLK_COUNT_WIDTH = `COUNT_WIDTH) (
    input       clk,            // Input signal of the (Sipeed Tang Primer 50 MHz) CLK at pin E2.
    input  wire i_reset_n,      // Active low RESET input, linked to pin G11.
`ifdef ADC_MODE_2
    input  wire i_analog1p,     // The positive part of the differential signal going to the ADC, tied to pin J8
    input  wire i_analog1n,     // The negative part of the differential signal going to the ADC, tied to pin K8
    input  wire i_analog2p,     // The positive part of the differential signal going to the ADC, tied to pin F2
    input  wire i_analog2n,     // The negative part of the differential signal going to the ADC, tied to pin F1
    input  wire i_analog3p,     // The positive part of the differential signal going to the ADC, tied to pin F2
    input  wire i_analog3n,     // The negative part of the differential signal going to the ADC, tied to pin F1
`endif
  // The following signals are related to the two LEDs on the dock
  // In 'Project-Configuration' you have to set the 'Ready', 'Done' and 'CPU' checkboxes.
    output wire o_led_ready,    // Wired to 'adc_start'.
    output wire o_led_done      // Wired to 'adc_ready'.
  ); 


// Local signals

// wire (with potential assignment) and register definitions
  reg  [CLK_COUNT_WIDTH-1 : 0]  clk_count = 0; // Incremented with every CLK tick; reset to 0 on occaisons


// Handles clock counter increment and Reset
  always @(posedge clk  or  negedge i_reset_n) begin
    if ( !i_reset_n ) begin
      clk_count <= 0;
    end
    else begin
      clk_count <= clk_count + 1'b1;
    end
  end



/////////////////////////////////////////
// Begin of 'ADC processing'
/////////////////////////////////////////

`ifdef ADC_MODE_1
  localparam NUM_ADC_CHANNELS    = 2;
`else
  localparam NUM_ADC_CHANNELS    = 3;
`endif


// Common parts
  wire          adc_clk;
  wire          adc_start;
  wire          adc_ready;
  wire [13:0]   adc_value;
  reg   [3:0]   adc_counts;
  wire          adc_ena         = 1'b1;     // enable. Active high
  wire          adc_mode        = 1'b1;     // 0 = temperature, 1 = voltage


  reg   [2:0]   adc_channel_ind    = 3'd0;

  reg  [13:0]   adc_channels[0:NUM_ADC_CHANNELS-1];
  reg  [13:0]   adc_current_0   = 0;
  reg  [13:0]   adc_current_1   = 0;

  reg  [2:0]    vsenctl         = 3'b000;   // 000=glo_left, 001=glo_right, 010=loc_left,  (only in voltage mode)

  wire [2:0]    vsenctl_0       = 3'b000;   // Preset for 'glo_left'
  wire [2:0]    vsenctl_1       = 3'b001;   // Preset for 'glo_right'
  wire [2:0]    vsenctl_2       = 3'b010;   // Preset for 'loc_left'

  wire          mdrp_clk_m1     = adc_clk;
  wire          mdrp_a_inc_m1   = 1'b0;
  wire [7:0]    mdrp_rdata_m1;
  wire [7:0]    mdrp_wdata_m1   = 8'h00;
  wire [1:0]    mdrp_opcode_m1  = 2'b00;


  assign  adc_clk     = clk_count[5]                  & i_reset_n;
// Fast ADC trigger (to be use with the Gowin Analyzer Oscilloscope)
  assign  adc_start   = clk_count[14] & clk_count[13] & i_reset_n;
// Slow ADC trigger (to see the LEDs
//  assign  adc_start   = clk_count[23];

  assign  o_led_ready = adc_start & i_reset_n;
  assign  o_led_done  = adc_ready & i_reset_n;


// ADC mode 1 : Alternating vsenctl between 'glo_left' and 'glo_right'.
`ifdef ADC_MODE_1

  reg        adc_wtoggle;

  // Instantiate two-channel ADC using the 'glo_left' / 'glo_right'.
    Gowin_ADC adc_glomodes (
        .adcrdy(adc_ready),           // output adcrdy
        .adcvalue(adc_value),         // output [13:0] adcvalue
        .mdrp_rdata(mdrp_rdata_m1),   // output [7:0] mdrp_rdata
        .clk(adc_clk),                // input clk
        .adcen(1'b1),                 // input adcen
        .drstn(1'b1),                 // input drstn
        .adcmode(adc_mode),           // input adcmode
        .vsenctl(vsenctl),            // input [2:0] vsenctl
        .adcreqi(adc_start),          // input adcreqi
        .mdrp_clk(mdrp_clk_m1),       // input mdrp_clk
        .mdrp_wdata(mdrp_wdata_m1),   // input [7:0] mdrp_wdata
        .mdrp_a_inc(mdrp_a_inc_m1),   // input mdrp_a_inc
        .mdrp_opcode(mdrp_opcode_m1)  // input [1:0] mdrp_opcode
    );

  always @ (posedge adc_ready ) begin
    adc_counts  <= adc_counts + 4'h1;

  // Get the value of the actual channel
    adc_channels[adc_channel_ind] <= adc_value;
  // Buffer the first to channels in separate registers ('cause GAO cannot display arrays)
    if ( adc_channel_ind == 0 ) adc_current_0 <= adc_value;
    if ( adc_channel_ind == 1 ) adc_current_1 <= adc_value;

  // Switch to the next channel
    adc_channel_ind <= ( adc_channel_ind >= NUM_ADC_CHANNELS ) ? 3'd0 : adc_channel_ind + 3'd1;

    case ( adc_channel_ind )
      3'b0    : begin
                  vsenctl <= vsenctl_0;
                end
      3'b1    : begin
                  vsenctl <= vsenctl_1;
                end
    endcase

  end

`endif



// ADC mode 2 :  With 'vsenctl' fixed at 'loc_left', alternating the 'tlvds_ibuf_adc_*' arguments.
`ifdef ADC_MODE_2

  reg   tlvds_ibuf_adc_en   = 1'b1;         // Enabled (active high)
  reg   tlvds_ibuf_adc_en1  = 1'b1;         // Enabled (active high)
  reg   tlvds_ibuf_adc_en2  = 1'b0;         // Enabled (active high)
  reg   tlvds_ibuf_adc_en3  = 1'b0;         // Enabled (active high)
  wire  tlvds_ibuf_adc_i; //    = i_analog1p;   // Positive part of the diffential ADC input signal pair
  wire  tlvds_ibuf_adc_ib; //   = i_analog1n;   // Negative part of the diffential ADC input signal pair

  // Instantiate multi-channel ADC using TLVDS controlled channel selection.
    Gowin_ADC  adc_dynamic (
        .adcrdy(adc_ready),                       //output adcrdy
        .adcvalue(adc_value),                     //output [13:0] adcvalue
        .mdrp_rdata(mdrp_rdata_m1),               //output [7:0] mdrp_rdata
//        .tlvds_ibuf_adc_i(tlvds_ibuf_adc_i),      //input tlvds_ibuf_adc_i
//        .tlvds_ibuf_adc_ib(tlvds_ibuf_adc_ib),    //input tlvds_ibuf_adc_ib
//        .tlvds_ibuf_adc_adcen(tlvds_ibuf_adc_en), //input tlvds_ibuf_adc_adcen
        .vsenctl(vsenctl_2),                      //input [2:0] vsenctl
        .adcen(adc_ena),                          //input adcen
        .clk(adc_clk),                            //input clk
        .drstn(i_reset_n),                        //input drstn
        .adcreqi(adc_start),                      //input adcreqi
        .adcmode(adc_mode),                       //input adcmode
        .mdrp_clk(mdrp_clk_m1),                   //input mdrp_clk
        .mdrp_wdata(mdrp_wdata_m1),               //input [7:0] mdrp_wdata
        .mdrp_a_inc(mdrp_a_inc_m1),               //input mdrp_a_inc
        .mdrp_opcode(mdrp_opcode_m1)              //input [1:0] mdrp_opcode
    );


TLVDS_IBUF_ADC tlvds_ibuf_adc_inst1 (
    .ADCEN(tlvds_ibuf_adc_en1),
    .I(i_analog1p),
    .IB(i_analog1n)
);

TLVDS_IBUF_ADC tlvds_ibuf_adc_inst2 (
    .ADCEN(tlvds_ibuf_adc_en2),
    .I(i_analog2p),
    .IB(i_analog2n)
);

TLVDS_IBUF_ADC tlvds_ibuf_adc_inst3 (
    .ADCEN(tlvds_ibuf_adc_en3),
    .I(i_analog3p),
    .IB(i_analog3n)
);



  always @ (posedge adc_ready ) begin
    adc_counts  <= adc_counts + 4'h1;

  // Get the value of the actual channel
    adc_channels[adc_channel_ind] <= adc_value;
  // Buffer the first to channels in separate registers ('cause GAO cannot display arrays)
    if ( adc_channel_ind == 0 ) adc_current_0 <= adc_value;
    if ( adc_channel_ind == 1 ) adc_current_1 <= adc_value;

//    case (adc_channel_ind)
//      3'd0    : begin 
//                  adc_current_0 = adc_value;
//                end
//      3'd1    : begin 
//                  adc_current_1 = adc_value;
//                end
//      default : begin 
//                  adc_current_0 = adc_value;
//                end
//    endcase

  // Switch to the next channel
    adc_channel_ind <= ( adc_channel_ind >= NUM_ADC_CHANNELS ) ? 3'd0 : adc_channel_ind + 3'd1;

    case (adc_channel_ind)
      3'd0    : begin 
                  tlvds_ibuf_adc_en1  <= 1'b1;
                  tlvds_ibuf_adc_en2  <= 1'b0;
                  tlvds_ibuf_adc_en3  <= 1'b0;
                end
      3'd1    : begin 
                  tlvds_ibuf_adc_en1  <= 1'b0;
                  tlvds_ibuf_adc_en2  <= 1'b1;
                  tlvds_ibuf_adc_en3  <= 1'b0;
                end
      3'd2    : begin 
                  tlvds_ibuf_adc_en1  <= 1'b0;
                  tlvds_ibuf_adc_en2  <= 1'b0;
                  tlvds_ibuf_adc_en3  <= 1'b1;
                end
      default : begin 
                  tlvds_ibuf_adc_en1  <= 1'b1;
                  tlvds_ibuf_adc_en2  <= 1'b0;
                end
    endcase

  end // always


`endif    // ADC


//---------------------------------------
// End of 'ADC processing'
//---------------------------------------


endmodule // top


