//------------------------------------------------------------------------------
// Module : message_rom
// Purpose: Read-only message memory of 16 characters (4 bits each). The
//          message is constant, so it is a combinational ROM: no flip-flops,
//          no reset and no initialisation are needed.
// Ports  : address - character index 0..15
//          char    - hexadecimal character stored at the address
// Notes  : Message = 0123456789abcdeF. Edit the CHAR_x constants to change it.
//------------------------------------------------------------------------------
module message_rom (
    input      [3:0] address,
    output reg [3:0] char
);

  localparam [3:0] CHAR_0 = 4'h0;
  localparam [3:0] CHAR_1 = 4'h1;
  localparam [3:0] CHAR_2 = 4'h2;
  localparam [3:0] CHAR_3 = 4'h3;
  localparam [3:0] CHAR_4 = 4'h4;
  localparam [3:0] CHAR_5 = 4'h5;
  localparam [3:0] CHAR_6 = 4'h6;
  localparam [3:0] CHAR_7 = 4'h7;
  localparam [3:0] CHAR_8 = 4'h8;
  localparam [3:0] CHAR_9 = 4'h9;
  localparam [3:0] CHAR_A = 4'hA;
  localparam [3:0] CHAR_B = 4'hB;
  localparam [3:0] CHAR_C = 4'hC;
  localparam [3:0] CHAR_D = 4'hD;
  localparam [3:0] CHAR_E = 4'hE;
  localparam [3:0] CHAR_F = 4'hF;

  always @(*) begin
    char = CHAR_0;  // default
    case (address)
      4'd0: begin
        char = CHAR_0;
      end
      4'd1: begin
        char = CHAR_1;
      end
      4'd2: begin
        char = CHAR_2;
      end
      4'd3: begin
        char = CHAR_3;
      end
      4'd4: begin
        char = CHAR_4;
      end
      4'd5: begin
        char = CHAR_5;
      end
      4'd6: begin
        char = CHAR_6;
      end
      4'd7: begin
        char = CHAR_7;
      end
      4'd8: begin
        char = CHAR_8;
      end
      4'd9: begin
        char = CHAR_9;
      end
      4'd10: begin
        char = CHAR_A;
      end
      4'd11: begin
        char = CHAR_B;
      end
      4'd12: begin
        char = CHAR_C;
      end
      4'd13: begin
        char = CHAR_D;
      end
      4'd14: begin
        char = CHAR_E;
      end
      4'd15: begin
        char = CHAR_F;
      end
      default: begin
        char = CHAR_0;
      end
    endcase
  end

endmodule
