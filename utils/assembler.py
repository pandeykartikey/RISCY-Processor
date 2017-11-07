#!/usr/bin/python

"""
A simple python script to convert the desired MIPS code to binary to be run for the implementation
The Syntax for writing the program is as follows:

1. Comments
    For now only single line comments have been implemented, comment using (//)
2. Registers
    To select a register use $r[register_no] as $r13
3. Syntax for statement
    Each statement must be terminated using semicolon(;)
    Arguments to an opcode must be comma seperated
    Eg. ADD $r1, $r2, $r3
    The syntax follow Intel assembly implementation that is
    OPCODE [Destination] [Source1] [Source2]
"""

import sys
import re
import argparse
import os

"""
RTYPE_FUNCTION_FIELD maps opcodes for an R-Type instruction to function fields
OPCODE_MAPPING maps opcodes to their binary values
"""

RTYPE_FUNCTION_FIELD = {
    "ADD" : '000000',
    "SUB" : '000001',
    "MUL" : '000010',
    "AND" : '000100',
    "OR"  : '000101',
    "XOR" : '000110',
    "SLL" : '001000',
    "SRL" : '001001',
}

OPCODE_MAPPING = {
    "ADDI": '010000',
    "ANDI": '010001',
    "XORI": '010010',
    "BEQ" : '010011',
    "LW"  : '010100',
    "SW"  : '010101',
    "SLT" : '010110',
    "SLTI": '010111'
}

labelTable = {}

def enum(**enums):
    return type('Enum', (), enums)

# Defines error_codes
Errors = enum(INVALID_OPCODE=0, INVALID_SYNTAX=1)

def handleError(error_code, instruction):
    if (error_code == Errors.INVALID_OPCODE):
        print "[-] Invalid OPCODE : " + str(instruction)
    elif (error_code == Errors.INVALID_SYNTAX):
        print "[-] Invalid Instruction syntax: " + str(instruction)
    raise SystemExit()

def stripComments(content):
    """
    Removes comments from program content 
    Syntax assumes that the comments start with // and only single line commenting exists
    removes everything after // character until a new-line character is found
    """
    return re.sub(r'//[^\n]*', '', content)

def stripContent(content):
    """
    Removes unnecessery newline characters and spaces from the content provided
    Syntax of writing assumes that each instruction ends with a ;(semicolon)
    """
    
    uncommentedContent = stripComments(content)
    return re.sub(r'[ \t]+', ' ', re.sub(r'\n', '', uncommentedContent))

def getLabelOffset(label, addr):
    return labelTable[label] - int(addr)

def addToLabelTable(instructionArr):
    currAddr = 0
    for instruction in instructionArr:
        if instruction[0] == ":":
            labelTable[instruction[1:]] = currAddr
        currAddr += 1

def getIntegerValue(value):
    if value[0:2] == "0x":
        return int(value[2:], 16)
    else:
        return int(value)


def convertInstruction(instruction, addr):
    """
    Instruction in MIPS implementation can be catagorized into three catagories
    1. R-Type instruction : OPCODE Rd, Rs, Rt 
    2. I-Type instruction : OPCODE Rd, Rs, [16-bit value]
    A register in instruction starts with $ as in ADD $r1 $r2 $r3
    """

    compArr = re.split(r', |,| ', instruction)
    instructionOpcode = compArr[0].upper()
    regUsedNo = instruction.count('$')

    if len(compArr) == 4 and regUsedNo == 3:
        # Instruction is an R-type instruction
        if instructionOpcode in RTYPE_FUNCTION_FIELD:
            opcode = '0'*6
            shiftAmt = '0'*5
            fnField = RTYPE_FUNCTION_FIELD[instructionOpcode]
            r1 = '{0:05b}'.format(int(compArr[1][2:])) # Rd
            r2 = '{0:05b}'.format(int(compArr[2][2:])) # Rt
            r3 = '{0:05b}'.format(int(compArr[3][2:])) # Rs
            return opcode + r3 + r2 + r1 + shiftAmt + fnField
        else:
            handleError(0, instruction)

    elif len(compArr) == 4 and regUsedNo == 2:
        # Instrution is an I-Type instruction
        if instructionOpcode in OPCODE_MAPPING:
            r1 = '{0:05b}'.format(int(compArr[1][2:])) # Rt
            r2 = '{0:05b}'.format(int(compArr[2][2:])) # Rs
            opcode = OPCODE_MAPPING[instructionOpcode]
            if instructionOpcode == "BEQ":
                # Third argument is a label
                branchOffset = '{0:016b}'.format(getLabelOffset(compArr[3], addr))
                return opcode + r1 + r2 + branchOffset
            else:
                # Third label is an immediate value
                imm = '{0:16b}'.format(getIntegerValue(compArr[3]))
                return opcode + r1 + r2 + imm
        else:
            handleError(0, instruction)
    else:
        handleError(1, instruction)

def writeAssembledCode(instrArr, filePath):
    newFilePath = filePath + '.bin'
    open(newFilePath, 'w').write('\n'.join(instrArr))  

def main(filePath):
    with open(filePath, "r") as program:
        content = program.read()
        strippedContent = stripContent(content)
        instructionArr = strippedContent.split(';')[:-1]
        currAddr = 0
        addToLabelTable(instructionArr)
        assembledInstr = []
        # Instruction array can conatin a label that begins with : used for branching
        # LabelTable is used to store these label and address corresponding to that
        for instruction in instructionArr:
            if instruction[0] != ':':
                bitStreamInstruction = convertInstruction(instruction, currAddr)
                print instruction, " : ", bitStreamInstruction
                assembledInstr.append(bitStreamInstruction)
            currAddr += 1
    writeAssembledCode(assembledInstr, filePath)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-f",
                        "--file",
                        help="Path of the file to be interpreted")
    args = parser.parse_args()
    filePath = ""
    try:
        os.stat(args.file)
        filePath = args.file
    except:
        try:
            filePath = os.path.join(os.getcwd(), args.file)
            os.stat(filePath)
        except:
            print "[-] The file path provided is not valid"
            raise SystemExit()
    main(filePath)
