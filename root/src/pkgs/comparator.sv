module comparator(clk, reset, Q, SW, out);
   output logic out;		// 1 means Q is greater, 0 is not
	input logic clk, reset;
	input logic [9:0] Q;
	input logic [8:0] SW;
	
	logic [9:0] SW_extend;
	
	// zero-ext for the MSB to make it 10-bit unsigned val for comparison
	assign SW_extend = {1'b0, SW}; 
	
   logic [10:0] Q_unsigned;
   logic [10:0] SW_unsigned;
   logic [10:0] difference;

   // pad zeros to Q and SW to treat as unsigned values
   assign Q_unsigned = {1'b0, Q}; // sign extend Q to make it unsigned
   assign SW_unsigned = {1'b0, SW_extend}; // Sign extend SW to make it unsigned

   // subtraction
   assign difference = Q_unsigned - SW_unsigned;

   // output logic
   always_comb begin
      // Check MSB of difference
      out = difference[10]; // Q is less than SW
   end

endmodule



// UNIMPLEMENTED
module comparator_testbench();
	logic out;
	logic clk, reset;
	logic [9:0] Q;
	logic [8:0] SW;
	logic [9:0] SW_extend;
	
	comparator dut(.clk, .reset, .Q, .SW, .out);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Test the design.
	initial begin
		reset <= 1;											@(posedge clk);
																@(posedge clk);
		reset <= 0;											@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000000;	SW = 9'b000000010;	@(posedge clk);
																@(posedge clk);
		Q = 10'b0000000011;								@(posedge clk);
																@(posedge clk);
		Q = 10'b0001010111;	SW = 9'b111111111;	@(posedge clk);
																@(posedge clk);
		Q = 10'b1000000001;								@(posedge clk);
																@(posedge clk);
																@(posedge clk);
																@(posedge clk);
		$stop;
	end
endmodule