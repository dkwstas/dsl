`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Testbench: tb_driver (Part D)
// Purpose  : Visual check of the automatic message rotation. The scan step is
//            shortened (STEP_CYCLES = 16, 3.2 us per step, 51.2 us per scan) and
//            the delay counter is 10 bits, so the message moves every 204.8 us
//            and one full rotation (16 steps) takes 3.3 ms. No automatic checks.
// Expected : 0123 -> 1234 -> 2345 -> ... -> F012 -> 0123.
// Waveform : step, ptr (inside dut), state, an, seg.
//------------------------------------------------------------------------------
module tb_driver;

  reg clk = 1'b0;
  reg reset = 1'b0;
  wire an3, an2, an1, an0;
  wire a, b, c, d, e, f, g, dp;

  FourDigitLEDdriver #(
      .STEP_CYCLES(16),
      .AUTO_N     (10)
  ) dut (
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
