//Ryan Crumpler
//CPU Design 03
//ALU Model

module alu #(parameter N = 16) (
	input [2:0] control,
	input enable,
	input signed [N-1:0] a,b,
	output reg overflow, zero, negative,
	output reg signed [N-1:0] dOut);
		
	reg other;
	always @(posedge enable) begin
		case (control)
			3'b000: {other,dOut} = a + b;
			3'b001: {other,dOut} = a - b;
			3'b010: dOut = a & b;
			3'b011: dOut = a | b;
			3'b100: dOut = a ^ b;
			default: dOut = a[N/2 -2:0] * b[N/2-1:0];
		endcase
		negative = dOut[N-1];
		if (dOut == 0) zero = 1'b1;
		else zero = 1'b0;
		overflow = ((control == 3'b000) || (control == 3'b001)) ? (other ^ dOut[N-1]) : 1'b0;
	end
endmodule
