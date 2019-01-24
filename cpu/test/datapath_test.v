//Ryan Crumpler
//Datapath testbench

module datapathBench ();
	reg clk, reset;
	wire [15:0] readData;
	wire [15:0] writeData;
	wire [9:0] address;
	wire WE;
	reg [20:0] count;
	datapath UUT (.reset(reset),.clk(clk),.readData(readData),.writeData(writeData),.address(address),.WE(WE));

	memory mem (.address(address),.clk(clk),.readData(readData),.writeData(writeData),.WE(WE));

	initial begin
		$dumpfile("bench_dataflow.vcd");
		$dumpvars(0,datapathBench);
		reset = 1'b1;
		clk = 1'b0;
		//readData = 16'h0000;
		#10;
		clk = 1'b1;
		#10;
		clk = 1'b0;
		#1;
		reset = 1'b0;
//		//readData = 16'h8060; //load const 0x6 to reg 0
		for (count = 0; count < 500; count = count + 1'b1) begin
			#1 clk = 1'b1;
			#1 clk = 1'b0;
		end
//		//readData = 16'h8011; //load const 0x1 to reg 1
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
//		//readData = 16'h3F01; //reg 15 = reg 0 + reg 1
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
//		readData = 16'hB00F; //push reg 15 to stack
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
//		readData = 16'hC00C; //pop stack to reg 12
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
//		readData = 16'hA0FC; //store reg 15 at address in reg 12
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
//		readData = 16'h0000; //halt
//		for (count = 0; count < 5; count = count + 1'b1) begin
//			#10 clk = 1'b1;
//			#10 clk = 1'b0;
//		end
		#10;
		$finish;
	end
endmodule
