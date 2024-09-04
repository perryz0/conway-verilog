// Pattern counter display module
module patternCounterDisplay (
    input logic [3:0] pattern_count,
    output logic [6:0] HEX4, HEX5
);
    // Pattern Counter Display Logic
    always_comb begin
        // Display pattern_count on HEX4 and HEX5
        HEX4 = getHexDigit(pattern_count % 10);
        HEX5 = getHexDigit(pattern_count / 10);
    end

    function logic [6:0] getHexDigit(input logic [3:0] digit);
        case (digit)
            4'd0: getHexDigit = 7'b1000000;
            4'd1: getHexDigit = 7'b1111001;
            4'd2: getHexDigit = 7'b0100100;
            4'd3: getHexDigit = 7'b0110000;
            4'd4: getHexDigit = 7'b0011001;
            4'd5: getHexDigit = 7'b0010010;
            4'd6: getHexDigit = 7'b0000010;
            4'd7: getHexDigit = 7'b1111000;
            4'd8: getHexDigit = 7'b0000000;
            4'd9: getHexDigit = 7'b0010000;
            default: getHexDigit = 7'b1111111; // Error state
        endcase
    endfunction
endmodule
