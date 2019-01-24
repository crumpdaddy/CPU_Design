//Ryan Crumpler
//CPU Design 4
//Top Level Datapath model

module datapath (
	input clk, reset,
	input [3:0] inr,
	input [15:0] readData,
	output reg WE,
	output [15:0] outvalue,
	output reg [15:0] writeData,
	output reg [9:0] address);

	wire [15:0] aluInY, regX, regY, regWriteIn, aluOut, aluMuxWire, constMuxWire;
	reg [3:0] opcode;
	reg [9:0] pc, sp, addr;
	reg [11:0] dataIn;
	wire [9:0] controlOut;
	wire [4:0] pipeline;
	wire fetch, decode, execute, memory, registers;
	wire [1:0] aluFunc;
	wire [3:0] regXAddr, regYAddr, regWriteAddr;
	wire jump, jumpLess, jumpEqual, compare, stack, memRead, memWrite, aluEnable, regLoad, constant, halt, zero, negative, overflow;
	
	assign fetch = pipeline[0];
	assign decode = pipeline[1];
	assign execute = pipeline[2];
	assign memory = pipeline[3];
	assign registers = pipeline[4];


	always @(posedge reset or posedge fetch or posedge decode or posedge memory or posedge registers) begin
		if (reset == 1'b1) begin
			address = 10'h000;
			addr = 10'h000;
			writeData = 16'h0000;
			pc = 10'h000;
			sp = 10'b1111111110;
		end
		if (fetch == 1'b1) begin
			if (halt == 1'b1) pc = pc;
			else begin
				address = pc;
				addr = address;
				pc = pc + 1'b1;
			end
		end
		if (decode == 1'b1) begin
			opcode = readData[15:12];
			dataIn = readData[11:0];
		end
		if (memory == 1'b1) begin
			if (memRead == 1'b1) begin
				if (stack == 1'b1) begin
					address = sp;
					sp = sp + 1'b1;
				end
				else address = regX;
			end
			if (memWrite == 1'b1) begin
				WE = 1'b1;
				if (stack == 1'b1) begin
					sp = sp - 1'b1;
					address = sp;
				end
				else address = regY;
				writeData = regX;
			end
			else WE = 1'b0;
		end
		if (registers == 1'b1) begin
			WE = 1'b0;
			if (jump) begin
				if (jumpLess == 1'b1) begin
					if (negative == 1'b1) begin
						if (constant == 1'b1) pc = controlOut;
						else pc = regX[9:0];
					end
				end
				else if (jumpEqual == 1'b1) begin
					if (zero == 1'b1) begin
						if (constant == 1'b1) pc = controlOut;
						else pc = regX[9:0];
					end
				end
				else begin 
					if (constant == 1'b1) pc = controlOut;
					else pc = regX[9:0];
				end
			end
		end
	end

	shiftReg #(5) cycle (
		.clk(clk),
		.reset(reset),
		.dOut(pipeline));

	control controller (
		.opcode(opcode),
		.dataIn(dataIn),
		.dOut(controlOut),
		.regWriteAddr(regWriteAddr),
		.regX(regXAddr),
		.regY(regYAddr),
		.jump(jump),
		.neg(jumpLess),
		.zero(jumpEqual),
		.compare(compare),
		.stack(stack),
		.memRead(memRead),
		.memWrite(memWrite),
		.aluEnable(aluEnable),
		.halt(halt),
		.aluFunc(aluFunc),
		.constant(constant),
		.regLoad(regLoad));
	
	regFile #(16) regFile (
		.clk(registers),
		.dIn(regWriteIn),
		.inr(inr),
		.outvalue(outvalue),
		.readAddr0(regYAddr),
		.readAddr1(regXAddr),
		.writeAddr(regWriteAddr),
		.writeEnable(regLoad),
		.dOut0(regX),
		.dOut1(regY));

	alu #(16) alu (
		.enable((aluEnable && execute)),
		.control(aluFunc),
		.a(regX),
		.b(aluInY),
		.zero(zero),
		.negative(negative),
		.overflow(overflow),
		.dOut(aluOut));

	mux #(16) constMux (
		.a({{6{controlOut[7]}}, controlOut}),
		.b(aluOut),
		.c(aluEnable),
		.dOut(constMuxWire));

	mux #(16) memMux (
		.a(constMuxWire),
		.b(readData),
		.c(memRead),
		.dOut(regWriteIn));

	mux #(16) aluIMux (
		.a(regY),
		.b({{6{controlOut[7]}}, controlOut}),
		.c(constant),
		.dOut(aluInY));

endmodule	
