//------------------------------------------------------------------------------
// Module : autostep
// Purpose: Fixed delay between two message steps. A free-running counter
//          gives a one-cycle step request every 2^N cycles.
// Ports  : clk   - input clock (clk_slow)
//          reset - asynchronous reset, active high
//          en    - clock enable (MMCM LOCKED)
//          step  - one-cycle step request when the counter is full
// Params : N - counter width. At 5 MHz, N = 23 gives 2^23 * 200 ns = 1.68 s.
//------------------------------------------------------------------------------
module autostep #(
    parameter N = 23
) (
    input  clk,
    input  reset,
    input  en,
    output step
);

  reg [N-1:0] cnt;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      cnt <= {N{1'b0}};
    end else if (en) begin
      cnt <= cnt + 1'b1;
    end
  end

  assign step = &cnt;

endmodule
