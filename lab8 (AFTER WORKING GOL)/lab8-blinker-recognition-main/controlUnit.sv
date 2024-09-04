// Manages timing for updating GoL state (delay between GoL iterations)

module controlUnit (clk, reset, start, enable_update);
   input logic clk, reset;
   input logic start;
   output logic enable_update;
   
   logic [31:0] counter;
   parameter UPDATE_INTERVAL = 250000;

   always_ff @(posedge clk or posedge reset) begin
      if (reset) begin
         counter <= 0;
         enable_update <= 0;
      end else if (start) begin
         if (counter == UPDATE_INTERVAL) begin
            counter <= 0;
            enable_update <= 1;
         end else begin
            counter <= counter + 1;
            enable_update <= 0;
         end
      end else begin
         enable_update <= 0;
      end
   end
endmodule



module controlUnit_testbench();
    logic clk, reset, start;
    logic enable_update;

    controlUnit dut (clk, reset, start, enable_update);

    // Set up a simulated clock.
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
    end

    // Test the design.
    initial begin
        // Reset the design
        reset <= 1; start <= 0; @(posedge clk); // reset every time we start
        @(posedge clk);
        reset <= 0; @(posedge clk); @(posedge clk);

        // Test case 1: No start signal
        start <= 0; @(posedge clk); @(posedge clk);

        // Test case 2: Start signal, enable_update should be asserted after UPDATE_INTERVAL
        start <= 1;
        repeat (250001) @(posedge clk);

        // Test case 3: Keep the start signal, observe enable_update behavior
        repeat (500000) @(posedge clk);

        // Test case 4: Remove start signal, enable_update should not assert
        start <= 0; @(posedge clk); @(posedge clk);

        // Test case 5: Reapply reset and start again
        reset <= 1; @(posedge clk); reset <= 0; @(posedge clk);
        start <= 1;
        repeat (250001) @(posedge clk);

        $stop;
    end
endmodule
