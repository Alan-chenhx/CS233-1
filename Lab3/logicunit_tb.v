module logicunit_test;

    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;

    reg [1:0] control = 0;


	initial begin
        $dumpfile("logicunit.vcd");
        $dumpvars(0, logicunit_test);


        # 8 control = 1; // wait 8 time units (why 16?) and then set it to 1
        # 8 control = 2; // wait 8 time units and then set it to 2

	end

	wire out;
    	logicunit l1(out, A, B, control);


    // exhaustively test your logic unit by adapting mux4_tb.v
endmodule // logicunit_test
