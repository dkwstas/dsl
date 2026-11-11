//------------------------------------------------------------------------------
// Module : scan_fsm
// Purpose: Moore FSM that scans the four digits. It is a 16-state rotating
//          counter that decrements on every tick:
//            1111 -> 1110 -> ... -> 0000 -> 1111
//          A digit anode is active in one of every four states, and the other
//          states are the safety margin between anode and data changes.
// Ports  : clk   - input clock (clk_slow)
//          reset - asynchronous reset, active high
//          en    - clock enable (MMCM LOCKED)
//          tick  - step enable, one pulse per scan step
//          state - current FSM state
//          slot  - one-cycle pulse on the tick that leaves state 0000. It is
//                  the only moment where the displayed message may change
//                  without violating the anode/data setup margin.
//------------------------------------------------------------------------------
module scan_fsm (
    input            clk,
    input            reset,
    input            en,
    input            tick,
    output reg [3:0] state,
    output           slot
);

  localparam [3:0] S_RESET = 4'b1111;
  localparam [3:0] S_SLOT = 4'b0000;

  reg [3:0] next_state;

  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= S_RESET;
    end else if (en && tick) begin
      state <= next_state;
    end
  end

  // Next-state logic
  always @(*) begin
    next_state = state - 4'd1;
  end

  // Output logic
  assign slot = tick && (state == S_SLOT);

endmodule
