module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(a, b) begin
    y = #5 a & b;
  end

endmodule