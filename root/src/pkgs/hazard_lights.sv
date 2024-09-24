// INPUTS are SW's, OUTPUTS are LEDR's, reset is KEY[0]

module hazard_lights (clk, reset, SW, LEDR);
	input logic clk, reset;
	input logic [9:0] SW;
	output logic [9:0] LEDR;
	
	// only using sw1, sw0 and ledr2, ledr1, ledr0
//	assign in[1:0] = SW[1:0];
//	assign out[2:0] = LEDR[2:0];
	
	// State variables (explicit bit-encodings for the 4 states in my design; 2 ff's used)
//	enum logic [2:0] { outside = 3'b101, center = 3'b010, left = 3'b100, right = 3'b001 } ps, ns;
	enum { outside, center, left, right } ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			outside: 	if (SW == 2'b00)			ns = center;
							else if (SW == 2'b01)	ns = right;
							else 							ns = left;	// when SW == 2'b10, since 2'b11 is not possible (DC)
							
			center: 		if (SW == 2'b00)			ns = outside;
							else if (SW == 2'b01)	ns = left;
							else 							ns = right;
							
			left: 		if (SW == 2'b00)			ns = outside;
							else if (SW == 2'b01)	ns = right;
							else 							ns = center;
							
			right: 		if (SW == 2'b00)			ns = outside;
							else if (SW == 2'b01)	ns = center;
							else 							ns = left;
		endcase
	end

	// Output logic
	always_comb begin
		if (reset)
			LEDR = 3'b101;
		else begin
			case (ns)	// the LED display output is fully dependent on what the next state is
				outside: 	LEDR = 3'b101;					
				center:		LEDR = 3'b010;
				left:			LEDR = 3'b100;
				right:		LEDR = 3'b001;
			endcase
		end
	end
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset) begin
			ps <= outside;
		end else
			ps <= ns;
	end
	
endmodule 


module hazard_lights_testbench();
	logic clk, reset;
	logic [9:0] SW;
	logic [9:0] LEDR;

	hazard_lights dut (clk, reset, SW, LEDR);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
											@(posedge clk);
		reset <= 1; 					@(posedge clk); // Always reset FSMs at start
		reset <= 0; SW <= 2'b01; 	@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						SW <= 2'b10; 	@(posedge clk);
		reset <= 1;					 	@(posedge clk);
		reset <= 0; SW <= 2'b00; 	@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						SW <= 2'b10; 	@(posedge clk);
											@(posedge clk);
		$stop; // End the simulation.
	end

endmodule 