module memory #(parameter N = 10, M = 16, O = 1024) (
	input clk, WE,
	input [N-1:0] address,
	input [M-1:0] writeData,
	output [M-1:0] readData);

	reg [M-1:0] mem [0:O-1];
	parameter MEM_INIT_FILE = "output.txt";	
	assign readData = mem[address];	
	initial begin
		if (MEM_INIT_FILE != "") begin
			$readmemh(MEM_INIT_FILE, mem);
		end
	end
	always @(posedge WE) begin
		if (WE == 1'b1) mem[address] = writeData;
	end

endmodule
