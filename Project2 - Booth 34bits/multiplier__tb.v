
`timescale 1ns/1ns

module multiplier__tb();

    parameter no_of_tests = 10000;

    reg clk = 1'b1;
    always @(clk)
        clk <= #5 ~clk;

    reg start;
    integer i, j, err = 0;
  
    reg signed [33:0] c, d;
    reg signed [67:0] q;


    initial begin
        start = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;

        for(i=0; i<no_of_tests; i=i+1) begin

            c = {$random(), $random(), $random(), $random()};    
            d = {$random(), $random(), $random(), $random()};
            q = c * d;

            start = 1;
            @(posedge clk);
            #1;
            start = 0;

//          for(j=0; j<=nb; j=j+1)        // Non-Booth
            for(j=0; j<=22; j=j+1)    // Booth
                @(posedge clk);
				@(posedge clk);
            if (q === sut.s)
;//                $display("OK");
            else begin
                err = err + 1;
                if(err < 20) begin
                  $write("%x (%0d) * %x (%0d) = %x (%0d) ", c, c, d, d, sut.s, sut.s);
                   $display("ERROR: expected %x, got %x", q, sut.s);
               end
            end
        end
        if(err)
            $display("\n\tOops, %0d (%%%0d) errors are found.\n", err, (err*100+no_of_tests)/(2*no_of_tests));
        else
            $display("\n\tGREAT, no errors found.\n");

        $stop;
    end


   signed_multiplier sut (       
        .clk(clk),
        .start(start),
        .a(c),
        .b(d),
        .s()
    );

endmodule
