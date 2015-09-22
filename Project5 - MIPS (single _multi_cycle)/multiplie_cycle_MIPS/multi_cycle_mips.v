/*Mulitplie Cycle MIPS Processor
Ramyad Hadidi
1st: wriiten 20th Nov 2012
2nd: edit jalr/edit slt in ALU module 4Dec 2012
*/

`timescale 1ns/1ns

//`define DEBUG_RF	// comment this line to disable register content  writing 
//`define DEBUG_MEM	// comment this line to disable memory content  writing 

`define AND  	4'b0000		//ALUop (module) definitions
`define OR 	 	4'b0001
`define ADD  	4'b0010
`define SUB  	4'b0011
`define NOR  	4'b0100
`define SLT  	4'b0101
`define XOR  	4'b0110
`define SLTU 	4'b0111
`define LUI  	4'b1000
`define PASS 	4'b1001


module  multi_cycle_mips (
            input clk,
            input reset
        );
		
		//inital for HW
				  	initial
				  	begin
					   	$display("ACA Project5\n Multiplie Cycle MIPS \n Ramyad Hadidi-88109971 \n\n\n");
				  	end
		
	reg PCsrc;
	wire [31:0] rel_add_e;
	wire [31:0] inst;
	reg [31:0] IR;
	reg [1:0] REGdst;
	reg SENZE;
	reg [1:0] MemtoReg;	
	reg WRTMem;
	reg WRTrf;
	reg WRTPC;
	reg WRTMAR;
	reg WRTIR;
	reg srcsel;
	wire ALUzero;
	reg [3:0] ALUop;
	reg [4:0] WR_line;
	reg [31:0] WD_line;
	wire [31:0] RD1,RD2;
	reg [31:0] pc;
	reg [31:0] MAR;
	reg [31:0] PC_line;
	reg [31:0] src_line;
	reg ALUAsel;
	reg [1:0] ALUBsel;
	reg[31:0] aluA_line;
	reg [31:0] aluB_line;
	wire [31:0] aluResult;
	reg [31:0] hi,lo;
	reg hiNlo;
	wire endm;
	reg [33:0]multa,multb;
	reg startm;
	wire [67:0] waste;
	reg WRThilo;
	
	//===========================================
	//Program counter and memory
	//MAR and PC  and IR registers
	always @(posedge clk) begin
		case ({reset,WRTPC,WRTMAR})
			3'b1xx: begin
					pc<=32'h00000000;
					MAR<=32'h00000000;
					end
			3'b010: pc<=src_line;
			3'b001: MAR<=src_line;
		endcase		
		case ({reset,WRTIR})
			2'b1x: IR<=32'h00000000;
			2'b01: IR<=inst;
		endcase	
	end
	
	//Multiplexer for MAR and PC
	always @(*)	begin
		case(srcsel)
			1'b0: src_line = aluResult;
			1'b1: src_line = {pc[31:28],IR[25:0],2'b00};
		endcase
		case(PCsrc)
			1'b0: PC_line = pc;
			1'b1: PC_line = MAR;
		endcase
	end
	
	//Program and Data Memory
	async_mem mem(
	.clk(clk),
	.write(WRTMem),
	.address(PC_line),
	.write_data(RD2),
	.read_data(inst)
	);
	
	//===========================================
	//Register File and SE/ZE and mulitplier
	//WR  and WD multiplexers
	always @(*)	begin
		case(REGdst)
			2'b00: WR_line = IR[20:16];
			2'b01: WR_line = IR[15:11];	
			2'b10: WR_line = 5'b11111;
			2'b11: WR_line = 5'bxxxxx;
		endcase
		case(MemtoReg)
			2'b00: WD_line = inst;
			2'b01: WD_line = aluResult;
			2'b10: WD_line = pc;
			2'b11: WD_line = hiNlo?hi:lo;
		endcase
	end
	//register file
	reg_file rf(
	.clk(clk),
	.write(WRTrf),
	.WR(WR_line),
	.WD(WD_line),
	.RR1(IR[25:21]),
	.RR2(IR[20:16]),
	.RD1(RD1),
	.RD2(RD2)
	);
	//SE/ZE part
	assign rel_add_e=SENZE?{{16{IR[15]}},IR[15:0]}:{16'h0000,IR[15:0]};	
	//booth
	signed_multiplier booth(
		.clk(clk), .start(startm), 
		.a(multa), 
		.b(multb), 
		.s({waste}),
		.endm (endm)
	);
	
	always @(posedge clk) begin
		if (WRThilo) begin
			lo<=waste[31:0];
			hi<=waste[63:32];
		end
	end
	//===========================================
	//ALU 	
	always @(*) begin
		case (ALUAsel)
			1'b0 : aluA_line=pc;
			1'b1 : aluA_line=RD1;
		endcase		
		case(ALUBsel)
			2'b00 : aluB_line = {{29{1'b0}},3'b100};
			2'b01 : aluB_line = RD2;
			2'b10 : aluB_line = rel_add_e;
			2'b11 : aluB_line = rel_add_e<<2;
		endcase
	end
	my_alu ALU(
	   .aluA(aluA_line),
	   .aluB(aluB_line),
	   .aluOp(ALUop),
	   .aluResult(aluResult),
	   .ALUZero(ALUzero)
	);
	
	//===========================================
	//control unit
	localparam	//opcodes
		R_type	= 6'h00,
		j		= 6'h02,
		jal		= 6'h03,
		beq		= 6'h04,
		bne		= 6'h05,
        lw		= 6'h23,
        sw		= 6'h2b,
		addiu	= 6'h09,
		slti	= 6'h0a,
		sltiu	= 6'h0b,
		andi	= 6'h08,
		ori		= 6'h0d,
		xori	= 6'h0e,
		lui		= 6'h0f;
		
		
		 
	localparam	//func field opcodes
		opjr	= 6'h08,
		opjalr	= 6'h09,
		opmfhi	= 6'h10,
		opmflo 	= 6'h12,
		opmult	= 6'h18,
		opmultu	= 6'h19,
		opaddu	= 6'h21,
		opsubu	= 6'h23,
		opand 	= 6'h24,
		opor	= 6'h25,
		opxor	= 6'h26,
		opnor	= 6'h27,
		opslt	= 6'h2a,
		opsltu	= 6'h2b;
	
	reg [3:0] CS,NS;
	localparam  	//states
		FETCH		= 4'b0000,
		EXECUTE		= 4'b0001,
		EXE_BEQ_BNE = 4'b0010,
		EXE_LW1		= 4'b0011,
		EXE_LW2		= 4'b0100,
		EXE_SW1		= 4'b0101,
		EXE_SW2		= 4'b0110,
		MULT_WAIT	= 4'b0111;
		 
	wire [5:0]OP = IR[31:26];
	wire [5:0]ALU_OP = IR[5:0];
	
	always @(posedge clk) begin
		if (reset)
			CS<=FETCH;
		else
			CS<=NS;
	end
	
	always @(*) begin		//controller
		WRTMAR=1'b0;	WRTPC=1'b0;		WRTMem=1'b0;	WRTIR=1'b0;		WRTrf=1'b0;	
		REGdst=2'bxx;	MemtoReg=2'bxx;	SENZE=1'bx; 	ALUop=4'hx;		PCsrc=1'b0;
		ALUAsel=1'bx;	ALUBsel=2'bxx;	srcsel=1'b0;	hiNlo=1'bx;		startm=1'b0;
		multa=34'hxxxxxxxxx;			multb=34'hxxxxxxxxx; 			WRThilo=1'b0;
		
		case (CS)
			FETCH: begin
					WRTIR=1'b1;
					ALUAsel=1'b0;
					ALUBsel=2'b00;
					WRTPC=1'b1;
					ALUop = `ADD;
					NS = EXECUTE;
					end
			EXECUTE: begin
					case(OP)
					R_type: begin
						REGdst		= 2'b01;
						WRTrf		= 1'b1;
						MemtoReg	= 2'b01;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b01;
						NS			= FETCH;
						case (ALU_OP)
							opand  	: ALUop = `AND;
							opor  	: ALUop = `OR ;
							opaddu	: ALUop = `ADD;
							opsubu	: ALUop = `SUB;
							opsltu 	: ALUop = `SLTU;
							opslt	: ALUop = `SLT;
							opnor  	: ALUop = `NOR;
							opxor	: ALUop = `XOR;
							opjr	: begin
										ALUAsel		= 1'b1;
										WRTPC		= 1'b1;
										ALUop		= `PASS;
									  end
							opjalr	: begin
										ALUAsel		= 1'b1;
										REGdst		= 2'b01;
										MemtoReg	= 2'b10;
										WRTPC		= 1'b1;
										ALUop		= `PASS;
									  end
							opmfhi: begin
										REGdst		= 2'b01;
										WRTrf		= 1'b1;
										MemtoReg	= 2'b11;
										hiNlo		= 1'b1;
										ALUAsel		= 1'bx;
										ALUBsel		= 2'bxx;	
									end
							opmflo: begin
										REGdst		= 2'b01;
										WRTrf		= 1'b1;
										MemtoReg	= 2'b11;
										hiNlo		= 1'b0;
										ALUAsel		= 1'bx;
										ALUBsel		= 2'bxx;	
									end
							opmult: begin
										REGdst		= 2'bxx;
										WRTrf		= 1'b0;
										MemtoReg	= 2'bxx;
										ALUAsel		= 1'bx;
										ALUBsel		= 2'bxx;
										NS			= MULT_WAIT;
										startm		= 1'b1;
										multa		= {RD1[31],RD1[31],RD1};
										multb		= {RD2[31],RD2[31],RD2};
									end
							opmultu: begin
										REGdst		= 2'bxx;
										WRTrf		= 1'b0;
										MemtoReg	= 2'bxx;
										ALUAsel		= 1'bx;
										ALUBsel		= 2'bxx;
										NS			= MULT_WAIT;
										startm		= 1'b1;
										multa		= {2'b00,RD1};
										multb		= {2'b00,RD2};
									end
							//more func here
							default	: begin
										REGdst		= 2'bxx;
										WRTrf		= 1'b0;
										MemtoReg	= 2'bxx;
										ALUAsel		= 1'bx;
										ALUBsel		= 2'bxx;
									  end
						endcase
					end
					
					j: begin
						srcsel		= 1'b1;
						WRTPC		= 1'b1;
						NS			= FETCH;
					end
					
					jal: begin
						srcsel		= 1'b1;
						WRTPC		= 1'b1;
						REGdst		= 2'b10;
						MemtoReg	= 2'b10;
						WRTrf		= 1'b1;
						NS			= FETCH;
					end
					
					beq: begin
						NS 			= ALUzero?EXE_BEQ_BNE:FETCH;
						ALUop		= `SUB;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b01;
					end
					
					bne: begin
						NS 			= ALUzero?FETCH:EXE_BEQ_BNE;
						ALUop		= `SUB;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b01;
					end
					
					lw: begin
						NS			= EXE_LW1;
						ALUop		= `ADD;
						SENZE 		= 1'b1;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						WRTMAR		= 1'b1;
					end
					
					sw: begin
						NS			= EXE_SW1;
						ALUop		= `ADD;
						SENZE 		= 1'b1;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						WRTMAR		= 1'b1;
					end
					
					addiu:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `ADD;
						SENZE 		= 1'b0;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					slti:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `SLT;
						SENZE 		= 1'b1;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					sltiu:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `SLTU;
						SENZE 		= 1'b0;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					andi:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `AND;
						SENZE 		= 1'b0;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					ori:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `OR;
						SENZE 		= 1'b0;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					xori:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `XOR;
						SENZE 		= 1'b0;
						ALUAsel		= 1'b1;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					
					lui:	begin
						NS			= FETCH;
						WRTrf		= 1'b1;
						ALUop		= `LUI;
						SENZE 		= 1'b0;
						ALUBsel		= 2'b10;
						REGdst		= 2'b00;
						MemtoReg	= 2'b01;
					end
					//more states here
					default: NS = FETCH;
				endcase
			end
			
			EXE_BEQ_BNE: begin
					NS			= FETCH;
					SENZE 		= 1'b1;
					ALUop		= `ADD;
					ALUAsel		= 1'b0;
					ALUBsel		= 2'b11;
					WRTPC		= 1'b1;
			end
			
			EXE_LW1: begin
					NS			= FETCH;
					PCsrc		= 1'b1;
					REGdst		= 2'b00;
					MemtoReg	= 2'b00;
					WRTrf		= 1'b1;
			end
			
			EXE_SW1: begin
					NS			= FETCH;
					PCsrc		= 1'b1;
					WRTMem		= 1'b1;
			end
			
			MULT_WAIT: begin
					{WRThilo,NS}=(endm)?{1'b1,FETCH}:{1'b0,MULT_WAIT};
			end
			//more states here
			default: NS = FETCH;
		endcase
	end
	
