module OddMux_3to1 (I0, I1, I2, Select, Out);

  // ports
  input wire I0;
  input wire I1;
  input wire I2;
  input wire [3:0] Select;
  output reg Out;

  // internal
  reg error;

  // ADD 0000
  // SUB 0001
  // XOR 0010
  // PADDSB 0111
  // RED 0011
  
  always @(I0,I1,I2, Select) begin
    case (Select)
      4'b0000, 4'b0001: begin
                Out = I0;
                error = 0;
             end
      4'b0010, 4'b0011: begin
                Out = I1;
                error = 0;
              end
      4'b0111: begin
                Out = I2;
                error = 0;
              end  
      default: error=1; // Default case 
    endcase
  end

endmodule