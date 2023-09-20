package main

OPCODES :: enum {
    // any function that does operations on 2 registers WILL push the result to the stack

    MOVEHEAP, // move value to heap address                                             val -> [addr]
    MOVEREG, // move value to register                                                  [val] -> reg
    PUSH, // push value to stack                                                        val -> stack[sp++]
    PUSHREG, // push a register to the stack                                            reg -> stack[sp++]
    POP, // pop a value off of the stack into a register                                stack[--sp] -> reg
    PPUSH, // push value to preserved stack                                             val -> p_stack[psp++]
    PPUSHREG, // push a register to the preserved stack                                 reg -> p_stack[psp++]
    PPOP, // pop top of preserved stack to a register                                   p_stack[--psp] -> reg
    MOVEHEAPTOREG, // move a value from the heap to a register                          [addr] -> reg
    MOVEREGTOHEAP, // move a value from a register to a heap address                    reg -> [addr]
    MOVEREGTOREG, // move a value from register to register                             reg1 -> reg2
    MOVEHEAPTOHEAP, // move a value from a heap address to another heap address         [addr1] -> [addr2]
    RET, // return from function to the top function object on the fpstack              fpstack[--fpsp].ret_addr -> ip
    ADD, // add 2 registers                                                             reg1 + reg2 -> stack[sp++]
    SUB, // subtract 2 registers                                                        reg1 - reg2 -> stack[sp++]
    MUL, // multiply 2 registers                                                        reg1 * reg2 -> stack[sp++]
    DIV, // divide 2 registers                                                          reg1 / reg2 -> stack[sp++]
    FDIV, // divide 2 floats in 2 registers                                             (f64)reg1 / (f64)reg2 -> (u64)stack[sp++]
    INC, // increment register                                                          reg++
    DEC, // decrement register                                                          reg--
    BITWISE_OR, // btiwise or between 2 registers                                       reg1 | reg2 -> stack[sp++]
    BITWISE_AND, // btiwise and between 2 registers                                     reg1 & reg2 -> stack[sp++]
    BITWISE_XOR, // btiwise xor between 2 registers                                     reg1 ~ reg2 -> stack[sp++]
    BITWISE_NOT, // btiwise not on a register                                           !reg -> stack[sp++]
    // all logical ops return 0 or 1
    LOGICAL_OR, // logical or between 2 registers                                       reg1 || reg2 -> stack[sp++]
    LOGICAL_AND, // logical and between 2 registers                                     reg1 && reg2 -> stack[sp++]
    LOGICAL_NOT, // logical not on a register                                           !reg1 -> stack[sp++]
    EQ, // check for equality between 2 registers                                       reg1 == reg2 -> stack[sp++]
    NEQ, // check for inequality between 2 registers                                    reg1 != reg2 -> stack[sp++]
    GT, // check if a register is greater than another                                  reg1 > reg2 -> stack[sp++]
    LT, // check if a register is less than another                                     reg1 != reg2 -> stack[sp++]
    GTEQ, // check if a register is greater than or euqal to another                    reg1 >= reg2 -> stack[sp++]
    LTEQ, // check if a register is less than or equal to another                       reg1 <= reg2 -> stack[sp++]
    CALL, // call a function and push the function object to the stack                  (ip, addr) -> fpstack[fpsp++]; ip -> addr; calling = true
    FUNC, // start of a function                                                        if calling == true: calling = false; continue else ip -> fpstack[--fpsp].ret_addr
    NATIVE, // call native function                                                     ip -> natives[stack[--sp]](stack[--sp], ...)
    JMPEQ, // jump if top of stack is 1                                                 if stack[--sp] == 1: ip -> stack[sp]
    JMPNEQ, // jump if top of stack is not euqal to 1                                   if stack[--sp] != 1: ip -> stack[sp]
    JMP, // jump to address unconditional                                               ip -> stack[--sp]
    NOOP, // print register
}

// FUNCTION CALLING CONVENTION
/*

// NOTE: WHEN YOU CALL A FUNCTION A NEW SCOPE IS CREATED
// There is a special stack for functions called a p stack, it is preserved when calling and returning from a function

MOVEREG 0xF, 0x1 // move 0xf to register 1
PPUSH 0x01 // push 0x1 to the preserved stack
PUSH 0x0F // push 0xf to the regular scoped stack
CALL func

func:
    DBG 0x1 // error accessing non-existant register
    PPOP 0x1 // pop off preserved stack into register 0x1
    DBG 0x1 // prints out 0x1 because thats whats on the top of the preserved stack
    POP 0x1 // stack underflow because in this scope the stack is empty
*/