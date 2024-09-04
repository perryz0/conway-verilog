// Top-level module that defines the I/Os for the DE-1 SoC + LED expansion boards
module DE1_SoC (
    CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_1
);
    input logic CLOCK_50; // 50MHz clock.
    output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    output logic [9:0] LEDR;
    input logic [3:0] KEY; // True when not pressed, False when pressed
    input logic [9:0] SW;
    output logic [35:0] GPIO_1;

    logic reset, start_game;
    assign reset = SW[9];
    assign start_game = SW[8];

    // Slower clock for Game of Life
    logic [31:0] clk;
    parameter slow = 6;
    clock_divider cdiv (.clock(CLOCK_50), .reset(reset), .divided_clocks(clk));

    // Game of Life modules and signals
    logic [15:0][15:0] RedPixels, GrnPixels, RedPixels_next;
    logic [7:0] row_select, col_select;
    logic cell_state, set_initial, game_running;
    logic [3:0] pattern_count;

    // Instantiate the interface for handling user configs to the startpos of GoL
    userInput user_interface (
        .clk(clk[slow]), 
        .reset(reset), 
        .KEY(KEY), 
        .SW0(SW[0]), 
        .start_game(start_game), 
        .row_select(row_select), 
        .col_select(col_select), 
        .set_initial(set_initial), 
        .cell_state(cell_state), 
        .GrnPixels(GrnPixels)
    );

    // Instantiate the Grid Module
    grid grid_inst (
        .clk(clk[slow]), 
        .reset(reset), 
        .row_select(row_select), 
        .col_select(col_select), 
        .set_initial(set_initial), 
        .new_state(cell_state), 
        .enable_update(game_running), 
        .grid(RedPixels),
        .grid_next(RedPixels_next),
        .pattern_count(pattern_count)
    );

    // Update Logic (when the game actually runs, after start signal is given, start cell config is done)
    updateLogic game_of_life (
        .clk(clk[slow]),
        .reset(reset),
        .grid(RedPixels), 
        .grid_next(RedPixels_next)
    );

    // Standard LED Driver instantiation (directly from LED driver tutorial)
    LEDDriver Driver (.CLK(clk[slow]), .RST(reset), .EnableCount(~reset), .RedPixels(RedPixels), .GrnPixels(GrnPixels), .GPIO_1(GPIO_1));

    // Control Unit
    controlUnit control_unit (
        .clk(clk[slow]), 
        .reset(reset), 
        .start(start_game), 
        .enable_update(game_running)
    );

    // Display pattern count on HEX4 and HEX5
    patternCounterDisplay counter_display (
        .pattern_count(pattern_count),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Turn off unused HEX displays
    assign HEX0 = '1;
    assign HEX1 = '1;
    assign HEX2 = '1;
    assign HEX3 = '1;
endmodule











module DE1_SoC_testbench();
   logic clk, reset, start_game;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [9:0] LEDR;
   logic [9:0] SW;
   logic [35:0] GPIO_1;
   logic [3:0] KEY;
   logic SW0;
   logic [7:0] row_select;
   logic [7:0] col_select;
   logic set_initial;
   logic cell_state;
   logic [15:0][15:0] RedPixels, RedPixels_next, GrnPixels, grid_initial;
   logic [3:0] pattern_count;

   DE1_SoC dut (clk, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_1);

   // Set up a simulated clock.
   parameter CLOCK_PERIOD = 100;
   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
   end

    // Test the design.
    initial begin
        reset <= 1;          @(posedge clk); // reset every time we start
        @(posedge clk);
        reset <= 0;          @(posedge clk);
        @(posedge clk);

        // Configure Pattern 1
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move left
        SW0 <= 0; @(posedge clk); @(posedge clk); // Clear cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 1
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);
        
        // Let the game run for a few cycles
        repeat (5) @(posedge clk);

        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Configure Pattern 2
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move left
        SW0 <= 0; @(posedge clk); @(posedge clk); // Clear cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 2
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);

        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Configure Pattern 3
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move left
        SW0 <= 0; @(posedge clk); @(posedge clk); // Clear cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 3
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);

        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Configure Pattern 4
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move left
        SW0 <= 0; @(posedge clk); @(posedge clk); // Clear cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 4
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);
        
        // Test Pattern 1: Vertical Blinker
        // Initial configuration for vertical blinker
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd7; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 1
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);


        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Test Pattern 2: Horizontal Blinker
        // Initial configuration for horizontal blinker
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd7; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move right
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move right
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 2
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (5) @(posedge clk);


        // Reset for next pattern
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);

        // Test Pattern 3: Both Vertical and Horizontal Blinker Oscillations
        // Initial configuration for both vertical and horizontal blinker oscillations
        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd7; col_select <= 8'd8; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1101; @(posedge clk); @(posedge clk); // Move down
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        KEY <= 4'b1111; SW0 <= 1;
        row_select <= 8'd8; col_select <= 8'd7; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move right
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell
        KEY <= 4'b1011; @(posedge clk); @(posedge clk); // Move right
        SW0 <= 1; @(posedge clk); @(posedge clk); // Set cell

        // Start game for Pattern 3
        SW[8] <= 1; @(posedge clk); @(posedge clk);
        SW[8] <= 0; @(posedge clk); @(posedge clk);

        // Let the game run for a few cycles
        repeat (10) @(posedge clk);

        $stop;
    end
endmodule
