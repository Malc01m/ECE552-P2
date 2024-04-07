module ID_unit(clk, rst_n, HLT, currInstruction, writeReg_WB, dstReg_WB, writeReg_ID, dstReg_ID, 
    regDataToWrite, regData1, regData2);

    // Ports
    input clk, rst_n, writeReg_WB;
    input [15:0] currInstruction, regDataToWrite, dstReg_WB;
    output writeReg_ID, HLT;
    output [15:0] regData1, regData2, dstReg_ID;

    // Internal
    wire [3:0] opCode;
    wire ComputeType, BinaryType, MemType, BranchType, memRead, memWrite, 
        readReg1, readReg2;
    reg [3:0] srcReg1, srcReg2, dstReg;
    reg [15:0] Compute_Data;

    // Extract opcode
    assign opCode = currInstruction[15:12];

    // set control signals
    controlUnit CU(.opCode(opCode), .rst_n(rst_n), .writeReg(writeReg_ID), .readReg1(readReg1), 
        .readReg2(readReg2), .memWrite(memWrite), .memRead(memRead), .ComputeType(ComputeType), 
        .MemType(MemType), .BinaryType(BinaryType), .BranchType(BranchType), .HLT(HLT));

    // select regSources
    selectRegSource srs(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), 
        .MemType(MemType), .BranchType(BranchType), .srcReg1(srcReg1), .srcReg2(srcReg2));

    // select regDst
    selectRegDst sld(.inst(currInstruction), .ComputeType(ComputeType), .RegDst(dstReg_ID), 
        .MemType(MemType), .BinaryType(BinaryType));

    // register files
    RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg_WB), 
        .WriteReg(writeReg_WB), .DstData(regDataToWrite), .SrcData1(regData1), .SrcData2(regData2));

endmodule