module topBench ();
	reg clk, reset;
	reg [3:0] inr;
	wire [15:0] outvalue;
	reg [20:0] count;

	top UUT (.clk(clk),.reset(reset),.inr(inr),.outvalue(outvalue));

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0,UUT);
		reset = 1'b1;
		clk = 1'b0;
		#10;
		clk = 1'b1;
		#10;
		clk = 1'b0;
		reset = 1'b0;
		#10;
		for (count = 0; count < 500000; count = count + 1'b1) begin
			#1 clk = 1'b1;
			#1 clk = 1'b0;
		end
		#10;
		$finish;
	end
endmodule
