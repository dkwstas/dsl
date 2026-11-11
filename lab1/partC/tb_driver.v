`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Testbench: tb_driver (Part C)
// Purpose  : Visual check of the message rotation with two button presses.
//            The scan step is shortened (STEP_CYCLES = 16, 3.2 us per step,
//            51.2 us per scan) and the debounce counter is 4 bits (3.2 us).
//            Each press and release has bounces of 300 ns. No automatic checks.
// Expected : 0123 -> press -> 1234 -> release -> 1234 -> press -> 2345.
// Waveform : step_btn, step, ptr (inside dut), state, an, seg.
//------------------------------------------------------------------------------
module tb_driver;

  reg clk = 1'b0;
  reg reset = 1'b0;
  reg step_btn = 1'b0;
  wire an3, an2, an1, an0;
  wire a, b, c, d, e, f, g, dp;

  FourDigitLEDdriver #(
      .STEP_CYCLES(16),
      .DB_N       (4)
  ) dut (
      .clk     (clk),
      .reset   (reset),
      .step_btn(step_btn),
      .an3     (an3),
      .an2     (an2),
      .an1     (an1),
      .an0     (an0),
      .a       (a),
      .b       (b),
      .c       (c),
      .d       (d),
      .e       (e),
      .f       (f),
      .g       (g),
      .dp      (dp)
  );

  always #5 clk = ~clk;  // 100 MHz

  wire [3:0] an = {an3, an2, an1, an0};  // active-low
  wire [6:0] seg = {a, b, c, d, e, f, g};  // active-low

  // Press and release with three bounces of 300 ns
  task press;
    begin
      repeat (3) begin
        step_btn = 1'b1;
        #300;
        step_btn = 1'b0;
        #300;
      end
      step_btn = 1'b1;
    end
  endtask

  task release_btn;
    begin
      repeat (3) begin
        step_btn = 1'b0;
        #300;
        step_btn = 1'b1;
        #300;
      end
      step_btn = 1'b0;
    end
  endtask

  initial begin
    #10 reset = 1'b1;
    #100 reset = 1'b0;
    @(negedge an3);  // wait mmcm lock
    #100_000;  // 0123

    press;
    #200_000;  // 1234
    release_btn;
    #200_000;  // still 1234
    press;
    #200_000;  // 2345

    $finish;
  end

endmodule
