module IF_unit(clk, rst_n, takeBranch, currInstruction, lastInstruction, PCS_PC, BR_PC, B_PC);

    // Ports
    input clk, rst_n, takeBranch;
    input [15:0] BR_PC, B_PC, lastInstruction;
    output [15:0] currInstruction, PCS_PC;

    // Internal
    wire [3:0] opCode;
    wire [15:0] readPC;
    wire hlt_fetched, b_fetched, br_fetched;

    /*
    "The HLT instruction should raise the ‘hlt’ signal only when it reaches the writeback stage. 
    In the IF stage, you need to check for HLT instructions. If you fetch a HLT instruction, you 
    must prevent the PC from being updated, thus stopping the program from fetching beyond the HLT
    instruction. The only exception is when the HLT instruction is fetched immediately after a taken
    branch: in this case, the HLT instruction is part of the wrong predict-not-taken branch path and 
    will be flushed, thus the PC should be updated to the branch target address as usual."
    */

    assign opCode = currInstruction[15:12];
    assign hlt_fetched =    (opCode == 4'b1111);
    assign b_fetched =      (opCode == 4'b1100);
    assign br_fetched =     (opCode == 4'b1101);

    assign last_opCode = lastInstruction[15:12];
    assign b_taken =        (last_opCode == 4'b1100);
    assign br_taken =       (last_opCode == 4'b1101);

    // Decide between halt, B address, BR Address, and PC+2
    assign selectedPC = ((hlt_fetched) & (b_taken))     ? B_PC :    // B taken, update anyway
                        ((hlt_fetched) & (br_taken))    ? BR_PC :   // BR taken, update anyway
                        (hlt_fetched)                   ? readPC :  // prevent the PC from being updated
                        (b_fetched & takeBranch)        ? B_PC : 
                        (br_fetched & takeBranch)       ? BR_PC : PCS_PC;
    
    // add four to curr pc
    addsub_16bit pcAdder(.A(selectedPC), .B(16'd2), .sub(1'b0), .Sum(PCS_PC), .Ovfl(pcError));

    // PC register
    PC_Register pc(.clk(clk), .rst(~rst_n), .D(selectedPC), .WriteReg(1'b1), .ReadEnable1(1'b1), 
        .Bitline1(readPC));

    // Instruction memory
    memory1c Imem(.addr(selectedPC), .data_out(currInstruction), .clk(clk), .rst(~rst_n), .enable(1'b1), 
        .wr(1'b0));

endmodule