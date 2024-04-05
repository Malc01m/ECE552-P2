`include "registerFile.v"

module TB_RegisterFile(SrcData1, SrcData2);


   
   // Parameters
   integer i, correct, total;

   // Signals
   reg rst, WriteReg;
   reg [3:0] SrcReg1, SrcReg2, DstReg;
   reg [15:0] DstData;

   inout wire[15:0] SrcData1, SrcData2;
   
   reg clk;
   reg [15:0] counter;
   initial clk = 0;
   always #10 clk = ~clk;

   
   // Instantiate the PSA_16bit module
   RegisterFile uut (
      .clk(clk),
      .rst(rst),
      .SrcReg1(SrcReg1),
      .SrcReg2(SrcReg2),
      .DstReg(DstReg),
      .WriteReg(WriteReg),
      .DstData(DstData),
      .SrcData1(SrcData1),
      .SrcData2(SrcData2)
   );

   

   // Test procedure
   always begin
      $display("Running RegisterFile testbench...");


      //$monitor("WriteEnable: %b | D %b \n Bitline1: %b| ReadEnable1: %b \n Bitline2: %b | ReadEnable2: %b \n____\n", WriteEnable, D, Bitline1, ReadEnable1, Bitline2, ReadEnable2);
      correct = 0;
      total = 0;

      // setup - enable write
      rst = 0;
      WriteReg = 1;

      // test SrcData1
      for (i = 0; i < 16; i = i + 1) begin
         DstReg = i;
         #20;
         DstData = i;
         #20;
         SrcReg1 = i;
         #20;
         if (SrcData1 == i) begin
         correct = correct + 1;
         //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
         end else begin
         $display("Test %d: Failed. Expected: %d, Got: %d", total, i, SrcData1);
         end
         total = total + 1;
      end


      // test SrcData2
      for (i = 0; i < 16; i = i + 1) begin
         DstReg = i;
         #20;
         DstData = i + 16;
         #20;
         SrcReg2 = i;
         #20;;
         if (SrcData2 == i + 16) begin
         correct = correct + 1;
         //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
         end else begin
         $display("Test %d: Failed. Expected: %d, Got: %d", total, i, SrcData2);
         end
         total = total + 1;
      end

      // test parallel read - diff
      for (i = 0; i < 15; i = i + 1) begin
         DstReg = i;
         #20;
         DstData = i;
         #20;
         SrcReg1 = i;
         #20;
         SrcReg2 = i + 1;
         #20;
         if (SrcData1 == i & SrcData2 == i + 17) begin
         correct = correct + 1;
         //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
         end else begin
         $display("Test %d: Failed. SRC1-E: %d Got: %d, SRC2-E: %d Got: %d", total, i, SrcData1, i + 17, SrcData2);
         end
         total = total + 1;
      end


      // reset
      for (i = 0; i < 16; i = i + 1) begin
         DstReg = i;
         #20;
         DstData = i;
         #20;
      end

      // test Parallel Read Same
      for (i = 0; i < 16; i = i + 1) begin
         
         SrcReg1 = i;
         #20;
         SrcReg2 = i;
         #20;
         if (SrcData1 == i & SrcData2 == i) begin
         correct = correct + 1;
         //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
         end else begin
         $display("Test %d: Failed. SRC1-E: %d Got: %d, SRC2-E: %d Got: %d", total, i, SrcData1, i, SrcData2);
         end
         total = total + 1;
      end


      // test can't write when disabled
      WriteReg = 0;
      #20;
      for (i = 0; i < 16; i = i + 1) begin
         DstReg = i;
         #20;
         DstData = i + 15;
         #20;
         SrcReg1 = i;
         #20;
         SrcReg2 = i;
         #20;
         
         if (SrcData1 == i & SrcData2 == i) begin
         correct = correct + 1;
         //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
         end else begin
         $display("Test %d: Failed. SRC1-E: %d Got: %d, SRC2-E: %d Got: %d", total, i, SrcData1, i, SrcData2);
         end
         total = total + 1;
      end

      // // test forwarding
      // WriteReg = 1;
      // #20;
      // for (i = 0; i < 16; i = i + 1) begin
      //    DstReg = i;
      //    DstData = i + 30;
      //    SrcReg1 = i;
      //    SrcReg2 = i;
      //    #10;
         
         
      //    if (SrcData1 == (i + 30) & SrcData2 == (i + 30)) begin
      //    correct = correct + 1;
      //    //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
      //    end else begin
      //    $display("Forwarding Test %d: Failed. SRC1-E: %d Got: %d, SRC2-E: %d Got: %d", total, i + 30, SrcData1, i + 30, SrcData2);
      //    end
      //    total = total + 1;
      // end
      
      $display("RegisterFile Testbench completed: %d/%d", correct, total);

      $finish;
   end

endmodule