//Ryab Crumpler
//CPU Design Part 3
//Multiplexer module

module mux #(parameter N = 16) (
	input [N-1:0] a,b,
	input c,
	output [N-1:0] dOut);

	assign dOut = (c) ? b : a;
endmodule
