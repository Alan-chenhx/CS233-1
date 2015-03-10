module test;

   // these are inputs to "circuit under test"
   reg       daytime;
   reg       weekday;
   reg       holiday;
  // wires for the outputs of "circuit under test"
   wire [1:0] color;
  // the circuit under test
   bus b(color, daytime, weekday, holiday);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      daytime = 0; weekday = 0; holiday = 0; #10;
      daytime = 0; weekday = 0; holiday = 1; #10;
      daytime = 0; weekday = 1; holiday = 0; #10;
      daytime = 0; weekday = 1; holiday = 1; #10;
      daytime = 1; weekday = 0; holiday = 0; #10;
      daytime = 1; weekday = 0; holiday = 1; #10;
      daytime = 1; weekday = 1; holiday = 0; #10;
      daytime = 1; weekday = 1; holiday = 1; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = daytime, weekday, holiday  outputs = color");
     $monitor("inputs = %b  %b  %b  outputs = %d   time = %2t",
              daytime, weekday, holiday, color, $time);
   end
endmodule // test
