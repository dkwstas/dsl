`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Testbench: tb_driver (Part B)
// Purpose  : Visual check of the four-digit scan with the real timing
//            (100 us per step, 1.6 ms per scan). No automatic checks.
// Waveform : clk_slow, locked, state, digit (inside dut), an, seg.
//------------------------------------------------------------------------------
module tb_driver;

  reg clk = 1'b0;
  reg reset = 1'b0;
  wire an3, an2, an1, an0;
  wire a, b, c, d, e, f, g, dp;

  FourDigitLEDdriver dut (
      .clk  (clk),
      .reset(reset),
      .an3  (an3),
      .an2  (an2),
      .an1  (an1),
      .an0  (an0),
      .a    (a),
      .b    (b),
      .c    (c),
      .d    (d),
      .e    (e),
      .f    (f),
      .g    (g),
      .dp   (dp)
  );

  always #5 clk = ~clk;  // 100 MHz

  wire [3:0] an = {an3, an2, an1, an0};  // active-low
  wire [6:0] seg = {a, b, c, d, e, f, g};  // active-low

  initial begin
    #10 reset = 1'b1;
    #100 reset = 1'b0;
    #4_000_000;
    $finish;
  end

endmodule
