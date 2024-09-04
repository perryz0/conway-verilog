module displayseg7 (SW, HEX0, HEX1);
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1;
	logic [6:0] invHEX0, invHEX1;
	
	seg7 h0 (.bcd(SW[3:0]), .leds(invHEX0));
	seg7 h1 (.bcd(SW[7:4]), .leds(invHEX1));

	assign HEX0 = ~invHEX0;
	assign HEX1 = ~invHEX1;
endmodule
