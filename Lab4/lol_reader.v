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


module lol_reader(L, O, Y, bits, clk, restart);
    output      L, O, Y;
    input [2:0] bits;
    input       restart, clk;
    wire        sBlank, sBlank_next, sL, ssL_next,
		sL_second, sL_second_next, sL_end, sL_end_next,
		sGarbage, sGarbage_next, sBlank2, sBlank2_next, sO, sO_next,
		sO_second, sO_second_next, sO_third, sO_third_next, sO_end, sO_end_next,
		sGarbage2, sGarbage2_next,sBlank3, sBlank3_next, sY, sY_next,
		sY_second, sY_second_next, sY_third, sY_third_next, sY_end, sY_end_next,
		sGarbage3, sGarbage3_next;

//L detecter
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
  // end of L


//start with O

	//assign in000 = bits ==3'b000;
	//assign in111 = bits ==3'b111;
	assign in101 = bits ==3'b101;

	assign sBlank2_next = ~restart &((sBlank2 | sO_end | sO_second | sGarbage2| sO) & in000);
	assign sO_next = ~restart &((sO_end | sBlank2) & in111);
	assign sO_second_next = ~restart & ((sO & in101));
	assign sO_third_next = ~restart & ((sO_second & in111));
	assign sO_end_next = ~restart &((sO_third & in000));
	assign sGarbage2_next = restart | ((sBlank2 | sO_second | sO_end)& ~(in000|in111) | (sGarbage2 | sO_third) & ~(in000) | (sO & ~(in000|in101)));
	
	 
	dffe fsBlank2(sBlank2, sBlank2_next, clk, 1'b1, 1'b0);
	dffe fsGarbage2(sGarbage2, sGarbage2_next, clk, 1'b1, 1'b0);
	dffe fsO1(sO, sO_next, clk, 1'b1, 1'b0);
	dffe fsO2(sO_second, sO_second_next, clk, 1'b1, 1'b0);
	dffe fsO3(sO_third, sO_third_next, clk, 1'b1, 1'b0);
	dffe fsO_end(sO_end, sO_end_next, clk, 1'b1, 1'b0);

	assign O = sO_end;
//end of O

//start with Y

	assign in100 = bits ==3'b100;

	assign in011 = bits ==3'b011;

	assign sBlank3_next = ~restart &((sBlank3 | sY_end | sY_second | sGarbage3| sY) & in000);
	assign sY_next = ~restart &((sY_end | sBlank3) & in100);
	assign sY_second_next = ~restart & ((sY & in011));
	assign sY_third_next = ~restart & ((sY_second & in100));
	assign sY_end_next = ~restart &((sY_third & in000));
	assign sGarbage3_next = restart | ((sBlank3 | sY_second | sY_end)& ~(in000|in100) | (sGarbage3 | sY_third) & ~(in000) | (sY & ~(in000|in011)));
	
	 
	dffe fsBlank3(sBlank3, sBlank3_next, clk, 1'b1, 1'b0);
	dffe fsGarbage3(sGarbage3, sGarbage3_next, clk, 1'b1, 1'b0);
	dffe fsY1(sY, sY_next, clk, 1'b1, 1'b0);
	dffe fsY2(sY_second, sY_second_next, clk, 1'b1, 1'b0);
	dffe fsY3(sY_third, sY_third_next, clk, 1'b1, 1'b0);
	dffe fsY_end(sY_end, sY_end_next, clk, 1'b1, 1'b0);

	assign Y = sY_end;
	



        
   // dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    
endmodule // lol_reader
