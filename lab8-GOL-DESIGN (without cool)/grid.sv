// Manages the state of the cells
module grid (clk, reset, row_select, col_select, set_initial, new_state, enable_update, grid, grid_next);
   input logic clk, reset;
   input logic [7:0] row_select, col_select;
   input logic set_initial, new_state, enable_update;
   output logic [15:0][15:0] grid;
	input logic [15:0][15:0] grid_next;

   always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
         grid <= '{default: 0};
      end else if (set_initial) begin
         grid[row_select][col_select] <= new_state;
      end else if (enable_update) begin
         grid <= grid_next;
      end
   end
endmodule




module grid_testbench();
    logic clk, reset;
    logic [7:0] row_select, col_select;
    logic set_initial, new_state, enable_update;
    logic [15:0][15:0] grid, grid_next;

    grid dut (clk, reset, row_select, col_select, set_initial, new_state, enable_update, grid, grid_next);

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

        $stop;
    end
endmodule
