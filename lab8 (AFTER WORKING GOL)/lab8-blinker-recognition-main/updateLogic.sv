// Implements rules of the GoL, helps to update the grid to grid_next after each clk cycle
// Is called when SW[8] i.e. start_game is pushed to 1

module updateLogic (
    input logic clk,
    input logic reset,
    input logic [15:0][15:0] grid,
    output logic [15:0][15:0] grid_next
);
    logic [2:0] num_neighbors;
    logic current_state;
    logic [4:0] neighbor_row, neighbor_col;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            grid_next <= '{default: 0};
        end else begin
            for (int row = 0; row < 16; row++) begin
                for (int col = 0; col < 16; col++) begin
                    num_neighbors = 0;
                    for (int i = -1; i <= 1; i++) begin
                        for (int j = -1; j <= 1; j++) begin
                            if (i != 0 || j != 0) begin
                                neighbor_row = row + i;
                                neighbor_col = col + j;
                                if (neighbor_row >= 0 && neighbor_row < 16 && neighbor_col >= 0 && neighbor_col < 16) begin
                                    num_neighbors += grid[neighbor_row][neighbor_col];
                                end
                            end
                        end
                    end
                    current_state = grid[row][col];
                    if (current_state == 1) begin
                        if (num_neighbors < 2 || num_neighbors > 3) begin
                            grid_next[row][col] = 0;
                        end else begin
                            grid_next[row][col] = 1;
                        end
                    end else begin
                        if (num_neighbors == 3) begin
                            grid_next[row][col] = 1;
                        end else begin
                            grid_next[row][col] = 0;
                        end
                    end
                end
            end
        end
    end
endmodule




module updateLogic_testbench();
    logic clk, reset;
    logic [15:0][15:0] grid;
    logic [15:0][15:0] grid_next;

    updateLogic dut (clk, reset, grid, grid_next);

    // Set up a simulated clock.
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    // Test the design.
    initial begin
        // Reset the design
        reset <= 1;          @(posedge clk); // reset every time we start
        @(posedge clk);
        reset <= 0;          @(posedge clk);
        @(posedge clk);

        // Test case 1: Initial grid state
        grid = '{default: 0};
        grid[8][7] = 1; grid[8][8] = 1; grid[8][9] = 1; // Horizontal blinker
        @(posedge clk); @(posedge clk);

        // Test case 2: Next grid state
        grid = grid_next;
        @(posedge clk); @(posedge clk);

        // Test case 3: Another next grid state
        grid = grid_next;
        @(posedge clk); @(posedge clk);

        // Test case 4: Reset and new pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);
        grid = '{default: 0};
        grid[7][8] = 1; grid[8][8] = 1; grid[9][8] = 1; // Vertical blinker
        @(posedge clk); @(posedge clk);

        // Test case 5: Next grid state
        grid = grid_next;
        @(posedge clk); @(posedge clk);

        // Test case 6: Another next grid state
        grid = grid_next;
        @(posedge clk); @(posedge clk);

        $stop;
    end
endmodule
