// Pseudo- RNG using an XNOR LFSR config

module LFSR(clk, reset, Q);
	output logic [9:0] Q;
   input logic clk, reset; 
   logic xnor_out;

   assign xnor_out = ~(Q[0] ^ Q[3]);	// table indicates "XNOR from 10, 7", so bit10 and bit7

   always_ff @(posedge clk) begin
		if(reset) Q <= 10'b0000000000;

      else Q <= {xnor_out, Q[9: 1]};	// right-shift and place the xnor'd output at MSB
   end
endmodule



module LFSR_testbench();
   logic [10:1] Q;
   logic clk, reset;
   logic xnor_out;

	LFSR dut (clk, reset, Q);
	
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	
	// Test the design.
	initial begin
        reset <= 1;                         		@(posedge clk);	// reset in beginning
                                                @(posedge clk);
        reset <= 0;                            	@(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);	// observe the pseudo-random Q vals
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
																@(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
                                                @(posedge clk);
        $stop;
    end
endmodule 