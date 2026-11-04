`timescale 1ns / 1ps

module tb;

  reg [3:0] char;
  wire [6:0] LED;
  integer i;

  LEDdecoder dut (
      .char(char),
      .LED (LED)
  );

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);

    for (i = 0; i < 16; i = i + 1) begin
      char = i;
      #10;
      $display("char=%h LED{a..g}=%b", char, LED);
    end
    $finish;
  end

endmodule
