// Implements rules of the GoL, helps to update the old grid to next state after clk cycle

module updateLogic (clk, grid, grid_next);
   input logic clk;
   input logic [15:0][15:0] grid;
   output logic [15:0][15:0] grid_next;
   
   logic [2:0] num_neighbors;
   logic current_state;

   always_comb begin
      for (int row = 0; row < 16; row++) begin
         for (int col = 0; col < 16; col++) begin
            num_neighbors = 0;
            for (int i = -1; i <= 1; i++) begin
               for (int j = -1; j <= 1; j++) begin
                  if (i != 0 || j != 0) begin
                     int neighbor_row = row + i;
                     int neighbor_col = col + j;
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
endmodule
