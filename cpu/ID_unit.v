module ID_unit(clk, rst_n, currInstruction, PC_plus4, PC_plusImm, I_ext, writeReg_WB, dstReg_WB, writeReg_ID, 
    regDataToWrite, regSel, PCSel, regData1, regData2, regDst1, regDst2);

    // Ports
    input clk, rst_n, writeReg_WB;
    input [3:0] dstReg_WB;
    input [15:0] currInstruction, regDataToWrite, PC_plus4;
    output writeReg_ID, regSel, PCSel;
    output [15:0] regData1, regData2, regDst1, regDst2, I_ext, PC_plusImm;

    // Internal
    wire ComputeType, BinaryType, MemType, BranchType, memRead, memWrite, 
        readReg1, readReg2;
    wire [15:0] I_ext_shft;
    reg [3:0] srcReg1, srcReg2, dstReg;
    reg [15:0] Compute_Data;

    // Extract possible destination registers
    // TODO: Is this the right order?
    assign regDst1 = currInstruction[11:8];
    assign regDst2 = currInstruction[8:5];

    // set control signals
    controlUnit control(.opCode(currInstruction[15:12]), .rst_n(rst_n), .writeReg(writeReg_ID), .readReg1(readReg1), 
        .readReg2(readReg2), .memWrite(memWrite), .memRead(memRead), .ComputeType(ComputeType), 
        .MemType(MemType), .BinaryType(BinaryType), .BranchType(BranchType));
    
    // calc branch control signal
    PC_control pc_control(.C(currInstruction[11:9]), .F(flags), .I(currInstruction[8:0]), .doBranch(doBranch));
    assign PCSel = (doBranch & (currInstruction[15:12] == 4'b1100)) ? 1'b1 : 1'b0;

    // Sign extend to 16 bit for adder input
    assign I_ext = {{7{currInstruction[8]}}, currInstruction[8:0]};
    assign I_ext_shft = {I_ext[13:0], 2'b00};
    addsub_16bit add_I(.Sum(PC_plusImm), .Sub(1'b0), .Ovfl(), .A(PC_plus4), .B(I_ext_shft));

    // select regSources
    selectRegSource selRegSrc(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), 
        .MemType(MemType), .BranchType(BranchType), .srcReg1(srcReg1), .srcReg2(srcReg2));

    selectRegDst selRegDst(.inst(currInstruction), .ComputeType(ComputeType), .BinaryType(BinaryType), 
        .MemType(MemType), .RegDst(regSel));

    // register files
    RegisterFile regFile(.clk(clk), .rst(~rst_n), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(dstReg_WB), 
        .WriteReg(writeReg_WB), .DstData(regDataToWrite), .SrcData1(regData1), .SrcData2(regData2));
    
    // see if branch taken or not
    // TODO: Deal with flags, takeBranch
    decideBranch db(.flags(flags), .condition(currInstruction[11:9]), .branchTaken(takeBranch));

endmodule