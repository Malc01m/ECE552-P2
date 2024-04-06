module Decoder_3_8(A0, A1, A2, Out);
    
    input A0, A1, A2;
    output [7:0] Out;
    
    Decoder_2_4 d1(.A0(A0), .A1(A1), .E(~A2), .Out(Out[3:0]));
    Decoder_2_4 d2(.A0(A0), .A1(A1), .E(A2), .Out(Out[7:4]));

endmodule