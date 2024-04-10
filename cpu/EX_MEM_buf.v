module EX_MEM_buf(clk, rst_n, MemDataIn_MEM, ALU_Data_MEM, regSel_MEM, writeReg_MEM, regDst_MEM, 
    memToReg_MEM, memRead_MEM, memWrite_MEM, MemDataIn_EX, ALU_Data_EX, regSel_EX, writeReg_EX, 
    regDst_EX, memToReg_EX, memRead_EX, memWrite_EX);

    input clk, rst_n, regSel_EX, memWrite_EX, writeReg_EX, memToReg_EX, memRead_EX;
    input [3:0] regDst_EX;
    input [15:0] MemDataIn_EX, ALU_Data_EX;
    output regSel_MEM, memWrite_MEM, writeReg_MEM, memToReg_MEM, memRead_MEM;
    output [3:0] regDst_MEM;
    output [15:0] MemDataIn_MEM, ALU_Data_MEM;

    dff MemDataInReg [15:0] (.q(MemDataIn_MEM), .d(MemDataIn_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff ALUDataReg [15:0] (.q(ALU_Data_MEM), .d(ALU_Data_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff regDstReg [3:0] (.q(regDst_MEM), .d(regDst_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff regSelReg (.q(regSel_MEM), .d(regSel_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff memWriteReg (.q(memWrite_MEM), .d(memWrite_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff writeRegReg (.q(writeReg_MEM), .d(writeReg_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff memToRegReg (.q(memToReg_MEM), .d(memToReg_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff memReadReg (.q(memRead_MEM), .d(memRead_EX), .wen(1'b1), .clk(clk), .rst(~rst_n));

endmodule