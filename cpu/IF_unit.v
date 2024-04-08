module IF_unit(clk, rst_n, PCSrc, currInstruction, PC_plusImm, PC_plus4);

    // Ports
    input clk, rst_n, PCSrc;
    input [15:0] PC_plusImm;
    output [15:0] currInstruction, PC_plus4;

    // Internal
    wire [3:0] opCode;
    wire [15:0] readPC;
    wire hlt_fetched;

    /*
    "The HLT instruction should raise the ‘hlt’ signal only when it reaches the writeback stage. 
    In the IF stage, you need to check for HLT instructions. If you fetch a HLT instruction, you 
    must prevent the PC from being updated, thus stopping the program from fetching beyond the HLT
    instruction. The only exception is when the HLT instruction is fetched immediately after a taken
    branch: in this case, the HLT instruction is part of the wrong predict-not-taken branch path and 
    will be flushed, thus the PC should be updated to the branch target address as usual."
    */

    assign opCode = currInstruction[15:12];
    assign hlt_fetched = (opCode == 4'b1111);

    // Decide between halt at current PC, PC_plusImm, and PC_plus4
    assign selectedPC = (hlt_fetched & ~PCSrc) ? readPC
        : ((PCSrc) ? PC_plusImm : PC_plus4);
    
    // add four to curr pc
    addsub_16bit pcAdder(.A(readPC), .B(16'd4), .sub(1'b0), .Sum(PC_plus4), .Ovfl(pcError));

    // PC register
    PC_Register pc(.clk(clk), .rst(~rst_n), .D(selectedPC), .WriteReg(1'b1), .ReadEnable1(1'b1), 
        .Bitline1(readPC));

    // Instruction memory
    memory1c Imem(.addr(readPC), .data_out(currInstruction), .clk(clk), .rst(~rst_n), .enable(1'b1), 
        .wr(1'b0));

endmodule