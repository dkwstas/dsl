`timescale 1ns / 1ps

module tb_driver;

  reg clk = 0;
  reg reset = 1;
  wire an3, an2, an1, an0;
  wire a, b, c, d, e, f, g, dp;

  FourDigitLEDdriver dut (
      .clk(clk),
      .reset(reset),
      .an3(an3),
      .an2(an2),
      .an1(an1),
      .an0(an0),
      .a(a),
      .b(b),
      .c(c),
      .d(d),
      .e(e),
      .f(f),
      .g(g),
      .dp(dp)
  );

  always #5 clk = ~clk;  // 100 MHz

  wire [3:0] an = {an3, an2, an1, an0};  // active-low
  wire [6:0] seg = {a, b, c, d, e, f, g};  // active-low

  initial begin
    #100 reset = 0;
    #100_000;
    $finish;
  end

endmodule
