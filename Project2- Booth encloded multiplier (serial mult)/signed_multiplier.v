/*serial signed multiplier
using booth encoding (radix4)
ACA course Oct 2012
Ramyad Hadidi 88109971
*/

`timescale 1ns/1ns

module signed_multiplier
	(
		clk,  		//system clk 
		start,		//all inputs are valid for starting
		a,		  	//operand
		b,		  	//operand
		s			//result
	);
            //inital for HW
				  	initial
				  	begin
					   	$display("ACA Project2 \n Ramyad Hadidi-88109971");
				  	end
	
	//parameters and definitions
	input             clk;
	input             start;
	input      [31:0] a;
	input      [31:0] b;
	output reg [63:0] s;
	
	//vars
	reg    [31:0]   A;
	reg    [64:0]   P;
	reg    [33:0]   ai;
	wire   [33:0]   bi;
	reg             ci;
	wire   [33:0]   so;
	reg    [4:0]    counter;   //for counting and registering output
	
	
	//**CODE	
	//
	always @(posedge clk)
	begin	
		if (start)	//load registers
		begin	
			A<=a;
			P[32:1]<=b;
			P[0]<=1'b0;
			P[64:33]<='b0;	
			counter <=5'b0000; 
			end
		else
		begin		//two shifts - save result of adder
			P<=(P>>2);
			P[64:31]<=so[33:0];
			counter <= counter + 1'b1;
			if (counter[4])
			   s[63:0]<=P[64:1];
		end
	end
	
  //adder
	full_adder adder(.ai(ai), .bi(bi), .ci(ci), .so(so), .co());
	assign bi[31:0]=P[64:33];
	assign bi[33]=P[64];
	assign bi[32]=P[64];
		
	//PP generator (deretemins ci and ai) (booth encoding)
	always @(P[2:0],A)
	begin
		case(P[2:0])
			3'b000:	begin	//0
					ai=34'b0;
					ci=1'b0;		end
			3'b001:	begin	//1
					ai[31:0]=A;
					ai[32]=A[31];
					ai[33]=A[31];
					ci=1'b0;		end	
			3'b010:	begin	//1
					ai[31:0]=A;
					ai[32]=A[31];
					ai[33]=A[31];
					ci=1'b0;		end	
			3'b011:	begin	//2
					ai[32:0]=A<<1;
					ai[33]=ai[32];	
					ci=1'b0;		end
			3'b100:	begin	//-2
					ai[32:0]=~(A<<1);
					ai[33]=ai[32];
					ci=1'b1;		end
			3'b101:	begin	//-1
					ai[31:0]=~A;
					ai[32]=ai[31];
					ai[33]=ai[31];
					ci=1'b1;		end
			3'b110:	begin	//-1
					ai[31:0]=~A;
					ai[32]=ai[31];
					ai[33]=ai[31];
					ci=1'b1;		end
			3'b111:	begin	//0
					ai=34'b0;
					ci=1'b0;		end
		endcase
	end	

endmodule

//----------------------------------------------------
//full adder 34bit
module full_adder(
        input [33:0] ai,
        input [33:0] bi,
        input ci,
        output [33:0] so,
        output co
    );
        assign {co, so} = ai + bi + ci;
endmodule

	