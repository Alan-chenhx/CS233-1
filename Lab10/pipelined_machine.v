module pipelined_machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0]  inst;
   
   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];
   wire [5:0]   opcode = inst[31:26];
   wire [5:0]   funct = inst[5:0];

   wire [4:0]   wr_regnum;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
   wire         PCSrc, zero;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;


   register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4, imm[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;
      
   instruction_memory imem (inst, PC[31:2]);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, 
                      opcode, funct);
   
   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data, 
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rd2_data, imm, ALUSrc);
   alu32 alu(alu_out_data, zero, ALUOp, rd1_data, B_data);
   
   data_mem data_memory(load_data, alu_out_data, rd2_data, MemRead, MemWrite, clk, reset);
   
   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);




   wire [5:0] opcode_EX;
   wire [5:0] funct_EX;
   wire [31:2] PC_plus4_EX;
   wire [31:0] rd1_data_EX;
   wire  [31:0] rd2_data_EX;
   wire  [31:0] imm_EX;
   wire  [4:0]  rt_EX;
   wire  [4:0] rd_EX;
   wire  [4:0] rs_EX;
   wire  [31:0] rs_select;
   wire  [31:0] rt_select;
   wire  [31:0] wr_data_EX;
   wire  [4:0] wr_regnum_EX;
   wire  enable_flush, forwardA, forwardB, RegWrite_EX;


   assign enable_flush = PCSrc || reset;


   register #(30) PC_plus4_pipeReg(PC_plus4_EX, PC_plus4, clk, 1'b1, enable_flush);
   register #(6) funct_hd_pipeReg(funct_EX, funct, clk, 1'b1, enable_flush);
   register #(6)  opcode_hd_pipeReg(opcode_EX, opcode, clk, 1'b1, enable_flush);
   register #(32) rd1_data_hd_pipeReg(rd1_data_EX, rd1_data, clk, 1'b1, enable_flush);
   register #(32) rd2_data_hd_pipeReg(rd2_data_EX, rd2_data, clk, 1'b1, enable_flush);
   register  #(32) immediate_hd_pipeReg(imm_EX, imm, clk, 1'b1, enable_flush);
   register #(5)  rt_hd_pipeReg(rt_EX, rt, clk, 1'b1, enable_flush);
   register #(5)  rd_hd_pipe_Reg(rd_EX, rd, clk, 1'b1, enable_flush);
   register #(5)  rs_hd_pipe_Reg(rs_EX, rs, clk, 1'b1, enable_flush);

   mux2v #(32)  mux_forwardA(rs_select, rd1_data_EX, wr_data_EX, forwardA);
   mux2v #(32)  mux_forwardB(rt_select, rd2_data_EX, wr_data_EX, forwardB);

   assign forwardA = (rs_EX == wr_regnum_EX) && RegWrite_EX;
   assign forwardB = (rt_EX == wr_regnum_EX) && RegWrite_EX;

   register #(32) wr_data_fd(wr_data_EX, wr_data, clk, 1'b1, reset);
   register #(5)  wr_regnum_hd_fd(wr_regnum_EX, wr_regnum, clk, 1'b1, reset);
   register #(1)  wr_enable_fd(RegWrite_EX, RegWrite, clk, 1'b1, reset);
   
endmodule // pipelined_machine
