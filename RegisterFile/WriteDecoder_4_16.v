module WriteDecoder_4_16(RegId, WriteReg, Wordline);

  input [3:0] RegId;
  input WriteReg;
  output [15:0] Wordline;

  wire[15:0] expandedRegID;
  Decoder_4_16 decoder(.In(RegId), .Out(expandedRegID));

  assign Wordline = (WriteReg == 1) ? expandedRegID: 16'b0000000000000000;

endmodule