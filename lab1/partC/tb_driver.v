`timescale 1ns / 1ps

module tb_driver;

  reg clk = 0;
  reg reset = 1;
  reg step_btn = 0;
  wire an3, an2, an1, an0;
  wire a, b, c, d, e, f, g, dp;

  FourDigitLEDdriver #(
      .DB_N(4)
  ) dut (
      .clk(clk),
      .reset(reset),
      .step_btn(step_btn),
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
    @(negedge an3);  // wait for mmcm lock
    #10_000;  // 0123

    // press with 3 300ns rebounces
    repeat (3) begin
      step_btn = 1;
      #300;
      step_btn = 0;
      #300;
    end
    step_btn = 1;

    #10_000;  // 1234

    // release with 3 300ns rebounces
    repeat (3) begin
      step_btn = 0;
      #300;
      step_btn = 1;
      #300;
    end
    step_btn = 0;

    #10_000;  // still 1234

    repeat (3) begin
      step_btn = 1;
      #300;
      step_btn = 0;
      #300;
    end
    step_btn = 1;

    #10_000;  // 2345

    $finish;
  end

endmodule
