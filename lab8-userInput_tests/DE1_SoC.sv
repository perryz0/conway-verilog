// Top-level module that defines the I/Os for the DE-1 SoC + LED expansion boards
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_1);
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

   // Instantiate the interface for handling user configs to the startpos of GoL
   userInput user_interface (
      .clk(clk[slow]), 
      .reset(reset), 
      .KEY(KEY), 
      .SW0(SW[0]), 
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
      .grid_next(RedPixels_next)
   );

   // Standard LED Driver instantiation (directly from LED driver tutorial)
   LEDDriver Driver (.CLK(clk[slow]), .RST(reset), .EnableCount(1'b1), .RedPixels(RedPixels), .GrnPixels(GrnPixels), .GPIO_1(GPIO_1));

   // Control Unit
   controlUnit control_unit (
      .clk(clk[slow]), 
      .reset(reset), 
      .start(start_game), 
      .enable_update(game_running)
   );

   // Update Logic (when the game actually runs, after start signal is given, start cell config is done)
   updateLogic game_of_life (
      .clk(clk[slow]), 
      .grid(RedPixels), 
      .grid_next(RedPixels_next)
   );

   // Turn off unused HEX displays
   assign HEX0 = '1;
   assign HEX1 = '1;
   assign HEX2 = '1;
   assign HEX3 = '1;
   assign HEX4 = '1;
   assign HEX5 = '1;
endmodule
