
`timescale 1ns/1ns

module parallel_unsigned_mult__tb();

    reg  [ 7:0] c, d;
    reg  [15:0] q;

   integer i, j, err = 0;


    initial begin
      for(j=0; j<256; j=j+1)
        for(i=0; i<256; i=i+1) begin

            c = i;
            d = j;
            q = c * d;

            #1;
            if (q === sut.p)
               ;
            else begin
                err = err + 1;
                if(err < 20) begin
                  $write("%x (%0d) * %x (%0d) = %x (%0d) ", c, c, d, d, sut.p, sut.p);
                  $display("ERROR: expected %x, got %x", q, sut.p);
               end
            end

        end

      if(err)
         $display("\n\tOops, %0d (%0d%%) errors are found.\n", err, (err*100+65536/2)/65536);
      else
         $display("\n\tGREAT, no errors found.\n");

   end

    parallel_unsigned_mult sut (    
        .a(c),
        .b(d),
        .p()
    );

endmodule

module half_adder(
   input ai,
   input bi,
   output so,
   output co
);
   assign {co, so} = ai + bi;
endmodule;

module full_adder(
   input ai,
   input bi,
   input ci,
   output so,
   output co
);
   assign {co, so} = ai + bi + ci;
endmodule;
