
`timescale 1ns/1ns

`define DEBUG	// comment this line to disable register content writing below

module reg_file(
	input clk,
	input write,
	input [4:0] WR,
	input [31:0] WD,
	input [4:0] RR1,
	input [4:0] RR2,
	output [31:0] RD1,
	output [31:0] RD2
);

	reg [31:0] reg_data [0:31];

	assign RD1 = reg_data[ RR1 ];

	assign RD2 = reg_data[ RR2 ];

	always @(posedge clk) begin
		if(write) begin
			reg_data[ WR ] <= #1 WD;

			`ifdef DEBUG
			if(WR)
				$display("$%0d = %x", WR, WD);
			`endif

		end
		reg_data[0] <= #1 32'h00000000;
	end

endmodule
