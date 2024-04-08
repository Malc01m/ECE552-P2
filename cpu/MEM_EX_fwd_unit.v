module MEM_EX_fwd_unit(ExSrcReg, WBDstReg, WBRegWrite, WBComputeData, FwdReg);
    input [3:0] ExSrcReg, WBDstReg;
    input WBRegWrite;
    input [15:0] WBComputeData;
    output [15:0] FwdReg;

    assign FwdReg = (ExSrcReg == WBDstReg & WBRegWrite == 1 & WBDstReg !== 4'b0000) ? WBComputeData : 16'b0;
endmodule
