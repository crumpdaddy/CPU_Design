module shiftReg #(parameter N = 16) (
	input clk, reset, dIn,
	output reg [N-1:0] dOut);

	always @(posedge reset or posedge clk) begin
		if (reset == 1'b1) dOut = 1'b0;
		else dOut = {dOut[N-2:0],dIn};
	end

endmodule
