// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, reset, divided_clocks);
	input logic reset, clock;
	output logic [31:0] divided_clocks = 0;

	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
	
endmodule


module clock_divider_testbench();
   logic clk;
	logic reset;
   logic [31:0] divided_clocks;

	clock_divider dut (.clock(clk), .reset, .divided_clocks);
	
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