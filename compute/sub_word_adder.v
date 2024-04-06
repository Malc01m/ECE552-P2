module sub_word_adder (ALU_In1, ALU_In2, Opcode, ALU_Out, Error);
    // op codes
    //  add: 00

    // ports
    input [3:0] ALU_In1, ALU_In2;
    input [1:0] Opcode; 
    output [3:0] ALU_Out;
    output Error; // Just to show overflow
    
    // internal
    wire [3:0] ADD_SUB_Out;
    wire ADD_SUB_Overflow;
    wire posOverflow;
    wire negOverflow;

    // add_sub/nand/xor
    addsub_4bit ADD_SUB (.A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]), .Sum(ADD_SUB_Out), .Ovfl(Error)); 

    assign aPosOverflow = (ALU_In1[3] == 0 & ALU_In2[3] == 0 & ADD_SUB_Out[3] == 1) ? 1 : 0;
    assign aNegOverflow = (ALU_In1[3] == 1 & ALU_In2[3] == 1 & ADD_SUB_Out[3] == 0) ? 1 : 0;

    assign ALU_Out = (Error == 0) ? ADD_SUB_Out : ((aPosOverflow == 1 ) ? 4'b0111: 4'b1000);
    
endmodule