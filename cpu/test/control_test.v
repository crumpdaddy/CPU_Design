//Ryan Crumpler
//Controller testbench

module controlTest ();
	reg [3:0] opcode;
	reg [4:0] count;
	reg fail, extra;
	wire [1:0] aluFunc;
	wire branch, jump, compare, memRead, memWrite, alu0, alu1, regLoad;

	control UUT (.opcode(opcode),.branch(branch),.jump(jump),.compare(compare),.memRead(memRead),.memWrite(memWrite),.alu0(alu0),.alu1(alu1),.aluFunc(aluFunc),.regLoad(regLoad));

	initial begin
		fail = 1'b0;
		for (count = 0; count <= 16; count = count + 1) begin
			opcode = count[3:0];
			#10;
			if ((opcode == 4'hE) || (opcode == 4'hF)) begin
				if (branch !== 1'b1) begin
					$display("Not show branch: opcode: ", opcode, " branch: ", branch);
					fail = 1'b1;
				end
			end
			else if (branch !== 1'b0) begin
				$display("Showing branch: opcode: ", opcode, " branch: ", branch);
				fail = 1'b1;
			end;
			if ((opcode == 4'hA) || (opcode == 4'hB) || (opcode == 4'hC) || (opcode == 4'hD)) begin
				if (jump !== 1'b1) begin
					$display("Not show jump: opcode: ", opcode, " jump: ", jump);
					fail = 1'b1;
				end
			end
			else if (jump !== 1'b0) begin
				$display("Showing jump: opcode: ", opcode, " jump: ", jump);
				fail = 1'b1;
			end
			if ((opcode == 4'h5) || (opcode == 4'hB) || (opcode == 4'hC) || (opcode == 4'hD)) begin
				if (compare !== 1'b1) begin
					$display("not show compare: opcode: ", opcode, " compare: ", compare);
					fail = 1'b1;
				end
			end
			else if (compare !== 1'b0) begin
				$display("Showing compare: opcode: ", opcode, " compare: ", compare);
				fail = 1'b1;
			end
			if (opcode == 4'h8) begin
				if (memRead !== 1'b1) begin
					$display("not show memRead: opcode: ", opcode, " memRead: ", memRead);
					fail = 1'b1;
				end
			end
			else if (memRead !== 1'b0) begin
				$display("Showing memRead: opcode: ", opcode, " memRead: ", memRead);
				fail = 1'b1;
			end
			if (opcode == 4'h9) begin
				if (memWrite !== 1'b1) begin
					$display("not show memWrite: opcode: ", opcode, " memWrite: ", memWrite);
					fail = 1'b1;
				end
			end
			else if (memWrite !== 1'b0) begin
				$display("Showing memWrite: opcode: ", opcode, " memWrite: ", memWrite);
				fail = 1'b1;
			end
			if ((opcode == 4'h0) || (opcode == 4'h9)) begin 
				if (alu0 !== 1'b0) begin
					$display("Showing alu0: opcode: ", opcode, " alu0: ", alu0);
					fail = 1'b1;
				end
			end
			else if (alu0 !== 1'b1) begin
				$display("not show alu0: opcode: ", opcode, " alu0: ", alu0);
				fail = 1'b1;
			end
			if ((opcode == 4'h1) || (opcode == 4'h2) || (opcode == 4'h3) || (opcode == 4'h4) || (opcode == 4'h5)) begin
				if (alu1 !== 1'b1) begin
					$display("not show alu1: opcode: ", opcode, " alu1: ", alu1);
					fail = 1'b1;
				end
			end
			else if (alu1 !== 1'b0) begin
				$display("Showing alu1: opcode: ", opcode, " alu1: ", alu1);
				fail = 1'b1;
			end
			if ((opcode == 4'h1) || (opcode == 4'h2) || (opcode == 4'h3) || (opcode == 4'h4) || (opcode == 4'h6) || (opcode == 4'h7) || (opcode == 4'h8) || (opcode == 4'h9)) begin
				if (regLoad !== 1'b1) begin
					$display("not show regLoad: opcode: ", opcode, " regLoad: ", regLoad);
					fail = 1'b1;
				end
			end
			else if (regLoad !== 1'b0) begin
				$display("Showing regLoad: opcode: ", opcode, " regLoad: ", regLoad);
				fail = 1'b1;
			end
			if ((opcode == 4'h1) || (opcode == 4'h2) || (opcode == 4'h4)) begin
				if ((opcode == 4'h1) && (aluFunc !== 2'b10)) begin
					$display("And not work: opcode: ", opcode, " aluFunc: ", aluFunc);
					fail = 1'b1;
				end
				if ((opcode == 4'h2) && (aluFunc !== 2'b11)) begin
					$display("Or not work: opcode: ", opcode, " aluFunc: ", aluFunc);
					fail = 1'b1;
				end
				if ((opcode == 4'h4) && (aluFunc !== 2'b01)) begin
					$display("Sub not work: opcode: ", opcode, " aluFunc: ", aluFunc);
					fail = 1'b1;
				end
			end
			else if (aluFunc !== 2'b00) begin
				$display("Showing aluFunc: opcode: ", opcode, " aluFunc: ", aluFunc);
				fail = 1'b1;
			end
		end
		if (fail == 1'b0) $display("all tests passed");
		$finish;
	end
endmodule


