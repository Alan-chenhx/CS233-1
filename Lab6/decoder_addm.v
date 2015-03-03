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

    wire add =  (opcode==`OP_OTHER0 & funct==`OP0_ADD);
    wire sub =  (opcode==`OP_OTHER0  & funct==`OP0_SUB);
    wire andd = (opcode==`OP_OTHER0 & funct==`OP0_AND);
    wire ord =  (opcode==`OP_OTHER0  & funct==`OP0_OR);
    wire nord = (opcode==`OP_OTHER0 & funct==`OP0_NOR);
    wire xord = (opcode==`OP_OTHER0 & funct==`OP0_XOR);
    
    wire addi=(opcode==`OP_ADDI);
    wire andi=(opcode==`OP_ANDI);
    wire ori=(opcode==`OP_ORI);
    wire xori=(opcode==`OP_XORI);

     
    wire beq = (opcode == `OP_BEQ);
    wire bne = (opcode == `OP_BNE);
    wire j = (opcode ==  `OP_J);   
    wire jr = (opcode == `OP_OTHER0 & funct == `OP0_JR);  
    wire lw =  (opcode == `OP_LW);
    wire lbu = (opcode == `OP_LBU); 
    wire sw = (opcode == `OP_SW);
    wire sb = (opcode == `OP_SB);
 
    assign  addm = (opcode ==`OP_OTHER0& funct == `OP0_ADDM);
    assign alu_op[2]=andd|andi|ord|ori|nord|xord|xori;
    assign alu_op[1]=add|addi|sub|nord|xord|xori|slt|lw|lbu|sw|sb|bne|beq|addm;
    assign alu_op[0]=sub|ord|ori|xord|xori|slt|bne|beq;
    assign rd_src=addi|andi|ori|xori|lui|lw|lbu;
    assign alu_src2= addi|andi|ori|xori|lw|lbu|sw|sb;

    assign writeenable = add|sub|andd|ord|xord|nord|addi|andi|ori|xori|lw|lbu |lui| slt|addm;
    assign except=~(add|sub|andd|ord|xord|nord|addi|andi|ori|xori| lui|slt|bne|beq||j|jr|lw|sw|lbu|sb|addm); // need to update
     //assign writeenable = ~except;
    assign lui = opcode == `OP_LUI;
    assign slt = opcode ==`OP_OTHER0 & funct == `OP0_SLT;
 
  

    assign control_type[0] = (bne & ~zero) | (beq & zero) | jr;
    assign control_type[1] = j | jr;
 
    assign mem_read = lw | lbu; //load from memory to register
    assign word_we =  sw; // transfer word from register to memory;
    assign byte_we =  sb;
    assign byte_load = lbu;
 

endmodule // mips_decode


