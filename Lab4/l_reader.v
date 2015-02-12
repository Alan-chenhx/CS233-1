// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
    output q;
    reg    q;
    input  d;
    input  clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= 0;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;
endmodule // dffe


module l_reader(L, bits, clk, restart);
    output      L;
    input [2:0] bits;
    input       restart, clk;
    wire        sBlank, sBlank_next, sL, sL_next,
		sL_second, sL_second_next, sL_end, sL_end_next,
		sGarbage, sGarbage_next;

	assign in000 = bits == 3'b000;
	assign in111 = bits == 3'b111;
	assign in001 = bits == 3'b001;
	
	assign sBlank_next = ~restart & ((sBlank | sL_end | sGarbage| sL) & in000);
	assign sL_next     = ~restart & ((sL_end | sBlank)& in111);
	assign sL_second_next = ~restart & ((sL & in001) );
	assign sL_end_next  = ~restart & (sL_second & in000);
	assign sGarbage_next = restart | (((sBlank | sL_end)& ~(in000 | in111))| ((sGarbage | sL_second) & ~(in000)) | (sL & ~(in000|in001)));

	dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
	dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
	dffe fsL1(sL,sL_next,clk, 1'b1, 1'b0);
	dffe fsL2(sL_second,sL_second_next, clk, 1'b1, 1'b0);
	dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);   

	assign L = sL_end;  // | other condition ... 
        
   // dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    
endmodule // l_reader

