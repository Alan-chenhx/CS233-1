module lol_reader_test;
 
    reg restart = 1;
    reg [2:0] bits = 3'b0;
    reg clk = 0;
    always #5 clk = !clk;
    
    initial begin
 
        $dumpfile("lol_reader.vcd");  
        $dumpvars(0, lol_reader_test);
       
        # 12
          restart = 0;
        # 20
          bits = 3'b111; // start of L
        # 10
          bits = 3'b001;
        # 10
          bits = 3'b000; // L should be recognized after this

        # 10
	restart =1;
	# 12
	restart =0;
	# 20
	bits =3'b000;
	#10
	bits =3'b111;
	#10
	bits =3'b101;
	#10
	bits =3'b111;
	#10
	bits =3'b000;  //O should be recognized after this

	
	# 20
	restart =1;
	# 12
	restart =0;
	# 20
	bits =3'b000;
	#10
	bits =3'b100;
	#10
	bits =3'b011;
	#10
	bits =3'b100;
	#10
	bits =3'b000;  //Y should be recognized after this 
	
	#40
          $finish;              // end the simulation
    end                      
    
    wire L, O, Y;
    lol_reader lolr(L, O, Y, bits, clk, restart);
 
    initial
      $monitor("At time %t, bits = %b L = %d O = %d Y = %d restart = %x",
               $time, bits, L, O, Y, restart);
endmodule // keypad_test
