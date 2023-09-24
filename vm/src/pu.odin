package main

import "core:fmt"
import "core:os"

Odari_PU :: struct {
    memory_scopes: [dynamic]Odari_MEM,
    p_stack: [dynamic]u64,
    xrefed: [dynamic]u64,
    psp: u64,
    calling: bool,
    scope_index: int,
    func_stack: [dynamic]Odari_FuncStackItem,
    fpsp: u64,
    ip: int,
    printing: bool,
}

@(private="file")
halt_msg :: proc(pu: ^Odari_PU) {
    debug_print("Halting!")
    debug_print("Final scopes: ",pu.memory_scopes , separ="")
    debug_print("Preserved Stack: ", pu.p_stack)
}

odari_push_pstack :: proc(val: u64, pu: ^Odari_PU) -> Maybe(Error) {
    verbose_print("Pushing", val, "to stack")
    resize_dynamic_array(&pu.p_stack, int(pu.psp + 1))
    pu.p_stack[pu.psp] = val
    pu.psp += 1
    verbose_print("Preserved Stack:", pu.p_stack)
    return nil
}

odari_pop_pstack :: proc(pu: ^Odari_PU) -> (u64, Maybe(Error)) {
    if int(pu.psp - 1) < 0 {
        return 0, Error{.STACK_UNDERFLOW, fmt.aprint("Attempted to pop from empty preserve stack")}
    }

    pu.psp -= 1

    top := pu.p_stack[pu.psp]

    verbose_print("Popped", top, "from preserved stack")
    verbose_print("PSP:", pu.psp)
    resize_dynamic_array(&pu.p_stack, int(pu.psp + 1))
    verbose_print("Preserved Stack:", pu.p_stack)
    if pu.psp == 0 do pu.p_stack = {}

    return top, nil
}

odari_execute_bytecode :: proc(pu: ^Odari_PU, bytecode: []OPCODE) -> Maybe(Error) {
    debug_print("Loading bytecode into exec memory")
    append(&pu.memory_scopes, Odari_MEM{})
    for b in bytecode {
        append(&pu.memory_scopes[0].exec, b.num)
    }
    for b in bytecode {
        append(&pu.xrefed, b.xref)
    }

    defer halt_msg(pu)

    verbose_print("Exec memory:", pu.memory_scopes[0].exec)

    debug_print("Starting execution...")
    for pu.ip < len(pu.memory_scopes[0].exec) {
        verbose_print("Executing: ", pu.memory_scopes[0].exec[pu.ip])
        err := OPCODE_CALL_TABLE[pu.memory_scopes[0].exec[pu.ip]](pu)
        if err == nil {
            pu.ip += 1
        } else {
            if err.?.type == .DO_NOT_SKIP {}
            else do return err
        }

        verbose_print("Opcodes left(IP:", pu.ip, "): ", pu.memory_scopes[0].exec[pu.ip:], separ="")
    }

    return nil
}