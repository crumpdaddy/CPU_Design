//Ryan Crumpler
//Controller module

module control (
	input [3:0] opcode,
	input [11:0] dataIn,
	output reg [9:0] dOut,
	output reg [1:0] aluFunc, shiftFunc, 
	output reg [3:0] regWriteAddr, regX, regY,
	output reg jump, neg, zero, compare, stack, memRead, memWrite, aluEnable, regLoad, constant, halt, shiftEnable);

	always @(*) begin
		case (opcode)
			4'h0: begin //halt
				halt = 1'b1;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = 4'h0;
				regX = 4'h0;
				regY = 4'h0;
				dOut = 10'h000;
			end
			4'h1: begin //and
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b10;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[11:8];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h2: begin //or
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b11;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[11:8];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h3: begin //add
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00; 
				regWriteAddr = dataIn[11:8];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h4: begin //sub
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b01;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[11:8];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h5: begin //addi
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b1;
				constant = 1'b1;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00; 
				aluFunc = ((dataIn[11] == 1'b1)) ? 2'b01 : 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				dOut = ((dataIn[11] == 1'b1)) ? {2'b00,(~(dataIn[11:4]) + 1'b1)} : {2'b00, dataIn[11:4]};
			end
			4'h6: begin //comp test
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b1;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b1;
				regLoad = 1'b0;
				constant = 1'b0;
				aluFunc = ((dataIn[11] == 1'b1)) ? 2'b10 : 2'b01;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00; 
				regWriteAddr = dataIn[7:4];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h7: begin //copy
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[7:4];
				regX = dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'h8: begin //cpyc
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b1;
				constant = 1'b1;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				dOut = {{2{dataIn[11]}},dataIn[11:4]};
			end
			4'h9: begin //load stor pop push
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = dataIn[11];
				memRead = dataIn[10];
				memWrite = ~dataIn[10];
				aluEnable = 1'b0;
				regLoad = dataIn[10];
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = ((dataIn[11] == 1'b1)) ? dataIn[3:0] : dataIn[7:4];
				regX = ((dataIn[11] == 1'b1)) ? dataIn[3:0] : dataIn[7:4];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'hA: begin //shift
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b1;
				shiftFunc = dataIn[11:10];
				regWriteAddr = dataIn[7:4];
				regX = dataIn[7:4];
				regY = dataIn[7:4];
				dOut = {{6{dataIn[3]}},dataIn[3:0]};
			end
			4'hB: begin //push
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b1;
				memRead = 1'b0;
				memWrite = 1'b1;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[7:4];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'hC: begin //pop
				halt = 1'b0;
				jump = 1'b0;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b0;
				stack = 1'b1;
				memRead = 1'b1;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b1;
				constant = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				dOut = 10'h000;
			end
			4'hD: begin //jmpl
				halt = 1'b0;
				jump = 1'b1;
				neg = 1'b1;
				zero = 1'b0;
				compare = 1'b1;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				if (dataIn[11] == 1'b1) begin
					constant = 1'b1;
					dOut = dataIn[9:0];
				end
				else begin
					constant = 1'b0;
					dOut = 10'h000;
				end
			end
			4'hE: begin //jmpe
				halt = 1'b0;
				jump = 1'b1;
				neg = 1'b0;
				zero = 1'b1;
				compare = 1'b1;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				if (dataIn[11] == 1'b1) begin
					constant = 1'b1;
					dOut = dataIn[9:0];
				end
				else begin
					constant = 1'b0;
					dOut = 10'h000;
				end
			end
			default: begin //jump
				halt = 1'b0;
				jump = 1'b1;
				neg = 1'b0;
				zero = 1'b0;
				compare = 1'b1;
				stack = 1'b0;
				memRead = 1'b0;
				memWrite = 1'b0;
				aluEnable = 1'b0;
				regLoad = 1'b0;
				aluFunc = 2'b00;
				shiftEnable = 1'b0;
				shiftFunc = 2'b00;
				regWriteAddr = dataIn[3:0];
				regX = dataIn[3:0];
				regY = dataIn[3:0];
				if (dataIn[11] == 1'b1) begin
					constant = 1'b1;
					dOut = dataIn[9:0];
				end
				else begin
					constant = 1'b0;
					dOut = 10'h000;
				end
			end
		endcase
	end
endmodule
