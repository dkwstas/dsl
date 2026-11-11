//------------------------------------------------------------------------------
// Module : anode_decoder
// Purpose: Combinational output logic of the scan FSM. Activates (logic 0)
//          one anode in states 1110, 1010, 0110 and 0010, never two together.
// Ports  : state - scan FSM state
//          an    - anodes {AN3,AN2,AN1,AN0}, active-low
//------------------------------------------------------------------------------
module anode_decoder (
    input      [3:0] state,
    output reg [3:0] an
);

  localparam [3:0] S_AN3 = 4'b1110;
  localparam [3:0] S_AN2 = 4'b1010;
  localparam [3:0] S_AN1 = 4'b0110;
  localparam [3:0] S_AN0 = 4'b0010;

  always @(*) begin
    an = 4'b1111;  // default: all digits off
    case (state)
      S_AN3: begin
        an = 4'b0111;
      end
      S_AN2: begin
        an = 4'b1011;
      end
      S_AN1: begin
        an = 4'b1101;
      end
      S_AN0: begin
        an = 4'b1110;
      end
      default: begin
        an = 4'b1111;
      end
    endcase
  end

endmodule
