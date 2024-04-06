module forwardingUnit();

    // EX to EX forwarding unit
    EX_EX_fwd_unit EXEXfw();
   
    // MEM to EX forwarding unit
    MEM_EX_fwd_unit MEMEXfw();

    // MEM to MEM forwarding unit
    MEM_MEM_fwd_unit MEMMEMfw();
    
endmodule