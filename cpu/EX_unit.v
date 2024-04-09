module EX_unit(clk, rst_n, regSel, regData1, regData2, regDst1, regDst2, regDst);

    // Ports
    input clk, rst_n, regSel;
    input [15:0] regData1, regData2;
    input [3:0] regDst1, regDst2;
    output [3:0] regDst;

    // Internal
    wire ALUError;

    assign regDst = (regSel) ? regDst2 : regDst1;
    
    // ALU
    ALU alu(.ALU_In1(regData1), .ALU_In2(regData2), .Opcode(opCode), .ALU_Out(ALU_Data), .Error(ALUError), 
        .imm(genImm));

endmodule