module ReadDecoder_4_16(RegId, Wordline); 
    input [3:0] RegId;
    output [15:0] Wordline;
    wire [15:0] sh_l_0, sh_l_1, sh_l_2, shift_base;

    assign shift_base = 15'b1;

    assign sh_l_0 = (RegId[0]) ? {shift_base[14:0], {1'b0}} : shift_base;
    assign sh_l_1 = (RegId[1]) ? {sh_l_0[13:0], {2'b0}} : sh_l_0;
    assign sh_l_2 = (RegId[2]) ? {sh_l_1[11:0], {4'b0}} : sh_l_1;
    assign Wordline = (RegId[3]) ? {sh_l_2[7:0], {8'b0}} : sh_l_2;

endmodule