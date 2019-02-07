module shift #(parameter N = 16) (
	input [1:0] control,
	inout enable,
	input [3:0] amount,
	input signed [N-1:0] dIn,
	output reg signed [N-1:0] dOut);

	always @(posedge enable) begin
		case (control)
			2'b00: dOut = dIn >>> amount;
			2'b01: dOut = dIn >> amount;
			2'b10: dOut = dIn <<< amount;
			default: dOut = dIn << amount;
		endcase
	end
endmodule
