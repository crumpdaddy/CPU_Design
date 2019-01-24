//Ryan Crumpler
//CPU Design 03
//ALU Model

module alu #(parameter N = 16) (
	input [1:0] control,
	input enable,
	input signed [N-1:0] a,b,
	output reg overflow, zero, negative,
	output reg signed [N-1:0] dOut);
		
	reg other;
	always @(posedge enable) begin
		case (control)
			2'b00: {other,dOut} = a + b;
			2'b01: {other,dOut} = a - b;
			2'b10: dOut = a & b;
			default: dOut = a | b;
		endcase
		negative = dOut[N-1];
		if (dOut == 0) zero = 1'b1;
		else zero = 1'b0;
		overflow = ((control == 2'b00) || (control == 2'b01)) ? (other ^ dOut[N-1]) : 1'b0;
	end
endmodule
