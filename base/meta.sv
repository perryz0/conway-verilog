// Addresses metastability issue for non-synced inputs into the system

module meta (clk, reset, button, out);
	input logic clk, reset;
	input logic button;
	output logic out;
	logic metastate;

	// first DFF
	always_ff @(posedge clk) begin
		metastate <= button;
	end
	
	// second DFF
	always_ff @(posedge clk) begin
		out <= metastate;
	end
endmodule 

// Metastability testbench, should be the same output across the board (when clk cycles differ)
module meta_testbench();
	logic clk, reset;
	logic button;
	logic out;
	logic metastate;
	
	meta dut (clk, reset, button, out);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Test the design.
	initial begin
		
		reset <= 1;					@(posedge clk);	// reset every time we start
										@(posedge clk);
		reset	<= 0;					@(posedge clk);
										@(posedge clk);
		button <= 0;				@(posedge clk);	// give it 2 clock cycles to pass thru 2 dff's
										@(posedge clk);
										@(posedge clk);
		button <= 1;				@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		button <= 0;				@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		button <= 1;				@(posedge clk);
										@(posedge clk);
										@(posedge clk);
													
		$stop; 
	end 
endmodule 