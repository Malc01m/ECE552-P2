module RegisterFile(clk, rst, WriteReg, SrcReg1, SrcReg2, DstReg, DstDat, SrcData1, SrcData2);
    input clk, rst, WriteReg;
    input [3:0] SrcReg1, SrcReg2, DstReg;
    input [15:0] DstDat;
    inout [15:0] SrcData1, SrcData2;

    wire [15:0] SrcReg1_dec, SrcReg2_dec, DstReg_dec;

    ReadDecoder_4_16 read_dec_1(.RegId(SrcReg1), .Wordline(SrcReg1_dec));
    ReadDecoder_4_16 read_dec_2(.RegId(SrcReg2), .Wordline(SrcReg2_dec));
    WriteDecoder_4_16 write_dec(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(DstReg_dec));
   
    Register register[15:0](.clk(clk), .rst(rst), .WriteReg(DstReg_dec), 
        .ReadEnable1(SrcReg1_dec), .ReadEnable2(SrcReg2_dec), .D(DstDat), 
        .Bitline1(SrcData1), .Bitline2(SrcData2));

endmodule