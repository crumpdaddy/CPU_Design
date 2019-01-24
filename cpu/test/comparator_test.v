//Ryan Crumpler
//Comparator testbench

module comparatorTest ();

	reg [7:0] dIn;
	wire equal, less;
	reg signed [7:0] i;
	reg fail;
	comparator #(8) UUT (.dIn(dIn),.equal(equal),.less(less));
	
	initial begin
		fail = 0;
		for (i = -128; i < 127; i = i + 1) begin
			dIn = i;
			#10;
			if (i < 0 && less !== 1'b1 && equal !== 1'b0) begin
				$display("Error less: dIn: ", dIn, " less: ", less, " equal: ", equal);
				fail = 1'b1;
			end
			else if (i == 0 && less !== 1'b0 && equal !== 1'b1) begin
				$display("Error equal: dIn: ", dIn, " less: ", less, " equal: ", equal);
				fail = 1'b1;
			end
			else if (i > 0 && less !== 1'b0 && equal !== 1'b0) begin
				$display("Error greater: dIn: ", dIn, " less: ", less, " equal: ", equal);
				fail = 1'b1;
			end
		end
		if (fail == 1'b0) $display("all tests passed");
		$finish;
	end
endmodule
			


