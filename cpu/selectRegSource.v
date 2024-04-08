module selectRegSource(inst, ComputeType, MemType, BinaryType, BranchType, srcReg1, srcReg2);

    // ports
    input wire [15:0] inst;
    input ComputeType, MemType, BinaryType, BranchType;
    output reg [3:0] srcReg1, srcReg2;

    // internal
    reg error;
    reg [3:0] combinedVector;

    // always #20 $monitor("Current Instruction: %b, CombinedVec: %b", inst, combinedVector);

    always @(inst, ComputeType, MemType, BinaryType, BranchType) begin
        combinedVector = {ComputeType, MemType, BinaryType, BranchType};
        case (combinedVector)
            // Compute
            4'b1000: begin
                srcReg1 = inst[7:4];
                srcReg2 = inst[3:0];
                error = 0;
            end
            // pure mem
            4'b0100: begin
                srcReg1 = inst[11:8];
                srcReg2 = inst[7:4];
                error = 0;
            end
            // LLB/LUB
            4'b0110: begin
                srcReg1 = inst[11:8];
                error = 0;
            end
            // Branch
            4'b0001: begin
                srcReg1 = inst[7:4];
                error = 0;
            end
            default: error=1; // Default case 
        endcase
    end

endmodule