module Mux_4to1 (I0, I1, I2, I3, Select, Out);

  // ports
  input wire I0;
  input wire I1;
  input wire I2;
  input wire I3;
  input wire [1:0] Select;
  output reg Out;

  // internal
  reg error;

  always @(I0,I1,I2,I3,Select) begin
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
      2'b11: begin
        Out = I3;
        error = 0;
      end
      default: error=1; // Default case 
    endcase
  end

endmodule