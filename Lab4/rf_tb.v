module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;

    reg [4:0]    wr_regnum = 0, rd1_regnum = 0, rd2_regnum = 0;
    reg [31:0]   wr_data = 0;
    wire [31:0]  rd1_data, rd2_data;
    
    initial begin
        $dumpfile("rf.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the RF
	# 10  enable = 1;	
	# 10  wr_regnum = 1;
	# 10  rd1_regnum = 1;
 	# 10  rd2_regnum = 1;	
	# 10  wr_data = 32'hffffffff;
	# 10  wr_data = 32'h31240498;
	# 10  reset = 0;
	# 10  wr_data[0] = 32'h8888888;
	# 10  wr_data[1] = 32'h7878787;
	# 10  enable = 1;
	# 10  rd1_regnum[1] = 1;
	# 10  rd2_regnum[2] = 1;
	# 10  wr_data[0] = 32'h87654321;
	# 10  wr_data[1] = 32'h13145120;
	# 10  rd1_regnum[4] = 1;


        # 700 $finish;
    end
    
    initial begin
    end

    mips_regfile rf (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
                     wr_regnum, wr_data, enable, clk, reset);
   
endmodule // test
