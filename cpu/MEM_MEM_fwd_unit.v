module MEM_MEM_fwd_unit(MemSrcReg1, WBDstReg, WBRegWrite, WBOpCode, Forward);
    input [3:0] MemSrcReg1, WBDstReg, WBOpCode;
    input WBRegWrite;
    output Fwd;

    assign Fwd = (MemSrcReg1 == WBDstReg & WBRegWrite == 1 & WBDstReg !== 4'b0000 & WBOpCode == 4'b1000) ? 1 : 0;
endmodule
