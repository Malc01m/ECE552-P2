`include "../memory/memory.v"
`include "../RegisterFile/RegisterFile.v"

// P2 CPU

module cpu(clk, rst_n, hlt, pc_out);

   // ports
   input clk, rst_n;
   output hlt;
   output [15:0] pc_out;

   // internal
   wire tookLastBranch;
   wire [15:0] BR_PC;
   // IF
   wire [15:0] currInstruction_IF, PC_plus4_IF;
   // ID
   wire [15:0] currInstruction_ID, regData1_ID, regData2_ID, regDst1_ID, regDst2_ID;
   wire regSel_ID, memToReg_ID, memRead_ID, memWrite_ID;
   // EX
   wire [15:0] regData1_EX, regData2_EX, regDst1_EX, regDst2_EX, ALU_Data_EX;
   wire regSel_EX, memToReg_EX, memRead_EX, memWrite_EX;
   // MEM
   wire memToReg_MEM, memRead_MEM, memWrite_MEM;
   wire [15:0] MemData_MEM, ALU_Data_MEM;
   // WB
   wire memToReg_WB;
   wire [15:0] MemData_WB, ALU_Data_WB, dstReg_WB;
   // hazards
   wire stall;
   // forwarding
   wire [15:0] regFwd1, regFwd2, MemMemFwd;

   // IF
   // Status: Complete
   IF_unit IF(.clk(clk), .rst_n(rst_n), .PCSrc(PCSrc), .PC_plus4(PC_plus4_IF), .currInstruction(currInstruction_IF), 
      .PC_plusImm(PC_plusImm));

   // IF/ID buffer
   // TODO: no-op on flush
   IF_ID_buf IFIDbuf(.clk(clk), .rst_n(rst_n), .flushIF(flushIF),
      .currInstruction_IF(currInstruction_IF), .PC_plus4_IF(PC_plus4_IF),
      .currInstruction_ID(currInstruction_ID), .PC_plus4_ID(PC_plus4_ID), .stall(stall));

   // ID
   // Status: Has issues with branches, working on it
   // "Branches should be resolved at the ID stage"
   // TODO: memToReg_ID, memRead_ID, memWrite_ID, PCSrc
   ID_unit ID(.clk(clk), .rst_n(rst_n), .currInstruction(currInstruction_ID), 
      .PC_plus4(PC_plus4_ID), .writeReg_WB(writeReg_WB), .dstReg_WB(dstReg_WB), .writeReg_ID(writeReg_ID), 
      .regDataToWrite(regDataToWrite), .regData1(regData1_ID), .regData2(regData2_ID), .regSel(regSel_ID), .PCSel(PCSrc),
      .regDst1(regDst1_ID), .regDst2(regDst2_ID), .PC_plusImm(PC_plusImm), .memRead(memRead_ID), .memWrite(memWrite_ID));

   // ID/EX buffer
   ID_EX_buf IDEXbuf(.clk(clk), .rst_n(rst_n),
      .regData1_ID(regData1_ID), .regData2_ID(regData2_ID), .regDst1_ID(regDst1_ID), .regDst2_ID(regDst2_ID), .regSel_ID(regSel_ID),
      .memToReg_ID(memToReg_ID), .memRead_ID(memRead_ID), .memWrite_ID(memWrite_ID), .writeReg_ID(writeReg_ID),
      .regData1_EX(regData1_EX), .regData2_EX(regData2_EX), .regDst1_EX(regDst1_EX), .regDst2_EX(regDst2_EX), .regSel_EX(regSel_EX),
      .memToReg_EX(memToReg_EX), .memRead(memRead_EX),    .memWrite(memWrite_EX),    .writeReg_EX(writeReg_EX), .stall(stall));

   // EX
   // Status: Complete
   EX_unit EX(.clk(clk), .rst_n(rst_n), .regSel(regSel_EX), .regData1(regData1_EX), .regData2(regData2_EX), 
      .memAddr(ALU_Data_MEM), .WB_Data(dstReg_WB), .regDst1(regDst1_EX), .regDst2(regDst2_EX), 
      .regData1_Sel(), .regData2_Sel(), .ALU_Data(ALU_Data_EX), .regDst(regDst_EX));

   // EX/MEM buffer
   EX_MEM_buf EXMEMbuf(.clk(clk), .rst_n(rst_n),
      .MemDataIn_MEM(MemDataIn_MEM), .ALU_Data_MEM(ALU_Data_MEM), .regSel_MEM(regSel_MEM), .writeReg_MEM(writeReg_MEM),
      .regDst_MEM(regDst_MEM), .memToReg_MEM(memToReg_MEM), .memRead_MEM(memRead_MEM), .memWrite_MEM(memWrite_MEM),
      .MemDataIn_EX(MemDataIn_EX),   .ALU_Data_EX(ALU_Data_EX),   .regSel_EX(regSel_EX),   .writeReg_EX(writeReg_EX), 
      .regDst_EX(regDst_EX),   .memToReg_EX(memToReg_EX),   .memRead_EX(memRead_EX), .memWrite_EX(memWrite_EX));

   // MEM
   // Status: Complete
   assign MemDataIn_MEM = MemMemFwd ? dstReg_WB : memToReg_MEM; // Forwarding purpose
   MEM_unit MEM(.clk(clk), .rst_n(rst_n), .MemDataIn(MemDataIn_MEM), .memAddress(ALU_Data_MEM), 
      .memRead(memRead_MEM), .memWrite(memWrite_MEM), .MemData(MemData_MEM));

   // MEM/WB buffer
   // Status: Not started
   MEM_WB_buf MEMWBbuf(.clk(clk), .rst_n(rst_n),
      .MemData_MEM(MemData_MEM), .ALU_Data_MEM(ALU_Data_MEM), .regSel_MEM(regSel_MEM), .writeReg_MEM(writeReg_MEM), 
      .regDst_MEM(regDst_MEM), .memToReg_MEM(memToReg_MEM),
      .MemData_WB(MemData_WB),   .ALU_Data_WB(ALU_Data_WB),   .regSel_WB(regSel_WB),   .writeReg_WB(writeReg_WB),  
      .regDst_WB(regDst_WB),   .memToReg_WB(memToReg_WB));

   // WB
   // Status: Complete
   WB_unit WB(.memToReg(memToReg_WB), .MemData(MemData_WB), .ALUData(ALU_Data_WB), .dstReg(dstReg_WB));

   // Hazard detection unit
   hazardUnit hazdetect(
    .writeRegSel_DX(regDst1_EX), // Destination register in Decode-Execute stage
    .writeRegSel_XM(regDst_EX), // Destination register in Execute-Memory stage
    .writeRegSel_MWB(dstReg_WB), // Destination register in Memory-WriteBack stage
    .readRegSel1(currInstruction_ID[11:8]),
    .readRegSel2(currInstruction_ID[8:5]),
    .regWrite_DX(writeReg_ID),
    .regWrite_XM(writeReg_EX),
    .regWrite_MWB(memToReg_WB), // Register write flag in Memory-WriteBack stage
    .stall(stall)
);

   // Forwarding unit
   forwardingUnit fw(
      .ExSrcReg1(regData1_EX),
      .ExSrcReg2(regData2_EX),
      .MemDstReg(regDst_MEM),
      .MemRegWrite(writeReg_MEM),
      .WBRegWrite(memToReg_WB), // Flag indicating register write in Write-Back stage
      .WBDstReg(dstReg_WB), // Destination register in Write-Back stage
      .WBComputeData(MemData_WB),
      .MemComputeData(MemData_MEM),
      .MemSrcReg1(ALU_Data_MEM),
      .WBOpCode(MemData_WB[15:12]), // I'm assuming this is the WB OPcode. not too sure honestly
      .FwdReg1(regFwd1),
      .FwdReg2(regFwd2),
      .MEM_MEM(MemMemFwd)
   );

