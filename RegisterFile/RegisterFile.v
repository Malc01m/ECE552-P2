module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

  // ports
  input clk, rst;
  input [3:0] SrcReg1, SrcReg2, DstReg;
  input WriteReg;
  input [15:0] DstData;
  inout [15:0] SrcData1, SrcData2;

  // internal
  wire[15:0] expandedWriteReg, expandedReadReg1, expandedReadReg2;

  WriteDecoder_4_16 wd(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(expandedWriteReg));
  ReadDecoder_4_16 rd1(.RegId(SrcReg1),.Wordline(expandedReadReg1));
  ReadDecoder_4_16 rd2(.RegId(SrcReg2),.Wordline(expandedReadReg2));

  Register rs[15:0](.clk(clk), .rst(rst), .D(DstData), .WriteReg(expandedWriteReg), 
    .ReadEnable1(expandedReadReg1), .ReadEnable2(expandedReadReg2), .Bitline1(SrcData1), 
    .Bitline2(SrcData2));

endmodule