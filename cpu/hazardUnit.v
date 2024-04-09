module hazardUnit(
    input [2:0] writeRegSel_DX, writeRegSel_XM, writeRegSel_MWB,
    input [2:0] readRegSel1, readRegSel2,
    input regWrite_DX, regWrite_XM, regWrite_MWB,
    output stall
);

    wire hazard_DX, hazard_XM, hazard_MWB;

    // Detect hazards from DX stage
    assign hazard_DX = (regWrite_DX && ((writeRegSel_DX == readRegSel1) || (writeRegSel_DX == readRegSel2)));

    // Detect hazards from XM stage
    assign hazard_XM = (regWrite_XM && ((writeRegSel_XM == readRegSel1) || (writeRegSel_XM == readRegSel2)));

    // Detect hazards from MWB stage
    assign hazard_MWB = (regWrite_MWB && ((writeRegSel_MWB == readRegSel1) || (writeRegSel_MWB == readRegSel2)));

    // Stall if any of the 3 hazards are detected
    assign stall = hazard_DX || hazard_XM || hazard_MWB;

endmodule
