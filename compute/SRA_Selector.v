module SRA_Selector (data_in, shiftVal, result);

  // ports
  input [15:0] data_in;     // Input data to be shifted (16 bits)
  input [3:0] shiftVal;     // Number of bits to shift
  output reg[15:0] result;     // Output shifted data
  reg error;  

  always @(data_in, shiftVal) begin
    case (shiftVal)
      4'd0: begin
        result = data_in;
        error = 0;
      end
      4'd1: begin
        result = (data_in[15] == 1) ? {1'b1, data_in[15:1]} : data_in >> 1;
        error = 0;
      end
      4'd2: begin
        result = (data_in[15] == 1) ? {{2'b11}, data_in[15:2]} : data_in >> 2;
        error = 0;
      end
      4'd3: begin
        result = (data_in[15] == 1) ? {{3'b111}, data_in[15:3]} : data_in >> 3;
        error = 0;
      end
      4'd4: begin
        result = (data_in[15] == 1) ? {{4'b1111}, data_in[15:4]} : data_in >> 4;
        error = 0;
      end
      4'd5: begin
        result = (data_in[15] == 1) ? {{5'b11111}, data_in[15:5]} : data_in >> 5;
        error = 0;
      end
      4'd6: begin
        result = (data_in[15] == 1) ? {{6'b111111}, data_in[15:6]} : data_in >> 6;
        error = 0;
      end
      4'd7: begin
        result = (data_in[15] == 1) ? {{7'b1111111}, data_in[15:7]} : data_in >> 7;
        error = 0;
      end
      4'd8: begin
        result = (data_in[15] == 1) ? {{8'b11111111}, data_in[15:8]} : data_in >> 8;
        error = 0;
      end
      4'd9: begin
        result = (data_in[15] == 1) ? {{9'b111111111}, data_in[15:9]} : data_in >> 9;
        error = 0;
      end
      4'd10: begin
        result = (data_in[15] == 1) ? {{10'b1111111111}, data_in[15:10]} : data_in >> 10;
        error = 0;
      end
      4'd11: begin
        result = (data_in[15] == 1) ? {{11'b11111111111}, data_in[15:11]} : data_in >> 11;
        error = 0;
      end
      4'd12: begin
        result = (data_in[15] == 1) ? {{12'b111111111111}, data_in[15:12]} : data_in >> 12;
        error = 0;
      end
      4'd13: begin
        result = (data_in[15] == 1) ? {{13'b1111111111111}, data_in[15:13]} : data_in >> 13;
        error = 0;
      end
      4'd14: begin
        result = (data_in[15] == 1) ? {{14'b11111111111111}, data_in[15:14]} : data_in >> 14;
        error = 0;
      end
      4'd15: begin
        result = (data_in[15] == 1) ? {{15'b111111111111111}, data_in[15:15]} : data_in >> 15;
        error = 0;
      end
      default: begin
        
        error = 1;
      end
    endcase
  end

endmodule