module grid (
    clk, 
    reset, 
    row_select, 
    col_select, 
    set_initial, 
    new_state, 
    enable_update, 
    grid, 
    grid_next, 
    grid_color, 
    grid_next_color, 
    color_mode
);
    input logic clk, reset;
    input logic [7:0] row_select, col_select;
    input logic set_initial, new_state, enable_update, color_mode;
    output logic [15:0][15:0] grid;
    input logic [15:0][15:0] grid_next;
    output logic [15:0][15:0] grid_color;
    input logic [15:0][15:0] grid_next_color;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            grid <= '{default: 0};
            grid_color <= '{default: 0};
        end else if (set_initial) begin
            grid[row_select][col_select] <= new_state;
            if (new_state) begin
                grid_color[row_select][col_select] <= 1; // Start with red
            end else begin
                grid_color[row_select][col_select] <= 0; // No color
            end
        end else if (enable_update) begin
            grid <= grid_next;
            if (color_mode) begin
                grid_color <= grid_next_color;
            end else begin
                grid_color <= '{default: 1}; // All red if color mode is off
            end
        end
    end
endmodule
