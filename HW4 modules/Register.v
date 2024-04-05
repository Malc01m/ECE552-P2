module Register(clk, rst, WriteReg, ReadEnable1, ReadEnable2, D, Bitline1, Bitline2);
    input clk, rst, WriteReg, ReadEnable1, ReadEnable2;
    input [15:0] D;
    inout [15:0] Bitline1, Bitline2;
    wire bypass1, bypass2;
    wire [15:0] Bitline1_reg, Bitline2_reg;

    and bp_and1(bypass1, WriteReg, ReadEnable1);
    and bp_and2(bypass2, WriteReg, ReadEnable2);

    assign Bitline1 = (bypass1) ? D : Bitline1_reg;
    assign Bitline2 = (bypass2) ? D : Bitline2_reg;

    BitCell bit_cell[15:0](.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), 
        .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), 
        .Bitline1(Bitline1_reg), .Bitline2(Bitline2_reg));

endmodule