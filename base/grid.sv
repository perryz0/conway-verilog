// Grid module with pattern detection

module grid (clk, reset, row_select, col_select, set_initial, new_state, enable_update, grid, grid_next, pattern_count);
    input logic clk;
    input logic reset;
    input logic [7:0] row_select;
    input logic [7:0] col_select;
    input logic set_initial;
    input logic new_state;
    input logic enable_update;
    output logic [15:0][15:0] grid;
    input logic [15:0][15:0] grid_next;
    output logic [3:0] pattern_count;

    logic [15:0][15:0] grid_prev;
    logic [3:0] temp_pattern_count;

    // State registers for grid and pattern count
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            grid <= '{default: 0};
            grid_prev <= '{default: 0};
            pattern_count <= 0;
        end else if (set_initial) begin
            grid[row_select][col_select] <= new_state;
        end else if (enable_update) begin
            grid <= grid_next;
            grid_prev <= grid;
            pattern_count <= temp_pattern_count;
        end
    end

    // Pattern detection logic for blinkers
    always_comb begin
        temp_pattern_count = pattern_count;
        for (int row = 1; row < 15; row++) begin
            for (int col = 1; col < 15; col++) begin
                // Horizontal blinker check in current state
                if (grid[row][col-1] == 1 && grid[row][col] == 1 && grid[row][col+1] == 1) begin
                    // Check for vertical blinker in previous state
                    if (grid_prev[row-1][col] == 1 && grid_prev[row][col] == 1 && grid_prev[row+1][col] == 1) begin
                        temp_pattern_count = temp_pattern_count + 1;
                    end
                end
            end
        end
    end
endmodule


module grid_testbench();
    logic clk, reset;
    logic [7:0] row_select, col_select;
    logic set_initial, new_state, enable_update;
    logic [15:0][15:0] grid, grid_next;
    logic [3:0] pattern_count;

    grid dut (clk, reset, row_select, col_select, set_initial, new_state, enable_update, grid, grid_next, pattern_count);

    // Set up a simulated clock.
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    // Test the design.
    initial begin
        // Reset and configure the grid
        reset <= 1;          @(posedge clk); // reset every time we start
        @(posedge clk);
        reset <= 0;          @(posedge clk);
        @(posedge clk);

        // Initial configuration for vertical blinker
        set_initial <= 1;
        row_select <= 8'd7; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd9; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);

        // Update grid to form a horizontal blinker
        grid_next[7][8] = 0;
        grid_next[8][7] = 1;
        grid_next[8][8] = 1;
        grid_next[8][9] = 1;
        grid_next[9][8] = 0;
        enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);



        // Reset and configure the grid for another blinker
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Initial configuration for another vertical blinker
        set_initial <= 1;
        row_select <= 8'd4; col_select <= 8'd4; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd5; col_select <= 8'd4; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd6; col_select <= 8'd4; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);

        // Update grid to form a horizontal blinker
        grid_next[4][4] = 0;
        grid_next[5][3] = 1;
        grid_next[5][4] = 1;
        grid_next[5][5] = 1;
        grid_next[6][4] = 0;
        enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);


        // Reset and configure the grid for a glider (not a blinker, should not affect pattern_count)
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Initial configuration for a glider
        set_initial <= 1;
        row_select <= 8'd1; col_select <= 8'd1; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd2; col_select <= 8'd2; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd2; col_select <= 8'd3; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd3; col_select <= 8'd1; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd3; col_select <= 8'd2; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a few cycles to see if the pattern count is unaffected
        repeat (5) @(posedge clk);


        // Reset for the next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Initial configuration for a horizontal blinker that becomes vertical
        set_initial <= 1;
        row_select <= 8'd10; col_select <= 8'd10; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd10; col_select <= 8'd11; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd10; col_select <= 8'd12; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);

        // Update grid to form a vertical blinker
        grid_next[9][11] = 1;
        grid_next[10][10] = 0;
        grid_next[10][11] = 1;
        grid_next[10][12] = 0;
        grid_next[11][11] = 1;
        enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a cycle
        repeat (1) @(posedge clk);

        $stop;
    end
endmodule
