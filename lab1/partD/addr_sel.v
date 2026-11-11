//------------------------------------------------------------------------------
// Module : addr_sel
// Purpose: Combinational selection of the message address of the digit that
//          is prepared in every scan state. AN3 is the leftmost digit and
//          shows message[ptr]; the next digits show the following characters.
//          The 4-bit sum wraps from 15 to 0, so the message rotates.
//          The address changes 2 steps before its anode goes active and it is
//          kept for 4 steps (the safety margin of the assignment).
// Ports  : state   - scan FSM state
//          ptr     - message pointer (address of the leftmost character)
//          address - message address to read
//------------------------------------------------------------------------------
module addr_sel (
    input      [3:0] state,
    input      [3:0] ptr,
    output reg [3:0] address
);

  always @(*) begin
    address = ptr;  // default
    case (state)
      4'b0000, 4'b1111, 4'b1110, 4'b1101: begin
        address = ptr;
      end  // AN3
      4'b1100, 4'b1011, 4'b1010, 4'b1001: begin
        address = ptr + 4'd1;
      end  // AN2
      4'b1000, 4'b0111, 4'b0110, 4'b0101: begin
        address = ptr + 4'd2;
      end  // AN1
      4'b0100, 4'b0011, 4'b0010, 4'b0001: begin
        address = ptr + 4'd3;
      end  // AN0
      default: begin
        address = ptr;
      end
    endcase
  end

endmodule
