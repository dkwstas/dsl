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

  wire    [3:0] an = {an3, an2, an1, an0};  // active-low
  wire    [3:0] lit = ~an;  // 1 = anode enabled
  wire    [6:0] seg = {a, b, c, d, e, f, g};  // active-low

  integer       errors = 0;
  integer       scans = 0;

  // 1) No double anodes lit at the same time
  always @(an)
    if ((lit & (lit - 4'd1)) != 4'd0) begin
      errors = errors + 1;
      $display("ERROR t=%0t: overlapping anodes an=%b", $time, an);
    end

  // 2) No segment change on lit anode
  realtime t_seg_change = 0;
  always @(seg) begin
    t_seg_change = $realtime;
    if (lit != 4'd0) begin
      errors = errors + 1;
      $display("ERROR t=%0t: segment change on lit anode", $time);
    end
  end

  // 3) Margin: stable data >= 200 ns before anode off
  reg [3:0] prev_lit = 4'd0;
  always @(lit) begin
    if (prev_lit == 4'd0 && lit != 4'd0 && ($realtime - t_seg_change) < 200.0) begin
      errors = errors + 1;
      $display("ERROR t=%0t: not enough margin", $time);
    end
    prev_lit = lit;
  end

  // 4) Correct digit for each anode (0123, left to right)
  task check_seg(input [6:0] expected);
    begin
      #100;
      if (seg !== expected) begin
        errors = errors + 1;
        $display("ERROR t=%0t: an=%b seg=%b expected=%b", $time, an, seg, expected);
      end
    end
  endtask

  always @(an) begin
    case (an)
      4'b0111: check_seg(7'b0000001);  // AN3: 0
      4'b1011: check_seg(7'b1001111);  // AN2: 1
      4'b1101: check_seg(7'b0010010);  // AN1: 2
      4'b1110: check_seg(7'b0000110);  // AN0: 3
      default: ;
    endcase
  end

  // 5) Scan period = 16 x 200 ns = 3200 ns
  realtime t_an3_fall = 0;
  always @(negedge an3) begin
    scans = scans + 1;
    if (t_an3_fall != 0 &&
        (($realtime - t_an3_fall) < 3199.0 || ($realtime - t_an3_fall) > 3201.0)) begin
      errors = errors + 1;
      $display("ERROR t=%0t: scan period %0f ns", $time, $realtime - t_an3_fall);
    end
    t_an3_fall = $realtime;
  end

  initial begin
    #100 reset = 0;
    #100000;  // 100 us (includes MMCM lock)
    if (scans < 10) begin
      errors = errors + 1;
      $display("ERROR: %0d scans (MMCM not locked)", scans);
    end
    if (errors == 0) $display("PASS: %0d scans no errors", scans);
    else $display("FAIL: %0d errors", errors);
    $finish;
  end

endmodule