endmodule


//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//asynchronous memory
module async_mem(
	input clk,
	input write,
	input [31:0] address,
	input [31:0] write_data,
	output [31:0] read_data
);


	reg [31:0] mem_data [0:1023];

	assign read_data = mem_data[ address[31:2] ];

	always @(posedge clk)
		if(write) begin
			mem_data[ address[31:2] ] <= #1 write_data;
			
			`ifdef DEBUG_MEM
				$display("[%x] = %x", address, write_data);
			`endif
		end

endmodule
//-----------------------------------------------------------------------------------------------------------
//register file

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

			`ifdef DEBUG_RF
			if(WR)
				$display("$%0d = %x", WR, WD);
			`endif

		end
		reg_data[0] <= #1 32'h00000000;
	end

endmodule
//-----------------------------------------------------------------------------------------------------------
//my ALU
module my_alu(
   input 			[31:0]	aluA,
   input 			[31:0]	aluB,
   input 			[3:0]	aluOp,
   output	reg 	[31:0]	aluResult,
   output					ALUZero
);
	wire [32:0]aluAs = $signed(aluA);
	wire [32:0]aluBs = $signed(aluB);
	

   always @(*)
      case(aluOp)
		 `AND 	: aluResult = aluA & aluB;
		 `OR  	: aluResult = aluA | aluB;
         `ADD 	: aluResult = aluA + aluB;           
         `SUB 	: aluResult = aluA - aluB;      
         `SLTU	: aluResult = (aluA<aluB)?32'h00000001:32'h00000000;
         `NOR 	: aluResult = ~(aluA | aluB);
		 `XOR 	: aluResult = aluA ^ aluB;
		 `SLT 	: aluResult = (aluAs<aluBs)?32'h00000001:32'h00000000;
		 `LUI 	: aluResult = {aluB[15:0],{16{1'b0}}};
		 `PASS	: aluResult = aluA;
		  default:	aluResult=32'hxxxxxxxx;
      endcase

   assign ALUZero = !(|aluResult);

