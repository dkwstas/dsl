//------------------------------------------------------------------------------
// Module : digit_sel
// Purpose: Selects the digit to decode in every scan state. The digit of an
//          anode is selected 2 steps before its anode goes active, and it is
//          kept for 4 steps (the safety margin of the assignment).
//          Part B shows the fixed message "0123" (AN3 = leftmost digit).
// Ports  : state - scan FSM state
//          digit - hexadecimal digit to display
//------------------------------------------------------------------------------
module digit_sel (
    input      [3:0] state,
    output reg [3:0] digit
);

  always @(*) begin
    digit = 4'd0;  // default
    case (state)
      4'b0000, 4'b1111, 4'b1110, 4'b1101: begin
        digit = 4'd0;
      end  // AN3
      4'b1100, 4'b1011, 4'b1010, 4'b1001: begin
        digit = 4'd1;
      end  // AN2
      4'b1000, 4'b0111, 4'b0110, 4'b0101: begin
        digit = 4'd2;
      end  // AN1
      4'b0100, 4'b0011, 4'b0010, 4'b0001: begin
        digit = 4'd3;
      end  // AN0
      default: begin
        digit = 4'd0;
      end
    endcase
  end

endmodule
