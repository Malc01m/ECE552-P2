module ALU (ALU_In1, ALU_In2, imm, Opcode, ALU_Out, Error);

    // op codes
    // ADD 0000
    // SUB 0001
    // XOR 0010
    // PADDSB 0111
    // RED 0011

    // SLL 0100
    // SRA 0101
    // ROR 0110
    
    // ports
    input [15:0] ALU_In1, ALU_In2;
    input [3:0] imm, Opcode; 
    output [15:0] ALU_Out;
    output Error; // Just to show overflow
    
    // internal
    wire [15:0] ADD_SUB_Out, ADD_SUB_Out_Final, PADDSB_Out, XOR_Out, RED_Out, Shift_Out;
    wire ADD_SUB_Overflow, PADDSB_Overflow, zero;
    
    // add_sub
    addsub_16bit ADD_SUB (.A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]), .Sum(ADD_SUB_Out), .Ovfl(ADD_SUB_Overflow)); 
    
    // red 
    RED redUnit(.A(ALU_In1), .B(ALU_In2), .Sum(RED_Out));
    
    // xor
    assign zero = 1'b0; // hardwire zero for XOR Error
    assign XOR_Out = ALU_In1 ^ ALU_In2;

    // PADDSB
    PSA_16bit swAdder16(.A(ALU_In1), .B(ALU_In2), .Sum(PADDSB_Out), .Error(PADDSB_Overflow));
    
    // SLL, SRA, ROR
    Shifter shiftUnit(.Shift_In(ALU_In1), .Shift_Val(imm), .Mode(Opcode[1:0]), .Shift_Out(Shift_Out));

    // select result and error (overflow in this case)
    ALU_Mux_4to1_16bit selectResult(.I0(ADD_SUB_Out), .I1(XOR_Out), .I2(PADDSB_Out), .I3(RED_Out), .I4(Shift_Out), .Out(ALU_Out), .Select(Opcode));
    OddMux_3to1 selectError(.I0(ADD_SUB_Overflow), .I1(zero), .I2(PADDSB_Overflow), .Select(Opcode), .Out(Error));

    // always #50 $monitor("imm: %b, Shift_Out: %b",imm, Shift_Out);
    
endmodule