endmodule

// P1 CPU

// module cpu(clk, rst_n, hlt, pc_out);

//    // ports
//    input clk, rst_n;
//    output hlt;
//    output [15:0] pc_out;

//    // internal
//    wire[15:0] internalPC, PCS_PC;

//    // CPU
//    wire [15:0] currInstruction;
//    wire [3:0] opCode;

//    // flag in/out, and indvidual flags
//    wire [2:0] flagIn, flags;
//    wire Zflag, Vflag, Nflag;

//    // regStuff
//    wire[3:0] srcReg1, srcReg2, dstReg;
//    wire[15:0] regData1, regData2;
//    wire[15:0] regDataToWrite;

//    // immeditaes
//    wire[7:0] binaryImm;
//    wire[3:0] genImm;

//    // control
//    wire writeReg, readReg1, readReg2;
//    wire memRead, memWrite; 
//    wire ComputeType, MemType, BinaryType, BranchType;
//    wire HLT;
//    wire flagZ_Write, flagV_Write, flagN_Write;
//    wire [2:0] flagWriteVec;

//    // data
//    wire [15:0] llb_data, lhb_data, ALU_Data, Shift_Data, Compute_Data, BinaryData, MemDataIn, MemData;

//    // mem address calcuations 
//    wire [15:0] memAddressPart1, memAddressPart2, memAddress;

