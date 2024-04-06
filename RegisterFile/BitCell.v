module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    
    // ports
    input clk;
    input rst;
    input D;
    input WriteEnable;
    input ReadEnable1;
    input ReadEnable2;
    inout Bitline1;
    inout Bitline2;
    
    // internal
    wire out;

    // D-flipflop
    dff data(.q(out), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
    
    // initial begin
    // #20;
    //     $monitor("Internal Bitcell \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, out: %b, bitline1: %b, bitline2: %b", WriteEnable, ReadEnable1, ReadEnable2, clk, D, out, Bitline1, Bitline2);
    // end
    // if readEnable is 0, then don't let them read; otherwise, give Q back
    assign Bitline1 = (ReadEnable1 == 0) ? 1'bz :  out;
    assign Bitline2 = (ReadEnable2 == 0) ? 1'bz : out;

endmodule