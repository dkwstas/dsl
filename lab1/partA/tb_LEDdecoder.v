`timescale 1ns / 1ps

module tb_LEDdecoder;

  reg  [3:0] char;
  wire [6:0] LED;
  reg  [6:0] expected[0:15];
  integer i, errors;

  // LED = {a,b,c,d,e,f,g}, 1 = on
  localparam [6:0] A = 7'b1000000, B = 7'b0100000, C = 7'b0010000,
                   D = 7'b0001000, E = 7'b0000100, F = 7'b0000010,
                   G = 7'b0000001;

  LEDdecoder dut (
      .char(char),
      .LED (LED)
  );

  // Segment outputs
  wire ca = LED[6], cb = LED[5], cc = LED[4], cd = LED[3], ce = LED[2], cf = LED[1], cg = LED[0];

  initial begin
    expected[4'h0] = A | B | C | D | E | F;
    expected[4'h1] = B | C;
    expected[4'h2] = A | B | D | E | G;
    expected[4'h3] = A | B | C | D | G;
    expected[4'h4] = B | C | F | G;
    expected[4'h5] = A | C | D | F | G;
    expected[4'h6] = A | C | D | E | F | G;
    expected[4'h7] = A | B | C;
    expected[4'h8] = A | B | C | D | E | F | G;
    expected[4'h9] = A | B | C | D | F | G;
    expected[4'hA] = A | B | C | E | F | G;
    expected[4'hB] = C | D | E | F | G;
    expected[4'hC] = A | D | E | F;
    expected[4'hD] = B | C | D | E | G;
    expected[4'hE] = A | D | E | F | G;
    expected[4'hF] = A | E | F | G;

    $dumpfile("wave.vcd");
    $dumpvars(0, tb_LEDdecoder);
    errors = 0;

    for (i = 0; i < 16; i = i + 1) begin
      char = i;
      #10;
      if (LED !== expected[i]) begin
        errors = errors + 1;
        $display("ERROR char=%h LED=%b expected=%b", char, LED, expected[i]);
      end
    end

    if (errors == 0) $display("PASS: 16 tests passed");
    else $display("FAIL: %0d tests failed", errors);
    $finish;
  end

endmodule

