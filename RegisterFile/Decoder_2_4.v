module Decoder_2_4(A0, A1, E, Out);
    
    input A0, A1, E;
    output [3:0] Out;
    
    assign Out[0] = (E == 0) ? 0: (~A0) & (~A1);
    assign Out[1] = (E == 0) ? 0: (A0) & (~A1);
    assign Out[2] = (E == 0) ? 0: (~A0) & (A1);
    assign Out[3] = (E == 0) ? 0: (A0) & (A1);

endmodule 