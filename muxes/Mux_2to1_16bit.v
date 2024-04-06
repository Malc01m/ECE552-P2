module Mux_2to1_16bit (I0, I1, Select, Out);

  // ports
  input wire [15:0] I0;
  input wire [15:0] I1;
  input wire Select;
  output reg [15:0] Out;

  // internal
  reg error;

  always @(I0,I1,Select) begin
    case (Select)
      1'b0: begin
        Out = I0;
        error = 0;
      end
      1'b1: begin
        Out = I1;
        error = 0;
      end
      default: error=1; // Default case 
    endcase
  end

endmodule