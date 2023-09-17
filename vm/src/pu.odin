package main

import "core:fmt"
import "core:os"

Odari_PU :: struct {
    memory: Odari_MEM,
    calling: bool,
    ip: int,
    printing: bool,
}

odari_execute_bytecode :: proc(pu: ^Odari_PU, bytecode: []u64) -> Maybe(Error) {
    debug_print("Loading bytecode")
    for b in bytecode {
        append(&pu.memory.exec, b)
    }

    verbose_print("Exec memory:", pu.memory.exec)

    debug_print("Starting execution...")
    for pu.ip < len(pu.memory.exec) {
        verbose_print("Executing: ", bytecode[pu.ip])
        OPCODE_CALL_TABLE[pu.memory.exec[pu.ip]](pu) or_return
        pu.ip += 1
        verbose_print("Opcodes left:", pu.memory.exec[pu.ip:])
    }

    return nil
}