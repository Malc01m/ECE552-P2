



module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

  // ports
  input clk, rst;
  input [3:0] SrcReg1, SrcReg2, DstReg;
  input WriteReg;
  input [15:0] DstData;
  
  inout [15:0] SrcData1, SrcData2;

  // internal
  wire[15:0] expandedWriteReg, expandedReadReg1, expandedReadReg2;

  
  WriteDecoder_4_16 wd(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(expandedWriteReg));
  ReadDecoder_4_16 rd1(.RegId(SrcReg1),.Wordline(expandedReadReg1));
  ReadDecoder_4_16 rd2(.RegId(SrcReg2),.Wordline(expandedReadReg2));

  Register rs[15:0](.clk(clk), .rst(rst), .D(DstData), .WriteReg(expandedWriteReg), .ReadEnable1(expandedReadReg1), .ReadEnable2(expandedReadReg2), .Bitline1(SrcData1), .Bitline2(SrcData2) );

  // relic of a bad idea :) 
  // wire[255:0] readOut1, readOut2;
  // Mux_16to1_16bit mux1(.In(readOut1), .Select(SrcReg1), .Out(SrcData1));
  // Mux_16to1_16bit mux2(.In(readOut2), .Select(SrcReg2), .Out(SrcData2));


endmodule


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



module ReadDecoder_4_16(RegId, Wordline);
    input [3:0] RegId;
    output   [15:0] Wordline;

    Decoder_4_16 decoder(.In(RegId), .Out(Wordline));

endmodule

module WriteDecoder_4_16(RegId, WriteReg, Wordline);
  
  input [3:0] RegId;
  input WriteReg;
  output [15:0] Wordline;

  wire[15:0] expandedRegID;
  Decoder_4_16 decoder(.In(RegId), .Out(expandedRegID));

  assign Wordline = (WriteReg == 1) ? expandedRegID: 16'b0000000000000000;

endmodule

module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	   wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state;

    assign q = state;

    always @(posedge clk) begin
      state = rst ? 0 : (wen ? d : state);
    //   $display("Q is %d", q);
    end

endmodule




module PC_Register(clk, rst, D, WriteReg, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    input clk;
    input rst;
    input [15:0] D;
    input WriteReg;
    input ReadEnable1;
    input ReadEnable2;
    inout [15:0] Bitline1;
    inout [15:0] Bitline2;
    
    


   BitCell cells[15:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));
   
    // initial begin
    // #10;
    //     $monitor("Internal \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, bitline1: %b, bitline2: %b", WriteReg, ReadEnable1, ReadEnable2, clk, D, Bitline1, Bitline2);
    // end
endmodule


module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    // ports
    input clk;
    input rst;
    input D;
    input WriteEnable;
    input ReadEnable1;
    input ReadEnable2;
    inout Bitline1;
    inout Bitline2;
    
    // internal
    wire out;

    // D-flipflop
    dff data(.q(out), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
    
    // initial begin
    // #20;
    //     $monitor("Internal Bitcell \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, out: %b, bitline1: %b, bitline2: %b", WriteEnable, ReadEnable1, ReadEnable2, clk, D, out, Bitline1, Bitline2);
    // end
    // if readEnable is 0, then don't let them read; otherwise, give Q back
    assign Bitline1 = (ReadEnable1 == 0) ? 1'bz :  out;
    assign Bitline2 = (ReadEnable2 == 0) ? 1'bz : out;

    
    
endmodule

module Register(clk, rst, D, WriteReg, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    input clk;
    input rst;
    input [15:0] D;
    input WriteReg;
    input ReadEnable1;
    input ReadEnable2;
    inout [15:0] Bitline1;
    inout [15:0] Bitline2;
    
    


   BitCell cells[15:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));
   
    // initial begin
    // #10;
    //     $monitor("Internal \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, bitline1: %b, bitline2: %b", WriteReg, ReadEnable1, ReadEnable2, clk, D, Bitline1, Bitline2);
    // end
endmodule

module FlagRegister(clk, rst, D, WriteReg, ReadEnable1, ReadEnable2, Bitline1, Bitline2);
    input clk;
    input rst;
    input [2:0] D, WriteReg;
    input ReadEnable1;
    input ReadEnable2;
    inout [2:0] Bitline1;
    inout [2:0] Bitline2;
    
    


   BitCell cells[2:0] (.clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2), .Bitline1(Bitline1), .Bitline2(Bitline2));
   
    // initial begin
    // #10;
    //     $monitor("Internal \n WriteEnable: %d, ReadEnable1: %d, ReadEnable2: %d, clk: %d, D: %b, bitline1: %b, bitline2: %b", WriteReg, ReadEnable1, ReadEnable2, clk, D, Bitline1, Bitline2);
    // end
endmodule




module Decoder_2_4(A0, A1, E, Out);
    
    input A0, A1, E;
    output [3:0] Out;
    
   
    

    assign Out[0] = (E == 0) ? 0: (~A0) & (~A1);
    assign Out[1] = (E == 0) ? 0: (A0) & (~A1);
    assign Out[2] = (E == 0) ? 0: (~A0) & (A1);
    assign Out[3] = (E == 0) ? 0: (A0) & (A1);

endmodule 

module Decoder_3_8(A0, A1, A2, Out);
    
    input A0, A1, A2;
    output [7:0] Out;
    
    Decoder_2_4 d1(.A0(A0), .A1(A1), .E(~A2), .Out(Out[3:0]));
    Decoder_2_4 d2(.A0(A0), .A1(A1), .E(A2), .Out(Out[7:4]));

endmodule

module Decoder_4_16(In, Out);
  input [3:0] In;
  output [15:0] Out;

  wire A0, A1, A2, A3;
  wire [7:0] lower, upper;

  assign A0 = In[0];
  assign A1 = In[1];
  assign A2 = In[2];
  assign A3 = In[3];

  
  Decoder_3_8 d1(.A0(A0), .A1(A1), .A2(A2), .Out(lower));
  Decoder_3_8 d2(.A0(A0), .A1(A1), .A2(A2), .Out(upper));



  assign Out[7:0] = (A3 == 1) ? 0:  lower;
  assign Out[15:8] = (A3 == 0) ? 0: upper;


endmodule