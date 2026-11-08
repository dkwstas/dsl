module Debounce #(
    parameter N = 16
) (
    input clk,
    input reset,
    input step_btn,
    output reg step
);

  reg s0, s1, stable;
  reg [N-1:0] cnt;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      s0 <= 1'b0;
      s1 <= 1'b0;
      stable <= 1'b0;
      cnt <= 0;
      step <= 1'b0;
    end else begin
      s0   <= step_btn;
      s1   <= s0;
      step <= 1'b0;
      if (s1 == stable) cnt <= 0;
      else begin
        cnt <= cnt + 1'b1;
        if (&cnt) begin
          stable <= s1;
          step   <= s1;
        end
      end
    end
  end

endmodule
