module IF_unit(clk, rst_n, currInstruction);

    input clk, rst_n;
    output [15:0] currInstruction;

    PC_Control PC_C(.curr_pc(internalPC), .new_pc(internalPC), .clk(clk), .rst_n(rst_n), .HLT(HLT), 
        .instruction(currInstruction), .branchRegData(regData1), .outPlus2PC(PCS_PC), .flags(flags));
    flagWriteSelect fws(.inst(currInstruction), .flagZ_Write(flagZ_Write), .flagV_Write(flagV_Write), 
        .flagN_Write(flagN_Write));
    assign flagWriteVec = {flagN_Write, flagV_Write, flagZ_Write};

    // Instruction memory
    memory1c Imem(.addr(internalPC), .data_out(currInstruction), .clk(clk), .rst(~rst_n), .enable(1'b1), 
        .wr(1'b0));

endmodule