module EX_unit(clk, rst_n, regSel, regData1, regData2, regDst1, regDst2, regDst);

    // Ports
    input clk, rst_n, regSel;
    input [15:0] regData1, regData2;
    input [3:0] regDst1, regDst2;
    output [3:0] regDst;

    assign regDst = (regSel) ? regDst2 : regDst1;
    

endmodule