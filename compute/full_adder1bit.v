module full_adder1bit (A, B, Cin, Sum, Cout);

  // ports
  input wire A, B, Cin;
  output wire Sum, Cout;

  // sum: xor A,B Cin
  assign Sum = A ^ B ^ Cin;

  // Cout
  assign Cout = (A & B) |  (Cin & (A^B));

endmodule
