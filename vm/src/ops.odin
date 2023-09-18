package main

OPCODES :: enum {
    // any function that does operations on 2 registers WILL push the result to the stack

    MOVEHEAP, // move value to heap address                                             val -> [addr]
    MOVEREG, // move value to register                                                  [val] -> reg
    PUSH, // push value to stack                                                        val -> stack[sp++]
    PUSHREG, // push a register to the stack                                            reg -> stack[sp++]
    POP, // pop a value off of the stack into a register                                stack[--sp] -> reg
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
    CALL, // call a function and push the function object to the stack                  (ip, stack[--sp]) -> fpstack[fpsp++]; ip -> stack[--sp]; calling = true
    FUNC, // start of a function                                                        if calling == true: calling = false; continue else ip -> fpstack[--fpsp].ret_addr
    NATIVE, // call native function                                                     ip -> natives[stack[--sp]](stack[--sp], ...)
    JMPEQ, // jump if top of stack is 1                                                 if stack[--sp] == 1: ip -> stack[sp]
    JMPNEQ, // jump if top of stack is not euqal to 1                                   if stack[--sp] != 1: ip -> stack[sp]
    JMP, // jump to address unconditional                                               ip -> stack[--sp]
    DBG, // print register
}