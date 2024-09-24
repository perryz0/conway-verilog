module centerLight (clk, reset, L, R, NL, NR, lightOn, resetround);
	input logic clk, reset;
	// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.
	input logic L, R, NL, NR;
	// when lightOn is true, the center light should be on.
	output logic lightOn;
	
	// logic to recenter the light even when reset switch is not on
	input logic resetround;
	
	
	// State variables (only 2 needed states)
	enum { on, off } ps, ns;

	// Next state logic
	always_comb begin
		case (ps)
			on: 		if ((R & ~L) | (L & ~R))			ns = off;	// xor for when L & R clicked simultaneously
						else										ns = on;
							
			off: 		if ((NR&L&(~R)) | (NL&R&(~L)))			ns = on;
						else										ns = off;
		endcase 
	end

	// Output LED logic
	always_comb begin
		case (ps)
			on:		lightOn = 1'b1;
			off:		lightOn = 1'b0;
		endcase
	end
	
	// Sequential logic (DFFs)
	always_ff @(posedge clk) begin
		if (reset | resetround)
			ps <= on;
		else
			ps <= ns;
	end
	
endmodule 


module centerLight_testbench();
	logic clk, reset;
	logic L, R; 
	logic NL, NR;
	logic lightOn;

	centerLight dut (clk, reset, L, R, NL, NR, lightOn);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Test the design.
	initial 
	begin
														@(posedge clk)  
		reset <= 1;									@(posedge clk)	// reset every time we start as usual
														@(posedge clk)
		reset <= 0;									@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 1; L <= 1; R <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0;							@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; 							@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 1; 						@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0; L <= 1; 				@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		reset <= 0;									@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0; L <= 0; R <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 1; R <= 0; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 0; R <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0; L <= 0; R <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 1; R <= 0; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 0; R <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		$stop; 
	end 
endmodule 