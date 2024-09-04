module updateLogic (
    clk, 
    reset, 
    grid, 
    grid_next, 
    grid_color, 
    grid_next_color, 
    color_mode
);
    input logic clk, reset;
    input logic [15:0][15:0] grid;
    output logic [15:0][15:0] grid_next;
    input logic [15:0][15:0] grid_color;
    output logic [15:0][15:0] grid_next_color;
    input logic color_mode;

    logic [2:0] num_neighbors;
    logic current_state, next_state;
    logic current_color;
    logic [4:0] neighbor_row, neighbor_col;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            grid_next <= '{default: 0};
            grid_next_color <= '{default: 0};
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
                    current_color = grid_color[row][col];
                    if (current_state == 1) begin
                        if (num_neighbors < 2 || num_neighbors > 3) begin
                            next_state = 0;
                            grid_next_color[row][col] = 0;
                        end else begin
                            next_state = 1;
                            if (color_mode) begin
                                grid_next_color[row][col] = (current_color == 1) ? 0 : 1; // Toggle color
                            end else begin
                                grid_next_color[row][col] = 1;
                            end
                        end
                    end else begin
                        if (num_neighbors == 3) begin
                            next_state = 1;
                            grid_next_color[row][col] = (color_mode) ? 1 : 0; // New cells are green if in color mode
                        end else begin
                            next_state = 0;
                            grid_next_color[row][col] = 0;
                        end
                    end
                    grid_next[row][col] = next_state;
                end
            end
        end
    end
endmodule
