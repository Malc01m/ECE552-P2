module FlagRegister(clk, rst, D, WriteReg, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    
    input clk;
    input rst;
    input [2:0] D, WriteReg;
    input ReadEnable1;
    input ReadEnable2;
    inout [2:0] Bitline1;
    inout [2:0] Bitline2;

    BitCell cells[2:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));

    // initial begin
    // #10;
    //     $monitor("Internal \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, bitline1: %b, bitline2: %b", WriteReg, ReadEnable1, ReadEnable2, clk, D, Bitline1, Bitline2);
    // end

endmodule