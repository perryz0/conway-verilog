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
