module IF_ID_buf(currInstruction_IF, currInstruction_ID, PCS_PC_IF, PCS_PC_ID);

    // Ports
    input [0:15] currInstruction_IF;
    input PCS_PC_IF;
    output [0:15] currInstruction_ID;
    output PCS_PC_ID;

endmodule