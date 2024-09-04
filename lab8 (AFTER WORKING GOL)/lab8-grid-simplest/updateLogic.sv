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
