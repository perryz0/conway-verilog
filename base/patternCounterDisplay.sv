// Pattern counter display module

module patternCounterDisplay (pattern_count, HEX4, HEX5);
    input logic [3:0] pattern_count;
    output logic [6:0] HEX4, HEX5;

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



module patternCounterDisplay_testbench();
    logic clk;
    logic [3:0] pattern_count;
    logic [6:0] HEX4, HEX5;

    patternCounterDisplay dut (pattern_count, HEX4, HEX5);

    // Set up a simulated clock.
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    // Test the design.
    initial begin
        // Test case 1: pattern_count = 0
        pattern_count = 4'd0; @(posedge clk); @(posedge clk);

        // Test case 2: pattern_count = 5
        pattern_count = 4'd5; @(posedge clk); @(posedge clk);

        // Test case 3: pattern_count = 9
        pattern_count = 4'd9; @(posedge clk); @(posedge clk);

        // Test case 4: pattern_count = 10
        pattern_count = 4'd10; @(posedge clk); @(posedge clk);

        // Test case 5: pattern_count = 15
        pattern_count = 4'd15; @(posedge clk); @(posedge clk);

        // Test case 6: pattern_count = 20
        pattern_count = 4'd20; @(posedge clk); @(posedge clk);

        $stop;
    end
endmodule
