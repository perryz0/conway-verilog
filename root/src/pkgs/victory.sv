module victory (clk, reset, L, R, LEDR, HEX0, HEX1, resetround);
	input logic clk, reset;
	input logic L, R;
	input logic [9:0] LEDR;
	output logic [6:0] HEX0, HEX1;
	output logic resetround;
	
	// 3-bit counter for wins
	logic [2:0] pwins, bwins;
	
	
	// State variables (leftW = KEY3 = Player 2, rightW = KEY0 = Player 1)
	enum { inprogress, botW, playerW } ps, ns;

	// Next state logic
	always_comb begin
		case (ps)
			inprogress: 		if (LEDR[9]&L&~R)						ns = botW;
									else if (LEDR[1]&R&~L)				ns = playerW;
									else										ns = inprogress;
							
			botW:					ns = botW;			// bot wins tracked by HEX1 (left player)
			playerW:				ns = playerW;		// player wins tracked by HEX0 (right player)
		endcase
	end

   // Output logic for HEX displays
   always_comb begin
      // PLAYER (rhs) wins counting system
      case (pwins)
         3'b000: HEX0 = ~7'b0111111; // 0
         3'b001: HEX0 = ~7'b0000110; // 1
         3'b010: HEX0 = ~7'b1011011; // 2
         3'b011: HEX0 = ~7'b1001111; // 3
         3'b100: HEX0 = ~7'b1100110; // 4
         3'b101: HEX0 = ~7'b1101101; // 5
         3'b110: HEX0 = ~7'b1111101; // 6
         default: HEX0 = ~7'b0000111; // 7
      endcase
      
      // BOT (lhs) wins counting system
      case (bwins)
         3'b000: HEX1 = ~7'b0111111; // 0
         3'b001: HEX1 = ~7'b0000110; // 1
         3'b010: HEX1 = ~7'b1011011; // 2
         3'b011: HEX1 = ~7'b1001111; // 3
         3'b100: HEX1 = ~7'b1100110; // 4
         3'b101: HEX1 = ~7'b1101101; // 5
         3'b110: HEX1 = ~7'b1111101; // 6
         default: HEX1 = ~7'b0000111; // 7
      endcase
   end
   
   // Sequential logic for state and counters
   always_ff @(posedge clk) begin
      if (reset) begin
         pwins <= 3'b000;
         bwins <= 3'b000;
         ps <= inprogress;
         resetround <= 0;
      end
		else if (resetround) begin
			ps <= inprogress;
			resetround <= 0;
		end
		else begin
         ps <= ns;
         if (ps == inprogress && ns == playerW) 
            pwins <= pwins + 3'b001;
         else if (ps == inprogress && ns == botW) 
            bwins <= bwins + 3'b001;
         
         // Reset round logic
         if (ps == botW || ps == playerW)
            resetround <= 1;
         else
            resetround <= 0;
      end
   end
	
endmodule 


module victory_testbench();
	logic clk, reset;
	logic L, R;
	logic [9:0] LEDR;
	logic [6:0] HEX0;

	victory dut (clk, reset, L, R, LEDR, HEX0);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Test the design.
	initial begin
		reset <= 1;															@(posedge clk);
																				@(posedge clk);
		reset <= 0;															@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 1; 	LEDR[1] <= 0; L <= 1; R <= 0;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1;									@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 1; 	LEDR[1] <= 1;									@(posedge clk);
																				@(posedge clk);
		LEDR[1] <= 0; 	R <= 1;  										@(posedge clk);
																				@(posedge clk);
		reset <= 1;															@(posedge clk);
																				@(posedge clk);
		reset <= 0;															@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);	// bot won >7 times in a row
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	LEDR[1] <= 1; L <= 0; R <= 1;				@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 1;				 										@(posedge clk);
																				@(posedge clk);
		LEDR[9] <= 0; 	L <= 1;											@(posedge clk);
																				@(posedge clk);
		$stop; 
	end 
endmodule 