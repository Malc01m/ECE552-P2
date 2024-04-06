module RED(A, B, Sum);
  // ports
  input [15:0] A,B;
  output [15:0] Sum;
  
  // always #10 $monitor("A: %b, B: %b, half1: %b, half2: %b; COut3: %b, COut11: %b, P: %b, G: %b, t2: %b", A, B, half1, half2, cOut3, cOut11, P, G, t2);
  // always #10 $monitor("A: %b, B: %b, half2: %b, COut11: %b, P: %b, G: %b, t2: %b", A[15:12], B[15:12], half2, cOut11, P, G, t2);
  // always #10 $monitor("A: %b, B: %b, half1: %b, half2: %b, Sum: %b, NewCout7: %b, Sum[8]: %b", A, B, half1, half2, Sum, newCOut7, Sum[8]);
  // always #10 $monitor("A[15:12]: %b, B[15:12] %b, half2[7:4]: %b, half2[3:0]: %b, half2: %b, COut11: %b",A[15:12], B[15:12], half2[7:4] ,half2[3:0],half2, cOut11);
  
  // internal
  wire [8:0] half1, half2;
  wire zero, cOut3, cOut11, t1, t2;
  wire [15:0] P, G;
  assign zero = 0;
  
  assign P = A[15:0] | B[15:0];
  assign G = A[15:0] & B[15:0];
  assign cOut3 = G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & zero))));
  assign cOut11 = G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8])));

  // stage 1
  add4bit half1_a(.A(A[3:0]), .B(B[3:0]),.Sum(half1[3:0]), .Cin(zero));
  add4bit half1_b(.A(A[7:4]), .B(B[7:4]), .Sum(half1[7:4]), .Ovfl(half1[8]), .Cin(cOut3));

  add4bit half2_a(.A(A[11:8]), .B(B[11:8]),.Sum(half2[3:0]), .Cin(zero));
  add4bit half2_b(.A(A[15:12]), .B(B[15:12]), .Sum(half2[7:4]), .Ovfl(half2[8]), .Cin(cOut11));

  // stage 2
  wire[8:0] newP, newG;
  wire newCOut3, newCOut7;
  assign newP = half1 | half2;
  assign newG = half1 & half2;
  
  assign newCOut3 = newG[3] | newP[3] & (newG[2] | newP[2] & (newG[1] | newP[1] & (newG[0] | (newP[0] & 0))));
  assign newCOut7 = newG[7] | newP[7] & (newG[6] | newP[6] & (newG[5] | newP[5] & (newG[4] | newP[4] & (newG[3] | newP[3] & (newG[2] | newP[2] & (newG[1] | newP[1] & (newG[0] | (newP[0] & zero))))))));

  add4bit part1(.A(half1[3:0]), .B(half2[3:0]), .Sum(Sum[3:0]), .Cin(zero));
  add4bit part2(.A(half1[7:4]), .B(half2[7:4]), .Sum(Sum[7:4]), .Cin(newCOut3));
  
  wire [3:0] temp, tempA, tempB;
  assign tempA = {{3{half1[8]}},half1[8]};
  assign tempB = {{3{half2[8]}},half2[8]};
  add4bit part3(.A(tempA), .B(tempB), .Sum(temp), .Cin(newCOut7));
  
  assign Sum[9:8] = temp[1:0];
  assign Sum[15:10] = {6{Sum[9]}};

endmodule