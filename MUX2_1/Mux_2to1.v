`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.09.2026 11:22:54
//////////////////////////////////////////////////////////////////////////////////
// To design a Mux 2 to 1 using always + assign statement
module Mux_2to1( A,B,S,Z);

   input [3:0] A,B;
   input S;
   output [3:0] Z;
   reg [3:0] G;            // was [0:3] - kept same bit order as A, B, Z

   always @(*)             // was "always" with no sensitivity list -> sim hangs
      begin
          if ( S == 0) G = A;
          else         G = B;
      end

   assign Z = G;

endmodule
