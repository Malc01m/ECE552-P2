module add4bit (A, B, Sum, Ovfl, Cin);

    input [3:0] A, B; //Input values
    input Cin; 
    output [3:0] Sum; //sum output
    output Ovfl; //To indicate overflow

    wire [3:0] carry_out_intermediate; // wire for carries
    wire addOverflow;
    wire [3:0] P, G;

    assign P = A | B;
    assign G = A & B;

    assign carry_out_intermediate[0] = G[0] | (P[0] & Cin); 
    assign carry_out_intermediate[1] = G[1] | P[1] & (G[0] | (P[0] & Cin)); 
    assign carry_out_intermediate[2] = G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))); 
    assign carry_out_intermediate[3] = G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))));
    
    // Instantiate 1-bit full adders
    full_adder1bit fa0 (.A(A[0]), .B(B[0]), .Cin(Cin), .Sum(Sum[0]));
    full_adder1bit fa1 (.A(A[1]), .B(B[1]), .Cin(carry_out_intermediate[0]), .Sum(Sum[1]));
    full_adder1bit fa2 (.A(A[2]), .B(B[2]), .Cin(carry_out_intermediate[1]), .Sum(Sum[2]));
    full_adder1bit fa3 (.A(A[3]), .B(B[3]), .Cin(carry_out_intermediate[2]), .Sum(Sum[3]));

    // if carry in of MSB != carry out - then overflow
    assign Ovfl = carry_out_intermediate[3];

    // always #1 $monitor("In adder overflow when adding %b + %b: %b", A, B, Ovfl);

endmodule