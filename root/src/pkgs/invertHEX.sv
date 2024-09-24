// LAB 4 PART 2: Helper mod to invert the segment displays


// NOT USED. FOUND EASIER METHOD OF INVERTING EACH BIT.
module invertHEX (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
						iHEX0, iHEX1, iHEX2, iHEX3, iHEX4, iHEX5);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [6:0] iHEX0, iHEX1, iHEX2, iHEX3, iHEX4, iHEX5;
	
//	// loop through all six HEX displays and invert seg-bits
//	for(i = 0; i < 6; i++) begin
//		assign iHEX+i = ~(HEX+i);
//	end

	assign HEX0 = ~iHEX0;
	assign HEX1 = ~iHEX1;
	assign HEX2 = ~iHEX2;
	assign HEX3 = ~iHEX3;
	assign HEX4 = ~iHEX4;
	assign HEX5 = ~iHEX5;
	
endmodule
