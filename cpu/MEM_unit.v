module MEM_unit(MemDataIn, memAddress, memRead, memWrite, clk, rst_n, MemData, notdonem);

    // Ports
    input [15:0] MemDataIn, memAddress;
    input memRead, memWrite, clk, rst_n;
    output [15:0] MemData;
    output notdonem;

    // Internal
    wire loaded;

    assign notdonem = ~loaded;

   // Data Memory
   dataMemory Dmem(.addr(memAddress), .data_in(MemDataIn), .data_out(MemData), .enable(memRead), .wr(memWrite), 
      .clk(clk), .rst(~rst_n), .loaded(loaded));

endmodule