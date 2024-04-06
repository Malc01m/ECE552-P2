module ReadDecoder_4_16(RegId, Wordline);

    input [3:0] RegId;
    output   [15:0] Wordline;

    Decoder_4_16 decoder(.In(RegId), .Out(Wordline));

endmodule