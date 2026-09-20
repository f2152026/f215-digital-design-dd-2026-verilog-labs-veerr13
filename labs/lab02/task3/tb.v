module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer errors;
  integer i, j;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
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

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;

        if (({t_gt, t_lt, t_eq} != 3'b100) &&
            ({t_gt, t_lt, t_eq} != 3'b010) &&
            ({t_gt, t_lt, t_eq} != 3'b001)) begin
          $display("FAIL: A=%0d B=%0d -> GT=%b LT=%b EQ=%b (not exactly one high)",
                    t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end
        else if (t_a > t_b && !t_gt) begin
          $display("FAIL: A=%0d B=%0d -> expected GT, got GT=%b LT=%b EQ=%b",
                    t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end
        else if (t_a < t_b && !t_lt) begin
          $display("FAIL: A=%0d B=%0d -> expected LT, got GT=%b LT=%b EQ=%b",
                    t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end
        else if (t_a == t_b && !t_eq) begin
          $display("FAIL: A=%0d B=%0d -> expected EQ, got GT=%b LT=%b EQ=%b",
                    t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
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
    $monitor($time, " A=%0d B=%0d | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule