module selectRegDst(inst,ComputeType, MemType, BinaryType, RegDst);

    // ports
    input wire [15:0] inst;
    input ComputeType, MemType, BinaryType;

    output reg [3:0] RegDst;

    // internal
    reg error;
    // ADD 0000
    // SUB 0001
    // XOR 0010
    // PADDSB 0111
    // RED 0011
    reg[2:0] combinedVector;

    always @(inst, ComputeType, MemType, BinaryType) begin
        combinedVector = {ComputeType, MemType, BinaryType};
        case (combinedVector)
            // Compute, LLB/LUB
            3'b100, 3'b011: begin
                RegDst = inst[11:8];
                error = 0;
            end
            // pure mem
            3'b010: begin
                RegDst = inst[11:8];
                error = 0;
            end
            default: error=1; // Default case 
        endcase
    end
endmodule