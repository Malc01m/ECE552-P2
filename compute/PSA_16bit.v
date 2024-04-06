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