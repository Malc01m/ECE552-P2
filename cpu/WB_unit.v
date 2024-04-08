module WB_unit(memToReg, MemData, memAddress, dstReg);

    // Ports
    input memToReg;
    input [15:0] MemData, memAddress;
    output [15:0] dstReg;

    assign dstReg = (memToReg) ? MemData : memAddress;

endmodule