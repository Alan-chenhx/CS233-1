// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;
    wire add0_inst, addi_inst, sub0_inst, and0_inst, andi_inst, or0_inst, ori_inst, nor0_inst, xor0_inst, xori_inst;
    
    assign add0_inst = (opcode ==`OP_OTHER0) & (funct ==`OP0_ADD);
    assign addi_inst = (opcode == `OP_ADDI); //don't check funct here
    assign sub0_inst = (opcode == `OP_OTHER0) & (funct ==`OP0_SUB);
    assign and0_inst =  (opcode == `OP_OTHER0) & (funct ==`OP0_AND);
    assign andi_inst = (opcode == `OP_ANDI);
    assign or0_inst  = (opcode ==`OP_OTHER0) & (funct == `OP0_OR);
    assign ori_inst = (opcode ==`OP_ORI);
    assign nor0_inst = (opcode ==`OP_OTHER0) & (funct == `OP0_NOR);
    assign xor0_inst = (opcode ==`OP_OTHER0) & (funct == `OP0_XOR);
    assign xori_inst = (opcode ==`OP_XORI);
     

    assign alu_op[0] = sub0_inst | or0_inst | xor0_inst | ori_inst | xori_inst;
    assign alu_op[1] = add0_inst | sub0_inst | nor0_inst | xor0_inst | addi_inst | xori_inst;
    assign alu_op[2] = and0_inst | or0_inst | nor0_inst | xor0_inst | addi_inst | ori_inst | xori_inst; 
	
    assign rd_src = addi_inst | andi_inst | ori_inst | xori_inst;
 
    assign alu_src2 = addi_inst | andi_inst | ori_inst | xori_inst;
 
    assign writeenable = add0_inst | addi_inst | sub0_inst | and0_inst | andi_inst | or0_inst | ori_inst | nor0_inst | xor0_inst | xori_inst;

    assign except = ~writeenable;

endmodule // mips_decode
