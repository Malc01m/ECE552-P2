`include "compute.v"
`include "memory.v"
`include "registerFile.v"

// Asnwers to Questions Asked on Friday -
//      sign extend then shift for address calc
//      it is ok if your mem is xxx when unwritten to
//      Former question: case statment is fine for shifter

module controlUnit(opCode, rst_n, writeReg, readReg1, readReg2, memRead, memWrite, ComputeType, MemType, BinaryType, BranchType, HLT);

  // ports
  input wire [3:0] opCode;
  input rst_n;
  output reg writeReg, readReg1, readReg2, memRead, memWrite, ComputeType, MemType, BinaryType, BranchType, HLT;
  
  // internal
  reg error;

  
  always @(opCode, rst_n) begin
    case (opCode)
      // ADD,     SUB,    XOR,   PADDSB,    SLL,     SRA,     ROR       RED    PCS
      4'b0000, 4'b0001, 4'b0010, 4'b0111, 4'b0100, 4'b0101, 4'b0110, 4'b0011, 4'b1110: begin
                // compute signals
                writeReg = 1;
                readReg1 = 1;
                readReg2 = 1;
                memRead = 0;
                memWrite = 0;
                
                
                ComputeType = 1;
                MemType = 0;
                BinaryType = 0;
                BranchType = 0;


                HLT = 0;
                error = 0;

             end
      // LW   
      4'b1000: begin
                
                readReg1 = 0;
                readReg2 = 1;
                writeReg = 1;
                memRead = 1;
                memWrite = 0;
                
                ComputeType = 0;
                MemType = 1;
                BinaryType = 0;
                BranchType = 0;
                


                HLT = 0;
                error = 0;
             end
      // SW   
      4'b1001: begin
                
                readReg1 = 1;
                readReg2 = 1;
                writeReg = 0;
                memRead = 1;
                memWrite = 1;
                
                ComputeType = 0;
                MemType = 1;
                BinaryType = 0;
                BranchType = 0;
                


                HLT = 0;
                error = 0;
             end

      // LLB,    LHB
      4'b1010, 4'b1011: begin
                // binary signals (binary is a sub cat of mem) 
                readReg1 = 1;
                readReg2 = 0;
                writeReg = 1;
                memRead = 0;
                memWrite = 0;
                
                ComputeType = 0;
                MemType = 1;
                BinaryType = 1;
                BranchType = 0;


                HLT = 0;
                error = 0;
             end
      // B,       BR
      4'b1100, 4'b1101: begin
                // branch signals
                readReg1 = 1;
                readReg2 = 0;
                writeReg = 0;
                memRead = 0;
                memWrite = 0;
                
                ComputeType = 0;
                MemType = 0;
                BinaryType = 0;
                BranchType = 1;

                HLT = 0;
                error = 0;
             end
      // HLT
      4'b1111: begin
                readReg1 = 0;
                readReg2 = 0;
                writeReg = 0;
                memRead = 0;
                memWrite = 0;
                
                ComputeType = 0;
                MemType = 0;
                BinaryType = 0;
                BranchType = 0;

                
                HLT = 1;
                error = 0;
             end
      default: begin
                error=1; // Default case 
                HLT = 0;
               end
    endcase
  end

endmodule


module selectRegSource(inst, ComputeType, MemType, BinaryType, BranchType, srcReg1, srcReg2);

  // ports
  input wire [15:0] inst;
  input ComputeType, MemType, BinaryType, BranchType;
  
  output reg [3:0] srcReg1, srcReg2;
  
  // internal
  reg error;
  reg[3:0] combinedVector;

   // always #20 $monitor("Current Instruction: %b, CombinedVec: %b", inst, combinedVector);
   
  always @(inst, ComputeType, MemType, BinaryType, BranchType) begin
   combinedVector = {ComputeType, MemType, BinaryType, BranchType};
    case (combinedVector)
      // Compute
      4'b1000: begin
                  srcReg1 = inst[7:4];
                  srcReg2 = inst[3:0];
                  error = 0;
             end
      // pure mem
      4'b0100: begin
                  srcReg1 = inst[11:8];
                  srcReg2 = inst[7:4];
                  error = 0;
             end
      // LLB/LUB
      4'b0110: begin
                  srcReg1 = inst[11:8];
                  error = 0;
             end
      // Branch
      4'b0001: begin
                  srcReg1 = inst[7:4];
                  error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

endmodule

module selectRegDst(inst,ComputeType, MemType, BinaryType, RegDst);

  // ports
  input wire [15:0] inst;
  input ComputeType, MemType, BinaryType;

  output reg [3:0] RegDst;
  
  
  // internal
  reg error;
  // ADD 0000
  // SUB 0001
  // XOR 0010
  // PADDSB 0111
  // RED 0011
  reg[2:0] combinedVector;

  
   
  always @(inst, ComputeType, MemType, BinaryType) begin
   combinedVector = {ComputeType, MemType, BinaryType};
    case (combinedVector)
      // Compute, LLB/LUB
      3'b100, 3'b011: begin
                  RegDst = inst[11:8];
                  error = 0;
             end
      // pure mem
      3'b010: begin
                  RegDst = inst[11:8];
                  error = 0;
             end
      default: error=1; // Default case 
    endcase
  end

 

endmodule

module selectRegData(ComputeType, MemType, BinaryType, ComputeData, MemData, BinaryData, regDataToWrite);
   input ComputeType, MemType, BinaryType;
   input [15:0] ComputeData, MemData, BinaryData;


   output reg [15:0] regDataToWrite;


    // internal
  reg error;
  reg[2:0] combinedVector;

   // always #20 $monitor("CombinedVec: %b, BinaryData: %b", combinedVector, BinaryData);
   
  always @(ComputeType, MemType, BinaryType, ComputeData, MemData, BinaryData) begin
   combinedVector = {ComputeType, MemType, BinaryType};
    case (combinedVector)
      // Compute
      3'b100: begin
                  regDataToWrite = ComputeData;
                  error = 0;
             end
      // pure mem
      3'b010: begin
                  regDataToWrite = MemData;
                  error = 0;
             end
      // LLB/LUB
      3'b011: begin
                  regDataToWrite = BinaryData;
                  error = 0;
             end
      default: error=1; // Default case 
    endcase
  end


endmodule

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

module decideBranch(flags, condition, branchTaken);
  input [2:0] flags, condition;
  output wire branchTaken;
  
  // Nflag, Vflag, Zflag
  wire Nflag, Vflag, Zflag, cond0, cond1, cond2, cond3, cond4, cond5, cond6, cond7;
  
  assign Zflag = flags[0];
  assign Vflag = flags[1];
  assign Nflag = flags[2];


  assign cond0 = (Zflag == 0) ? 1 : 0;
  assign cond1 = (Zflag == 1) ? 1 : 0;
  assign cond2 = (Zflag == 0 & Nflag == 0) ? 1 : 0;
  assign cond3 = (Nflag == 1) ? 1 : 0;
  assign cond4 = (Zflag == 1 | (Zflag == 0 & Nflag == 0)) ? 1 : 0;
  assign cond5 = (Nflag == 1 | Zflag == 1) ? 1 : 0;
  assign cond6 = (Vflag == 1) ? 1 : 0;
  assign cond7 = 1;

  assign branchTaken =  (condition == 3'b000) ? cond0 :
                        (condition == 3'b001) ? cond1 :
                        (condition == 3'b010) ? cond2 :
                        (condition == 3'b011) ? cond3 :
                        (condition == 3'b100) ? cond4 :
                        (condition == 3'b101) ? cond5 :
                        (condition == 3'b110) ? cond6 :
                        (condition == 3'b111) ? cond7 : 0;

endmodule

module PC_Control(instruction, curr_pc, new_pc, clk, rst_n, branchRegData, HLT, outPlus2PC, flags);

  //  always #50 $monitor("Curr PC: %d, Plus2PC: %d, B_PC: %d", intermediatePC, plus2PC, B_PC);
  input [15:0] instruction, curr_pc, branchRegData;
  input clk, rst_n, HLT;
  input [2:0] flags;

  output [15:0] new_pc, outPlus2PC;

  wire [15:0] plus2PC, B_PC, BR_PC, selectedPC, readPC;
  wire pcError, takeBranch, Zflag, Vflag, Nflag;
  

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

module flagWriteSelect(inst,flagZ_Write, flagV_Write, flagN_Write);

  // ports
  input wire [15:0] inst;
  output reg flagZ_Write, flagV_Write, flagN_Write;

  // internal
  reg error;
 
  always @(inst) begin
    case (inst[15:12])
      // Add,     Sub
      4'b0000, 4'b0001: begin
                  flagZ_Write = 1;
                  flagV_Write = 1;
                  flagN_Write = 1;
                  error = 0;
             end
      // XOR,     SLL,    SRA,      ROR
      4'b0010, 4'b0100, 4'b0101, 4'b0110: begin
                  flagZ_Write = 1;
                  flagV_Write = 0;
                  flagN_Write = 0;
                  error = 0;
             end
      
      default: begin
        // every other instruction cannot change flags
        flagZ_Write = 0;
        flagV_Write = 0;
        flagN_Write = 0;
        error=1; // Default case

      end 
    endcase
  end

 

endmodule


module cpu(clk, rst_n, hlt, pc_out);
   
   // ports
   input clk, rst_n;
   output hlt;
   output [15:0] pc_out;

  // internal
   wire[15:0] internalPC, PCS_PC;
   
   // CPU
   wire [15:0] currInstruction;
   wire [3:0] opCode;

   // flag in/out, and indvidual flags
   wire [2:0] flagIn, flags;
   wire Zflag, Vflag, Nflag;


   // regStuff
   wire[3:0] srcReg1, srcReg2, dstReg;
   wire[15:0] regData1, regData2;
   wire[15:0] regDataToWrite;
   
   // immeditaes
   wire[7:0] binaryImm;
   wire[3:0] genImm;

   // control
   wire writeReg, readReg1, readReg2, memRead, memWrite, ComputeType, MemType, BinaryType, BranchType, HLT, flagZ_Write, flagV_Write, flagN_Write;
   wire [2:0] flagWriteVec;
   

   // data
   wire[15:0] llb_data, lhb_data, ALU_Data, Shift_Data, Compute_Data, BinaryData, MemDataIn, MemData;
   
   // mem address calcuations 
   wire[15:0] memAddressPart1, memAddressPart2, memAddress;
   
   // Error
   wire ALUError, memError;
  //  always #50 $monitor("Inst: %b, readReg1: %b, writeReg: %b, memRead: %b, memWrite: %b, MemType: %b, MemAddress: %b, MemDataIn: %b, MemDataOut: %b", currInstruction, readReg1, writeReg, memRead, memWrite, MemType, memAddress, MemDataIn, MemData);
    // always #50 $monitor("Inst: %b, readReg2: %b, writeReg: %b, memRead: %b, memWrite: %b, MemType: %b, MemAddress: %b, MemDataOut: %b", currInstruction, readReg2, writeReg, memRead, memWrite, MemType, memAddress, MemData);
    // always #50 $monitor("Inst: %b, readReg2: %b, regSrc2: %b, writeReg: %b, regDst: %b, memRead: %b, memWrite: %b, MemType: %b", currInstruction, readReg2, srcReg2, writeReg, dstReg, memRead, memWrite, MemType);


   PC_Control PC_C(.curr_pc(internalPC), .new_pc(internalPC), .clk(clk), .rst_n(rst_n), .HLT(HLT), .instruction(currInstruction), .branchRegData(regData1), .outPlus2PC(PCS_PC), .flags(flags));
   flagWriteSelect fws(.inst(currInstruction), .flagZ_Write(flagZ_Write), .flagV_Write(flagV_Write), .flagN_Write(flagN_Write));
   assign flagWriteVec = {flagN_Write, flagV_Write, flagZ_Write};
   

   // Instruction memory
   memory1c Imem(.addr(internalPC), .data_out(currInstruction),.clk(clk), .rst(~rst_n), .enable(1'b1), .wr(1'b0));
   
   // Data Memory
   dataMemory Dmem(.addr(memAddress), .data_in(MemDataIn), .data_out(MemData), .enable(memRead), .wr(memWrite), .clk(clk), .rst(~rst_n));
   
   // get op code from instruction
   assign opCode = currInstruction[15:12];


   // assign immediates
   assign binaryImm = currInstruction[7:0];
   assign genImm = currInstruction[3:0];
   
   // calcuate memAddressTarget and data to be stored
   assign memAddressPart1 =  regData2 & 16'hFFFE;
   assign memAddressPart2 = {{13{genImm[3]}}, genImm} << 1;
   addsub_16bit memAdder(.A(memAddressPart1), .B(memAddressPart2), .sub(1'b0), .Sum(memAddress), .Ovfl(memError));
   assign MemDataIn = regData1;

   // llb and lhb calcuation -> Then assign one to BinaryData
   assign llb_data = (regData1 & 16'hFF00) | binaryImm;
   assign lhb_data = (regData1 & 16'h00FF) | (binaryImm << 8);
   assign BinaryData = (opCode == 4'b1010) ? llb_data: lhb_data;

   // ALU
   ALU alu(.ALU_In1(regData1), .ALU_In2(regData2), .Opcode(opCode), .ALU_Out(ALU_Data), .Error(ALUError), .imm(genImm));
   assign Compute_Data = (opCode == 4'b1110) ? PCS_PC : ALU_Data;
   
    // set flags
    assign Zflag = (ALU_Data == 0) ? 1 : 0;
    assign Vflag = ALUError;
    assign Nflag = (ALU_Data[15] == 1) ? 1 : 0;
   
   // set control signals
   controlUnit CU(.opCode(opCode),.rst_n(rst_n), .writeReg(writeReg), .readReg1(readReg1), .readReg2(readReg2), .memWrite(memWrite), .memRead(memRead), .ComputeType(ComputeType), .MemType(MemType), .BinaryType(BinaryType), .BranchType(BranchType), .HLT(HLT));

   // select regSources
   selectRegSource srs(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), .MemType(MemType), .BranchType(BranchType), .srcReg1(srcReg1), .srcReg2(srcReg2));
   
   // select regDst
   selectRegDst sld(.inst(currInstruction), .ComputeType(ComputeType), .RegDst(dstReg), .MemType(MemType), .BinaryType(BinaryType));
   
   // select regData
   selectRegData srd(.ComputeType(ComputeType), .MemType(MemType), .BinaryType(BinaryType), .ComputeData(Compute_Data), .MemData(MemData), .BinaryData(BinaryData), .regDataToWrite(regDataToWrite));

   // register files
   RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg), .WriteReg(writeReg), .DstData(regDataToWrite), .SrcData1(regData1), .SrcData2(regData2));
   FlagRegister fr(.clk(clk), .rst(~rst_n), .D({Nflag, Vflag, Zflag}), .WriteReg(flagWriteVec), .ReadEnable1(1'b1), .Bitline1(flags));

  // always #50 $monitor("Current Instruction: %b, InternalPC: %b, flags(N,V,Z): %b, ALU_Error: %b, writeEnable: %b, regDst: %b, dstData: %b, srcReg1: %b, regData1: %b, srcReg2: %b, regData2: %b, MemAddress: %b,  MemDataIn: %b , MemDataOut: %b\n", currInstruction, internalPC, flags, ALUError, writeReg, dstReg, regDataToWrite, srcReg1, regData1, srcReg2, regData2, memAddress, MemDataIn, MemData);
  //  always #50 $monitor("Inst: %b, llb_data: %b, lhb_data: %b, regDataToWrite: %b",currInstruction, llb_data, lhb_data, regDataToWrite);
  //  always #50 $monitor("Inst: %b, compute_data: %b, regDataToWrite: %b",currInstruction, Compute_Data, regDataToWrite);
  //  always #50 $monitor("Inst: %b, MemRead: %b, MemWrite: %b, MemAddress: %b, MemData: %b, RegSrc: %b, RegSrcData %b, regDataToWrite: %b",currInstruction, memRead, memWrite, memAddress, MemData, srcReg1,regData1, regDataToWrite);
  // always #50 if (opCode == 4'b1111) $finish;

   assign pc_out = internalPC;
   assign hlt = HLT;
   
endmodule


// module basic(hlt, pc);

//     reg clk, rst_n;
//     output wire hlt;
//     output wire[15:0] pc;
//     initial clk = 0;
//     always #20 clk = ~clk;

//     CPU uut (
//       .clk(clk),
//       .rst_n(rst_n),
//       .hlt(hlt),
//       .pc(pc)
//    );

//     // Test procedure
//    always begin
//       #20;
//       rst_n = 1;
//       #20;
//       rst_n = 0;
//       // $display("Running CPU testbench...");
//       #400;




//       $finish;
//    end

// endmodule


// module PCSelect(opCode, plus2_Target, B_Target, BR_Target, clk, target_pc);

//   // ports
//   input clk;
//   input wire [3:0] opCode;
//   input wire [15:0] plus2_Target, B_Target, BR_Target;
//   output reg [15:0] target_pc;
//   // output reg writeReg, readReg1, readReg2, ComputeType, MemType, BinaryType, HLT;
  
//   // internal
//   reg error;
  
  
//   always @(opCode, clk) begin
//     case (opCode)
//       // B
//       4'b1100: begin
//                 target_pc = B_Target;
//                 error = 0;
//              end
      
//       default: begin
//                   error=1; // Default case
//                   target_pc =  plus2_Target;
//                 end
//     endcase
//   end

// endmodule

// module haltLogic(opCode, HLT, clk);
//   input [3:0] opCode;
//   input clk;
//   output reg HLT;

//   // always #50 $monitor("OpCode: %b, Case1: %d, Case2: %d", opCode, case1, case2);
//   reg error, case1, case2;
//   always @(opCode, clk) begin
//     case (opCode)
//       4'b1111: begin
//                 case1 = 1; 
//                 error = 0;
//                 HLT = 1;
//              end
//       default: begin
//       HLT = 0;
//       error=1; // Default case 
//       end
//     endcase
//   end
// endmodule

 // // MemType
  // // LLB 1010
  // always @(ComputeType, inst) begin
  //   case (ComputeType)
  //     // Compute type - RD = [11:8]
  //     1'b1: begin
  //               error = 0;
  //               RegDst = inst[11:8];
  //            end
  //     default: error=1; // Default case 
  //   endcase
  // end


  // always @(MemType, inst) begin
  //   case (MemType)
  //     // Compute type - RD = [11:8]
  //     1'b1: begin
  //               error = 0;
  //               RegDst = inst[11:8];
  //            end
  //     default: error=1; // Default case 
  //   endcase
  // end