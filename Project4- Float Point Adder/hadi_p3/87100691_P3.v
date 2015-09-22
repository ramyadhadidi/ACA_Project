//*************** @author : Hadi Asghari Moghaddam *** 87100691 ***********************************
//*************** @Sharif University of Technology ************************************************
//*************************************************************************************************

module fp_adder
    (
        input [31:0] a,
        input [31:0] b,
        output [31:0] s
    );
	wire [35:0] a1,b1,sum,normSum;
	wire [32:0] roundedRes;
	initial 
		begin
			$display("Hadi Asghari Moghaddam 87100691");
		end
	fpalign fpalign(.a(a),.b(b),.a1(a1),.b1(b1));
	addNums addNums(.a(a1),.b(b1),.sum(sum));
	normalize normalize(.sum(sum),.normSum(normSum));
	rounding	rounding(.normSum(normSum),.roundedRes(roundedRes));
	finalStep finalStep(.roundedRes(roundedRes),.s(s));
endmodule
/**************************************************************************************************/
/**************************************************************************************************/
module finalStep
	(
		input  [32:0] roundedRes,
		output [31:0] s		
	);
	wire isZero;
	assign isZero = (roundedRes[23:0]== 24'd0) ? 1'b1:1'b0;
	assign s = (~isZero)?{roundedRes[32:24],roundedRes[22:0]}:32'b0;

endmodule
/**************************************************************************************************/
/**************************************************************************************************/
module rounding
	(
		input [35:0] normSum,
		output [32:0] roundedRes
	);
	wire allOne,ov,isBigger;
	wire [23:0] roundedResTemp;
	wire [32:0] ovRes,novRes;
	
	assign allOne  = &normSum[26:3];					//needed to distingush overflowed result after rounding
	
	assign isBigger = 	(normSum[2:0] > 3'b100 ) ? 1'b1 :
						(normSum[2:0] < 3'b100 ) ? 1'b0 :
						((normSum[3:0] == 4'b1100)) ? 1'b1 : 1'b0;
	
	assign roundedResTemp = (isBigger) ? (normSum[26:3]+1'b1):normSum[26:3];		
	
	assign ov = (isBigger & allOne );	
	
	assign ovRes = {normSum[35],normSum[34:27]+1'b1,1'b1,23'b0};				//overflowed result
	assign novRes	= {normSum[35:27],roundedResTemp};								//non overflowed result
	assign roundedRes = ov ? ovRes : novRes ;

endmodule
/**************************************************************************************************/
/**************************************************************************************************/
module normalize
	(
		input [35:0] sum,
		output[35:0] normSum
	);
	wire isBigger;
	wire [7:0]  exponent,lessShamt;
	wire [26:0] sumval;
	wire [4:0]  shamt;
	assign shamt =
		sum[26] ? 0 :
		sum[25] ? 1 :
		sum[24] ? 2 :
		sum[23] ? 3 :
		sum[22] ? 4 :
		sum[21] ? 5 :
		sum[20] ? 6 :
		sum[19] ? 7 :
		sum[18] ? 8 :
		sum[17] ? 9 :
		sum[16] ? 10 :
		sum[15] ? 11 :
		sum[14] ? 12 :
		sum[13] ? 13 :
		sum[12] ? 14 :
		sum[11] ? 15 :
		sum[10] ? 16 :
		sum[9 ] ? 17 :
		sum[8 ] ? 18 :
		sum[7 ] ? 19 :
		sum[6 ] ? 20 :
		sum[5 ] ? 21 :
		sum[4 ] ? 22 :
		sum[3 ] ? 23 :
		sum[2 ] ? 24 :
		sum[1 ] ? 25 :
		sum[0 ] ? 26 : 27 ;
		
		assign isBigger = sum[34:27] > shamt;
		assign lessShamt = (sum[34:27]>0)? (sum[34:27]-1'b1) : 1'b0;
		assign exponent =isBigger ? (sum[34:27] - shamt ):8'b0;
		assign sumval = isBigger ?(sum[26:0] << shamt):(sum[26:0] << lessShamt);
		assign normSum = {sum[35],exponent,sumval};
endmodule 
/**************************************************************************************************/
/**************************************************************************************************/
module addNums
	(
		input [35:0]a,
		input [35:0]b,
		output [35:0]sum
	  
	);
	wire op,sumSign,overFlow,addedOr;
	//wire [24:0] bval;
	wire [27:0] sumValue;
	wire [7:0] sumExponent;
		
	assign op   = a[35] ^ b[35];
	//assign bval = op ? (~b[24:0]):b[24:0];
	assign sumSign = a[35];  // because |a| > |b| then sign of sum is sign of a bigger number
	assign sumExponent = a[34:27];
	//assign sumValue = a[24:0] + bval + op;
	assign sumValue = op ? a[26:0]-b[26:0] : a[26:0]+b[26:0];
	assign overFlow = (sumValue[27] & (!op) );		//if both of them are in same sign ,shift is needed
	assign addedOr = |sumValue[1:0];
	assign sum = overFlow ? {sumSign,sumExponent+1'b1,sumValue[27:2],addedOr}:{sumSign,sumExponent,sumValue[26:0]};

endmodule


/**************************************************************************************************/
/**************************************************************************************************/
//***********************************************   ***********************************************
module fpalign
		(
			input [31:0]a,			
			input [31:0]b,				
			output [35:0]a1,			
			output [35:0]b1
				
		);
		wire abigger,azero,bzero;
		wire [31:0] atemp,btemp;		
		wire [7: 0] exponentDiff,expa,expb;
		wire [47:0] bVal;
		wire [7:0 ] shamt;

		assign abigger = (a[30:0] > b[30:0]) ? 1'b1 : 1'b0;       //distinguish bigger number
		assign atemp = abigger ? a:b;   						//making a temporary value to manipulate it
		assign btemp = abigger ? b:a;
		
		assign azero = |atemp[30:23]; 							// if exponent is not zero
		assign bzero = |btemp[30:23];
		
		assign expa = azero ?  atemp[30:23]:8'd1 ;	// put the exponent of a into expa
		assign expb = bzero ?  btemp[30:23]:8'd1 ;	// put exponent of b into expb

		assign exponentDiff = expa-expb;
		assign shamt = (exponentDiff < 7'd25) ? exponentDiff : 7'd25; 	//shift amount has to be min(exponent difference , fraction+2)

				
		assign a1 = {atemp[31:23],azero,atemp[22:0],3'b0};				//construncting a
		assign bVal = {bzero,btemp[22:0],24'b0}>>shamt;			//length = 1+23+24 = 48 [47:0]
		
		assign b1 = {btemp[31],btemp[30
		:23]+shamt,bVal[47:22],|bVal[21:0]};		//constructing b	length = 1+8+26+1=36
				
endmodule
