//------------------------------------------------------------------------------
// Module : debounce
// Purpose: Button synchroniser, debouncer and press detector. The pressed
//          level is accepted only after the input differs from the accepted
//          value for 2^N consecutive cycles, then a one-cycle pulse is given
//          on the press (not on the release).
// Ports  : clk   - input clock (clk_slow)
//          reset - asynchronous reset, active high
//          en    - clock enable (MMCM LOCKED)
//          btn   - asynchronous button input
//          step  - one-cycle pulse for every accepted press
// Params : N - counter width. At 5 MHz, N = 16 gives 13.1 ms (typical bounce
//              time is 10-20 ms).
//------------------------------------------------------------------------------
module debounce #(
    parameter N = 16
) (
    input      clk,
    input      reset,
    input      en,
    input      btn,
    output reg step
);

  reg         sync1;
  reg         sync2;
  reg         stable;
  reg [N-1:0] cnt;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      sync1  <= 1'b0;
      sync2  <= 1'b0;
      stable <= 1'b0;
      cnt    <= {N{1'b0}};
      step   <= 1'b0;
    end else if (en) begin
      sync1 <= btn;  // 2-flip-flop synchroniser
      sync2 <= sync1;
      step  <= 1'b0;
      if (sync2 == stable) begin
        cnt <= {N{1'b0}};  // no change, or bounce: restart the count
      end else begin
        cnt <= cnt + 1'b1;  // input differs from the accepted value
        if (&cnt) begin  // stable long enough
          stable <= sync2;
          step   <= sync2;  // pulse only on a press
        end
      end
    end
  end

endmodule
