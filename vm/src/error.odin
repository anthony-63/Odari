package main

import "core:fmt"
import "core:os"
ERROR_TYPE :: enum {
    INVALID_OPCODE,
    STACK_UNDERFLOW,
    INVALID_REGISTER,
    INVALID_MEMORY_ADDRESS,
    NONE,
    NOT_IMPLEMENTED,
}

Error :: struct {
    type: ERROR_TYPE,
    message: string,
}