## a code generator for the ALU chain in the 32-bit ALU
## see example_generator.cpp for inspiration
## 
## python generator.py
	
	width = 32
for i in range(2, width):
    print("alu1 a{0}(out[{0}],carryout[{0}], A[{0}], B[{0}], carryout[{1}], control);\n".format(i, i - 1)) 

