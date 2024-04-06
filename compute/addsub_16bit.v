`include "full_adder1bit.v"

// P1 version

module addsub_16bit (A, B, sub, Sum, Ovfl);
  
    input [15:0] A, B; //Input values
    input sub; // add-sub indicator
    output [15:0] Sum; //sum output
    output Ovfl; //To indicate overflow

    wire [15:0] carry_out_intermediate; // wire for carries
    wire [15:0] B_mod; // wires for B
    wire Cin; // wire for +1 if subtraction
    wire [15:0] extended_sub;
    wire [15:0] iSum, addSum, subSum;
    wire addOverflow, subOverflow, aPosOverflow, sPosOverflow;

    // negate and + 1 if sub is 1, otherwise leave
    assign extended_sub =  {16{sub}};
    assign B_mod = B ^ extended_sub;
    assign Cin = sub;
    
    wire [15:0] P, G;
    assign P = A | B_mod;
    assign G = A & B_mod;

    assign carry_out_intermediate[0] = G[0] | (P[0] & Cin); 
    assign carry_out_intermediate[1] = G[1] | P[1] & (G[0] | (P[0] & Cin)); 
    assign carry_out_intermediate[2] = G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))); 
    assign carry_out_intermediate[3] = G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))));
    
    assign carry_out_intermediate[4] = G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))));
    assign carry_out_intermediate[5] = G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))));
    assign carry_out_intermediate[6] = G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))))));
    assign carry_out_intermediate[7] = G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))))));
    
    assign carry_out_intermediate[8] = G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))))))));
    assign carry_out_intermediate[9] = G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))))))));
    assign carry_out_intermediate[10] = G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))))))))));
    assign carry_out_intermediate[11] = G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))))))))));
    
    assign carry_out_intermediate[12] = G[12] | P[12] & (G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))))))))))));
    assign carry_out_intermediate[13] = G[13] | P[13] & (G[12] | P[12] & (G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))))))))))));
    assign carry_out_intermediate[14] = G[14] | P[14] & (G[13] | P[13] & (G[12] | P[12] & (G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin)))))))))))))));
    assign carry_out_intermediate[15] = G[15] | P[15] & (G[14] | P[14] & (G[13] | P[13] & (G[12] | P[12] & (G[11] | P[11] & (G[10] | P[10] & (G[9] | P[9] & (G[8] | P[8] & (G[7] | P[7] & (G[6] | P[6] & (G[5] | P[5] & (G[4] | P[4] & (G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))))))))))))))));

    // Instantiate 1-bit full adders
    full_adder1bit fa0 (.A(A[0]), .B(B_mod[0]), .Cin(Cin), .Sum(iSum[0]));
    full_adder1bit fa1 (.A(A[1]), .B(B_mod[1]), .Cin(carry_out_intermediate[0]), .Sum(iSum[1]));
    full_adder1bit fa2 (.A(A[2]), .B(B_mod[2]), .Cin(carry_out_intermediate[1]), .Sum(iSum[2]));
    full_adder1bit fa3 (.A(A[3]), .B(B_mod[3]), .Cin(carry_out_intermediate[2]), .Sum(iSum[3]));

    full_adder1bit fa4 (.A(A[4]), .B(B_mod[4]), .Cin(carry_out_intermediate[3]), .Sum(iSum[4]));
    full_adder1bit fa5 (.A(A[5]), .B(B_mod[5]), .Cin(carry_out_intermediate[4]), .Sum(iSum[5]));
    full_adder1bit fa6 (.A(A[6]), .B(B_mod[6]), .Cin(carry_out_intermediate[5]), .Sum(iSum[6]));
    full_adder1bit fa7 (.A(A[7]), .B(B_mod[7]), .Cin(carry_out_intermediate[6]), .Sum(iSum[7]));

    full_adder1bit fa8 (.A(A[8]), .B(B_mod[8]), .Cin(carry_out_intermediate[7]), .Sum(iSum[8]));
    full_adder1bit fa9 (.A(A[9]), .B(B_mod[9]), .Cin(carry_out_intermediate[8]), .Sum(iSum[9]));
    full_adder1bit fa10 (.A(A[10]), .B(B_mod[10]), .Cin(carry_out_intermediate[9]), .Sum(iSum[10]));
    full_adder1bit fa11 (.A(A[11]), .B(B_mod[11]), .Cin(carry_out_intermediate[10]), .Sum(iSum[11]));

    full_adder1bit fa12 (.A(A[12]), .B(B_mod[12]), .Cin(carry_out_intermediate[11]), .Sum(iSum[12]));
    full_adder1bit fa13 (.A(A[13]), .B(B_mod[13]), .Cin(carry_out_intermediate[12]), .Sum(iSum[13]));
    full_adder1bit fa14 (.A(A[14]), .B(B_mod[14]), .Cin(carry_out_intermediate[13]), .Sum(iSum[14]));
    full_adder1bit fa15 (.A(A[15]), .B(B_mod[15]), .Cin(carry_out_intermediate[14]), .Sum(iSum[15]));
      
    // if carry in of MSB != carry out - then overflow
    assign Ovfl = carry_out_intermediate[15] ^ carry_out_intermediate[14];

    // detect overflow and saturate - TODO: need to fix for postive and neg detection
    assign aPosOverflow = (A[15] == 0 & B[15] == 0 & iSum[15] == 1) ? 1 : 0;
    assign sPosOverflow = (A[15] == 1 & B[15] == 0 & iSum[15] == 0) ? 1 : 0;
    
    // always begin
    //   #10;
    //   $monitor("Op: %b, Ovfl %d, SPosOverflow: %d, subSum: %b, Sum: %b",sub, Ovfl, sPosOverflow, subSum, Sum);
    // end
    
    assign addSum = (Ovfl == 0) ? iSum: ((aPosOverflow == 1 ) ? 16'b0111111111111111: 16'b1000000000000000);
    assign subSum = (Ovfl == 0) ? iSum: ( (sPosOverflow == 1) ? 16'b1000000000000000: 16'b0111111111111111 );

    assign Sum = (sub == 0) ? addSum: subSum;

endmodule

// Malcolm's HW5 version

// module addsub_16bit (Sum, Ovfl, A, B, Sub);

//     input [15:0] A, B;   // Input values
//     input Sub;           // add-sub indicator
//     output [15:0] Sum;   // sum output
//     output Ovfl;         // To indicate overflow

//     wire [15:0] B_Sub, Cout;

//     // Negate B for subtraction
//     xor xor_b [15:0] (B_Sub[15:0], B[15:0], Sub);

//     // 2s compliment overflow
//     xor xor_ovfl(Ovfl, Cout[15], Cout[14]);
    
//     // LSB to MSB
//     full_adder_1bit FA1(.A(A[0]), .B(B_Sub[0]), .Cin(Sub), .S(Sum[0]), .Cout(Cout[0]));
//     full_adder_1bit FAVECT [14:0] (.A(A[15:1]), .B(B_Sub[15:1]), .Cin(Cout[14:0]),  
//         .S(Sum[15:1]), .Cout(Cout[15:1]));
    
// endmodule