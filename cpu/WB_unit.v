module WB_unit(memToReg, MemData, ALUData, dstReg);

    // Ports
    input memToReg;
    input [15:0] MemData, ALUData;
    output [15:0] dstReg;

    assign dstReg = (memToReg) ? MemData : ALUData;

endmodule