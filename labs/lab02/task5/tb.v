module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer errors;
  integer i, j, k;
  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;

    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        for (k = 0; k < 2; k = k + 1) begin
          t_a  = i[3:0];
          t_b  = j[3:0];
          t_op = k[0];
          #5;

          expected = t_op ? (t_a - t_b) : (t_a + t_b);

          if (t_result !== expected) begin
            $display("FAIL: a=%0d b=%0d op=%0d -> expected=%0d got=%0d",
                      t_a, t_b, t_op, expected, t_result);
            errors = errors + 1;
          end
        end
      end
    end

    if (errors == 0)
      $display("Simulation complete: ALL TESTS PASSED");
    else
      $display("Simulation complete: %0d TEST(S) FAILED", errors);

    $finish;
  end

  initial
    $monitor($time, " a=%0d b=%0d op=%0d | result=%0d", t_a, t_b, t_op, t_result);

endmodule