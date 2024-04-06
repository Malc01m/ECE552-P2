module ALU_Mux_4to1_16bit (I0, I1, I2, I3, I4, Select, Out);

  // ports
  input wire [15:0] I0, I1, I2, I3, I4;
  input wire [3:0] Select;
  output reg [15:0] Out;
  
  // internal
  reg error;

  // ADD 0000
  // SUB 0001
  // XOR 0010
  // PADDSB 0111
  // RED 0011
  always @(I0,I1, I2,I3, I4, Select) begin
    casex (Select)
      4'b0000, 4'b0001: begin
        Out = I0;
        error = 0;
      end
      4'b0010: begin
        Out = I1;
        error = 0;
      end
      4'b0111: begin
        Out = I2;
        error = 0;
      end
      4'b0011: begin
        Out = I3;
        error = 0;
      end
      4'b0100, 4'b0101, 4'b0110: begin
        Out = I4;
        error = 0;
      end
      default: error=1; // Default case 
    endcase
  end

endmodule