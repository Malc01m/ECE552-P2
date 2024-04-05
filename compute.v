
module Shifter (Shift_In,Shift_Val, Mode, Shift_Out);
  // ports
  input [15:0] Shift_In; 	// This is the input data to perform shift operation on
  input [3:0] Shift_Val; 	// Shift amount (used to shift the input data)
  input  [1:0] Mode; 		// To indicate 0=SLL or 1=SRA 
  output wire[15:0] Shift_Out; 	// Shifted output data

  // internal
  wire[15:0] sllOut;
  wire[15:0] sraOut;
  wire[15:0] RorOut;
  


  LeftShiftSelector sll(.data_in(Shift_In), .shiftVal(Shift_Val), .result(sllOut));
  SRA_Selector sra(.data_in(Shift_In), .shiftVal(Shift_Val), .result(sraOut));
  ROR ror(.data_in(Shift_In), .shiftVal(Shift_Val), .result(RorOut));

  Mux_3to1_16bit mux16(.I0(sllOut), .I1(sraOut), .I2(RorOut), .Select(Mode), .Out(Shift_Out));

endmodule

module ROR(data_in, shiftVal, result);
  input [15:0] data_in;     // Input data to be shifted (16 bits)
  input [3:0] shiftVal;     // Number of bits to shift
  output reg[15:0] result;     // Output shifted data
  reg error;


  always @(data_in, shiftVal) begin
    case (shiftVal)
      4'd0: begin
        result = data_in;
        error = 0; // No error for specific cases
      end
      4'd1: begin
        result = {data_in[0], data_in[15:1]};
        error = 0;
      end
      4'd2: begin
        result = {data_in[1:0], data_in[15:2]};
        error = 0;
      end
      4'd3: begin
        result ={data_in[2:0], data_in[15:3]};
        error = 0;
      end
      4'd4: begin
        result = {data_in[3:0], data_in[15:4]};
        error = 0;
      end
      4'd5: begin
        result = {data_in[4:0], data_in[15:5]};
        error = 0;
      end
      4'd6: begin
        result = {data_in[5:0], data_in[15:6]};
        error = 0;
      end
      4'd7: begin
        result = {data_in[6:0], data_in[15:7]};
        error = 0;
      end
      4'd8: begin
        result = {data_in[7:0], data_in[15:8]};
        error = 0;
      end
      4'd9: begin
        result = {data_in[8:0], data_in[15:9]};
        error = 0;
      end
      4'd10: begin
        result = {data_in[9:0], data_in[15:10]};
        error = 0;
      end
      4'd11: begin
        result = {data_in[10:0], data_in[15:11]};
        error = 0;
      end
      4'd12: begin
        result = {data_in[11:0], data_in[15:12]};
        error = 0;
      end
      4'd13: begin
        result = {data_in[12:0], data_in[15:13]};
        error = 0;
      end
      4'd14: begin
        result = {data_in[13:0], data_in[15:14]};
        error = 0;
      end
      4'd15: begin
        result =  {data_in[14:0], data_in[15]}; // Rotate all bits to the right
        error = 0;
      end
      default: begin
        error = 1;      // Set error flag for default case
      end
    endcase
  end


endmodule

