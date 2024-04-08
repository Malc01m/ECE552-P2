module EX_EX_fwd_unit(ExSrcReg, MemDstReg, MemRegWrite, MemComputeData, FwdReg);
    input [3:0] ExSrcReg, MemDstReg;
    input MemRegWrite;
    input [15:0] MemComputeData;
    output [15:0] FwdReg;

    assign FwdReg = (ExSrcReg == MemDstReg & MemRegWrite == 1 & MemDstReg !== 4'b0000) ? MemComputeData : 16'b0;
endmodule
