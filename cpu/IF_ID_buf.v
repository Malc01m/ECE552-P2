module IF_ID_buf(currInstruction_IF, currInstruction_ID, PC_plus4_IF, PC_plus4_ID, clk, rst_n, flushIF, stall);

    // Ports
    input [0:15] currInstruction_IF;
    input PC_plus4_IF, clk, rst_n, flushIF, stall;
    output [0:15] currInstruction_ID;
    output PC_plus4_ID;

    // TODO: no-op on flushIF
    dff instReg(.q(currInstruction_ID), .d(currInstruction_IF), .wen(~stall), .clk(clk), .rst(~rst_n));
    dff pcs_pcReg [15:0] (.q(PC_plus4_ID), .d(PC_plus4_IF), .wen(~stall), .clk(clk), .rst(~rst_n));

endmodule