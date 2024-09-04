// Grid module with pattern detection
// Grid module with pattern detection
module grid (
    input logic clk,
    input logic reset,
    input logic [7:0] row_select,
    input logic [7:0] col_select,
    input logic set_initial,
    input logic new_state,
    input logic enable_update,
    output logic [15:0][15:0] grid,
    input logic [15:0][15:0] grid_next,
    output logic [3:0] pattern_count
);
    logic [15:0][15:0] grid_prev;
    logic [15:0][15:0] candidate_blinkers;
    logic [15:0][15:0] confirmed_blinkers;
    logic [3:0] temp_pattern_count;

    // State registers for grid and pattern count
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            grid <= '{default: 0};
            grid_prev <= '{default: 0};
            candidate_blinkers <= '{default: 0};
            confirmed_blinkers <= '{default: 0};
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
        // Initialize candidate blinkers to zero
        candidate_blinkers = '{default: 0};

        for (int row = 1; row < 15; row++) begin
            for (int col = 1; col < 15; col++) begin
                // Horizontal blinker check
                if (grid[row][col-1] == 1 && grid[row][col] == 1 && grid[row][col+1] == 1 &&
                    grid_prev[row-1][col] == 0 && grid_prev[row+1][col] == 0 &&
                    grid_prev[row][col-1] == 1 && grid_prev[row][col] == 1 && grid_prev[row][col+1] == 1) begin
                    candidate_blinkers[row][col] = 1;
                end
                // Vertical blinker check
                else if (grid[row-1][col] == 1 && grid[row][col] == 1 && grid[row+1][col] == 1 &&
                         grid_prev[row][col-1] == 0 && grid_prev[row][col+1] == 0 &&
                         grid_prev[row-1][col] == 1 && grid_prev[row][col] == 1 && grid_prev[row+1][col] == 1) begin
                    candidate_blinkers[row][col] = 1;
                end
            end
        end

        // Confirm candidates and update confirmed_blinkers
        for (int row = 1; row < 15; row++) begin
            for (int col = 1; col < 15; col++) begin
                if (candidate_blinkers[row][col] == 1) begin
                    if (confirmed_blinkers[row][col] == 0) begin
                        temp_pattern_count = temp_pattern_count + 1;
                        confirmed_blinkers[row][col] = 1;
                    end
                end else if (confirmed_blinkers[row][col] == 1) begin
                    // Check if the confirmed blinker still exists
                    if (!((grid[row][col-1] == 1 && grid[row][col] == 1 && grid[row][col+1] == 1) ||
                          (grid[row-1][col] == 1 && grid[row][col] == 1 && grid[row+1][col] == 1))) begin
                        confirmed_blinkers[row][col] = 0; // Remove if disturbed
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
        // Reset and configure pattern 1
        reset <= 1;          @(posedge clk); // reset every time we start
        @(posedge clk);
        reset <= 0;          @(posedge clk);
        @(posedge clk);

        // Pattern 1
        row_select <= 8'd8;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd8;
        col_select <= 8'd7;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd9;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd10;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        // Start the game
        enable_update <= 1;
        @(posedge clk); @(posedge clk);
        enable_update <= 0;
        repeat (5) @(posedge clk); // Let the game run for a few cycles
        reset <= 1; @(posedge clk); @(posedge clk); reset <= 0; @(posedge clk);

        // Pattern 2
        row_select <= 8'd8;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd9;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd10;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        // Start the game
        enable_update <= 1;
        @(posedge clk); @(posedge clk);
        enable_update <= 0;
        repeat (5) @(posedge clk); // Let the game run for a few cycles
        reset <= 1; @(posedge clk); @(posedge clk); reset <= 0; @(posedge clk);

        // Pattern 3
        row_select <= 8'd8;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd9;
        col_select <= 8'd7;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd9;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd10;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        // Start the game
        enable_update <= 1;
        @(posedge clk); @(posedge clk);
        enable_update <= 0;
        repeat (5) @(posedge clk); // Let the game run for a few cycles
        reset <= 1; @(posedge clk); @(posedge clk); reset <= 0; @(posedge clk);

        // Pattern 4
        row_select <= 8'd8;
        col_select <= 8'd8;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd9;
        col_select <= 8'd9;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd10;
        col_select <= 8'd10;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        row_select <= 8'd11;
        col_select <= 8'd11;
        set_initial <= 1;
        new_state <= 1;
        @(posedge clk); @(posedge clk);
        set_initial <= 0; @(posedge clk); @(posedge clk);

        // Start the game
        enable_update <= 1;
        @(posedge clk); @(posedge clk);
        enable_update <= 0;
        repeat (5) @(posedge clk); // Let the game run for a few cycles
		  
		  
		  
		  
		  
			// Test cases for pattern recognition
			
        // Test Pattern 1: Vertical Blinker
        // Initial configuration for vertical blinker
        set_initial <= 1;
        row_select <= 8'd7; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd9; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);

        // Check pattern_count
        $display("Pattern count after vertical blinker: %d", pattern_count);

        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Test Pattern 2: Horizontal Blinker
        // Initial configuration for horizontal blinker
        set_initial <= 1;
        row_select <= 8'd8; col_select <= 8'd7; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd9; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);

        // Check pattern_count
        $display("Pattern count after horizontal blinker: %d", pattern_count);

        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Test Pattern 3: Both Vertical and Horizontal Blinker Oscillations
        // Initial configuration for both vertical and horizontal blinker oscillations
        set_initial <= 1;
        row_select <= 8'd7; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd9; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell

        row_select <= 8'd8; col_select <= 8'd7; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd8; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        row_select <= 8'd8; col_select <= 8'd9; new_state <= 1; @(posedge clk); @(posedge clk); // Set cell
        set_initial <= 0; enable_update <= 1; @(posedge clk); @(posedge clk); enable_update <= 0;

        // Let the game run for a few cycles
        repeat (10) @(posedge clk);

        // Check pattern_count
        $display("Pattern count after both blinkers: %d", pattern_count);

        $stop;
    end
endmodule
