module top (
	input clk, reset,
	input [3:0] inr,
	output [15:0] outvalue);

	wire [15:0] readData, writeData;
	wire [9:0] address;
	wire WE;

	memory #(10,16,1024) RAM (
		.clk(clk),
		.WE(WE),
		.address(address),
		.writeData(writeData),
		.readData(readData));

	datapath CPU (
		.clk(clk),
		.reset(reset),
		.WE(WE),
		.inr(inr),
		.address(address),
		.readData(readData),
		.writeData(writeData),
		.outvalue(outvalue));

endmodule
