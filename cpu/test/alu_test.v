//Ryan Crumpler
//ALU testbench

module aluTest ();
	reg signed [7:0] ia, ib, ic;
	reg signed [7:0] a,b;
	wire signed [7:0] dOut;
	reg  enable, fail;
	wire overflow;
	reg [1:0] control;
	alu #(8) UUT (.a(a),.b(b),.control(control),.enable(enable),.dOut(dOut),.overflow(overflow));
	initial begin
		fail = 1'b0;
		enable = 1'b0;
		for (ic = 0; ic < 4; ic = ic + 1) begin
			for (ia = -128; ia < 127; ia = ia + 1) begin
				for (ib = -128; ib < 127; ib = ib + 1) begin
					control = ic[1:0];;
					a = ia;
					b = ib;
					enable = 1'b1;
					#10;
					enable = 1'b0;
					if (control == 2'b00) begin
						if ((ia + ib < -128) || (ia + ib > 127)) begin
							if (overflow !== 1'b1) begin
								$display("Add Overflow Error A: ", ia, " B: ", ib, " Over: ", overflow);
								fail = 1'b1;
							end
						end
						else if (overflow !== 1'b0) begin
							$display("Add Overflow Error A: ", ia, " B: ", ib, " Over: ", overflow);
							fail = 1'b1;
						end
						if (dOut !== (ia + ib)) begin
							$display("Add error: A: ", ia, " B: ", ib, " Sum: ", dOut);
							fail = 1'b1;
						end
					end
					else if (control == 2'b01) begin
						if ((ia - ib < -128) || (ia - ib > 127)) begin
							if (overflow !== 1'b1) begin
								$display("Sub Overflow Error A: ", ia, " B: ", ib, " Over: ", overflow);
								fail = 1'b1;
							end
						end
						else if (overflow !== 1'b0) begin
							$display("Sub Overflow Error A: ", ia, " B: ", ib, " Over: ", overflow);
							fail = 1'b1;
						end
						if (dOut !== (ia - ib)) begin
							$display("Sub error: A: ", ia, " B: ", ib, " Sum: ", dOut);
							fail = 1'b1;
						end
					end
					else if (control == 2'b10) begin
						if (overflow == 1'b1) begin
							$display("And Overflow Error A: ", ia, " B: ", ib, " Sum: ", overflow);
							fail = 1'b1;
						end
						if (dOut !== (ia & ib)) begin
							$display("And error: A: ", ia, " B: ", ib, " Sum: ", dOut);
							fail = 1'b1;
						end
					end
					else if (control == 2'b11) begin
						if (overflow == 1'b1) begin
							$display("Or Overflow Error A: ", ia, " B: ", ib, " Sum: ", overflow);
							fail = 1'b1;
						end
						if (dOut !== (ia | ib)) begin
							$display("Or error: A: ", ia, " B: ", ib, " Sum: ", dOut);
							fail = 1'b1;
						end
					end
				end
			end
		end
		if (fail == 1'b0) $display("all tests passed");
		$finish;
	end
endmodule

