module ROR(data_in, shiftVal, result);

    // ports
    input [15:0] data_in;     // Input data to be shifted (16 bits)
    input [3:0] shiftVal;     // Number of bits to shift
    output reg[15:0] result;     // Output shifted data
    reg error;

    always @(data_in, shiftVal) begin
        case (shiftVal)
            4'd0: begin
                result = data_in;
                error = 0; // No error for specific cases
            end
            4'd1: begin
                result = {data_in[0], data_in[15:1]};
                error = 0;
            end
            4'd2: begin
                result = {data_in[1:0], data_in[15:2]};
                error = 0;
            end
            4'd3: begin
                result = {data_in[2:0], data_in[15:3]};
                error = 0;
            end
            4'd4: begin
                result = {data_in[3:0], data_in[15:4]};
                error = 0;
            end
            4'd5: begin
                result = {data_in[4:0], data_in[15:5]};
                error = 0;
            end
            4'd6: begin
                result = {data_in[5:0], data_in[15:6]};
                error = 0;
            end
            4'd7: begin
                result = {data_in[6:0], data_in[15:7]};
                error = 0;
            end
            4'd8: begin
                result = {data_in[7:0], data_in[15:8]};
                error = 0;
            end
            4'd9: begin
                result = {data_in[8:0], data_in[15:9]};
                error = 0;
            end
            4'd10: begin
                result = {data_in[9:0], data_in[15:10]};
                error = 0;
            end
            4'd11: begin
                result = {data_in[10:0], data_in[15:11]};
                error = 0;
            end
            4'd12: begin
                result = {data_in[11:0], data_in[15:12]};
                error = 0;
            end
            4'd13: begin
                result = {data_in[12:0], data_in[15:13]};
                error = 0;
            end
            4'd14: begin
                result = {data_in[13:0], data_in[15:14]};
                error = 0;
            end
            4'd15: begin
                result = {data_in[14:0], data_in[15]}; // Rotate all bits to the right
                error = 0;
            end
                default: begin
                error = 1;      // Set error flag for default case
            end
        endcase
    end

endmodule