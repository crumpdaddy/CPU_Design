module shiftArray #(parameter N = 16, M = 4) (
	input clk, reset,
	input [N-1:0] dIn,
	output [N-1:0] dOut);
	
	integer i;	
	reg [N-1:0] sa [0:M-1];

	assign dOut = sa[M-1];

	always @(posedge reset or posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < M; i = i + 1'b1) begin
				sa[i] = 0;
			end
		end
		else begin
			for (i = 1; i < M; i = i + 1) begin
				sa[i - 1] = sa[i];
			end
			sa[0] = dIn;
		end
	end

endmodule

