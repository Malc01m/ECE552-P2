module forwardingUnit(ExSrcReg1, ExSrcReg2, MemDstReg, MemRegWrite, WBRegWrite, WBDstReg, WBComputeData, MemComputeData, MemSrcReg1, WBOpCode, 
                      FwdReg1, FwdReg2, MEM_MEM);

    input [3:0] ExSrcReg1, ExSrcReg2, MemDstReg, WBDstReg, MemSrcReg1, WBOpCode;
    input MemRegWrite, WBRegWrite;
    input [15:0] WBComputeData, MemComputeData;

    output [15:0] FwdReg1, FwdReg2;
    output MEM_MEM;

    // Ex to Ex Forwarding Unit (2)
    EX_EX_fwd_unit EXEXfw1(ExSrcReg1, MemDstReg, MemRegWrite, MemComputeData, FwdReg1);
    EX_EX_fwd_unit EXEXfw2(ExSrcReg2, MemDstReg, MemRegWrite, MemComputeData, FwdReg2);
   
    // Mem to Ex Forwarding Unit (2)
    MEM_EX_fwd_unit MEMEXfw1(ExSrcReg1, WBDstReg, WBRegWrite, WBComputeData, FwdReg1);
    MEM_EX_fwd_unit MEMEXfw2(ExSrcReg2, WBDstReg, WBRegWrite, WBComputeData, FwdReg2);

    // Mem to Mem Forwarding Unit (1)
    MEM_MEM_fwd_unit MEMMEMfw(MemSrcReg1, WBDstReg, WBRegWrite, WBOpCode, MEM_MEM);
    
endmodule
