module MEM_unit(MemDataIn, memAddress, memRead, memWrite, clk, rst_n, MemData);

    // Ports
    input [15:0] MemDataIn, memAddress;
    input memRead, memWrite, clk, rst_n;
    output [15:0] MemData;

   // Data Memory
   dataMemory Dmem(.addr(memAddress), .data_in(MemDataIn), .data_out(MemData), .enable(memRead), .wr(memWrite), 
      .clk(clk), .rst(~rst_n));

endmodule