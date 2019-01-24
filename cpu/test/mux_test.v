//Ryan Crumpler
//multiplexer bench

module muxTest ();
	reg [7:0] a,b;
	reg c,fail;
	wire [7:0] dOut;
	mux #(8) UUT (.a(a),.b(b),.c(c),.dOut(dOut));

	initial begin
		fail = 1'b0;
		for (a = 0; a < 255; a = a + 1) begin
			b = ~a;
			c = 1'b0;
			#10;
			if (dOut !== a) begin
				$display("failed input a: expected: ", a, " actual: ", dOut);
				fail = 1'b1;
			end;
			c = 1'b1;
			#10;
			if (dOut !== b) begin
				$display("failed input b: expected: ", b, " actual: ", dOut);
				fail = 1'b1;
			end;
		end
		if (fail == 1'b0) $display("all tests passed");
		$finish;
	end
endmodule
