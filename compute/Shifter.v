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