module branchUnit(instruction, curr_pc, B_PC);
  input [15:0] instruction, curr_pc;
  output [15:0] B_PC;
  

  wire [15:0] pc_plus_2, br_out, imm;
  wire [9:0] temp;
  assign temp = instruction[8:0] << 1; 
  assign imm = {{7{temp[8]}}, temp};

  addsub_16bit branchAdder_1(.A(curr_pc), .B(16'd2), .sub(1'b0), .Sum(pc_plus_2));
  addsub_16bit branchAdder_2(.A(pc_plus_2), .B(imm), .sub(1'b0), .Sum(B_PC));
   
  // assign new_pc = br_out;
endmodule