module tb;

  reg  [1:0] sel;
  wire [7:0] dout;

  lut DUT (
    .sel  (sel),
    .dout (dout)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    sel = 0;
    #5  sel = 1;
    #5  sel = 2;
    #5  sel = 3;
    #5  $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", sel, dout);

endmodule