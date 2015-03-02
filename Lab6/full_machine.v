// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clk, reset);
    output      except;
    input       clk, reset;

  
    wire [31:0] inst;  
    wire [31:0] PC;  
    wire zero, negative;
    wire [31:0] nextPC, branchOffset, PCADD, branchADD, jump;
    wire [31:0] rsData, rtData, rdData,data_Mux, luiI, mem_read, slt_read,neg, data_out, byte_read,zeros,out, B;
    //wire [15:0] imm16;
    wire [31:0] imm32, out2, out3, lui_out, addm_out, addr;
    wire [1:0] control_type;
    wire [2:0] alu_op;
    wire [4:0] Rdest;
    wire [5:0] opcode, funct;
    wire writeenable, memRead, byte_we,word_we,byte_load,slt,lui, rd_src, alu_src2, addm;
    // DO NOT comment out or rename this module
    // or the test bench will break



    register #(32) PC_reg(PC, nextPC, clk,1'b1,reset /* connect signals */);
    
    alu32 add4(PCADD, , , , PC, 32'h4, 3'b010); //pc add 4 instruction
    alu32 offset(branchADD, , , ,PCADD, branchOffset, 3'b010);
    assign jump[31:28] = PC[31:28];
    assign jump[27:2] = inst[25:0]; 
    assign jump[0] = 0;
    assign jump[1] = 0;
    assign luiI[31:16] = inst[15:0];
    assign luiI[15:0] = zeros[15:0];
    assign opcode[5:0] = inst[31:26];
    assign funct[5:0] = inst[5:0];
    assign neg[0] = negative;
    assign neg[31:1] = zeros[31:1];
    assign data_Mux[31:8] = zeros[31:8];




    mux2v #(32) Mux1r(lui_out, mem_read, luiI, lui);
    mux2v #(32) Mux2b(byte_read, data_out, data_Mux, byte_load);
    mux4v #(8) Mux4d(data_Mux[7:0], data_out[7:0], data_out[15:8], data_out[23:16],data_out[31:24], out[1:0]);
    mux2v #(32) Mux2m(mem_read, slt_read, byte_read,memRead);
    mux2v #(32) Mux2s(slt_read,out,neg,slt);
    mux4v #(32) selectPC(nextPC, PCADD, branchADD, jump, rsData, control_type);

    mips_decode decoder1(alu_op,writeenable, rd_src, alu_src2, except, control_type, memRead,word_we,byte_we, byte_load, lui, slt, addm, opcode, funct, zero);
    
    
    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rsData,rtData, inst[25:21], inst[20:16], Rdest, rdData, writeenable, clk, reset /* connect signal wires */);
   
    data_mem memD(data_out, addr, rtData, word_we, byte_we, clk, reset);
    instruction_memory inMem(inst, PC[31:2]);
    //assign imm16 = inst[15:0];
    assign imm32[31:16] = zeros[31:16];
    assign imm32[15:0] = inst[15:0];
 
    shift_leftBy2 shift(branchOffset, imm32[29:0]);
    mux2v #(5) a1(Rdest, inst[15:11], inst[20:16], rd_src);
    mux2v #(32) a2(B, rtData, imm32, alu_src2);
 
    mux2v #(32) a3(addr, out, rsData, addm);
    mux2v #(32) alu3(rdData, lui_out, addm_out, addm);    
    
    alu32 #(32) alu2(addm_out, , , ,data_out,rtData, 3'b010); 
    alu32 #(32) alu1(out,  , zero,negative, rsData, B, alu_op);
    //alu32 #(32) alu1(out,  , zero,negative, rsData, B, alu_op);

assign zeros[0] = 0; 
assign zeros[1] = 0;
assign zeros[2] = 0; 
assign zeros[3] = 0; 
assign zeros[4] = 0; 
assign zeros[5] = 0; 
assign zeros[6] = 0; 
assign zeros[7] = 0; 
assign zeros[8] = 0; 
assign zeros[9] = 0; 
assign zeros[10] = 0; 
assign zeros[11] = 0; 
assign zeros[12] = 0; 
assign zeros[13] = 0; 
assign zeros[14] = 0; 
assign zeros[15] = 0; 
assign zeros[16] = 0; 
assign zeros[17] = 0; 
assign zeros[18] = 0; 
assign zeros[19] = 0; 
assign zeros[20] = 0; 
assign zeros[21] = 0; 
assign zeros[22] = 0; 
assign zeros[23] = 0; 
assign zeros[24] = 0; 
assign zeros[25] = 0; 
assign zeros[26] = 0; 
assign zeros[27] = 0; 
assign zeros[28] = 0; 
assign zeros[29] = 0; 
assign zeros[30] = 0; 
assign zeros[31] = 0; 

	
    /* add other modules */

endmodule // full_machine



module shift_leftBy2(out, in);

	output [31:0] out;
       	input [29:0] in;
	assign out[31:2] = in[29:0];
        assign out[1] = 0;
        assign out[0] = 0;

endmodule
