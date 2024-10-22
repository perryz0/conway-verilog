// LAB 4 PART 2: UPC code to display (lab 3 copy)

module lab3 (LEDR, SW);
	output logic [9:0] LEDR;
	input logic [9:0] SW;
	
	// SW[9], SW[8], SW[7] for U, P, C respectively. SW[0] for MARK.
	// LEDR[0], LEDR[1] for DISCOUNTED, STOLEN signals respectively.
	
	// DISCOUNTED signal implementation: 2 gates used
	assign LEDR[0] = SW[8] | (SW[9] & SW[7]);		// 1 AND, 1 OR gates used --- 2 gates
	
	
	// STOLEN signal implementation: 3 gates used
	assign LEDR[1] = ~((~SW[9] & SW[7]) | SW[0] | SW[8]);	// 1 NOT, 1 AND, 1 NOR used --- 3 gates
	
endmodule
