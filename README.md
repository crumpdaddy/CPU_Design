# CPU Design
This is a 16-bit RISC CPU created in Verilog. It currently uses a multi-cycle datapath with 16 registers
It features these operations:
Halt
Bitwise AND, OR
Arithmetic add, subtract, add constant, compare
Copy value to register
Copy constant to register
Load to register
Store in memory
Push to stack
Pop from Stack
Jump if: less, greater than, equal
Unconditional branch

There is also an included assembler.
The assembler uses opcodes found in the desing_exp.xlsx

# Tips for using assembler:

Registers are accessed by putting '$Rx' with x being the register number 1-16
For example
PUSH $R1

This pushes register 1 onto the stack

To lables are defined by putting ':' before the label name.
For example
:label PUSH $R1

You can jump to a label by adding a '*labelName' to the jump instruction
FOr example
JUMP *label

This will jump to the addesss at 'label'

Comments are also supported using '#' to denote the start of a comment.
It is to be noted that everything after '#' will be considered a comment
Comments that take up an entire line are not supported at this time, please add comments after instructions only.

You can specify an init.txt file. This file will initilize values into the memory.
Using comments that occupy an entire line will mess up the memory initilization.

The assembler will output 'output.txt' put this file in the same directory as the Verilog files to have the program loaded into memory.
