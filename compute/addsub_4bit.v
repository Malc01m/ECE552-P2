module addsub_4bit (A, B, sub, Sum, Ovfl, Cin);

    input [3:0] A, B; //Input values
    input sub, Cin; // add-sub indicator and Cin
    output [3:0] Sum; //sum output
    output Ovfl; //To indicate overflow


    wire [3:0] carry_out_intermediate; // wire for carries
    wire[3:0] B_mod; // wires for B
    wire [3:0] extended_sub;

    wire addOverflow, subOverflow;

    // negate and + 1 if sub is 1, otherwise leave
    assign extended_sub =  {4{sub}};
    assign B_mod = B ^ extended_sub;
    assign Cin = sub;
    
    wire [3:0] P, G;
    assign P = A | B_mod;
    assign G = A & B_mod;

    assign carry_out_intermediate[0] = G[0] | (P[0] & Cin); 
    assign carry_out_intermediate[1] = G[1] | P[1] & (G[0] | (P[0] & Cin)); 
    assign carry_out_intermediate[2] = G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))); 
    assign carry_out_intermediate[3] = G[3] | P[3] & (G[2] | P[2] & (G[1] | P[1] & (G[0] | (P[0] & Cin))));
    
    // Instantiate 1-bit full adders
    full_adder1bit fa0 (.A(A[0]), .B(B_mod[0]), .Cin(Cin), .Sum(Sum[0]), .Cout());
    full_adder1bit fa1 (.A(A[1]), .B(B_mod[1]), .Cin(carry_out_intermediate[0]), .Sum(Sum[1]), .Cout());
    full_adder1bit fa2 (.A(A[2]), .B(B_mod[2]), .Cin(carry_out_intermediate[1]), .Sum(Sum[2]), .Cout());
    full_adder1bit fa3 (.A(A[3]), .B(B_mod[3]), .Cin(carry_out_intermediate[2]), .Sum(Sum[3]), .Cout());

    // if carry in of MSB != carry out - then overflow
    assign Ovfl = carry_out_intermediate[3] ^ carry_out_intermediate[2];

endmodule