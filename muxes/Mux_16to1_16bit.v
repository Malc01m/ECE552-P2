module Mux_16to1_16bit (In, Select, Out);

   // ports
   input wire [255:0] In;
   input wire [3:0] Select;
   output reg [15:0] Out;

   // internal
   reg error;

   always @(In, Select) begin
      case (Select)
         4'b0000: begin
            Out = In[15:0];
            error = 0;
         end
         4'b0001: begin
            Out = In[31:16];
            error = 0;
         end
         4'b0010: begin
            Out = In[47:32];
            error = 0;
         end
         4'b0011: begin
            Out = In[63:48];
            error = 0;
         end
         4'b0100: begin
            Out = In[79:64];
            error = 0;
         end
         4'b0101: begin
            Out = In[95:80];
            error = 0;
         end
         4'b0110: begin
            Out = In[111:96];
            error = 0;
         end
         4'b0111: begin
            Out = In[127:112];
            error = 0;
         end
         4'b1000: begin
            Out = In[143:128];
            error = 0;
         end
         4'b1001: begin
            Out = In[159:144];
            error = 0;
         end
         4'b1010: begin
            Out = In[175:160];
            error = 0;
         end
         4'b1011: begin
            Out = In[191:176];
            error = 0;
         end
         4'b1100: begin
            Out = In[207:192];
            error = 0;
         end
         4'b1101: begin
            Out = In[223:208];
            error = 0;
         end
         4'b1110: begin
            Out = In[239:224];
            error = 0;
         end
         4'b1111: begin
            Out = In[255:240];
            error = 0;
         end
         default: error = 1; // Default case
      endcase
   end
   
endmodule