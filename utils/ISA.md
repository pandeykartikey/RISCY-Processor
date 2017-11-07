# ISA

OPCODES | Opcode-Repr | Description
------- | ----------  | -----------
ADD     | 000000      | Add content of two register and store it in third register
SUB     | 000000      | Subract the contents of second register from first register and store it in third register
MUL     | 000000      | Multiply the content of two register and store it in third register
AND     | 000000      | Bitwise AND two register and strore in third register.
OR      | 000000      | Bitwise OR two 32-bit register and store in third register.
XOR     | 000000      | Bitwise XOR the contents of two register and store in third.
SLL     | 000000      | Shift the register content bitwise left logically by a given amount and store in a register.
SRL     | 000000      | Shift register content bitwise right logically by a given amount and store in a register.
ADDI    | 010000      | Add the contents of register with an immediate constant value and store in a register.
ANDI    | 010001      | Bitwise logically **and** the content of a register with a constant immediate.
XORI    | 010010      | Bitwise logically **xor** the content of a register with a constant immediate.
BEQ     | 010011      | Update the Program counter to branch address relative to PC when the register content are equal.
LW      | 010100      | Load a word from memory location specified in the instruction into a register.
SW      | 010101      | Store the contents of a register into data memory at the location specified in the instruciton.
SLT     | 010110      | Set the contents of a register to zero comparing the other two register(Set to zero if first is less than second register).
SLTI    | 010111      | Set the contents of a register to zero if content of other register is less than the immediate value specified in the instruction.
JMP     | 110000      | Jump to address specified in the instruction(Update program counter to the specified address).
