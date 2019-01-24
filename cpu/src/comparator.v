//Ryan Crumpler
//CPU Design Part 3
//Comparator Module

module comparator #(parameter N = 16) (
	input signed [N-1:0] dIn,
	output equal, less);
	
	assign equal = (dIn) ? 1'b0 : 1'b1;
	assign less = dIn[N-1];
endmodule
