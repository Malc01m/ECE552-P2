module flagWriteSelect(inst,flagZ_Write, flagV_Write, flagN_Write);

  // ports
  input wire [15:0] inst;
  output reg flagZ_Write, flagV_Write, flagN_Write;

  // internal
  reg error;
 
  always @(inst) begin
    case (inst[15:12])
      // Add,     Sub
      4'b0000, 4'b0001: begin
                  flagZ_Write = 1;
                  flagV_Write = 1;
                  flagN_Write = 1;
                  error = 0;
             end
      // XOR,     SLL,    SRA,      ROR
      4'b0010, 4'b0100, 4'b0101, 4'b0110: begin
                  flagZ_Write = 1;
                  flagV_Write = 0;
                  flagN_Write = 0;
                  error = 0;
             end
      
      default: begin
        // every other instruction cannot change flags
        flagZ_Write = 0;
        flagV_Write = 0;
        flagN_Write = 0;
        error=1; // Default case

      end 
    endcase
  end

endmodule