/*Wallace Tree Based Multiplier
ACA course Oct 2012
Ramyad Hadidi 88109971
*/

`timescale 1ns/1ns

module parallel_unsigned_mult
	(
		a,			//input1 8bit unsigned
		b,			//input2 8bit unsigned
		p			//output 16bit unsigned
	);
					//inital for HW
					initial
					begin
						$display("ACA Project1 \n Ramyad Hadidi-88109971");
					end
	//parameters and definitions
	input [7:0]a;
	input [7:0]b;
	output [15:0] p;
	
	//Vars
	integer k;
	reg [7:0] L1 [7:0];		//for first layer
	wire [14:0] L2_0;		//consti. for second layer
	wire [12:0] L2_1;
	wire [8:0] L2_2;
	wire [6:0] L2_3;
	wire [2:0] L2_4;
	wire [0:0] L2_5;
	wire [15:0] L3_0;		//consti. for third layer
	wire [11:0] L3_1;
	wire [6:0] L3_2;
	wire [2:0] L3_3;
	wire [15:0] L4_0;		//consti. for forth layer
	wire [11:0] L4_1;
	wire [2:0] L4_2;
	wire [16:0] L5_0;		//consti. for fifth layer
	wire [10:0] L5_1;
	wire [17:0] L6_0;		//consti. for sixth layer (addition)
	wire [10:0]	L6_1;
	
		
	//***CODE
	//---first layer-8layer-all and
	always @(a,b)
		for (k=0; k<=7; k=k+1)
		begin
			if (b[k]==1)
				L1[k]=a;
			else
				L1[k]=8'b0;
		end
		
	//---second layer-wallace
	//full_adder(.ai(L1[][]), .bi(L1[][]), .ci(L1[][]), .so(L2_?[]), .co(L2_?[]));
	//half_adder(.ai(L1[][]), .bi(L1[][]), .so(L2_?[]), .co(L2_?[]));
	//assign L2_?[]=L1[][];
	//1st col.
	assign L2_0[0]=L1[0][0];
	//2nd col.
	half_adder a1(.ai(L1[0][1]), .bi(L1[1][0]), .so(L2_0[1]), .co(L2_0[2]));
	//3rd col.
	full_adder a2(.ai(L1[0][2]), .bi(L1[1][1]), .ci(L1[2][0]), .so(L2_1[0]), .co(L2_0[3]));
	//4th col.
	full_adder a3(.ai(L1[0][3]), .bi(L1[1][2]), .ci(L1[2][1]), .so(L2_1[1]), .co(L2_0[4]));
	assign L2_2[0]=L1[3][0];
	//5th col.
	full_adder a4(.ai(L1[0][4]), .bi(L1[1][3]), .ci(L1[2][2]), .so(L2_1[2]), .co(L2_0[5]));
	half_adder a5(.ai(L1[3][1]), .bi(L1[4][0]), .so(L2_2[1]), .co(L2_1[3]));
	//6th col.
	full_adder a6(.ai(L1[0][5]), .bi(L1[1][4]), .ci(L1[2][3]), .so(L2_2[2]), .co(L2_0[6]));
	full_adder a7(.ai(L1[3][2]), .bi(L1[4][1]), .ci(L1[5][0]), .so(L2_3[0]), .co(L2_1[4]));
	//7th col.
	full_adder a9(.ai(L1[0][6]), .bi(L1[1][5]), .ci(L1[2][4]), .so(L2_2[3]), .co(L2_0[7]));
	full_adder a10(.ai(L1[3][3]), .bi(L1[4][2]), .ci(L1[5][1]), .so(L2_3[1]), .co(L2_1[5]));
	assign L2_4[0]=L1[6][0];
	//8th col.
	full_adder a11(.ai(L1[0][7]), .bi(L1[1][6]), .ci(L1[2][5]), .so(L2_2[4]), .co(L2_0[8]));
	full_adder a12(.ai(L1[3][4]), .bi(L1[4][3]), .ci(L1[5][2]), .so(L2_3[2]), .co(L2_1[6]));
	half_adder a13(.ai(L1[6][1]), .bi(L1[7][0]), .so(L2_4[1]), .co(L2_2[5]));
	//9th col.
	full_adder a14(.ai(L1[1][7]), .bi(L1[2][6]), .ci(L1[3][5]), .so(L2_3[3]), .co(L2_0[9]));
	full_adder a15(.ai(L1[4][4]), .bi(L1[5][3]), .ci(L1[6][2]), .so(L2_4[2]), .co(L2_1[7]));
	assign L2_5[0]=L1[7][1];
	//10th col.
	full_adder a16(.ai(L1[2][7]), .bi(L1[3][6]), .ci(L1[4][5]), .so(L2_2[6]), .co(L2_0[10]));
	full_adder a17(.ai(L1[5][4]), .bi(L1[6][3]), .ci(L1[7][2]), .so(L2_3[4]), .co(L2_1[8]));
	//11th col.
	full_adder a18(.ai(L1[3][7]), .bi(L1[4][6]), .ci(L1[5][5]), .so(L2_2[7]), .co(L2_0[11]));
	half_adder a19(.ai(L1[6][4]), .bi(L1[7][3]), .so(L2_3[5]), .co(L2_1[9]));
	//12th col.
	full_adder a20(.ai(L1[4][7]), .bi(L1[5][6]), .ci(L1[6][5]), .so(L2_2[8]), .co(L2_0[12]));
	assign L2_3[6]=L1[7][4];
	//13th col.
	full_adder a21(.ai(L1[5][7]), .bi(L1[6][6]), .ci(L1[7][5]), .so(L2_1[10]), .co(L2_0[13]));
	//14th col.
	half_adder a22(.ai(L1[6][7]), .bi(L1[7][6]), .so(L2_1[11]), .co(L2_0[14]));
	//15th col.
	assign L2_1[12]=L1[7][7];
	
	//---third layer-wallace
	//full_adder(.ai(L2_?[]), .bi(L2_?[]), .ci(L2_?[]), .so(L3_?[]), .co(L3_?[]));
	//half_adder(.ai(L2_?[]), .bi(L2_?[]), .so(L3_?[]), .co(L3_?[]));
	//assign L3_?[]=L2_?[];
	//1st col.
	assign L3_0[0]=L2_0[0];
	//2nd col.
	assign L3_0[1]=L2_0[1];
	//3rd col.
	half_adder b1(.ai(L2_0[2]), .bi(L2_1[0]), .so(L3_0[2]), .co(L3_0[3]));
	//4th col.
	full_adder b2(.ai(L2_0[3]), .bi(L2_1[1]), .ci(L2_2[0]), .so(L3_1[0]), .co(L3_0[4]));
	//5th col.
	full_adder b3(.ai(L2_0[4]), .bi(L2_1[2]), .ci(L2_2[1]), .so(L3_1[1]), .co(L3_0[5]));
	//6th col.
	full_adder b4(.ai(L2_0[5]), .bi(L2_1[3]), .ci(L2_2[2]), .so(L3_1[2]), .co(L3_0[6]));
	assign L3_2[0]=L2_3[0];
	//7th col.
	full_adder b5(.ai(L2_0[6]), .bi(L2_1[4]), .ci(L2_2[3]), .so(L3_1[3]), .co(L3_0[7]));
	half_adder b6(.ai(L2_3[1]), .bi(L2_4[0]), .so(L3_2[1]), .co(L3_1[4]));
	//8th col.
	full_adder b7(.ai(L2_0[7]), .bi(L2_1[5]), .ci(L2_2[4]), .so(L3_2[2]), .co(L3_0[8]));
	half_adder b8(.ai(L2_3[2]), .bi(L2_4[1]), .so(L3_3[0]), .co(L3_1[5]));
	//9th col.
	full_adder b9(.ai(L2_0[8]), .bi(L2_1[6]), .ci(L2_2[5]), .so(L3_2[3]), .co(L3_0[9]));
	full_adder b10(.ai(L2_3[3]), .bi(L2_4[2]), .ci(L2_5[0]), .so(L3_3[1]), .co(L3_1[6]));
	//10th col.
	full_adder b11(.ai(L2_0[9]), .bi(L2_1[7]), .ci(L2_2[6]), .so(L3_2[4]), .co(L3_0[10]));
	assign L3_3[2]=L2_3[4];
	//11th col.
	full_adder b12(.ai(L2_0[10]), .bi(L2_1[8]), .ci(L2_2[7]), .so(L3_1[7]), .co(L3_0[11]));
	assign L3_2[5]=L2_3[5];
	//12th col.
	full_adder b13(.ai(L2_0[11]), .bi(L2_1[9]), .ci(L2_2[8]), .so(L3_1[8]), .co(L3_0[12]));
	assign L3_2[6]=L2_3[6];
	//13th col.
	half_adder b14(.ai(L2_0[12]), .bi(L2_1[10]), .so(L3_1[9]), .co(L3_0[13]));
	//14th col.
	half_adder b15(.ai(L2_0[13]), .bi(L2_1[11]), .so(L3_1[10]), .co(L3_0[14]));
	//15th col.
	half_adder b16(.ai(L2_0[14]), .bi(L2_1[12]), .so(L3_1[11]), .co(L3_0[15]));
	
	//---forth layer-wallace
	//full_adder(.ai(L3_?[]), .bi(L3_?[]), .ci(L3_?[]), .so(L4_?[]), .co(L4_?[]));
	//half_adder(.ai(L3_?[]), .bi(L3_?[]), .so(L4_?[]), .co(L4_?[]));
	//assign L4_?[]=L3_?[];
	//1st col.
	assign L4_0[0]=L3_0[0];
	//2nd col.
	assign L4_0[1]=L3_0[1];
	//3rd col.
	assign L4_0[2]=L3_0[2];
	//4th col.
	half_adder c1(.ai(L3_0[3]), .bi(L3_1[0]), .so(L4_0[3]), .co(L4_0[4]));
	//5th col.
	half_adder c2(.ai(L3_0[4]), .bi(L3_1[1]), .so(L4_1[0]), .co(L4_0[5]));
	//6th col.
	full_adder c3(.ai(L3_0[5]), .bi(L3_1[2]), .ci(L3_2[0]), .so(L4_1[1]), .co(L4_0[6]));
	//7th col.
	full_adder c4(.ai(L3_0[6]), .bi(L3_1[3]), .ci(L3_2[1]), .so(L4_1[2]), .co(L4_0[7]));
	//8th col.
	full_adder c5(.ai(L3_0[7]), .bi(L3_1[4]), .ci(L3_2[2]), .so(L4_1[3]), .co(L4_0[8]));
	assign L4_2[0]=L3_3[0];
	//9th col.
	full_adder c6(.ai(L3_0[8]), .bi(L3_1[5]), .ci(L3_2[3]), .so(L4_1[4]), .co(L4_0[9]));
	assign L4_2[1]=L3_3[1];
	//10th col.
	full_adder c7(.ai(L3_0[9]), .bi(L3_1[6]), .ci(L3_2[4]), .so(L4_1[5]), .co(L4_0[10]));
	assign L4_2[2]=L3_3[2];
	//11th col.
	full_adder c8(.ai(L3_0[10]), .bi(L3_1[7]), .ci(L3_2[5]), .so(L4_1[6]), .co(L4_0[11]));
	//12th col.
	full_adder c9(.ai(L3_0[11]), .bi(L3_1[8]), .ci(L3_2[6]), .so(L4_1[7]), .co(L4_0[12]));
	//13th col.
	half_adder c10(.ai(L3_0[12]), .bi(L3_1[9]), .so(L4_1[8]), .co(L4_0[13]));
	//14th col.
	half_adder c11(.ai(L3_0[13]), .bi(L3_1[10]), .so(L4_1[9]), .co(L4_0[14]));
	//15th col.
	half_adder c12(.ai(L3_0[14]), .bi(L3_1[11]), .so(L4_1[10]), .co(L4_0[15]));
	//16th col.
	assign L4_1[11]=L3_0[15];
	
	//---fifth layer-wallace
	//full_adder(.ai(L4_?[]), .bi(L4_?[]), .ci(L4_?[]), .so(L5_?[]), .co(L5_?[]));
	//half_adder(.ai(L4_?[]), .bi(L4_?[]), .so(L5_?[]), .co(L5_?[]));
	//assign L5_?[]=L4_?[];
	//1st col.
	assign L5_0[0]=L4_0[0];
	//2nd col.
	assign L5_0[1]=L4_0[1];
	//3rd col.
	assign L5_0[2]=L4_0[2];
	//4th col.
	assign L5_0[3]=L4_0[3];
	//5th col.
	half_adder d1(.ai(L4_0[4]), .bi(L4_1[0]), .so(L5_0[4]), .co(L5_0[5]));
	//6th col.
	half_adder d2(.ai(L4_0[5]), .bi(L4_1[1]), .so(L5_1[0]), .co(L5_0[6]));
	//7th col.
	half_adder d3(.ai(L4_0[6]), .bi(L4_1[2]), .so(L5_1[1]), .co(L5_0[7]));
	//8th col.
	full_adder d4(.ai(L4_0[7]), .bi(L4_1[3]), .ci(L4_2[0]), .so(L5_1[2]), .co(L5_0[8]));
	//9th col.
	full_adder d5(.ai(L4_0[8]), .bi(L4_1[4]), .ci(L4_2[1]), .so(L5_1[3]), .co(L5_0[9]));
	//10th col.
	full_adder d6(.ai(L4_0[9]), .bi(L4_1[5]), .ci(L4_2[2]), .so(L5_1[4]), .co(L5_0[10]));
	//11th col.
	half_adder d7(.ai(L4_0[10]), .bi(L4_1[6]), .so(L5_1[5]), .co(L5_0[11]));
	//12th col.
	half_adder d8(.ai(L4_0[11]), .bi(L4_1[7]), .so(L5_1[6]), .co(L5_0[12]));
	//13th col.
	half_adder d9(.ai(L4_0[12]), .bi(L4_1[8]), .so(L5_1[7]), .co(L5_0[13]));
	//14th col.
	half_adder d10(.ai(L4_0[13]), .bi(L4_1[9]), .so(L5_1[8]), .co(L5_0[14]));
	//15th col.
	half_adder d11(.ai(L4_0[14]), .bi(L4_1[10]), .so(L5_1[9]), .co(L5_0[15]));
	//16th col.
	half_adder d12(.ai(L4_0[15]), .bi(L4_1[11]), .so(L5_1[10]), .co(L5_0[16]));
	
	//---sixth layer-Addition
	//full_adder(.ai(L5_?[]), .bi(L5_?[]), .ci(L5_?[]), .so(L6_?[]), .co(L6_?[]));
	//half_adder(.ai(L5_?[]), .bi(L5_?[]), .so(L6_?[]), .co(L6_?[]));
	//assign L6_?[]=L5_?[];
	//1st col.
	assign L6_0[0]=L5_0[0];
	//2nd col.
	assign L6_0[1]=L5_0[1];
	//3rd col.
	assign L6_0[2]=L5_0[2];
	//4th col.
	assign L6_0[3]=L5_0[3];
	//5th col.
	assign L6_0[4]=L5_0[4];
	//6th col.
	half_adder e1(.ai(L5_0[5]), .bi(L5_1[0]), .so(L6_0[5]), .co(L6_1[0]));
	//7th col.
	full_adder e2(.ai(L5_0[6]), .bi(L5_1[1]), .ci(L6_1[0]), .so(L6_0[6]), .co(L6_1[1]));
	//8th col.
	full_adder e3(.ai(L5_0[7]), .bi(L5_1[2]), .ci(L6_1[1]), .so(L6_0[7]), .co(L6_1[2]));
	//9th col.
	full_adder e4(.ai(L5_0[8]), .bi(L5_1[3]), .ci(L6_1[2]), .so(L6_0[8]), .co(L6_1[3]));
	//10th col.
	full_adder e5(.ai(L5_0[9]), .bi(L5_1[4]), .ci(L6_1[3]), .so(L6_0[9]), .co(L6_1[4]));
	//11th col.
	full_adder e6(.ai(L5_0[10]), .bi(L5_1[5]), .ci(L6_1[4]), .so(L6_0[10]), .co(L6_1[5]));
	//12th col.
	full_adder e7(.ai(L5_0[11]), .bi(L5_1[6]), .ci(L6_1[5]), .so(L6_0[11]), .co(L6_1[6]));
	//13th col.
	full_adder e8(.ai(L5_0[12]), .bi(L5_1[7]), .ci(L6_1[6]), .so(L6_0[12]), .co(L6_1[7]));
	//14th col.
	full_adder e9(.ai(L5_0[13]), .bi(L5_1[8]), .ci(L6_1[7]), .so(L6_0[13]), .co(L6_1[8]));
	//15th col.
	full_adder e10(.ai(L5_0[14]), .bi(L5_1[9]), .ci(L6_1[8]), .so(L6_0[14]), .co(L6_1[9]));
	//16th col.
	full_adder e11(.ai(L5_0[15]), .bi(L5_1[10]), .ci(L6_1[9]), .so(L6_0[15]), .co(L6_1[10]));
	//17th col.
	half_adder e12(.ai(L5_0[16]), .bi(L6_1[10]), .so(L6_0[16]), .co(L6_0[17]));
	
	//---output assignments
	//assign p[]=L6_0[];
	assign p[15:0]=L6_0[15:0];
	
	
endmodule
//---------------------------------------------------------------------------------
//half aader
 module half_adder(
        input ai,
        input bi,
        output so,
        output co
    );
        assign {co, so} = ai + bi;
endmodule
//---------------------------------------------------------------------------------
//full adder
module full_adder(
        input ai,
        input bi,
        input ci,
        output so,
        output co
    );
        assign {co, so} = ai + bi + ci;
endmodule


		