module SRA_Selector (data_in, shiftVal, result);
  input [15:0] data_in;     // Input data to be shifted (16 bits)
  input [3:0] shiftVal;     // Number of bits to shift
  output reg[15:0] result;     // Output shifted data
  reg error;  

  always @(data_in, shiftVal) begin
    case (shiftVal)
      4'd0: begin
        result = data_in;
        error = 0;
      end
      4'd1: begin
        result = (data_in[15] == 1) ? {1'b1, data_in[15:1]} : data_in >> 1;
        error = 0;
      end
      4'd2: begin
        result = (data_in[15] == 1) ? {{2'b11}, data_in[15:2]} : data_in >> 2;
        error = 0;
      end
      4'd3: begin
        result = (data_in[15] == 1) ? {{3'b111}, data_in[15:3]} : data_in >> 3;
        error = 0;
      end
      4'd4: begin
        result = (data_in[15] == 1) ? {{4'b1111}, data_in[15:4]} : data_in >> 4;
        error = 0;
      end
      4'd5: begin
        result = (data_in[15] == 1) ? {{5'b11111}, data_in[15:5]} : data_in >> 5;
        error = 0;
      end
      4'd6: begin
        result = (data_in[15] == 1) ? {{6'b111111}, data_in[15:6]} : data_in >> 6;
        error = 0;
      end
      4'd7: begin
        result = (data_in[15] == 1) ? {{7'b1111111}, data_in[15:7]} : data_in >> 7;
        error = 0;
      end
      4'd8: begin
        result = (data_in[15] == 1) ? {{8'b11111111}, data_in[15:8]} : data_in >> 8;
        error = 0;
      end
      4'd9: begin
        result = (data_in[15] == 1) ? {{9'b111111111}, data_in[15:9]} : data_in >> 9;
        error = 0;
      end
      4'd10: begin
        result = (data_in[15] == 1) ? {{10'b1111111111}, data_in[15:10]} : data_in >> 10;
        error = 0;
      end
      4'd11: begin
        result = (data_in[15] == 1) ? {{11'b11111111111}, data_in[15:11]} : data_in >> 11;
        error = 0;
      end
      4'd12: begin
        result = (data_in[15] == 1) ? {{12'b111111111111}, data_in[15:12]} : data_in >> 12;
        error = 0;
      end
      4'd13: begin
        result = (data_in[15] == 1) ? {{13'b1111111111111}, data_in[15:13]} : data_in >> 13;
        error = 0;
      end
      4'd14: begin
        result = (data_in[15] == 1) ? {{14'b11111111111111}, data_in[15:14]} : data_in >> 14;
        error = 0;
      end
      4'd15: begin
        result = (data_in[15] == 1) ? {{15'b111111111111111}, data_in[15:15]} : data_in >> 15;
        error = 0;
      end
      default: begin
        
        error = 1;
      end
    endcase
  end

endmodule




module LeftShiftSelector (data_in, shiftVal, result);
  input [15:0] data_in;     // Input data to be shifted (16 bits)
  input [3:0] shiftVal;     // Number of bits to shift
  output reg [15:0] result;     // Output shifted data
  reg error;          // Error flag

  always @(data_in, shiftVal) begin
    case (shiftVal)
      4'd0: begin
        result = data_in;
        error = 0;
      end
      4'd1: begin
        result = data_in << 1;
        error = 0;
      end
      4'd2: begin
        result = data_in << 2;
        error = 0;
      end
      4'd3: begin
        result = data_in << 3;
        error = 0;
      end
      4'd4: begin
        result = data_in << 4;
        error = 0;
      end
      4'd5: begin
        result = data_in << 5;
        error = 0;
      end
      4'd6: begin
        result = data_in << 6;
        error = 0;
      end
      4'd7: begin
        result = data_in << 7;
        error = 0;
      end
      4'd8: begin
        result = data_in << 8;
        error = 0;
      end
      4'd9: begin
        result = data_in << 9;
        error = 0;
      end
      4'd10: begin
        result = data_in << 10;
        error = 0;
      end
      4'd11: begin
        result = data_in << 11;
        error = 0;
      end
      4'd12: begin
        result = data_in << 12;
        error = 0;
      end
      4'd13: begin
        result = data_in << 13;
        error = 0;
      end
      4'd14: begin
        result = data_in << 14;
        error = 0;
      end
      4'd15: begin
        result = data_in << 15;
        error = 0;
      end
      default: begin
        error = 1;      // Set error flag for default case
      end
    endcase
  end

endmodule







module full_adder1bit (A,B,Cin, Sum, Cout);
  // ports
  input wire A, B, Cin;
  output wire Sum, Cout;

  // sum: xor A,B Cin
  assign Sum = A ^ B ^ Cin;

  // Cout
  assign Cout = (A & B) |  (Cin & (A^B));

endmodule


module PSA_16bit (Sum, Error, A, B);
  // ports
  input wire [15:0] A, B; 	// Input data values
  output wire [15:0] Sum; 	// Sum output
  output wire Error; 	// To indicate overflows

  // internal
  wire sw1E, sw2E, sw3E, Sw4E;
  wire[1:0] OPcode = 2'b00;


  sub_word_adder swAdder2(.ALU_In1(A[7:4]), .ALU_In2(B[7:4]), .Opcode(OPcode), .ALU_Out(Sum[7:4]), .Error(sw2E));
  sub_word_adder swAdder1(.ALU_In1(A[3:0]), .ALU_In2(B[3:0]), .Opcode(OPcode), .ALU_Out(Sum[3:0]), .Error(sw1E));
  sub_word_adder swAdder3(.ALU_In1(A[11:8]), .ALU_In2(B[11:8]), .Opcode(OPcode), .ALU_Out(Sum[11:8]), .Error(sw3E));
  sub_word_adder swAdder4(.ALU_In1(A[15:12]), .ALU_In2(B[15:12]), .Opcode(OPcode), .ALU_Out(Sum[15:12]), .Error(sw4E));

  assign Error = sw1E | sw2E | sw3E | sw4E; 

  
endmodule

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


module addsub_16bit (A, B, sub, Sum, Ovfl);
  
    input [15:0] A, B; //Input values
    input sub; // add-sub indicator
    output [15:0] Sum; //sum output
    output Ovfl; //To indicate overflow


    wire [15:0] carry_out_intermediate; // wire for carries
    wire[15:0] B_mod; // wires for B
    wire Cin; // wire for +1 if subtraction
    wire [15:0] extended_sub;

    wire[15:0] iSum, addSum, subSum;

    wire addOverflow, subOverflow, aPosOverflow, sPosOverflow;

    
    // negate and + 1 if sub is 1, otherwise leave
    assign extended_sub =  {16{sub}};
    assign B_mod = B ^ extended_sub;
    assign Cin = sub;
    
    
    wire [15:0] P, G;
    assign P = A | B_mod;
    assign G = A & B_mod;


    // hardware is free :) 
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
    
    
    // assign aNegOverflow = (A[15] == 1 & B[15] == 1 & iSum[15] == 0) ? 1 : 0;
    
    // always begin
    //   #10;
    //   $monitor("Op: %b, Ovfl %d, SPosOverflow: %d, subSum: %b, Sum: %b",sub, Ovfl, sPosOverflow, subSum, Sum);
    // end
    
    
    assign addSum = (Ovfl == 0) ? iSum: ((aPosOverflow == 1 ) ? 16'b0111111111111111: 16'b1000000000000000);
    assign subSum = (Ovfl == 0) ? iSum: ( (sPosOverflow == 1) ? 16'b1000000000000000: 16'b0111111111111111 );


    // ((sPosOverflow == 1 ) ? 16'b1000000000000000: 16'b0111111111111111)
    assign Sum = (sub == 0) ? addSum: subSum;
    // assign ADD_SUB_Out_Final = (ADD_SUB_Overflow == 1) ? ( (Opcode == 2'b00) ? 16'b0111111111111111: 16'b1111111111111111 ): ADD_SUB_Out;


endmodule

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
    full_adder1bit fa0 (.A(A[0]), .B(B_mod[0]), .Cin(Cin), .Sum(Sum[0]));
    full_adder1bit fa1 (.A(A[1]), .B(B_mod[1]), .Cin(carry_out_intermediate[0]), .Sum(Sum[1]));
    full_adder1bit fa2 (.A(A[2]), .B(B_mod[2]), .Cin(carry_out_intermediate[1]), .Sum(Sum[2]));
    full_adder1bit fa3 (.A(A[3]), .B(B_mod[3]), .Cin(carry_out_intermediate[2]), .Sum(Sum[3]));

    // if carry in of MSB != carry out - then overflow
    assign Ovfl = carry_out_intermediate[3] ^ carry_out_intermediate[2];

endmodule


// ADD 0000
// SUB 0001
// XOR 0010
// PADDSB 0111
// RED 0011

// SLL 0100
// SRA 0101
// ROR 0110

module ALU (ALU_In1, ALU_In2, imm, Opcode, ALU_Out, Error);
    // op codes
    //  add: 00
    //  sub: 01
     // xor: 10
    

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


module Fancy_Mux_2to1 (I0, I1,Select, Out);
  // ports
  input wire I0, I1, Select;
  output reg Out;
  
  // internal
  reg error;

  always @(I0,I1, Select) begin
    case (Select)
      1'b0: begin
                Out = I0;
                error = 0;
             end
      1'b1: begin
                Out = I1;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule


module ALU_Mux_4to1_16bit (I0, I1, I2, I3, I4, Select, Out);
  // ports
  input wire [15:0] I0, I1, I2, I3, I4;


  input wire [3:0] Select;
  output reg [15:0] Out;
  
  // internal
  reg error;
  // ADD 0000
  // SUB 0001
  // XOR 0010
  // PADDSB 0111
  // RED 0011
  always @(I0,I1, I2,I3, I4, Select) begin
    casex (Select)

      4'b0000, 4'b0001: begin
                Out = I0;
                error = 0;
             end
      
      4'b0010: begin
                Out = I1;
                error = 0;
             end
      4'b0111: begin
                Out = I2;
                error = 0;
             end
      4'b0011: begin
                Out = I3;
                error = 0;
             end
      4'b0100, 4'b0101, 4'b0110: begin
                Out = I4;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule

module ALU_Mux_3to1_16bit (I0, I1, I2, Select, Out);
  // ports
  input wire [15:0] I0, I1, I2;


  input wire [1:0] Select;
  output reg [15:0] Out;
  
  // internal
  reg error;
  
  always @(I0,I1, I2, Select) begin
    casex (Select)
      2'b0x: begin
                Out = I0;
                error = 0;
             end
      2'b10: begin
                Out = I1;
                error = 0;
             end
      2'b11: begin
                Out = I2;
                error = 0;
             end
     
      default: error=1; // Default case 
    endcase
  end

endmodule


module Mux_4to1_4bit (I0, I1, I2, I3, Select, Out);
  
  //ports
  input wire [3:0] I0;
  input wire [3:0] I1;
  input wire [3:0] I2;
  input wire [3:0] I3;
  input wire [1:0] Select;
  output reg [3:0] Out;
  
  // internal
  reg error;
  
  always @(I0,I1,I2,I3,Select) begin
    case (Select)
      2'b00: begin
                Out = I0;
                error = 0;
             end
      2'b01: begin
                Out = I1;
                error = 0;
             end
      2'b10: begin
                Out = I2;
                error = 0;
              end
      2'b11: begin
                Out = I3;
                error = 0;
              end
      default: error=1; // Default case 
    endcase
  end

endmodule

module Mux_2to1_16bit (I0, I1, Select, Out);

  // ports
  input wire [15:0] I0;
  input wire [15:0] I1;
  input wire Select;
  output reg [15:0] Out;

  // internal
  reg error;

  always @(I0,I1,Select) begin
    case (Select)
      1'b0: begin
                Out = I0;
                error = 0;
             end
      1'b1: begin
                Out = I1;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule

module Mux_3to1_16bit (I0, I1, I2, Select, Out);

  // ports
  input wire [15:0] I0;
  input wire [15:0] I1;
  input wire [15:0] I2;
  
  input wire[1:0] Select;
  output reg [15:0] Out;

  // internal
  reg error;

  always @(I0,I1,I2, Select) begin
    case (Select)
      2'b00: begin
                Out = I0;
                error = 0;
             end
      2'b01: begin
                Out = I1;
                error = 0;
             end
      2'b10: begin
                Out = I2;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule


module Mux_2to1 (I0, I1, Select, Out);

  // ports
  input wire I0;
  input wire I1;
  input wire Select;
  output reg Out;

  // internal
  reg error;

  always @(I0,I1,Select) begin
    case (Select)
      1'b0: begin
                Out = I0;
                error = 0;
             end
      1'b1: begin
                Out = I1;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule


module OddMux_3to1 (I0, I1, I2, Select, Out);

  // ports
  input wire I0;
  input wire I1;
  input wire I2;

  input wire [3:0] Select;
  output reg Out;

  // internal
  reg error;

  // ADD 0000
  // SUB 0001
  // XOR 0010
  // PADDSB 0111
  // RED 0011
  always @(I0,I1,I2, Select) begin
    case (Select)
      4'b0000, 4'b0001: begin
                Out = I0;
                error = 0;
             end
      4'b0010, 4'b0011: begin
                Out = I1;
                error = 0;
              end
      4'b0111: begin
                Out = I2;
                error = 0;
              end  
      default: error=1; // Default case 
    endcase
  end

endmodule



module Mux_4to1 (I0, I1, I2, I3, Select, Out);

  // ports
  input wire I0;
  input wire I1;
  input wire I2;
  input wire I3;
  input wire [1:0] Select;
  output reg Out;

  // internal
  reg error;


  always @(I0,I1,I2,I3,Select) begin
    case (Select)
      2'b00: begin
                Out = I0;
                error = 0;
             end
      2'b01: begin
                Out = I1;
                error = 0;
             end
      2'b10: begin
                Out = I2;
                error = 0;
              end
      2'b11: begin
                Out = I3;
                error = 0;
              end
      default: error=1; // Default case 
    endcase
  end

endmodule



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

module Mux_3to1_4bit (I0, I1, I2, Select, Out);
  // ports
  input wire [3:0] I0;
  input wire [3:0] I1;
  input wire [3:0] I2;
  input wire [1:0] Select;
  output reg [3:0] Out;
  
  // internal
  reg error;
  
  always @(I0,I1, I2, Select) begin
    casex (Select)
      2'b0x: begin
                Out = I0;
                error = 0;
             end
      2'b10: begin
                Out = I1;
                error = 0;
             end
      2'b11: begin
                Out = I2;
                error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule


