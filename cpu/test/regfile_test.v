//Ryan Crumpler
//Regfile testbench

module regFileTest ();
	reg [7:0] dIn, i;
	reg [1:0] readAddr, writeAddr;
	reg writeEnable, fail;
	wire [7:0] dOut;

	regFile #(8,2) UUT (.dIn(dIn),.readAddr(readAddr),.writeAddr(writeAddr),.writeEnable(writeEnable),.dOut(dOut));

	initial begin
		fail = 1'b0;
		for (i = 0; i < 4; i = i + 1) begin
			writeAddr = i[1:0];
			dIn = i;
			writeEnable = 1'b1;
			#10;
			writeEnable = 1'b0;
		end
		for (i = 0; i < 4; i = i + 1) begin
			readAddr = i[1:0];
			#10;
			if (dOut !== i) begin
				$display("Error L1: addr: ", readAddr, " Act: ", dOut, " Exp: ", i);
				fail = 1'b1;
			end
		end
		for (i = 3; i < 4; i = i - 1) begin
			writeAddr = i[1:0];
			dIn = ~i;
			writeEnable = 1'b1;
			#10;
			writeEnable = 1'b0;
		end
		for (i = 3; i < 4; i = i - 1) begin
			readAddr = i[1:0];
			#10;
			if (dOut !== (~ i)) begin
				$display("Error L2: addr: ", readAddr, " Act: ", dOut, " Exp: ",(~ i));
				fail = 1'b1;
			end
		end
		for (i = 0; i < 4; i = i + 1) begin
			writeAddr = i[1:0];
			dIn = i;
			writeEnable = 1'b1;
			#10;
			writeEnable = 1'b0;
		end
		for (i = 0; i < 4; i = i + 1) begin
			readAddr = i[1:0];
			#10;
			if (dOut !== i) begin
				$display("Error L3: addr: ", readAddr, " Act: ", dOut, " Exp: ", i);
				fail = 1'b1;
			end
		end
		if (fail == 1'b0) $display("all tests passed");
		$finish;
	end
endmodule
