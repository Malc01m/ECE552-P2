module Mux_3to1_16bit (I0, I1, I2, Select, Out);

  // ports
  input wire [15:0] I0;
  input wire [15:0] I1;
  input wire [15:0] I2;
  input wire [1:0] Select;
  output reg [15:0] Out;

  // internal
  reg error;

  always @(I0,I1,I2, Select) begin
    case (Select)
      2'b00: begin
        Out = I0;
        error = 0;
      end
      2'b01: begin
        Out = I1;
        error = 0;
      end
      2'b10: begin
        Out = I2;
        error = 0;
      end
      default: error=1; // Default case 
    endcase
  end

endmodule