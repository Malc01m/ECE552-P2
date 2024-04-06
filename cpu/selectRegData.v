module selectRegData(ComputeType, MemType, BinaryType, ComputeData, MemData, BinaryData, regDataToWrite);
    input ComputeType, MemType, BinaryType;
    input [15:0] ComputeData, MemData, BinaryData;
    output reg [15:0] regDataToWrite;

    // internal
    reg error;
    reg[2:0] combinedVector;

    // always #20 $monitor("CombinedVec: %b, BinaryData: %b", combinedVector, BinaryData);

    always @(ComputeType, MemType, BinaryType, ComputeData, MemData, BinaryData) begin
        combinedVector = {ComputeType, MemType, BinaryType};
        case (combinedVector)
            // Compute
            3'b100: begin
                regDataToWrite = ComputeData;
                error = 0;
            end
            // pure mem
            3'b010: begin
                regDataToWrite = MemData;
                error = 0;
            end
            // LLB/LUB
            3'b011: begin
                regDataToWrite = BinaryData;
                error = 0;
            end
            default: error=1; // Default case 
        endcase
    end

endmodule