module IF_ID_buf(currInstruction_IF, currInstruction_ID, PCS_PC_IF, PCS_PC_ID, clk, rst_n);

    // Ports
    input [0:15] currInstruction_IF;
    input PCS_PC_IF, clk, rst_n;
    output [0:15] currInstruction_ID;
    output PCS_PC_ID;

    dff instReg(.q(currInstruction_ID), .d(currInstruction_IF), .wen(1'b1), .clk(clk), .rst(~rst_n));
    dff pcs_pcReg [15:0] (.q(PCS_PC_ID), .d(PCS_PC_IF), .wen(1'b1), .clk(clk), .rst(~rst_n));

endmodule