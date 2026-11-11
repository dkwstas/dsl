//------------------------------------------------------------------------------
// Module : LEDdecoder
// Purpose: Combinational decoder from a hexadecimal digit to the 7 segments.
// Ports  : char - input  [3:0] hexadecimal digit 0..F
//          LED  - output [6:0] segments {a,b,c,d,e,f,g}, 1 = segment on
// Notes  : The output is active-high. The cathodes of the board are
//          active-low, so the polarity is inverted in segment_driver.
//------------------------------------------------------------------------------
module LEDdecoder (
    input  [3:0] char,
    output [6:0] LED
);

  assign LED = (char == 4'h0) ? 7'b1111110 :  // 0
      (char == 4'h1) ? 7'b0110000 :  // 1
      (char == 4'h2) ? 7'b1101101 :  // 2
      (char == 4'h3) ? 7'b1111001 :  // 3
      (char == 4'h4) ? 7'b0110011 :  // 4
      (char == 4'h5) ? 7'b1011011 :  // 5
      (char == 4'h6) ? 7'b1011111 :  // 6
      (char == 4'h7) ? 7'b1110000 :  // 7
      (char == 4'h8) ? 7'b1111111 :  // 8
      (char == 4'h9) ? 7'b1111011 :  // 9
      (char == 4'hA) ? 7'b1110111 :  // A
      (char == 4'hB) ? 7'b0011111 :  // B
      (char == 4'hC) ? 7'b1001110 :  // C
      (char == 4'hD) ? 7'b0111101 :  // D
      (char == 4'hE) ? 7'b1001111 :  // E
      (char == 4'hF) ? 7'b1000111 :  // F
      7'b0000000;

endmodule
