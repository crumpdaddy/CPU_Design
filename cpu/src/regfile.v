//Ryan Crumpler
//CPU Design Part 3
//Register File Module

module regFile #(parameter N = 16, M = 4, O = 16) (
	input clk, writeEnable,
	input [N-1:0] dIn, 
	input [M-1:0] readAddr0, readAddr1, writeAddr,
	output [N-1:0] dOut0, dOut1);

	reg [N-1:0] rf [0:O-1];

	assign dOut0 = rf[readAddr0];
	assign dOut1 = rf[readAddr1];

	always @(posedge clk) begin
		if (writeEnable == 1'b1) rf[writeAddr] = dIn;
	end

endmodule