//    // Error
//    wire ALUError, memError;
//    // always #50 $monitor("Inst: %b, readReg1: %b, writeReg: %b, memRead: %b, memWrite: %b, MemType: %b, MemAddress: %b, MemDataIn: %b, MemDataOut: %b", currInstruction, readReg1, writeReg, memRead, memWrite, MemType, memAddress, MemDataIn, MemData);
//    // always #50 $monitor("Inst: %b, readReg2: %b, writeReg: %b, memRead: %b, memWrite: %b, MemType: %b, MemAddress: %b, MemDataOut: %b", currInstruction, readReg2, writeReg, memRead, memWrite, MemType, memAddress, MemData);
//    // always #50 $monitor("Inst: %b, readReg2: %b, regSrc2: %b, writeReg: %b, regDst: %b, memRead: %b, memWrite: %b, MemType: %b", currInstruction, readReg2, srcReg2, writeReg, dstReg, memRead, memWrite, MemType);

//    PC_Control PC_C(.curr_pc(internalPC), .new_pc(internalPC), .clk(clk), .rst_n(rst_n), .HLT(HLT), 
//       .instruction(currInstruction), .branchRegData(regData1), .outPlus2PC(PCS_PC), .flags(flags));
//    flagWriteSelect fws(.inst(currInstruction), .flagZ_Write(flagZ_Write), .flagV_Write(flagV_Write), 
//       .flagN_Write(flagN_Write));
//    assign flagWriteVec = {flagN_Write, flagV_Write, flagZ_Write};

//    // Instruction memory
//    memory1c Imem(.addr(internalPC), .data_out(currInstruction),.clk(clk), .rst(~rst_n), .enable(1'b1), 
//       .wr(1'b0));

//    // Data Memory
//    dataMemory Dmem(.addr(memAddress), .data_in(MemDataIn), .data_out(MemData), .enable(memRead), .wr(memWrite), 
//       .clk(clk), .rst(~rst_n));

//    // get op code from instruction
//    assign opCode = currInstruction[15:12];

//    // assign immediates
//    assign binaryImm = currInstruction[7:0];
//    assign genImm = currInstruction[3:0];

