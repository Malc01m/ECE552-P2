module WB_unit(memToReg, regSel, MemData, memAddress);

    // Ports
    input memToReg;
    input [15:0] regSel, MemData, memAddress;
    output [15:0] dstReg;

    assign dstReg = (memToReg) ? MemData : memAddress;

endmodule