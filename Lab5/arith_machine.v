// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

/*
module signExtender{
input [15:0] imm16;
input clock;
output reg [31:0] imm32;
};

always@(posedge clock)
   begin
     extend <= $signed(unextended);
   end

endmodule
*/



module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] next_PC;
    wire [4:0] rsNum;
    wire [4:0] rtNum;
    wire [4:0] rdNum;
    wire [31:0] rdData;
    wire [31:0] rsData;
    wire [31:0] rtData;
    wire [29:0] addr;
    wire [4:0] Rdest;
    //wire [31:0] inst;
    wire rd_src;
    wire wr_enable;
    wire [2:0]alu_op;
    wire alu_src2;
    wire [15:0] imm16;
    wire [31:0]imm32;
    //wire A [31:0];
    wire [31:0]B;
    wire [5:0]opcode;
    wire [5:0]funct;




    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, next_PC, clock, 1, reset /* connect signals */);
    alu32 PC_reg2(next_PC, , , ,PC, 32'h4, `ALU_ADD);
    assign addr = PC[31:2];
    assign rsNum = inst[25:21];
    assign rtNum = inst[20:16];
    assign rdNum  = inst[15:11];
    assign imm16 = inst[15:0];
    assign opcode = inst[31:26];
    assign funct = inst[5:0];
    

    instruction_memory im(inst, addr);

    mux2v #(5) mout(Rdest,rdNum,rtNum,rd_src);
   
    	
    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( rsData, rtData, rsNum, rtNum, Rdest, rdData, wr_enable, clock, reset/* connect signal wires */);

    mips_decode mout1(alu_op, wr_enable, rd_src, alu_src2, except, opcode, funct);

    assign imm32 = {{16{imm16[15]}}, imm16};

    mux2v mout2(B,rtData,imm32,alu_src2);

    alu32 aOut(rdData, , , ,rsData, B, alu_op);


    /* add other modules */
   
endmodule // arith_machine
