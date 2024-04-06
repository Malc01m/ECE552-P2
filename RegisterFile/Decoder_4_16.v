module Decoder_4_16(In, Out);

  input [3:0] In;
  output [15:0] Out;

  wire A0, A1, A2, A3;
  wire [7:0] lower, upper;

  assign A0 = In[0];
  assign A1 = In[1];
  assign A2 = In[2];
  assign A3 = In[3];

  Decoder_3_8 d1(.A0(A0), .A1(A1), .A2(A2), .Out(lower));
  Decoder_3_8 d2(.A0(A0), .A1(A1), .A2(A2), .Out(upper));

  assign Out[7:0] = (A3 == 1) ? 0:  lower;
  assign Out[15:8] = (A3 == 0) ? 0: upper;

endmodule