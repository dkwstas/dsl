//------------------------------------------------------------------------------
// Module : segment_driver
// Purpose: Drives the shared cathodes. Decodes the digit with LEDdecoder and
//          converts the active-high pattern to the active-low cathodes.
// Ports  : char - hexadecimal digit to show
//          a..g - segment cathodes, active-low
//          dp   - decimal point cathode, kept off (logic 1)
//------------------------------------------------------------------------------
module segment_driver (
    input  [3:0] char,
    output       a,
    output       b,
    output       c,
    output       d,
    output       e,
    output       f,
    output       g,
    output       dp
);

  wire [6:0] LED;

  LEDdecoder LEDdecoder_inst (
      .char(char),
      .LED (LED)
  );

  assign {a, b, c, d, e, f, g} = ~LED;
  assign dp = 1'b1;

endmodule
