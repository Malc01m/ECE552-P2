`include "../memory/memory.v"
`include "../RegisterFile/RegisterFile.v"

// P2 CPU

module cpu(clk, rst_n, hlt, pc_out);

   // ports
   input clk, rst_n;
   output hlt;
   output [15:0] pc_out;

   // IF
   wire [0:15] currInstruction_IF;

   IF_unit IF(.clk(clk), .rst_n(rst_n), .currInstruction(currInstruction_IF));

   // IF/ID buffer
   IF_ID_buf IFIDbuf();

   // ID
   ID_unit ID();

   // ID/EX buffer
   ID_EX_buf IDEXbuf();

   // EX
   EX_unit EX();

   // EX/MEM buffer
   EX_MEM_buf EXMEMbuf();

   // MEM
   MEM_unit MEM();

   // MEM/WB buffer
   MEM_WB_buf MEMWBbuf();

   // WB
   WB_unit WB();

   // Hazard detection unit
   hazardUnit hazdetect();

   // Forwarding unit
   forwardingUnit fw();

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