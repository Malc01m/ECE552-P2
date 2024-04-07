module PC_Control(instruction, curr_pc, new_pc, clk, rst_n, branchRegData, HLT, outPlus2PC, flags);

  //  always #50 $monitor("Curr PC: %d, Plus2PC: %d, B_PC: %d", intermediatePC, plus2PC, B_PC);
  input [15:0] instruction, curr_pc, branchRegData;
  input clk, rst_n, HLT;
  input [2:0] flags;

  output [15:0] new_pc, outPlus2PC;

  wire [15:0] plus2PC, B_PC, BR_PC, selectedPC, readPC;
  wire pcError, takeBranch;
  
  // add two to curr pc
  addsub_16bit pcAdder(.A(curr_pc), .B(16'd2), .sub(1'b0), .Sum(plus2PC), .Ovfl(pcError));

  // calc branch
  branchUnit br(.instruction(instruction), .curr_pc(curr_pc), .B_PC(B_PC));
  
  // see if branch taken or not
  decideBranch db(.flags(flags), .condition(instruction[11:9]), .branchTaken(takeBranch));
  
  // Decide between PC+2, B address, and BR Address 
  //                                            B                                       BR        
  assign selectedPC = (instruction[15:12] == 4'b1100 & takeBranch) ? B_PC : (instruction[15:12] == 4'b1101 & takeBranch) ? branchRegData : plus2PC;
  PC_Register pc(.clk(clk), .rst(~rst_n), .D(selectedPC), .WriteReg(1'b1), .ReadEnable1(1'b1), .Bitline1(readPC));

  assign new_pc = (HLT == 1) ? curr_pc: readPC;
  assign outPlus2PC = plus2PC;
  
endmodule

// Malcolm's HW5 version

// module PC_control(C, F, I, PC_in, PC_out);

//     // 3-bit condition codes (C)
//     // 000	Not Equal (Z = 0)
//     // 001	Equal (Z = 1)
//     // 010	Greater Than (Z = N = 0)
//     // 011	Less Than (N = 1) 
//     // 100	Greater Than or Equal (Z = 1 or Z = N = 0)
//     // 101	Less Than or Equal (N = 1 or Z = 1)
//     // 110	Overflow (V = 1)
//     // 111	Unconditional

//     // Flags 
//     // Zero (Z), Overflow (V) and Sign bit (N)

//     input  [2:0]  C, F;         // Condition code, flag
//     input  [8:0]  I;            // 9-bit offset
//     input  [15:0] PC_in;        // Program counter in
//     output reg [15:0] PC_out;   // Program counter out

//     // Internal
//     wire [15:0] branch_addr, PC_in_2, I_ext_shft, two_ext;
//     wire Z, V, N;
//     reg error;

//     // FLags
//     assign Z = F[0];
//     assign V = F[1];
//     assign N = F[2];

//     // Sign extend to 16 bit for adder input
//     assign I_ext_shft = {{6{I[8]}}, I[8:0], 1'b0};
//     assign two_ext = 16'h0002;

//     addsub_16bit add_two (.Sum(PC_in_2),     .Sub(1'b0), .Ovfl(), .A(PC_in),   .B(two_ext));
//     addsub_16bit add_I   (.Sum(branch_addr), .Sub(1'b0), .Ovfl(), .A(PC_in_2), .B(I_ext_shft));

//     always @* begin
//         case (C)
//             3'b000: begin
//                 PC_out = (~Z) ? branch_addr : PC_in;
//             end 
//             3'b001: begin
//                 PC_out = (Z) ? branch_addr : PC_in;
//             end 
//             3'b010: begin
//                 PC_out = ((~Z) & (~N)) ? branch_addr : PC_in;
//             end 
//             3'b011: begin
//                 PC_out = (N) ? branch_addr : PC_in;
//             end 
//             3'b100: begin
//                 PC_out = (Z | ((~Z) & (~N))) ? branch_addr : PC_in;
//             end 
//             3'b101: begin
//                 PC_out = (N | Z) ? branch_addr : PC_in;
//             end 
//             3'b110: begin
//                 PC_out = (V) ? branch_addr : PC_in;
//             end 
//             3'b111: begin
//                 PC_out = branch_addr;
//             end
//             default: begin
//                 error = 1'b1;
//             end
//         endcase
//     end

// endmodule