endmodule
//-----------------------------------------------------------------------------------------------------------
//Booth multiplier (34bits)
module signed_multiplier (
		clk,  		//system clk 
		start,		//all inputs are valid for starting
		a,		  	//operand
		b,		  	//operand
		s,			//result
		endm		//indicate end of mul
	);
	//parameters and definitions
	input             clk;
	input             start;
	input      [33:0] a;
	input      [33:0] b;
	output reg [67:0] s;
	output reg		  endm;
	
	//vars
	reg    [33:0]   A;
	reg    [68:0]   P;
	reg    [35:0]   ai;
	wire   [35:0]   bi;
	reg             ci;
	wire   [35:0]   so;
	reg    [4:0]    counter;   //for counting and registering output
	
	
	//**CODE	
	//
	always @(posedge clk)
	begin	
		if (start)	//load registers
		begin	
			A<=a;
			P[34:1]<=b;
			P[0]<=1'b0;
			P[68:35]<='b0;	
			counter <=5'b0000;
			endm<=1'b0;			
			end
		else
		begin		//two shifts - save result of adder
			P<=(P>>2);
			P[68:33]<=so[35:0];
			counter <= counter + 1'b1;
			endm<=1'b0;	
			if (counter==5'd17) begin
			   s[67:0]<=P[68:1];
			   endm<=1'b1;
			end
		end
	end
	
  //adder
	full_adder adder(.ai(ai), .bi(bi), .ci(ci), .so(so), .co());
	assign bi[33:0]=P[68:35];
	assign bi[35]=P[68];
	assign bi[34]=P[68];
		
	//PP generator (deretemins ci and ai) (booth encoding)
	always @(P[2:0],A)
	begin
		case(P[2:0])
			3'b000:	begin	//0
					ai=36'b0;
					ci=1'b0;		end
			3'b001:	begin	//1
					ai[33:0]=A;
					ai[34]=A[33];
					ai[35]=A[33];
					ci=1'b0;		end	
			3'b010:	begin	//1
					ai[33:0]=A;
					ai[34]=A[33];
					ai[35]=A[33];
					ci=1'b0;		end	
			3'b011:	begin	//2
					ai[34:0]=A<<1;
					ai[35]=ai[34];	
					ci=1'b0;		end
			3'b100:	begin	//-2
					ai[34:0]=~(A<<1);
					ai[35]=ai[34];
					ci=1'b1;		end
			3'b101:	begin	//-1
					ai[33:0]=~A;
					ai[34]=ai[33];
					ai[35]=ai[33];
					ci=1'b1;		end
			3'b110:	begin	//-1
					ai[33:0]=~A;
					ai[34]=ai[33];
					ai[35]=ai[33];
					ci=1'b1;		end
			3'b111:	begin	//0
					ai=36'b0;
					ci=1'b0;		end
		endcase
	end	

endmodule

//full adder 34bit
module full_adder(
        input [35:0] ai,
        input [35:0] bi,
        input ci,
        output [35:0] so,
        output co
    );
        assign {co, so} = ai + bi + ci;
endmodule	
//-----------------------------------------------------------------------------------------------------------