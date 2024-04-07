module IF_unit(clk, rst_n, currInstruction, PCS_PC);

    input clk, rst_n;
    output [15:0] currInstruction;
    output PCS_PC;

    /* Signals
    internalPC
    HLT
    regData1
    flags
    */

    PC_Control PC_C(.curr_pc(internalPC), .new_pc(internalPC), .clk(clk), .rst_n(rst_n), .HLT(HLT), 
        .instruction(currInstruction), .branchRegData(regData1), .outPlus2PC(PCS_PC), .flags(flags));

    // Instruction memory
    memory1c Imem(.addr(internalPC), .data_out(currInstruction), .clk(clk), .rst(~rst_n), .enable(1'b1), 
        .wr(1'b0));

endmodule