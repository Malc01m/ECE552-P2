module ID_EX_buf(regData1_ID, regData1_EX, regData2_ID, regData2_EX, clk, rst_n, stall);
    
    input clk, rst_n, stall;
    input [15:0] regData1_ID, regData2_ID;
    output [15:0] regData1_EX, regData2_EX;

    dff regData1Reg [15:0] (.q(regData1_EX), .d(regData1_ID), .wen(~stall), .clk(clk), .rst(~rst_n));
    dff regData2Reg [15:0] (.q(regData2_EX), .d(regData2_ID), .wen(~stall), .clk(clk), .rst(~rst_n));

endmodule