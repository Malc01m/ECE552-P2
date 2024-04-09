module EX_unit(clk, rst_n, regSel, regData1, regData2, memAddr, WB_Data, regDst1, regDst2, 
    regData1_Sel, regData2_Sel, ALU_Data, regDst);

    // Ports
    input clk, rst_n, regSel;
    input [15:0] regData1, regData2, memAddr, WB_Data;
    input [3:0] regDst1, regDst2, regData1_Sel, regData2_Sel;
    output [3:0] regDst;
    output [15:0] ALU_Data;

    // Internal
    wire ALUError;
    wire [15:0] regData1Out, regData2Out;

    assign regDst = (regSel) ? regDst2 : regDst1;
    Mux_3to1_16bit reg1Mux(.I0(regData1), .I1(WB_Data), .I2(memAddr), .Select(regData1_Sel), .Out(regData1Out));
    Mux_3to1_16bit reg2Mux(.I0(regData2), .I1(WB_Data), .I2(memAddr), .Select(regData2_Sel), .Out(regData2Out));
    
    // ALU
    ALU alu(.ALU_In1(regData1Out), .ALU_In2(regData2Out), .Opcode(opCode), .ALU_Out(ALU_Data), .Error(ALUError), 
        .imm(genImm));

endmodule