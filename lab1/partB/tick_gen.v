//------------------------------------------------------------------------------
// Module : tick_gen
// Purpose: Clock-enable generator. Gives a one-cycle pulse every N enabled
//          cycles of clk, so the slow display scan needs no extra clock.
// Ports  : clk   - input clock (clk_slow)
//          reset - asynchronous reset, active high
//          en    - clock enable (MMCM LOCKED)
//          tick  - one-cycle pulse, once every N enabled cycles
// Params : N - cycles between two ticks, must be >= 2
//------------------------------------------------------------------------------
module tick_gen #(
    parameter N = 500
) (
    input  clk,
    input  reset,
    input  en,
    output tick
);

  localparam W = $clog2(N);

  reg [W-1:0] cnt;

  assign tick = (cnt == N - 1);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      cnt <= {W{1'b0}};
    end else if (en) begin
      if (tick) begin
        cnt <= {W{1'b0}};
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
  end

endmodule
