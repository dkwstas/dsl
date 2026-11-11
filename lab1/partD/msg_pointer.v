//------------------------------------------------------------------------------
// Module : msg_pointer
// Purpose: Message pointer. A step request (button press or timer) is
//          remembered and applied at the next safe slot of the scan, so the
//          displayed message never changes while an anode is active.
// Ports  : clk   - input clock (clk_slow)
//          reset - asynchronous reset, active high
//          en    - clock enable (MMCM LOCKED)
//          step  - one-cycle step request
//          slot  - one-cycle pulse when the pointer may change (scan_fsm)
//          ptr   - address of the leftmost character, wraps from 15 to 0
// Notes  : A second request that arrives while one is still pending is merged
//          with it. The delay is at most one scan (1.6 ms), not visible.
//------------------------------------------------------------------------------
module msg_pointer (
    input            clk,
    input            reset,
    input            en,
    input            step,
    input            slot,
    output reg [3:0] ptr
);

  reg pending;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      ptr     <= 4'd0;
      pending <= 1'b0;
    end else if (en) begin
      if (slot && (pending || step)) begin
        ptr     <= ptr + 4'd1;
        pending <= 1'b0;
      end else if (step) begin
        pending <= 1'b1;
      end
    end
  end

endmodule
