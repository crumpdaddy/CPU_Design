module shiftReg #(parameter N = 16) (
	input clk, reset,
	output reg [N-1:0] dOut);

	always @(posedge reset or posedge clk) begin
		if (reset == 1'b1) dOut = 1'b0;
		else if (dOut == 0) dOut = 1'b1;
		else if (dOut[N-1] == 1'b1) dOut = 1'b1;
		else dOut = {dOut[N-2:0],1'b0};
	end

endmodule
