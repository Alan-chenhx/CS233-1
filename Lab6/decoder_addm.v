// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;
    wire add0_inst, addi_inst, sub0_inst, and0_inst, andi_inst, or0_inst, ori_inst, nor0_inst, xor0_inst, xori_inst, bnei_inst,beqi_inst, ji_inst, jr0_inst, lui_inst, slt0_inst, lwi_inst, lbui_inst, swi_inst, sbi_inst, addm_inst;
    wire non_except;
    
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
    assign bnei_inst = (opcode ==`OP_BNE);
    assign beqi_inst = (opcode ==`OP_BEQ);
    assign ji_inst = (opcode ==`OP_J);
    assign jr0_inst = (opcode ==`OP_OTHER0) & (funct ==`OP0_JR);
    assign lui_inst = (opcode ==`OP_LUI);
    assign slt0_inst = (opcode ==`OP_OTHER0) & (funct ==`OP0_SLT);
    assign lwi_inst = (opcode ==`OP_LW);
    assign lbui_inst = (opcode ==`OP_LBU);
    assign swi_inst = (opcode ==`OP_SW);
    assign sbi_inst = (opcode ==`OP_SB);
    assign addm_inst = (opcode ==`OP_OTHER0) & (funct ==`OP0_ADDM);



    assign alu_op[0] = sub0_inst | or0_inst | xor0_inst | ori_inst | xori_inst | beqi_inst | bnei_inst | slt0_inst;
    assign alu_op[1] = add0_inst | sub0_inst | nor0_inst | xor0_inst | addi_inst | xori_inst | beqi_inst | bnei_inst | slt0_inst | lwi_inst | lbui_inst | swi_inst | sbi_inst | addm_inst;
    assign alu_op[2] = and0_inst | or0_inst | nor0_inst | xor0_inst | ori_inst | xori_inst |andi_inst; 

    assign control_type[0] = (beqi_inst & zero) | (bnei_inst & zero) | jr0_inst;
    assign control_type[1] = ji_inst | jr0_inst;

    assign mem_read = lwi_inst | lbui_inst | addm_inst;

    assign word_we = swi_inst;
    assign byte_we = sbi_inst;

    assign byte_load = lbui_inst;
    assign lui = lui_inst;
    assign slt = slt0_inst;
    

    assign alu_src2 = ~(opcode == `OP_OTHER0 | bnei_inst | beqi_inst);

    assign rd_src =  ~(opcode == `OP_OTHER0 | bnei_inst | beqi_inst);


    assign non_except = add0_inst | addi_inst | sub0_inst | and0_inst | andi_inst | or0_inst | ori_inst | nor0_inst | xor0_inst | xori_inst | lui_inst | slt0_inst | lwi_inst | lbui_inst | beqi_inst | bnei_inst | ji_inst | jr0_inst | swi_inst | sbi_inst | addm_inst;

    assign writeenable = add0_inst | addi_inst | sub0_inst | and0_inst | andi_inst | or0_inst | ori_inst | nor0_inst | xor0_inst | xori_inst | lui_inst | slt0_inst | lwi_inst | lbui_inst | addm_inst; 

    assign except = ~non_except;

endmodule // mips_decode
