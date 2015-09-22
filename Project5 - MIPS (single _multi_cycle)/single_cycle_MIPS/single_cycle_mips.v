/*Single Cycle MIPS Processor
Ramyad Hadidi
1st: 20th Nov 2012
2nd: edit jalr/edit slt in ALU module 4Dec 2012
*/

`timescale 1ns/1ns

`define DEBUG	// comment this line to disable register and memory content  writing 

`define AND  4'b0000		//ALUop (module) definitions
`define OR 	 4'b0001
`define ADD  4'b0010
`define SUB  4'b0011
`define NOR  4'b0100
`define SLT  4'b0101
`define XOR  4'b0110
`define SLTU 4'b0111
`define LUI  4'b1000


module  single_cycle_mips (
            input clk,
            input reset
        );
		
	reg [1:0] PCsrc;
	wire [31:0] rel_add_e;
	wire [31:0] inst;
	reg [1:0] REGdst;
	reg SENZE;
	reg [1:0] MemtoReg;
	reg ALUsrc;
	reg WRTdata;
	reg WRTrf;
	wire ALUzero;
	reg [3:0] ALUop;
	reg [4:0] WR_line;
	reg [31:0] WD_line;
	wire [31:0] RD1,RD2;
	wire [31:0] read_dataMem;
	reg [31:0] pc;	
	reg [31:0] PC_line;
	wire [31:0] aluB_line;
	wire [31:0] aluResult;
	
	//===========================================
	//Program counter and memory
	always @(*)	begin
		case(PCsrc)
			2'b11: PC_line = RD1;
			2'b10: PC_line = {pc[31:28],inst[25:0],2'b00};
			2'b01: PC_line = (pc+4)+(rel_add_e<<2);
			2'b00: PC_line = (pc+4);
		endcase
	end
	always @(posedge clk) begin
		if (reset)
			pc<=32'h00000000;
		else
			pc<=PC_line;
	end
	
	async_mem mem_prog(
	.clk(clk),
	.write(),
	.address(pc),
	.write_data(),
	.read_data(inst)
	);
	
	//===========================================
	//Register File and SE/ZE 
	always @(*)	begin
		case(REGdst)
			2'b00: WR_line = inst[20:16];
			2'b01: WR_line = inst[15:11];	
			2'b10: WR_line = 5'b11111;
			2'b11: WR_line = 5'bxxxx;
		endcase
		case(MemtoReg)
			2'b00: WD_line = aluResult;
			2'b01: WD_line = read_dataMem;
			2'b10: WD_line = (pc+4);
			2'b11: WD_line = 5'bxxxx;
		endcase
	end
	reg_file rf(
	.clk(clk),
	.write(WRTrf),
	.WR(WR_line),
	.WD(WD_line),
	.RR1(inst[25:21]),
	.RR2(inst[20:16]),
	.RD1(RD1),
	.RD2(RD2)
	);
	
	assign rel_add_e=SENZE?{{16{inst[15]}},inst[15:0]}:{16'h0000,inst[15:0]};	
	//===========================================
	//ALU and data Memory		
	assign aluB_line=ALUsrc?rel_add_e:RD2;
	my_alu ALU(
	   .aluA(RD1),
	   .aluB(aluB_line),
	   .aluOp(ALUop),
	   .aluResult(aluResult),
	   .ALUZero(ALUzero)
	);
	
	async_mem mem_data(
	.clk(clk),
	.write(WRTdata),
	.address(aluResult),
	.write_data(RD2),
	.read_data(read_dataMem)
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
		//opmfhi	= 6'h10,//
		//opmflo 	= 6'h12,//
		//opmult	= 6'h18,//
		//opmultu	= 6'h19,//
		opaddu	= 6'h21,
		opsubu	= 6'h23,
		opand 	= 6'h24,
		opor	= 6'h25,
		opxor	= 6'h26,
		opnor	= 6'h27,
		opslt	= 6'h2a,
		opsltu	= 6'h2b;
		 
		 
	wire [5:0]OP = inst[31:26];
	wire [5:0]ALU_OP = inst[5:0];
		 
	always @(*) begin		//controller
		case (OP)
			R_type: begin
				PCsrc		= 2'b00;
				REGdst		= 2'b01;
				WRTrf		= 1'b1;
				SENZE		= 1'bx;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b0;
				WRTdata		= 1'b0;
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
								PCsrc		= 2'b11;
								REGdst		= 2'bxx;
								WRTrf		= 1'b0;
								SENZE		= 1'bx;
								MemtoReg	= 2'bxx;
								ALUsrc		= 1'bx;
								WRTdata		= 1'b0;
							  end
					opjalr	: begin
								PCsrc		= 2'b11;
								REGdst		= 2'b01;
								WRTrf		= 1'b1;
								SENZE		= 1'bx;
								MemtoReg	= 2'b10;
								ALUsrc		= 1'bx;
								WRTdata		= 1'b0;
							  end
					//more func here
					default: begin 
								ALUop 		= 4'hx;
								WRTrf 		= 1'b0;
								REGdst		= 2'bxx;
								MemtoReg	= 2'bxx;
								ALUsrc		= 1'bx;
							  end
				endcase
			end
			
			j: begin
				PCsrc		= 2'b10;
				REGdst		= 2'bxx;
				WRTrf		= 1'b0;
				SENZE		= 1'bx;
				MemtoReg	= 2'bxx;
				ALUsrc		= 1'bx;
				WRTdata		= 1'b0;
				ALUop		= 4'hx;
			end
			
			jal: begin
				PCsrc		= 2'b10;
				REGdst		= 2'b10;
				WRTrf		= 1'b1;
				SENZE		= 1'bx;
				MemtoReg	= 2'b10;
				ALUsrc		= 1'bx;
				WRTdata		= 1'b0;
				ALUop		= 4'hx;
			end
			
			beq: begin
				PCsrc		= ALUzero?2'b01:2'b00;
				REGdst		= 2'bxx;
				WRTrf		= 1'b0;
				SENZE		= 1'b1;
				MemtoReg	= 2'bxx;
				ALUsrc		= 1'bx;
				WRTdata		= 1'b0;
				ALUop		= `SUB;
			end
			
			bne: begin
				PCsrc		= ALUzero?2'b00:2'b01;
				REGdst		= 2'bxx;
				WRTrf		= 1'b0;
				SENZE		= 1'b1;
				MemtoReg	= 2'bxx;
				ALUsrc		= 1'bx;
				WRTdata		= 1'b0;
				ALUop		= `SUB;
			end
			
			lw:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b1;
				MemtoReg	= 2'b01;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `ADD;
			end
			
			sw:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'bxx;
				WRTrf		= 1'b0;
				SENZE		= 1'b1;
				MemtoReg	= 2'bxx;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b1;
				ALUop		= `ADD;
			end
					
			addiu:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b0;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `ADD;
			end
			
			slti:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b1;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `SLT;
			end
			
			sltiu:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b0;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `SLTU;
			end
			
			andi:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b0;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `AND;
			end
			
			ori:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b0;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `OR;
			end
			
			xori:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'b0;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `XOR;
			end
			
			lui:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'b00;
				WRTrf		= 1'b1;
				SENZE		= 1'bx;
				MemtoReg	= 2'b00;
				ALUsrc		= 1'b1;
				WRTdata		= 1'b0;
				ALUop		= `LUI;
			end
			//more op here
			default:	begin
				PCsrc		= 2'b00;
				REGdst		= 2'bxx;
				WRTrf		= 1'b0;
				SENZE		= 1'bx;
				MemtoReg	= 2'bxx;
				ALUsrc		= 1'bx;
				WRTdata		= 1'b0;
				ALUop		= 4'hx;
			end
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
			
			`ifdef DEBUG
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

			`ifdef DEBUG
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
   output						ALUZero
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
		  default:	aluResult=32'hxxxxxxxx;
      endcase

   assign ALUZero = !(|aluResult);

endmodule
//-----------------------------------------------------------------------------------------------------------