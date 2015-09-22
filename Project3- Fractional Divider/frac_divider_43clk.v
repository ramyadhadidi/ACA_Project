/* fractional divider
ACA course Oct 2012
Ramyad Hadidi - 88109971
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
					   	$display("ACA Project2 \n Ramyad Hadidi-88109971");
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
		if (start)
			begin
			  A<={1'b0,a};
			  Q[-no]<='b1;
				//{Q[-no],A[-1:-ni]}<={1'b0,a}-{1'b0,b};
				//A[0]<=1'b0;
				B<=b;
				count<=5'b0;
			end
		else if (A==0)
			begin
				Q<={Q[-1:(-no)],1'b0};
				count<=count+1'b1;
				if(count==6'd41)
					q<=Q;
				else if (count ==0)
					count<=6'b0;
			end
		else if (count==6'd41)
		      q<=Q;
		else
			begin
				A<=s<<1;
				Q<={Q[0:(-no)],~c};
				count<=count+1'b1;
			end
	end
	
	//add_sub & control
	defparam add_sub_1.w=(ni+1);
	add_sub add_sub_1(.addsub(Q[-no]), .a(A), .b({1'b0,B}), .s(s), .c(c));
		
endmodule

//-----------------------------------------------------
//add/sub module
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
		s={1'b0,a}+{1'b0,b};
		else //(addsub==1)
		s={1'b0,a}-{1'b0,b};
	end
	
	assign c=s[-1];
	
endmodule