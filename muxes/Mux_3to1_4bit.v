module Mux_3to1_4bit (I0, I1, I2, Select, Out);

  // ports
  input wire [3:0] I0;
  input wire [3:0] I1;
  input wire [3:0] I2;
  input wire [1:0] Select;
  output reg [3:0] Out;
  
  // internal
  reg error;
  
  always @(I0,I1, I2, Select) begin
    casex (Select)
      2'b0x: begin
        Out = I0;
        error = 0;
      end
      2'b10: begin
        Out = I1;
        error = 0;
      end
      2'b11: begin
        Out = I2;
        error = 0;
      end
      default: error=1; // Default case 
    endcase
  end

endmodule
