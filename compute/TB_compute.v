`include "ALU.v"

module TB_compute();

   // Parameters
   integer i, j, correct, total, sat_total;
   integer sat1, sat1_total, sat2, sat2_total, sat3, sat3_total, sat4, sat4_total, missed_condition, total_missed;

   // Signals
   reg [15:0] ALU_In1, ALU_In2, cSum;
   reg [3:0] Opcode;
   wire [15:0] ALU_Out;
   wire Error;
   reg signed [8:0] interSumHalf1, interSumHalf2;
   reg signed[15:0] dummyRedSum;
   reg [3:0] imm;

   // Instantiate the ALU module
   ALU uut (
      .ALU_In1(ALU_In1),
      .ALU_In2(ALU_In2),
      .Opcode(Opcode),
      .ALU_Out(ALU_Out),
      .Error(Error),
      .imm(imm)
   );

   // Signals
   reg [15:0] A, B;
   wire [15:0] Sum;

   wire [1:0] hardwire = 2'b00;
   wire [15:0] dummySum;
   wire Er1, Er2, Er3, Er4;
   wire dummyError; 
   wire pwError;

   mini4BitALU alu1 (
      .ALU_In1(ALU_In1[3:0]),
      .ALU_In2(ALU_In2[3:0]),
      .Opcode(hardwire),
      .ALU_Out(dummySum[3:0]),
      .Error(Er1)
   );

   mini4BitALU alu2 (
      .ALU_In1(ALU_In1[7:4]),
      .ALU_In2(ALU_In2[7:4]),
      .Opcode(hardwire),
      .ALU_Out(dummySum[7:4]),
      .Error(Er2)
   );

   mini4BitALU alu3 (
      .ALU_In1(ALU_In1[11:8]),
      .ALU_In2(ALU_In2[11:8]),
      .Opcode(hardwire),
      .ALU_Out(dummySum[11:8]),
      .Error(Er3)
   );

   mini4BitALU alu4 (
      .ALU_In1(ALU_In1[15:12]),
      .ALU_In2(ALU_In2[15:12]),
      .Opcode(hardwire),
      .ALU_Out(dummySum[15:12]),
      .Error(Er4)
   );

   assign dummyError = Er1 | Er2 | Er3 | Er4; 

   // Signals
   reg signed [15:0] Shift_In;
   reg [3:0] Shift_Val;
   reg [1:0] Mode;
   wire signed [15:0] Shift_Out;

   Shifter Shiftuut (
      .Shift_In(Shift_In),
      .Shift_Val(Shift_Val),
      .Mode(Mode),
      .Shift_Out(Shift_Out)
   );

   // Signals
   reg signed [15:0] shift_ALU_In1, shift_ALU_In2;
   reg [3:0] shift_imm;
   reg [3:0] shift_Opcode;
   wire signed [15:0] shift_ALU_Out;

   ALU myALU (
      .ALU_In1(shift_ALU_In1),
      .ALU_In2(shift_ALU_In2),
      .Opcode(shift_Opcode),
      .ALU_Out(shift_ALU_Out),
      .imm(shift_imm)
   );

   // Test procedure
   initial begin
      $display("Running RED testbench");
      correct = 0;
      total = 0;
      Opcode = 4'b0011;
      // Run RED testbench
      for (i = 0; i < 50000; i = i + 1) begin
         total = total + 1;
         ALU_In1 = $random;
         ALU_In2 = $random;
         interSumHalf1 = ALU_In1[7:0] + ALU_In2[7:0];
         interSumHalf2 = ALU_In1[15:8] + ALU_In2[15:8];
         dummyRedSum = interSumHalf1 + interSumHalf2;

         #20;  // Allow some time for the output to settle

         if (ALU_Out == (dummyRedSum)) begin
            // $display("Test %d Passed", i);
            correct = correct + 1;
         end else begin
            $display("Test %d: Failed. A: %b, B: %b, Expected: %b, Got: %b, interSumHalf1: %b, interSumHalf2: %b", i, ALU_In1, ALU_In2, dummyRedSum, ALU_Out, interSumHalf1, interSumHalf2);
         end
      end
      $display("RED Testbench completed: %d/%d", correct, total);

      $display("Running add testbench");

      // $monitor("OPCODE: %d  ALU_In1: %d ALU_IN2: %d  ALU_OUT: ", Opcode, ALU_In1, ALU_In2, ALU_Out);
      correct = 0;
      sat_total = 0;
      // Run random  additions
      for (i = 0; i < 10000; i = i + 1) begin
         ALU_In1 = $random;
         ALU_In2 = $random;
         cSum = ALU_In1 + ALU_In2;
         Opcode = 4'b0000;

         #20;  // Allow some time for the output to settle

         if (Error == 0) begin
            if (ALU_Out == (ALU_In1+ALU_In2)) begin
               correct = correct + 1;
               // $display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
            end else begin
               $display("Test %d: Failed. Expected: %d, Got: %d, Overflow: %b", i, (ALU_In1 + ALU_In2), ALU_Out, Error);
            end
         end else begin
            sat_total = sat_total + 1;
            if (ALU_In1[15] == 0 && ALU_In2[15] == 0 && cSum[15] == 1) begin
               if (ALU_Out == 16'b0111111111111111) begin
                  correct = correct + 1;
               end
            end else if (ALU_In1[15] == 1 && ALU_In2[15] == 1 && cSum[15] == 0) begin
               if (ALU_Out == 16'b1000000000000000) begin
                  correct = correct + 1;
               end
            end
         end
      end
      $display("Adding Testbench completed: %d/10000; %d of them had Saturation", correct, sat_total);

      $display("Sub testbench started...");
      correct = 0;
      sat_total = 0;
      // Run random subtractions
      for (i = 0; i < 10000; i = i + 1) begin
         ALU_In1 = $random;
         ALU_In2 = $random;
         cSum = ALU_In1 - ALU_In2;
         Opcode = 4'b0001; 

         #100;  // Allow some time for the output to settle
         
         if (Error == 0) begin
            if (ALU_Out == (ALU_In1 - ALU_In2)) begin
               correct = correct + 1;
               // $display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
            end else begin
               $display("Test %d: Failed. Expected: %d, Got: %d, Overflow: %b", i, (ALU_In1 - ALU_In2), ALU_Out, Error);
            end
         end else begin
            sat_total = sat_total + 1;
            if (ALU_In1[15] == 1 && ALU_In2[15] == 0 && cSum[15] == 0) begin
               // $display("Should be max negative: %b", ALU_Out);
               if (ALU_Out == 16'b1000000000000000) begin
                  correct = correct + 1;
               end
            end else if (ALU_In1[15] == 0 && ALU_In2[15] == 1 && cSum[15] == 1) begin
               // $display("Should be max postive: %b", ALU_Out);
               if (ALU_Out == 16'b0111111111111111) begin
                  correct = correct + 1;
               end
            end
         end
      end
      $display("Subtraction Testbench completed: %d/10000; %d of them had saturation",correct, sat_total);

      correct = 0;
      // Run 50 random Xors
      for (i = 0; i < 10000; i = i + 1) begin
         ALU_In1 = $random;
         ALU_In2 = $random;
         Opcode = 4'b0010;

         #10;  // Allow some time for the output to settle

         if (ALU_Out == (ALU_In1 ^ ALU_In2) && (Error == 0)) begin
            // $display("Test %d Passed", i);
            correct = correct + 1;
         end else begin
            $display("Test %d: Failed. Expected: %d, Got: %d, Overflow: %b", i, (ALU_In1 ^ ALU_In2), ALU_Out, Error);
         end
      end
      $display("XOR Testbench completed: %d/10000", correct);


      correct = 0;
      total = 0;
      sat1 = 0;
      sat1_total = 0;
      sat2 = 0;
      sat2_total = 0;
      sat3 = 0;
      sat3_total = 0;
      sat4 = 0;
      sat4_total = 0;
      
      missed_condition = 0;
      total_missed = 0;
      // Run PADDSB Test
      for (i = 0; i < 50000; i = i + 1) begin
         ALU_In1 = $random;
         ALU_In2 = $random;
         Opcode = 4'b0111;

         #10;  // Allow some time for the output to settle

         // $display("A: %d , B: %d ", A, B);
         if (dummyError == 0) begin
               total = total + 1;
               if (Error == dummyError & ALU_Out[3:0] == (ALU_In1[3:0] + ALU_In2[3:0]) & ALU_Out[7:4] == (ALU_In1[7:4] + ALU_In2[7:4]) & ALU_Out[11:8] == (ALU_In1[11:8] + ALU_In2[11:8]) & ALU_Out[15:12] == (ALU_In1[15:12] + ALU_In2[15:12])) begin
                  correct = correct + 1;
                  // $display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
               end else begin
                  $display("Test %d: Failed. \nS[3:0] Expected: %d, Got: %d  \nS[7:4] Expected: %d, Got: %d\nS[11:8] Expected: %d, Got: %d \nS[15:12] Expected: %d, Got: %d\n Expected Error %d, Error: %b\n___\n", i, (ALU_In1[3:0] + ALU_In2[3:0]), ALU_Out[3:0], (ALU_In1[7:4] + ALU_In2[7:4]), ALU_Out[7:4], (ALU_In1[11:8] + ALU_In2[11:8]), ALU_Out[11:8], (ALU_In1[15:12] + ALU_In2[15:12]), ALU_Out[15:12], dummyError, Error);
               end
         end else begin
               missed_condition = 0;

               if (ALU_In1[3] == 0 && ALU_In2[3] == 0 && dummySum[3] == 1) begin
                  sat1_total = sat1_total + 1;
                  missed_condition = 1;

                  if (ALU_Out[3:0] == 7) begin
                     sat1 = sat1 + 1;
                  end
               end else if (ALU_In1[3] == 1 && ALU_In2[3] == 1 && dummySum[3] == 0) begin
                  missed_condition = 1;
                  sat1_total = sat1_total + 1;

                  if (ALU_Out[3:0] == 4'b1000) begin
                     sat1 = sat1 + 1;
                  end
               end

               if (ALU_In1[7] == 0 && ALU_In2[7] == 0 && dummySum[7] == 1) begin
                  missed_condition = 1;
                  sat2_total = sat2_total + 1;
                  
                  if (ALU_Out[7:4] == 7) begin
                     sat2 = sat2 + 1;
                  end
               end else if (ALU_In1[7] == 1 && ALU_In2[7] == 1 && dummySum[7] == 0) begin
                  missed_condition = 1;
                  sat2_total = sat2_total + 1;

                  if (ALU_Out[7:4] == 4'b1000) begin
                     sat2 = sat2 + 1;
                  end
               end

               if (ALU_In1[11] == 0 && ALU_In2[11] == 0 && dummySum[11] == 1) begin
                  missed_condition = 1;
                  sat3_total = sat3_total + 1;

                  if (ALU_Out[11:8] == 7) begin
                     sat3 = sat3 + 1;
                  end
               end else if (ALU_In1[11] == 1 && ALU_In2[11] == 1 && dummySum[11] == 0) begin
                  missed_condition = 1;
                  sat3_total = sat3_total + 1;

                  if (ALU_Out[11:8] == 4'b1000) begin
                     sat3 = sat3 + 1;
                  end
               end

               if (ALU_In1[15] == 0 && ALU_In2[15] == 0 && dummySum[15] == 1) begin
                  missed_condition = 1;
                  sat4_total = sat4_total + 1;

                  if (ALU_Out[15:12] == 7) begin
                     sat4 = sat4 + 1;
                  end
               end else if (ALU_In1[15] == 1 && ALU_In2[15] == 1 && dummySum[15] == 0) begin
                  missed_condition = 1;
                  sat4_total = sat4_total + 1;

                  if (ALU_Out[15:12] == 4'b1000) begin
                     sat4 = sat4 + 1;
                  end
               end

               if (missed_condition == 0) begin
                  total_missed = total_missed + 1;
               end

         end
      end
      $display("PADDSUB Testbench completed; No Saturation:%d/%d, Sat[3:0]: %d/%d, Sat[7:4]: %d/%d, Sat[11:8]: %d/%d, Sat[15:12] %d/%d, Missed Condition: %d", correct, total, sat1, sat1_total, sat2, sat2_total, sat3, sat3_total, sat4, sat4_total, total_missed);

      total = 0;
      correct = 0;
      $display("Running sll Testbench...");
      
      for (i = 0; i < 16; i = i + 1) begin
         shift_imm = i;

         for (j = 0; j < 10000; j = j + 1) begin
            shift_ALU_In1 = $random;
            shift_Opcode = 4'b0100;

            #10;  // Allow some time for the output to settle
            
            if (shift_ALU_Out == (shift_ALU_In1 << shift_imm )) begin
               correct = correct + 1;
               // $display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
            end else begin
               $display("%d Shift Failed; expected: %b out: %b", i, (shift_ALU_In1 << shift_imm), shift_ALU_Out);
            end
            total = total + 1;
         end
      end
      $display("sll Testbench Completed: %d/%d", correct, total);

      total = 0;
      correct = 0;
      $display("Running sra Testbench...");
      for (i = 0; i < 16; i = i + 1) begin

         shift_imm = i;

         for (j = 0; j < 10000; j = j + 1) begin
            shift_ALU_In1 = $random;
            shift_Opcode = 4'b0101;
            #10;  // Allow some time for the output to settle
            if  (shift_ALU_Out == (shift_ALU_In1 >>> shift_imm )) begin
            correct = correct + 1;
            //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
            end else begin
            $display("%d Shift Failed; OG: %b expected: %b out: %b",shift_imm, shift_ALU_In1, (shift_ALU_In1 >>> shift_imm), shift_ALU_Out);
            end
            total = total + 1;
         end
      end

      $display("sra Testbench Completed: %d/%d", correct, total);
      total = 0;
      correct = 0;
      $display("Running ROR Testbench...");
      for (i = 0; i < 16; i = i + 1) begin
         shift_imm = i;

         for (j = 0; j < 10000; j = j + 1) begin
            shift_ALU_In1 = $random;
            shift_Opcode = 4'b0110;
            #25;  // Allow some time for the output to settle
            if  (shift_ALU_Out == ((shift_ALU_In1 >> i) | (shift_ALU_In1 << (16 - i)) )) begin
               correct = correct + 1;
               //$display("Test %d Passed; expected: %d sum: %d", i, (ALU_In1 + ALU_In2), ALU_Out);
            end else begin
               $display("%d Shift Failed; OG: %b expected: %b out: %b",shift_imm, shift_ALU_In1, ((shift_ALU_In1 >> i) | (shift_ALU_In1 << (16 - i))), shift_ALU_Out);
            end
            total = total + 1;
         end
      end

      $display("ROR Testbench Completed: %d/%d", correct, total);
      
      $finish;
   end

endmodule