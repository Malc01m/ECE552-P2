module ID_unit(clk, rst_n, flushIF, currInstruction, PCS_PC_ID, writeReg_WB, dstReg_WB, writeReg_ID, 
    regDataToWrite, regData1, regData2, regDst1, regDst2, B_PC);

    // Ports
    input clk, rst_n, writeReg_WB;
    input [3:0] dstReg_WB;
    input [15:0] currInstruction, regDataToWrite, PCS_PC_ID;
    output writeReg_ID, flushIF;
    output [15:0] regData1, regData2, regDst1, regDst2, B_PC;

    // Internal
    wire [3:0] opCode;
    wire ComputeType, BinaryType, MemType, BranchType, memRead, memWrite, 
        readReg1, readReg2;
    wire [15:0] imm;
    wire [9:0] temp;
    reg [3:0] srcReg1, srcReg2, dstReg;
    reg [15:0] Compute_Data;

    // Extract opcode
    assign opCode = currInstruction[15:12];

    // Extract possible destination registers
    assign regDst1 = currInstruction[20:16];
    assign regDst2 = currInstruction[15:11];

    // set control signals
    // TODO: add flushIF
    controlUnit CU(.opCode(opCode), .rst_n(rst_n), .writeReg(writeReg_ID), .readReg1(readReg1), 
        .readReg2(readReg2), .memWrite(memWrite), .memRead(memRead), .ComputeType(ComputeType), 
        .MemType(MemType), .BinaryType(BinaryType), .BranchType(BranchType));

    // select regSources
    selectRegSource srs(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), 
        .MemType(MemType), .BranchType(BranchType), .srcReg1(srcReg1), .srcReg2(srcReg2));

    // register files
    RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg_WB), 
        .WriteReg(writeReg_WB), .DstData(regDataToWrite), .SrcData1(regData1), .SrcData2(regData2));

    // calc branch
    // TODO: I don't think this is right anymore for P2. Will fix.
    assign temp = currInstruction[8:0] << 1; 
    assign imm = {{7{temp[8]}}, temp};

    addsub_16bit branchAdder_2(.A(PCS_PC_ID), .B(imm), .sub(1'b0), .Sum(B_PC));
    
    // see if branch taken or not
    decideBranch db(.flags(flags), .condition(instruction[11:9]), .branchTaken(takeBranch));

endmodule