// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;
 
    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;
 
    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;
    
    decoder2 d1(w_enable[1:0],in[1],enable);
    decoder2 d2(out[1:0],in[0],w_enable[0]);
    decoder2 d3(out[3:2],in[0],w_enable[1]);
    
    //decoder2 b2(out[3:2],in[1],enable);


 
    // implement using decoder2's
    
endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [1:0]    w_enable;

    decoder2 e1(w_enable[1:0],in[2],enable);
    decoder4 e2(out[3:0],in[1:0],w_enable[0]);
    decoder4 e3(out[7:4],in[1:0],w_enable[1]);
 
    // implement using decoder2's and decoder4's
 
endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [1:0]    w_enable;

    decoder2 f1(w_enable[1:0],in[3],enable);
    decoder8 f2(out[7:0],in[2:0],w_enable[0]);
    decoder8 f3(out[15:8],in[2:0],w_enable[1]);

    // implement using decoder2's and decoder8's
 
endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [1:0]    w_enable;

    decoder2 g1(w_enable[1:0],in[4],enable);
    decoder16 g2(out[15:0],in[3:0],w_enable[0]);
    decoder16 g3(out[31:16],in[3:0],w_enable[1]);
 
    // implement using decoder2's and decoder16's
 
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
             wr_regnum, wr_data, writeenable, 
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;

    wire    [31:0]data;
    wire    [31:0]muxData [0:31];
	
	
    decoder32 r1(data, wr_regnum, writeenable);

assign muxData[0] =0;


register q1(muxData[1], wr_data, clock, data[1], reset);
register q2(muxData[2], wr_data, clock, data[2], reset);
register q3(muxData[3], wr_data, clock, data[3], reset);
register q4(muxData[4], wr_data, clock, data[4], reset);
register q5(muxData[5], wr_data, clock, data[5], reset);
register q6(muxData[6], wr_data, clock, data[6], reset);
register q7(muxData[7], wr_data, clock, data[7], reset);
register q8(muxData[8], wr_data, clock, data[8], reset);
register q9(muxData[9], wr_data, clock, data[9], reset);
register q10(muxData[10], wr_data, clock, data[10], reset);
register q11(muxData[11], wr_data, clock, data[11], reset);
register q12(muxData[12], wr_data, clock, data[12], reset);
register q13(muxData[13], wr_data, clock, data[13], reset);
register q14(muxData[14], wr_data, clock, data[14], reset);
register q15(muxData[15], wr_data, clock, data[15], reset);
register q16(muxData[16], wr_data, clock, data[16], reset);
register q17(muxData[17], wr_data, clock, data[17], reset);
register q18(muxData[18], wr_data, clock, data[18], reset);
register q19(muxData[19], wr_data, clock, data[19], reset);
register q20(muxData[20], wr_data, clock, data[20], reset);
register q21(muxData[21], wr_data, clock, data[21], reset);
register q22(muxData[22], wr_data, clock, data[22], reset);
register q23(muxData[23], wr_data, clock, data[23], reset);
register q24(muxData[24], wr_data, clock, data[24], reset);
register q25(muxData[25], wr_data, clock, data[25], reset);
register q26(muxData[26], wr_data, clock, data[26], reset);
register q27(muxData[27], wr_data, clock, data[27], reset);
register q28(muxData[28], wr_data, clock, data[28], reset);
register q29(muxData[29], wr_data, clock, data[29], reset);
register q30(muxData[30], wr_data, clock, data[30], reset);
register q31(muxData[31], wr_data, clock, data[31], reset);

	

    mux32v m1(rd1_data, muxData[0],muxData[1],muxData[2],muxData[3],muxData[4],muxData[5],muxData[6],muxData[7],muxData[8],muxData[9],muxData[10],muxData[11],muxData[12],muxData[13],muxData[14],muxData[15],muxData[16],muxData[17],muxData[18],muxData[19],muxData[20],muxData[21],muxData[22],muxData[23],muxData[24],muxData[25],muxData[26],muxData[27],muxData[28],muxData[29],muxData[30],muxData[31], rd1_regnum);

    mux32v m2(rd2_data, muxData[0],muxData[1],muxData[2],muxData[3],muxData[4],muxData[5],muxData[6],muxData[7],muxData[8],muxData[9],muxData[10],muxData[11],muxData[12],muxData[13],muxData[14],muxData[15],muxData[16],muxData[17],muxData[18],muxData[19],muxData[20],muxData[21],muxData[22],muxData[23],muxData[24],muxData[25],muxData[26],muxData[27],muxData[28],muxData[29],muxData[30],muxData[31], rd2_regnum);
 
    // build a register file!
    
endmodule // mips_regfile

