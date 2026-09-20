// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder: every carry is computed
// directly (two-level, no rippling), exactly like cla4.v, just scaled to
// 64 bits. Add delays throughout (same convention as cla4.v) so it can be
// fairly compared against rca64.v and cla64_blocked.v.

`timescale 1ns/1ps
 
module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);
 
  wire [63:0] p, g;
  wire [64:1] c;
 
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate
 
  // c[k] = g[k-1] | (p[k-1]&g[k-2]) | (p[k-1]&p[k-2]&g[k-3]) | ...
  //        | (p[k-1]&...&p[1]&g[0]) | (p[k-1]&...&p[0]&cin)
  // computed with a runtime loop instead of writing all 64 equations out by hand
  function automatic carry_bit;
    input integer   k;
    input [63:0]    pp, gg;
    input           cn;
    integer j, m;
    reg     term;
    begin
      term = cn;
      for (m = 0; m <= k-1; m = m + 1)
        term = term & pp[m];
      carry_bit = term;
      for (j = k-1; j >= 0; j = j - 1) begin
        term = gg[j];
        for (m = k-1; m > j; m = m - 1)
          term = term & pp[m];
        carry_bit = carry_bit | term;
      end
    end
  endfunction
 
  generate
    for (i = 1; i <= 64; i = i + 1) begin : gen_c
      assign #(2) c[i] = carry_bit(i, p, g, cin);
    end
  endgenerate
 
  assign cout = c[64];
  assign #(2) sum = p ^ {c[63:1], cin};
 
endmodule
