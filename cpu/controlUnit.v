module controlUnit(opCode, rst_n, writeReg, readReg1, readReg2, memRead, memWrite, ComputeType, 
   MemType, BinaryType, BranchType, HLT);

   // ports
   input wire [3:0] opCode;
   input rst_n;
   output reg writeReg, readReg1, readReg2, memRead, memWrite, ComputeType, MemType, BinaryType, 
      BranchType, HLT;

   // internal
   reg error;

   always @(opCode, rst_n) begin
      case (opCode)

         // ADD,     SUB,    XOR,   PADDSB,    SLL,     SRA,     ROR       RED    PCS
         4'b0000, 4'b0001, 4'b0010, 4'b0111, 4'b0100, 4'b0101, 4'b0110, 4'b0011, 4'b1110: begin
            // compute signals
            writeReg = 1;
            readReg1 = 1;
            readReg2 = 1;
            memRead = 0;
            memWrite = 0;

            ComputeType = 1;
            MemType = 0;
            BinaryType = 0;
            BranchType = 0;

            HLT = 0;
            error = 0;
         end

         // LW   
         4'b1000: begin
            readReg1 = 0;
            readReg2 = 1;
            writeReg = 1;
            memRead = 1;
            memWrite = 0;

            ComputeType = 0;
            MemType = 1;
            BinaryType = 0;
            BranchType = 0;

            HLT = 0;
            error = 0;  
         end

         // SW   
         4'b1001: begin
            readReg1 = 1;
            readReg2 = 1;
            writeReg = 0;
            memRead = 1;
            memWrite = 1;

            ComputeType = 0;
            MemType = 1;
            BinaryType = 0;
            BranchType = 0;

            HLT = 0;
            error = 0;
         end

         // LLB,    LHB
         4'b1010, 4'b1011: begin
            // binary signals (binary is a sub cat of mem) 
            readReg1 = 1;
            readReg2 = 0;
            writeReg = 1;
            memRead = 0;
            memWrite = 0;

            ComputeType = 0;
            MemType = 1;
            BinaryType = 1;
            BranchType = 0;

            HLT = 0;
            error = 0;
         end

         // B,       BR
         4'b1100, 4'b1101: begin
            // branch signals
            readReg1 = 1;
            readReg2 = 0;
            writeReg = 0;
            memRead = 0;
            memWrite = 0;

            ComputeType = 0;
            MemType = 0;
            BinaryType = 0;
            BranchType = 1;

            HLT = 0;
            error = 0;
         end
         
         // HLT
         4'b1111: begin
            readReg1 = 0;
            readReg2 = 0;
            writeReg = 0;
            memRead = 0;
            memWrite = 0;

            ComputeType = 0;
            MemType = 0;
            BinaryType = 0;
            BranchType = 0;

            HLT = 1;
            error = 0;
         end

         default: begin
            error=1; // Default case 
            HLT = 0;
         end
         
      endcase
   end

endmodule