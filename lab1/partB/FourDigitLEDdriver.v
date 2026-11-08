module FourDigitLEDdriver (
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

  wire clk_fb, clk_slow_raw, clk_slow, locked;

  MMCME2_BASE #(
      .CLKIN1_PERIOD  (10.0),
      .CLKFBOUT_MULT_F(6.0),
      .CLKOUT1_DIVIDE (120)
  ) MMCME2_BASE_inst (
      .CLKIN1  (clk),
      .CLKFBOUT(clk_fb),
      .CLKFBIN (clk_fb),
      .CLKOUT1 (clk_slow_raw),
      .LOCKED  (locked),
      .PWRDWN  (1'b0),
      .RST     (reset)
  );

  BUFG bufg_slow (
      .I(clk_slow_raw),
      .O(clk_slow)
  );

  wire rst_int = reset | ~locked;

  reg [3:0] state;
  always @(posedge clk_slow or posedge rst_int) begin
    if (rst_int) state <= 4'b1111;
    else state <= state - 1;  // one step per 200 ns
  end

  reg [3:0] an;
  always @(*) begin
    case (state)
      4'b1110: an = 4'b0111;
      4'b1010: an = 4'b1011;
      4'b0110: an = 4'b1101;
      4'b0010: an = 4'b1110;
      default: an = 4'b1111;
    endcase
  end

  reg [3:0] digit;
  always @(*) begin
    case (state)
      4'b0000, 4'b1111, 4'b1110, 4'b1101: digit = 4'h0;
      4'b1100, 4'b1011, 4'b1010, 4'b1001: digit = 4'h1;
      4'b1000, 4'b0111, 4'b0110, 4'b0101: digit = 4'h2;
      4'b0100, 4'b0011, 4'b0010, 4'b0001: digit = 4'h3;
      default:                            digit = 4'h0;
    endcase
  end

  wire [6:0] LED;
  LEDdecoder LEDdecoder_inst (
      .char(digit),
      .LED (LED)
  );

  assign {an3, an2, an1, an0} = an;
  assign {a, b, c, d, e, f, g} = ~LED;
  assign dp = 1'b1;

endmodule