//    // calcuate memAddressTarget and data to be stored
//    assign memAddressPart1 =  regData2 & 16'hFFFE;
//    assign memAddressPart2 = {{13{genImm[3]}}, genImm} << 1;
//    addsub_16bit memAdder(.A(memAddressPart1), .B(memAddressPart2), .sub(1'b0), .Sum(memAddress), 
//       .Ovfl(memError));
//    assign MemDataIn = regData1;

//    // llb and lhb calcuation -> Then assign one to BinaryData
//    assign llb_data = (regData1 & 16'hFF00) | binaryImm;
//    assign lhb_data = (regData1 & 16'h00FF) | (binaryImm << 8);
//    assign BinaryData = (opCode == 4'b1010) ? llb_data: lhb_data;

//    // ALU
//    ALU alu(.ALU_In1(regData1), .ALU_In2(regData2), .Opcode(opCode), .ALU_Out(ALU_Data), .Error(ALUError), 
//       .imm(genImm));
//    assign Compute_Data = (opCode == 4'b1110) ? PCS_PC : ALU_Data;

//    // set flags
//    assign Zflag = (ALU_Data == 0) ? 1 : 0;
//    assign Vflag = ALUError;
//    assign Nflag = (ALU_Data[15] == 1) ? 1 : 0;

//    // set control signals
//    controlUnit CU(.opCode(opCode),.rst_n(rst_n), .writeReg(writeReg), .readReg1(readReg1), .readReg2(readReg2), 
//       .memWrite(memWrite), .memRead(memRead), .ComputeType(ComputeType), .MemType(MemType), 
//       .BinaryType(BinaryType), .BranchType(BranchType), .HLT(HLT));

//    // select regSources
//    selectRegSource srs(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), 
//       .MemType(MemType), .BranchType(BranchType), .srcReg1(srcReg1), .srcReg2(srcReg2));

//    // select regDst
//    selectRegDst sld(.inst(currInstruction), .ComputeType(ComputeType), .RegDst(dstReg), .MemType(MemType), 
//       .BinaryType(BinaryType));

//    // select regData
//    selectRegData srd(.ComputeType(ComputeType), .MemType(MemType), .BinaryType(BinaryType), 
//       .ComputeData(Compute_Data), .MemData(MemData), .BinaryData(BinaryData), .regDataToWrite(regDataToWrite));

//    // register files
//    RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg), 
//       .WriteReg(writeReg), .DstData(regDataToWrite), .SrcData1(regData1), .SrcData2(regData2));
//    FlagRegister fr(.clk(clk), .rst(~rst_n), .D({Nflag, Vflag, Zflag}), .WriteReg(flagWriteVec), 
//       .ReadEnable1(1'b1), .Bitline1(flags));

//    // always #50 $monitor("Current Instruction: %b, InternalPC: %b, flags(N,V,Z): %b, ALU_Error: %b, writeEnable: %b, regDst: %b, dstData: %b, srcReg1: %b, regData1: %b, srcReg2: %b, regData2: %b, MemAddress: %b,  MemDataIn: %b , MemDataOut: %b\n", currInstruction, internalPC, flags, ALUError, writeReg, dstReg, regDataToWrite, srcReg1, regData1, srcReg2, regData2, memAddress, MemDataIn, MemData);
//    // always #50 $monitor("Inst: %b, llb_data: %b, lhb_data: %b, regDataToWrite: %b",currInstruction, llb_data, lhb_data, regDataToWrite);
//    // always #50 $monitor("Inst: %b, compute_data: %b, regDataToWrite: %b",currInstruction, Compute_Data, regDataToWrite);
//    // always #50 $monitor("Inst: %b, MemRead: %b, MemWrite: %b, MemAddress: %b, MemData: %b, RegSrc: %b, RegSrcData %b, regDataToWrite: %b",currInstruction, memRead, memWrite, memAddress, MemData, srcReg1,regData1, regDataToWrite);
//    // always #50 if (opCode == 4'b1111) $finish;

//    assign pc_out = internalPC;
//    assign hlt = HLT;

// endmodule