package main

import "core:fmt"
import "core:os"

Odari_PU :: struct {
    memory: Odari_MEM,
    calling: bool,
    ip: int,
    printing: bool,
}

@(private="file")
halt_msg :: proc(pu: ^Odari_PU) {
    debug_print("Halting!")
    debug_print("Final heap(", pu.memory.heap_size + 1, "): ", pu.memory.heap, separ="")
    debug_print("Final stack(", pu.memory.sp, "): ", pu.memory.stack, separ="")
    debug_print("Final registers(", pu.memory.registers_size + 1, "): ", pu.memory.registers, separ="")
    debug_print("Final exec memory(", len(pu.memory.exec) - pu.ip, "): ", pu.memory.exec[pu.ip-1:], separ="")
}

odari_execute_bytecode :: proc(pu: ^Odari_PU, bytecode: []u64) -> Maybe(Error) {
    debug_print("Loading bytecode")
    for b in bytecode {
        append(&pu.memory.exec, b)
    }

    defer halt_msg(pu)

    verbose_print("Exec memory:", pu.memory.exec)

    debug_print("Starting execution...")
    for pu.ip < len(pu.memory.exec) {
        verbose_print("Executing: ", bytecode[pu.ip])
        err := OPCODE_CALL_TABLE[pu.memory.exec[pu.ip]](pu)
        if err == nil {
            pu.ip += 1
        } else {
            if err.?.type == .DO_NOT_SKIP {}
            else do return err
        }

        verbose_print("Opcodes left(IP:", pu.ip, "): ", pu.memory.exec[pu.ip:])
    }

    
    return nil
}