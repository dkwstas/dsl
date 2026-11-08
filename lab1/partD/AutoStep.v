module AutoStep #(
    parameter N = 23
) (
    input  clk,
    input  reset,
    output step
);

  reg [N-1:0] cnt;
  always @(posedge clk or posedge reset) begin
    if (reset) cnt <= 0;
    else cnt <= cnt + 1'b1;
  end
  assign step = &cnt;

endmodule
