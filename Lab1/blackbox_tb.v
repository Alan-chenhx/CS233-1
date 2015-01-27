module blackbox_test;
	reg g_in, v_in, y_in;
	wire j_out;

	blackbox black (j_out, g_in, v_in, y_in); 

	initial begin 

	 $dumpfile("blackbox.vcd");                  // name of dump file to create
        $dumpvars(0,blackbox_test);      
           // record all signals of module "sc_test" and sub-modules
                             
	g_in = 0; v_in = 0; y_in=0; # 10;             // set initial values and wait 10 time units
        g_in = 0; v_in = 0; y_in=1; # 10;             // change inputs and then wait 10 time units
        g_in = 0; v_in = 1; y_in=0; # 10;          // as above
  	g_in = 0; v_in = 1; y_in=1; # 10;  
	g_in = 1; v_in = 0; y_in=0; # 10;  
	g_in = 1; v_in = 0; y_in=1; # 10;  
	g_in = 1; v_in = 1; y_in=0; # 10;  
	g_in = 1; v_in = 1; y_in=1; # 10;  

	
        $finish;      
	end

	initial
        $monitor("At time %2t, g_in = %d v_in = %d y_in=%d j_out = %d",
                 $time, g_in, v_in, y_in, j_out);

endmodule // blackbox_test
