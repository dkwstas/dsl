//------------------------------------------------------------------------------
// Module : FourDigitLEDdriver (Part B)
// Purpose: Top level. Scans the four 7-segment digits of the Boolean Board and
//          shows the fixed message "0123".
// Params : STEP_CYCLES - clk_slow cycles per scan step (500 -> 100 us). One
//                        scan has 16 steps (1.6 ms), inside the 1-16 ms
//                        refresh period of the seven-segment manual.
// Ports  : clk   - 100 MHz board clock
//          reset - btn[0], asynchronous, active high
//          an3..an0 - digit anodes, active-low
//          a..g, dp - segment cathodes, active-low
//------------------------------------------------------------------------------
module FourDigitLEDdriver #(
    parameter STEP_CYCLES = 500
) (
    input  clk,
    input  reset,
    output an3,
    output an2,
    output an1,
    output an0,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output dp
);

  wire       clk_fb;
  wire       clk_slow_raw;
  wire       clk_slow;
  wire       locked;
  wire       tick;
  wire       slot;
  wire [3:0] state;
  wire [3:0] digit;

  // 100 MHz -> 5 MHz: VCO = 100 MHz * 6 / 1 = 600 MHz, CLKOUT1 = 600 / 120.
  // The internal feedback is connected directly to CLKFBOUT.
  MMCME2_BASE #(
      .CLKIN1_PERIOD  (10.0),
      .DIVCLK_DIVIDE  (1),
      .CLKFBOUT_MULT_F(6.0),
      .CLKOUT1_DIVIDE (120)
  ) MMCME2_BASE_inst (
      .CLKIN1  (clk),
      .CLKFBIN (clk_fb),
      .CLKFBOUT(clk_fb),
      .CLKOUT1 (clk_slow_raw),
      .LOCKED  (locked),
      .PWRDWN  (1'b0),
      .RST     (reset)
  );

  BUFG bufg_slow (
      .I(clk_slow_raw),
      .O(clk_slow)
  );

  // LOCKED is used as clock enable of all sequential logic.
  tick_gen #(
      .N(STEP_CYCLES)
  ) tick_gen_inst (
      .clk  (clk_slow),
      .reset(reset),
      .en   (locked),
      .tick (tick)
  );

  scan_fsm scan_fsm_inst (
      .clk  (clk_slow),
      .reset(reset),
      .en   (locked),
      .tick (tick),
      .state(state),
      .slot (slot)
  );

  anode_decoder anode_decoder_inst (
      .state(state),
      .an   ({an3, an2, an1, an0})
  );

  digit_sel digit_sel_inst (
      .state(state),
      .digit(digit)
  );

  segment_driver segment_driver_inst (
      .char(digit),
      .a   (a),
      .b   (b),
      .c   (c),
      .d   (d),
      .e   (e),
      .f   (f),
      .g   (g),
      .dp  (dp)
  );

endmodule
