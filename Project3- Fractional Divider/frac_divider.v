/* fractional divider
ACA course Oct 2012
Ramyad Hadidi - 88109971
latency=no+2 clk
*/

`timescale 1ns/1ns

module frac_divider
	#(
		parameter ni = 32,		//number of inputs fractional bits
		parameter no = 40		// number of output fractional bits after point
	)
	(
		input 				 clk,				//system clock, posedge
		input 			     start,				//start divideing also sample inputs
		input 		[-1:-ni] a,					// dividend, in fractional format: 0.a[-1] ... a[-ni]
		input 		[-1:-ni] b,					// divisor, in fractional format:  0.b[-1] ... b[-ni]
		output reg	[0:-no]  q					// quotient: q[0].q[-1] ... q[-no] = a / b
	);
	
	//inital for HW
				  	initial
				  	begin
					   	$display("ACA Project3 \n Ramyad Hadidi-88109971");
				  	end
	
	//vars
		reg	 [0:-ni]	A;
		reg	 [-1:-ni]	B;
		reg	 [0:-no]  	Q;
		wire [0:-ni] 	s;
		wire			c;
		reg	 [5:0]		count;
				
	//CODE
	//clocked part
	always @(posedge clk)
	begin
		if (start) begin //in the start we subtract two input and then  X2result and save them, this saves time(1clk)
						 //if area is important use frac_divider_43clk.v. latency=no+3
				{Q[-no],A[0:-ni+1]}<={1'b0,a}-{1'b0,b};
				A[-ni]<=1'b0;
				B<=b;
				count<=5'b0;
			end
		else if (A==0) begin	//if A==0 there is no reminder and we should stop
				Q<={Q[-1:(-no)],1'b1};
				count<=count+1'b1;
				if(count==6'd40)
					q<=~Q;
				else if (count ==0)
					count<=6'b0;
			end
		else if (count==6'd40)	//time to register output
		      q<=~Q;
		else begin	//x2 result, save 1bit of answer with shifting
				A<=s<<1;
				Q<={Q[0:(-no)],c};
				count<=count+1'b1;
			end
	end
	
	//add_sub & control for add or sub
	defparam add_sub_1.w=(ni+1);
	add_sub add_sub_1(.addsub(~Q[-no]), .a(A), .b({1'b0,B}), .s(s), .c(c));
		
endmodule

//-----------------------------------------------------
//add/sub module (add or sub is defined by an input)
//do not use in other codes
module add_sub
	#(
		parameter w = 33
	)
	(
		input 					addsub,
		input 			[-1:-w] a,
		input 			[-1:-w] b,
		output reg		[-1:-w] s,
		output  				c
	);
	
	always@(addsub,a,b)
	begin

		if(addsub==0)
		s=a+b;
		else //(addsub==1)
		s=a-b;
	end
	
	assign c=s[-1];
	
endmodule

	