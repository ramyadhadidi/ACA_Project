/* single-precision float point adder
ACA course Oct 2012
Ramyad Hadidi - 88109971
*/

`timescale 1ns/1ns

module fp_adder
    (
        input [31:0] a,		//32pit fp input
        input [31:0] b,		//32pit fp input
        output [31:0] s		//32pit fp result
    );
	
	//inital for HW
				  	initial
				  	begin
					   	$display("ACA Project4 \n Ramyad Hadidi-88109971");
				  	end
	
	//vars
	wire			swap;							//for detemine wich E is larger (determines which number is a or b)(1=swaping)
	wire	[31:0]	num1_p,num2_p;					//num1 has larger E (p denote packed)
	wire	[23:0]	num1_unp;						//unpacked fractional parts (num1)
	wire	[23:0]	num2_unp_temp;					//unpacked fractional parts (num2)
	wire    [50:0]  num2_unp_temp2;					//for determining R,G,S
	wire    [50:0]  num2_unp_temp3;					//for determining R,G,S and num2_unp
	wire    [23:0]  num2_unp;						//unpacked fractional parts (num2)  with shifting (ready for adding to num1)
	wire			R,G,S;							//round, gaurd, and sticky bits
	wire	[7:0]	shift;							//|E1-E2|
	wire			addsub;							//add or subtract
	wire	[26:0]	res;							//add/sub result
	wire	[27:0]	res_temp;		  				//add/sub result after shifting of carry
	wire	[27:0]  res_temp2;						//normalized
	wire	[27:0]  res_temp3;						//final normalized
	wire	[27:0]  res_temp4;
	wire	[27:0]  res_temp5;
	wire	[22:0]  res_temp6;
	wire			c;								//carry/borrow add/sub result(above)
	wire			sign_out;						//sign output
	wire	[7:0]	exp_output;						//exponent of output
	wire	[7:0]	exp_output2;					//exponent after normalization
	wire    [7:0]   exp_output3;					//exponent after normalization
	wire	[7:0]	exp_output4;					//exponent after normalization
	wire	[7:0]	exp_output5;					//exponent after normalization
	wire	[7:0]	new_exp;						//exponent after normalization
	wire			c_exp1;							//carry of exponenet sum
	wire			c_exp2;							//carry of expoenent sum
	wire			nor_need;						//normalize needed after add/sub because of 0????
	wire	[4:0]	nor_shift;						//how many shift needed for shifting
	wire			res_is_zero;					//indicates that result is all zero 1=zero
	wire			nor_to_zero;					//indicates with normalization we will got zero
	wire			shift_more;						//indicates if more shifting needed (>2)
	wire			round;							//yes=1
	wire			c_round;						//carry after rounding
	
	//CODE
	//1//determine which E is larger and assign
	sub_8bit s1(.a(a[30:23]), .b(b[30:23]), .s(shift), .c(swap));
	
	assign num1_p=swap?b:a;
	assign num2_p=swap?a:b;
	
	//2//unpack Fractional parts
	assign num1_unp=(|num1_p[30:23])?{1'b1,num1_p[22:0]}:{1'b0,num1_p[22:0]};
	assign num2_unp_temp=(|num2_p[30:23])?{1'b1,num2_p[22:0]}:{1'b0,num2_p[22:0]};
	assign num2_unp_temp2[50:27]=num2_unp_temp;
	assign num2_unp_temp2[26:0]=27'b0;
	assign num2_unp_temp3=(shift==1 & num2_p[30:23]==0)?num2_unp_temp2:(num2_p[30:23]==0?(num1_p[30:23]==0?num2_unp_temp2:(num2_unp_temp2>>(shift-1))):num2_unp_temp2>>shift);	//if one E=0 and another E=1 we dont need shifting(both exp=-126)
	assign num2_unp=num2_unp_temp3[50:27];
	
	//3//assign R,G,S bits
	//method1
	assign R2=num2_unp_temp3[26];
	assign G2=num2_unp_temp3[25];
	assign S2=|num2_unp_temp3[24:0];
	//method2
	//with every shift (for shift<=24 with this {num2_unp_temp[shift-1:22-2],|num2_unp_temp[shift-3:0]})
	//assign {R,G,S}=(|shift)?(shift>=27?3'b000:(shift==26?{2'b00,|num2_unp_temp[23:0]}:(shift==25)?{1'b0,num2_unp_temp[23],|num2_unp_temp[22:0]}:((shift==24)?{num2_unp_temp[23:22],|num2_unp_temp[21:0]}:((shift==23)?{num2_unp_temp[22:21],|num2_unp_temp[20:0]}:((shift==22)?{num2_unp_temp[21:20],|num2_unp_temp[19:0]}:((shift==21)?{num2_unp_temp[20:19],|num2_unp_temp[18:0]}:((shift==20)?{num2_unp_temp[19:18],|num2_unp_temp[17:0]}:((shift==19)?{num2_unp_temp[18:17],|num2_unp_temp[16:0]}:((shift==18)?{num2_unp_temp[17:16],|num2_unp_temp[15:0]}:((shift==17)?{num2_unp_temp[16:15],|num2_unp_temp[14:0]}:((shift==17)?{num2_unp_temp[16:15],|num2_unp_temp[14:0]}:((shift==16)?{num2_unp_temp[15:14],|num2_unp_temp[13:0]}:((shift==15)?{num2_unp_temp[14:13],|num2_unp_temp[12:0]}:((shift==14)?{num2_unp_temp[13:12],|num2_unp_temp[11:0]}:((shift==13)?{num2_unp_temp[12:11],|num2_unp_temp[10:0]}:((shift==12)?{num2_unp_temp[11:10],|num2_unp_temp[9:0]}:((shift==11)?{num2_unp_temp[10:9],|num2_unp_temp[8:0]}:((shift==10)?{num2_unp_temp[9:8],|num2_unp_temp[7:0]}:((shift==9)?{num2_unp_temp[8:7],|num2_unp_temp[6:0]}:((shift==8)?{num2_unp_temp[7:6],|num2_unp_temp[5:0]}:((shift==7)?{num2_unp_temp[6:5],|num2_unp_temp[4:0]}:((shift==6)?{num2_unp_temp[5:4],|num2_unp_temp[3:0]}:((shift==5)?{num2_unp_temp[4:3],|num2_unp_temp[2:0]}:((shift==4)?{num2_unp_temp[3:2],|num2_unp_temp[1:0]}:((shift==3)?{num2_unp_temp[2:1],|num2_unp_temp[0]}:((shift==2)?{num2_unp_temp[1:0],1'b0}:{num2_unp_temp[0],2'b00})))))))))))))))))))))))))):3'b000;
	
	//4//add or sub //and defining output sign //normailze
	assign addsub=num1_p[31]^num2_p[31];	//0 mens +
	addsub_27bit s2(.a({num1_unp,3'b000}), .b({num2_unp,R2,G2,S2}), .s(res), .addsub(addsub), .c(c));
	
	assign sign_out=~addsub?(num1_p[31]?1'b1:1'b0):(~swap?(~c?a[31]:b[31]):(~c?b[31]:a[31]));		//if + sign = sign a or b // if - sign  = sign(a-b) with respect of swap and c
	assign res_temp=(~addsub&c)?{1'b1,res[26:0]}:{res,1'b0};		//if we had a carry in + we must import it; else res will be output of the module that is corrected in the module
	assign {c_exp1,exp_output}=~swap?(~addsub&c?(a[30:23]+1'b1):{1'b0,a[30:23]}):(~addsub&c?(b[30:23]+1'b1):{1'b0,b[30:23]});
	assign exp_output2=c_exp1?8'hFF:exp_output;	//overflow maybe in exponent
	
	assign nor_need=res_temp[27]?1'b0:1'b1;	//determine if normalization is needed
	assign {res_is_zero,nor_shift}=nor_need?(res_temp[26]?{1'b0,5'd1}:(res_temp[25]?{1'b0,5'd2}:(res_temp[24]?{1'b0,5'd3}:(res_temp[23]?{1'b0,5'd4}:(res_temp[22]?{1'b0,5'd5}:(res_temp[21]?{1'b0,5'd6}:(res_temp[20]?{1'b0,5'd7}:(res_temp[19]?{1'b0,5'd8}:(res_temp[18]?{1'b0,5'd9}:(res_temp[17]?{1'b0,5'd10}:(res_temp[16]?{1'b0,5'd11}:(res_temp[15]?{1'b0,5'd12}:(res_temp[14]?{1'b0,5'd13}:(res_temp[13]?{1'b0,5'd14}:(res_temp[12]?{1'b0,5'd15}:(res_temp[11]?{1'b0,5'd16}:(res_temp[10]?{1'b0,5'd17}:(res_temp[9]?{1'b0,5'd18}:(res_temp[8]?{1'b0,5'd19}:(res_temp[7]?{1'b0,5'd20}:(res_temp[6]?{1'b0,5'd21}:(res_temp[5]?{1'b0,5'd22}:(res_temp[4]?{1'b0,5'd23}:(res_temp[3]?{1'b0,5'd24}:(res_temp[2]?{1'b0,5'd25}:{1'b1,5'd0}))))))))))))))))))))))))):{1'b0,5'd0};	//determine how many shift needed and if result is zero
	sub_8bit s3(.a(exp_output2), .b({3'b000,nor_shift}), .s(new_exp), .c(nor_to_zero));
	assign {shift_more,res_temp2}=nor_to_zero?(nor_shift==new_exp?{1'b0,res_temp[27:0]}:({1'b0,res_temp<<(nor_shift-new_exp-1)})):(res_is_zero?{1'b0,28'b0}:(nor_shift==0?{1'b0,res_temp[27:0]}:(nor_shift==1?{1'b0,res_temp[26:0],1'b0}:(nor_shift==2?{1'b0,res_temp[25:0],2'b00}:{1'b1,res_temp[25:0],2'b00}))));	//we must stop when reaching to e=-126  
	assign R=res_temp2[3];
	assign G=res_temp2[2];
	assign S=res_temp2[1]|res_temp2[0];
	assign res_temp3=shift_more?res_temp2<<(nor_shift-2):res_temp2;
	assign exp_output3=(nor_to_zero|res_is_zero)?7'b0:new_exp;
	
	//5//rounding //and normalizing
	assign round=R?(G|S?1'b1:(res_temp3[4]?1'b1:0'b0)):1'b0;
	assign {c_round,res_temp4}=round?({res_temp3[27:4]+1'b1,4'b0000}):{1'b0,res_temp3[27:4],4'b0000};
	assign res_temp5=c_round?{1'b1,res_temp4>>1}:res_temp4;
	assign {c_exp2,exp_output4}=c_round?(exp_output3+1):{1'b0,exp_output3};
	assign exp_output5=c_exp2?8'hFF:exp_output4;
	
	//6//packing
	assign res_temp6=exp_output5==0&res_temp5[27]?res_temp5[27:5]:res_temp5[26:4];
	assign s={sign_out,exp_output5,res_temp6};
	
endmodule

//------------------------------------------------------
//sub 2 8bits and returns |a-b| with borrow
module sub_8bit
	(
		input 	[7:0] 	a,
		input 	[7:0] 	b,
		output	[7:0] 	s,
		output 			c
	);
	
	wire 	[8:0] 	temp;
	assign temp=a-b;
	assign c=temp[8];
	assign s=c?(b-a):temp[7:0];
	
endmodule

//------------------------------------------------------
//24bit adder/sub and result is |a-b|
module addsub_27bit
	(
		input			addsub,
		input	[26:0]	a,
		input	[26:0]	b,
		output	[26:0]	s,
		output			c
	);
	
	wire 	[27:0]	temp;
	
	assign temp=addsub?(a-b):a+b;
	assign c=temp[27];
	assign s=c&addsub?(b-a):temp[26:0];
	
endmodule

