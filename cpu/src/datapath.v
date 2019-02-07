//Ryan Crumpler
//CPU Design 4
//Top Level Datapath model

module datapath (
	input clk, reset,
	input [15:0] readData, programData,
	output WE,
	output [15:0] writeData,
	output [9:0] dataAddress,
	output reg [9:0] programAddress);

	wire [15:0] aluInY, regX, regY, regWriteIn, aluOut, aluMuxWire, constMuxWire;
	wire [3:0] opcode;
	reg execute, writeBack;
	reg [9:0] sp, pc;
	wire [11:0] dataIn;
	wire [9:0] controlOut, memReadWire, memAddrWire, jumpConditionalWire, jumpAddressWire,  haltWire, jumpMuxWire, spReadWire, spWire, memStackWire;
	wire [1:0] aluFunc;
	wire [3:0] regXAddr, regYAddr, regWriteAddr;
	wire jump, jumpLess, jumpEqual, compare, stack, memRead, memWrite, aluEnable, regLoad, constant, halt, zero, negative, overflow;

	assign opcode = programData[15:12];
	assign dataIn = programData[11:0];
	assign WE = memWrite;

	always @(posedge reset or posedge clk) begin
		if (reset == 1'b1) begin
			programAddress = 10'h000;
			pc = 10'h000;
			sp = 10'b1111111110;
		end
		else begin
			sp = spWire;
			pc = jumpMuxWire;
			programAddress = pc;
		end
	end

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
		.writeEnable(regLoad & ~clk),
		.dOut0(regX),
		.dOut1(regY));

	alu #(16) alu (
		.enable((clk && aluEnable)),
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

	mux #(10) jumpAddressMux (
		.a(regX[9:0]),
		.b(controlOut),
		.c(constant),.
		dOut(jumpAddressWire));
	
	mux #(10) haltMux (
		.a((pc + 1'b1)),
		.b(pc),
		.c(halt),
		.dOut(haltWire));
	
	mux #(10) jumpConditionalMux (
		.a(haltWire),
		.b(jumpAddressWire),
		.c((jumpLess & negative) | (jumpEqual & zero)),
		.dOut(jumpConditionalWire));

	mux #(10) jumpMux (
		.a(jumpConditionalWire),
		.b(jumpAddressWire),
		.c((jump & (~jumpLess & ~jumpEqual))),
		.dOut(jumpMuxWire));
	
	mux #(10) memAddrMux (
		.a(10'b0000000000),
		.b(regX[9:0]),
		.c((memRead | memWrite)),
		.dOut(memAddrWire));

	mux #(10) memReadMux (
		.a(memAddrWire),
		.b(regY[9:0]),
		.c(memWrite),
		.dOut(memReadWire));

	mux #(10) memStackMux (
		.a(memReadWire),
		.b(sp),
		.c(stack),
		.dOut(memStackWire));
	
	mux #(10) memPCkMux (
		.a(memStackWire),
		.b(spWire),
		.c((stack & memRead)),
		.dOut(dataAddress));

	mux #(16) memWriteMux (
		.a(writeData),
		.b(regX),
		.c(memWrite),
		.dOut(writeData));

	mux #(10) readStackMux (
		.a(sp),
		.b((sp + 1'b1)),
		.c((memRead & stack)),
		.dOut(spReadWire));

	mux #(10) writeStackMux (
		.a(spReadWire),
		.b((sp - 1'b1)),
		.c((memWrite & stack)),
		.dOut(spWire));

endmodule	
