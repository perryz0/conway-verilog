// Manages the state of the cells
module grid (clk, reset, row_select, col_select, set_initial, new_state, enable_update, grid, grid_next);
   input logic clk, reset;
   input logic [7:0] row_select, col_select;
   input logic set_initial, new_state, enable_update;
   output logic [15:0][15:0] grid, grid_next;

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
   logic set_initial, new_state;
   logic [15:0][15:0] grid_initial;
   
   grid dut (clk, reset, row_select, col_select, set_initial, new_state, grid_initial);
   
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

      // Set initial cell states
      row_select <= 8'd8;
      col_select <= 8'd8;
      set_initial <= 1;
      new_state <= 1;
      @(posedge clk);      @(posedge clk);
      set_initial <= 0;
      @(posedge clk);      @(posedge clk);
      row_select <= 8'd9;
      col_select <= 8'd9;
      set_initial <= 1;
      new_state <= 1;
      @(posedge clk);      @(posedge clk);
      set_initial <= 0;
      @(posedge clk);      @(posedge clk);

      $stop;
   end
endmodule
