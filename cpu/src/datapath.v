//Ryan Crumpler
//CPU Design 4
//Top Level Datapath model

module datapath (
	input clk, reset,
	input [15:0] readData, programData
	output reg WE,
	output reg [15:0] writeData,
	output reg [9:0] address, programAddress);

	wire [15:0] aluInY, regX, regY, regWriteIn, aluOut, aluMuxWire, constMuxWire;
	reg [3:0] opcode;
	reg [9:0] pc, sp, addr;
	reg [11:0] dataIn;
	wire [9:0] controlOut, controlOutIn;
	wire [4:0] pipeline;
	wire fetch, decode, execute, memory, registers;
	wire [1:0] aluFunc, aluFuncIn;
	wire [3:0] regXAddr, regYAddr, regWriteAddr, regXAddrIn, regYAddrIn, regWriteAddrIn;
	wire jump, jumpLess, jumpEqual, compare, stack, memRead, memWrite, aluEnable, regLoad, constant, halt, zero, negative, overflow, jumpIn, jumpLessIn, jumpEqualIn, compareIn, stackIn, memReadIn, memWriteIn, aluEnableIn, regLoadIn, constantIn, haltIn;
	wire [35:0] controlToAluOut;
	wire [18:0] aluToWriteOut;
	wire [29:0] controlToWriteOut;

	assign fetch = pipeline[0];
	assign decode = pipeline[1];
	assign execute = pipeline[2];
	assign memory = pipeline[3];
	assign registers = pipeline[4];

	always @(posedge reset) begin
		address = 10'h000;
		addr = 10'h000;
		writeData = 16'h0000;
		pc = 10'h000;
		sp = 10'b1111111110;
	end
	always @(posedge clk) begin
		if (halt == 1'b1) pc = pc;
		else begin
			programAddress = pc;
			addr = programAddress;
			pc = pc + 1'b1;
		end
	end
	always @(posedge clk) begin
		opcode = programData[15:12];
		dataIn = programData[11:0];
	end

	always @(posedge reset or posedge fetch or posedge decode or posedge memory or posedge registers) begin
		if (fetch == 1'b1) begin
			if (halt == 1'b1) pc = pc;
			else begin
				programAddress = pc;
				addr = programAddress;
				pc = pc + 1'b1;
			end
		end
		if (decode == 1'b1) begin
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
		.clk(clk),
		.dIn(regWriteIn),
		.readAddr0(regYAddr),
		.readAddr1(regXAddr),
		.writeAddr(regWriteAddr),
		.writeEnable(regLoad),
		.dOut0(regX),
		.dOut1(regY));

	alu #(16) alu (
		.enable((controlToAluOut[2])),
		.control(controlToAluOut[1:0]),
		.a(controlToAluOut[45:30]),
		.b(aluInY),
		.zero(zero),
		.negative(negative),
		.overflow(overflow),
		.dOut(aluOut));

	mux #(16) constMux (
		.a({{6{controlToAluOut[13]}}, controlToAluOut[13:4]}),
		.b(aluOut),
		.c(controlToAluOut[2]),
		.dOut(constMuxWire));

	mux #(16) memMux (
		.a(aluToMemoryOut),
		.b(readData),
		.c(memRead),
		.dOut(regWriteIn));

	mux #(16) aluIMux (
		.a(controlToAluOut[29:14]),
		.b({{6{controlToAluOut[13]}}, controlToAluOut[13:4]}),
		.c(controlToAluOut[3]),
		.dOut(aluInY));

	shiftArray #(46, 2) controlToAluShifter (
		.dIn({regX, regY, controlOut, constant, aluEnable, aluFunc}),
		.dOut(controlToAluOut),
		.clk(clk),
		.reset(reset));

	shiftArray #(19, 3) aluToWriteShifter (
		.dIn({constMuxWire, zero, negative, overflow}),
		.dOut(aluToWriteOut),
		.clk(clk),
		.reset(reset));

	shiftArray #(30, 4) controlToWriteShifter (
		.dIn({regX, jumpEqual, jumpLess, jump, constant}),
		.dOut(controlToWriteOut),
		.clk(clk),
		.reset(reset));

	shiftArray #(35, 3) controlToMemoryShifter (
		.dIn({regX, regY, remRead, memWrite, stack}),
		.dOut(controlToMemoryOut),
		.clk(clk),
		.reset(reset));

	shiftArray #(16, 2) aluToMemoryShifter (
		.dIn(constMuxWire),
		.dOut(aluToMemoryOut),
		.clk(clk),
		.reset(reset));

endmodule	
