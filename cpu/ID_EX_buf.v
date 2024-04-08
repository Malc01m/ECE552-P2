module ID_EX_buf(PCS_PC_ID, PCS_PC_EX, regData1_ID, regData1_EX, regData2_ID, regData2_EX, clk, rst_n);
    
    input clk, rst_n;
    input [15:0] regData1_ID, regData2_ID, PCS_PC_ID;
    output [15:0] regData1_EX, regData2_EX, PCS_PC_EX;

    dff regData1Reg [15:0] (.q(regData1_EX), .d(regData1_ID), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff regData2Reg [15:0] (.q(regData2_EX), .d(regData2_ID), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff pcs_pcReg [15:0] (.q(PCS_PC_EX), .d(PCS_PC_ID), .wen(1'b1), .clk(clk), .rst(~rst_n));

endmodule