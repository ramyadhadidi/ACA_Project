
`timescale 1ns/1ns

module fp_add__tb();


	reg [31:0] a, b, s;

	initial begin

      #10
			a =32'hdeadbeef;  
			b =32'hdadaabba;
			s =32'h4d064dda;
      
      #10
			a =32'h440d491c;  
			b =32'h4d064db7;
			s =32'h4d064dda;
			
			#10;
			a =32'h366b66c4;  
			b =32'h42307eb7;
			s =32'h42307eb8;
			
			#10;
			a =32'h12e1798b;  
			b =32'h121f73da;
			s =32'h131899bc;
			
			#10;
			a =32'h575360bf;  
			b =32'h5c673cd6;
			s =32'h5c6771ae;
			
			#10;
			a =32'h422d54dc;  
			b =32'h368e0d66;
			s =32'h422d54dd;
			
			#10;
			a =32'h49f7442b;  
			b =32'h50781481;
			s =32'h50781c3b;
			
			#10;
			a =32'h18502b00;  
			b =32'h16d47f61;
			s =32'h186abaec;
			
			#10;
			a =32'h4d675968;  
			b =32'h4ad42cf7;
			s =32'h4d6dfad0;
			
			#10;
			a =32'h5d240588;  
			b =32'h55797cfe;
			s =32'h5d240681;
			
			#10;
			a =32'h285248db;  
			b =32'h27251643;
			s =32'h287b8e6c;
			
			#10;
			a =32'h01925662;  
			b =32'h81b81010;
			s =32'h8096e6b8;
			
			#10;
			a =32'h00012832;  
			b =32'h0014283c;
			s =32'h0015506e;
			
			#10;
			a =32'h00012832;  
			b =32'h8014283c;
			s =32'h8013000a;
			
			#10;
			a =32'h00b627be;  
			b =32'h000a21a8;
			s =32'h00c04966;
			
			#10;
			a =32'h00b627be;  
			b =32'h800a21a8;
			s =32'h00ac0616;
			
			#10;
			a =32'h02682174; 
			b =32'h826f0850;
			s =32'h803736e0;
			
			#10;
			a =32'h00d47943; 
			b =32'h80c67efc;
			s =32'h000dfa47;
			
			#10;
			a =32'h440d491c; 
			b =32'h00000000;
			s =32'h440d491c;
			
			#10;
			a =32'h00004002; 
			b =32'h00000002;
			s =32'h00004004;
			
			#10;
			a =32'h3F800001; 
			b =32'hBF800001;
			s =32'h00000000;
			
			#10;
			a =32'h3F800001; 
			b =32'hBF800000;
			s =32'h34000000;
			
			#10;
			a =32'h40000000; 
			b =32'h34000000;
			s =32'h40000000;
			
			#10;
			a =32'h40000000; 
			b =32'h34000001;
			s =32'h40000001;
			
			#10;
			a =32'h3fffffff; 
			b =32'h34000000;
			s =32'h40000000;
			
			#10;
			a =32'h440d491c; 
			b =32'h40000000;
			s =32'h440dc91c;
			
			#10;
			a =32'h407fffff; 
			b =32'h347fffff;
			s =32'h40800000;
			
			#10;
			a =32'h407fffff; 
			b =32'h34000000;
			s =32'h40800000;
			
			#10;
			a =32'h407fffff; 
			b =32'h34400000;
			s =32'h40800000;
	end			
		fp_adder S1(.a(a), .b(b), .s());		

endmodule