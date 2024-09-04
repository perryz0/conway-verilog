// LAB 4 PART 2: UPC code to display (RTL display design)

module upcdisplay (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input logic [9:0] SW;
	logic [2:0] upc;
	
	assign upc[2:0] = SW[9:7];
	
	// SW[9], SW[8], SW[7] for U, P, C respectively.

	always_comb begin
		case (upc)
			// Jeep
			3'b000: begin
				HEX5 = ~7'b1011010;
				HEX4 = ~7'b1011101;
				HEX3 = ~7'b1011101;
				HEX2 = ~7'b0001111;
				HEX1 = ~7'b1000000;
				HEX0 = ~7'b1000000;
				end
			// Coffee
			3'b001: begin
				HEX5 = ~7'b0111001;
				HEX4 = ~7'b1011100;
				HEX3 = ~7'b1110001;
				HEX2 = ~7'b1110001;
				HEX1 = ~7'b1111001;
				HEX0 = ~7'b1111001;
				end
			// Pencil
			3'b011: begin
				HEX5 = ~7'b1000110;
				HEX4 = ~7'b0001001;
				HEX3 = ~7'b0001001;
				HEX2 = ~7'b0001111;
				HEX1 = ~7'b0111111;
				HEX0 = ~7'b0000000;
				end
			// Windows PC
			3'b100: begin
				HEX5 = ~7'b0000000;
				HEX4 = ~7'b1111111;
				HEX3 = ~7'b1111111;
				HEX2 = ~7'b0000110;
				HEX1 = ~7'b0111111;
				HEX0 = ~7'b0000000;
				end
			// Rocket
			3'b101: begin
				HEX5 = ~7'b1000110;
				HEX4 = ~7'b0001001;
				HEX3 = ~7'b0001001;
				HEX2 = ~7'b0001001;
				HEX1 = ~7'b1111001;
				HEX0 = ~7'b1001001;
				end
			// Soccer Ball
			3'b110: begin
				HEX5 = ~7'b1111100;
				HEX4 = ~7'b1110111;
				HEX3 = ~7'b1100110;
				HEX2 = ~7'b1111001;
				HEX1 = ~7'b1010000;
				HEX0 = ~7'b1010100;
				end
			
			// Default case for don't cares
			default: begin
				HEX5 = 7'bX;
				HEX4 = 7'bX;
				HEX3 = 7'bX;
				HEX2 = 7'bX;
				HEX1 = 7'bX;
				HEX0 = 7'bX;
			end
		endcase
	end
endmodule
