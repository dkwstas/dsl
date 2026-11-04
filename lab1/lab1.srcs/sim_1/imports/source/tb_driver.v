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

  wire [3:0] low = ~{an3, an2, an1, an0};
  always @(low)
    if ((low & (low - 1)) != 0)
      $display("ERROR t=%0t: επικάλυψη ανόδων, an=%b", $time, {an3, an2, an1, an0});

  always @(an3 or an2 or an1 or an0)
    $display(
        "t=%0t state=%b digit=%h an=%b%b%b%b seg(abcdefg)=%b%b%b%b%b%b%b",
        $time,
        dut.state,
        dut.digit,
        an3,
        an2,
        an1,
        an0,
        a,
        b,
        c,
        d,
        e,
        f,
        g
    );

  initial begin
    $dumpfile("wave_driver.vcd");
    $dumpvars(0, tb_driver);
    #100 reset = 0;
    #20000 $finish;
  end

endmodule
