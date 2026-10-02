`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for Mux_2to1 (4-bit, 2-to-1)
// Exhaustive self-checking test: all 16 x 16 x 2 = 512 combinations of A, B, S
//////////////////////////////////////////////////////////////////////////////////
module tb_Mux_2to1;

   reg  [3:0] A, B;
   reg        S;
   wire [3:0] Z;

   integer i, j, k;
   integer errors = 0;
   reg [3:0] expected;

   // Device under test
   Mux_2to1 dut ( .A(A), .B(B), .S(S), .Z(Z) );

   initial begin
      $display("---- Mux_2to1 test start ----");
      A = 0; B = 0; S = 0;
      #10;

      for (k = 0; k < 2; k = k + 1) begin
         for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
               S = k;
               A = i;
               B = j;
               #10;                       // let the output settle
               expected = (S == 0) ? A : B;
               if (Z !== expected) begin
                  errors = errors + 1;
                  $display("FAIL t=%0t  S=%b A=%h B=%h  Z=%h  expected=%h",
                           $time, S, A, B, Z, expected);
               end
            end
         end
      end

      // Check unknown select: Z should not match a clean value silently
      S = 1'bx; A = 4'hA; B = 4'h5; #10;
      $display("Info: S=x  ->  Z=%b (if-else treats x as false, so B is selected)", Z);

      if (errors == 0)
         $display("---- PASS: all 512 combinations correct ----");
      else
         $display("---- FAIL: %0d mismatches ----", errors);

      $finish;
   end

   // Optional: print a few lines of activity in the transcript
   initial begin
      $monitor("t=%0t  S=%b  A=%h  B=%h  Z=%h", $time, S, A, B, Z);
      #60 $monitoroff;                    // only the first few changes
   end

endmodule
