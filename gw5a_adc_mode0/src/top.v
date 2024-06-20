
//
// ADC demo for Gowin GW5A FPGA
// 1.1 
//
// Measure a single external voltages using the GW5A's ADC:
// Using 'vsenctl' set to 'glo_left' and, in the .cst file, 'USE_ADC_SRC <bus> <loc>' statement to specify the signal.
// e.g.:   USE_ADC_SRC bus0 IOT56;  // For 'glo_left' use differential signal IOT56 on pins J8 (A) and K8 (B) of BANK0 for bus0.



`define CLK_FREQ      50_000_000
`define COUNT_WIDTH   24



// The TOP module.
// ( The name of the TOP module can be specified in 'Project - Configuration - Synthesize - General';
//   otherwise the SW seems to consider the first module which is not called in another module as the TOP module! )

module top #(parameter CLK_COUNT_WIDTH = `COUNT_WIDTH) (
    input       clk,            // Input signal of the (Sipeed Tang Primer 50 MHz) CLK at pin E2.
  // The following signals are related to the two LEDs on the dock
  // In 'Project-Configuration' you have to set the 'Ready', 'Done' and 'CPU' checkboxes.
    output wire o_led_ready,    // Wired to 'adc_start'.
    output wire o_led_done      // Wired to 'adc_ready'.
  ); 


// Local signals

// wire (with potential assignment) and register definitions
  reg  [CLK_COUNT_WIDTH-1 : 0]  clk_count = 0; // Incremented with every CLK tick; reset to 0 on occaisons


// Handles clock counter increment and Reset
  always @(posedge clk) begin
    clk_count <= clk_count + 1'b1;
  end



/////////////////////////////////////////
// Begin of 'ADC processing'
/////////////////////////////////////////


// Common parts
  wire          adc_clk;
  wire          adc_start;
  wire          adc_ready;
  wire [13:0]   adc_value;
  reg   [3:0]   adc_counts;
  wire          adc_ena         = 1'b1;     // enable. Active high
  wire          adc_mode        = 1'b1;     // 0 = temperature, 1 = voltage

  reg  [13:0]   adc_current     = 0;

  wire [2:0]    vsenctl_0       = 3'b000;   // Preset for 'glo_left'

  wire          mdrp_clk_m1     = adc_clk;
  wire          mdrp_a_inc_m1   = 1'b0;
  wire [7:0]    mdrp_rdata_m1;
  wire [7:0]    mdrp_wdata_m1   = 8'h00;
  wire [1:0]    mdrp_opcode_m1  = 2'b00;


  assign  adc_clk     = clk_count[5];
// Fast ADC trigger (to be used with the Gowin Analyzer Oscilloscope)
  assign  adc_start   = clk_count[14] & clk_count[13];
// Slow ADC trigger (to see the LEDs
//  assign  adc_start   = clk_count[23];

  assign  o_led_ready = adc_start;
  assign  o_led_done  = adc_ready;


  // Instantiate two-channel ADC using the 'glo_left' / 'glo_right'.
    Gowin_ADC adc_glomodes (
        .adcrdy(adc_ready),           // output adcrdy
        .adcvalue(adc_value),         // output [13:0] adcvalue
        .mdrp_rdata(mdrp_rdata_m1),   // output [7:0] mdrp_rdata
        .clk(adc_clk),                // input clk
        .adcen(1'b1),                 // input adcen
        .drstn(1'b1),                 // input drstn
        .adcmode(adc_mode),           // input adcmode
        .vsenctl(vsenctl_0),          // input [2:0] vsenctl
        .adcreqi(adc_start),          // input adcreqi
        .mdrp_clk(mdrp_clk_m1),       // input mdrp_clk
        .mdrp_wdata(mdrp_wdata_m1),   // input [7:0] mdrp_wdata
        .mdrp_a_inc(mdrp_a_inc_m1),   // input mdrp_a_inc
        .mdrp_opcode(mdrp_opcode_m1)  // input [1:0] mdrp_opcode
    );

  always @ (posedge adc_ready ) begin
    adc_counts  <= adc_counts + 4'h1;

  // Get the value of the actual channel
    adc_current <= adc_value;

  end


//---------------------------------------
// End of 'ADC processing'
//---------------------------------------


endmodule // top


