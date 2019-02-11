module top (
	input clk, reset);

	wire [15:0] readData, writeData, programData;
	wire [9:0] programAddress, dataAddress;
	wire WE;


	memory #(10,16,1024,"output.txt") ROM (
		.WE(1'b0),
		.address(programAddress),
		.writeData(16'h0000),
		.readData(programData));

	memory #(10,16,1024,"ram.txt") RAM (
		.WE((WE & ~clk)),
		.address(dataAddress),
		.writeData(writeData),
		.readData(readData));

	datapath CPU (
		.clk(clk),
		.reset(reset),
		.WE(WE),
		.dataAddress(dataAddress),
		.programAddress(programAddress),
		.readData(readData),
		.programData(programData),
		.writeData(writeData));

endmodule
