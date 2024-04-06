module mini4BitALU (ALU_In1, ALU_In2, Opcode, ALU_Out, Error);
    // op codes
    //  add: 00
    //  sub: 01
    // nand: 10
    //  xor: 11

    // ports
    input [3:0] ALU_In1, ALU_In2;
    input [1:0] Opcode; 
    output [3:0] ALU_Out;
    output Error; // Just to show overflow
    
    // internal
    wire [3:0] ADD_SUB_Out, NAND_Out, XOR_Out;
    wire ADD_SUB_Overflow, zero;
    
    // hardwire zero for NAND/XOR Error
    assign zero = 1'b0;

    // add_sub/nand/xor
    addsub_4bit ADD_SUB (.A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]), .Sum(ADD_SUB_Out), .Ovfl(ADD_SUB_Overflow)); 
    assign NAND_Out = ~(ALU_In1 & ALU_In2);
    assign XOR_Out = ALU_In1 ^ ALU_In2;


    // select result and error (overflow in this case)
    Mux_3to1_4bit selectResult(.I0(ADD_SUB_Out), .I1(NAND_Out), .I2(XOR_Out), .Out(ALU_Out), .Select(Opcode));
    Fancy_Mux_2to1 selectError(.I0(ADD_SUB_Overflow), .I1(zero), .Select(Opcode[1]), .Out(Error));

endmodule