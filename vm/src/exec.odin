package main

import "core:fmt"
import "core:mem"

OPCODE_CALL_TABLE := [](proc(^Odari_PU) -> Maybe(Error)){
    moveheap,
    movereg,
    push,
    pushreg,
    pop,
    ppush,
    ppushreg,
    ppop,
    moveheaptoreg,
    moveregtoheap,
    moveregtoreg,
    moveheaptoheap,
    moveregtoref,
    ret,
    add,
    sub,
    mul,
    div,
    fdiv,
    inc,
    dec,
    bitwiseor,
    bitsizeand,
    bitwisexor,
    bitwisenot,
    logicalor,
    logicaland,
    logicalnot,
    eq,
    neq,
    gt,
    lt,
    gteq,
    lteg,
    call,
    func,
    end,
    native,
    jmpeq,
    jmpneq,
    jmp,
    jmpstack,
    puship,
    noop,
}

next :: proc(pu: ^Odari_PU) -> (u64, Maybe(Error)) {
    pu.ip += 1
    if pu.ip >= len(pu.memory_scopes[0].exec) {
        return 0, Error{.FAILED_TO_ACCESS_EXEC, "Failed to get next exec opcode"}
    }
    
    verbose_print("Next: ", pu.memory_scopes[0].exec[pu.ip])
    return pu.memory_scopes[0].exec[pu.ip], nil
}

@(private="file")
moveheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        next(pu) or_return,
        next(pu) or_return,
        &pu.memory_scopes[pu.scope_index],
    )

    return nil
}

@(private="file")
movereg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        next(pu) or_return,
        next(pu) or_return, 
        &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
push :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_pushstack(
        next(pu) or_return, 
        &pu.memory_scopes[pu.scope_index],
    )

    return nil
}

@(private="file")
pushreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_pushstack(
        odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return, 
        &pu.memory_scopes[pu.scope_index],
    ) or_return
    
    return nil
}

@(private="file")
pop :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return, 
        next(pu) or_return, &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
ppush :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_push_pstack(
        next(pu) or_return, 
        pu,
    )

    return nil
}

@(private="file")
ppushreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_push_pstack(
        odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return, 
        pu,
    )

    return nil
}

@(private="file")
ppop :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_pop_pstack(pu) or_return, 
        next(pu) or_return, &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
moveheaptoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_getheap(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return,
        next(pu) or_return, 
        &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
moveregtoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return, 
        next(pu) or_return, 
        &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
moveregtoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return,
        next(pu) or_return,
        &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
moveheaptoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        odari_getheap(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return,
        next(pu) or_return,
        &pu.memory_scopes[pu.scope_index],
    ) or_return

    return nil
}

@(private="file")
moveregtoref :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return,
        odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return,
        &pu.memory_scopes[pu.scope_index],
    ) or_return
    return nil
}

@(private="file")
ret :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    mem.set(&pu.memory_scopes[pu.scope_index], 0, size_of(Odari_MEM))
    pu.scope_index -= 1
    pu.fpsp -= 1
    pu.ip = int(pu.func_stack[pu.fpsp].ret_addr)
    resize_dynamic_array(&pu.func_stack, int(pu.fpsp))
    return nil
}

@(private="file")
add :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val + r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
sub :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val - r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
mul :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val * r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
div :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val / r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
fdiv :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction fdiv not implemented"}
}

@(private="file")
inc :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    reg := next(pu) or_return
    odari_setreg(
        (odari_getreg(reg, &pu.memory_scopes[pu.scope_index]) or_return) + 1,
        reg,
        &pu.memory_scopes[pu.scope_index],
    ) or_return
    return nil
}

@(private="file")
dec :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    reg := next(pu) or_return
    odari_setreg(
        (odari_getreg(reg, &pu.memory_scopes[pu.scope_index]) or_return) - 1,
        reg,
        &pu.memory_scopes[pu.scope_index],
    ) or_return
    return nil
}

@(private="file")
bitwiseor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val | r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
bitsizeand :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val & r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
bitwisexor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val ~ r2val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
bitwisenot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(r1val &~ r1val, &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
logicalor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(bool(r1val) || bool(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
logicaland :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(bool(r1val) && bool(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
logicalnot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(!bool(r1val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
eq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(bool(r1val) == bool(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
neq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(bool(r1val) != bool(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
gt :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(int(r1val) > int(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
lt :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(int(r1val) < int(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
gteq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(int(r1val) >= int(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
lteg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory_scopes[pu.scope_index]) or_return
    odari_pushstack(u64(int(r1val) <= int(r2val)), &pu.memory_scopes[pu.scope_index]) or_return
    return nil
}

@(private="file")
call :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    pu.calling = true
    pu.scope_index += 1
    jump := next(pu) or_return
    verbose_print("Calling function at index: ", pu.ip)
    call_stack_entry: Odari_FuncStackItem
    call_stack_entry.ret_addr = u64(pu.ip)
    pu.ip = int(jump)
    append(&pu.func_stack, call_stack_entry)
    pu.fpsp += 1
    append(&pu.memory_scopes, Odari_MEM{})
    verbose_print("Call stack:", pu.func_stack)
    return nil
}

@(private="file")
func :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    if !pu.calling {
        verbose_print("Skipping function: ", pu.ip)
        dist := pu.xrefed[pu.ip] - u64(pu.ip)
        pu.ip += int(dist)
    }
    pu.calling = false
    
    return nil
}

@(private="file")
native :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    func_idx := odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return
    verbose_print("Calling native function index:", func_idx)
    BASE_FUNCTIONS[func_idx](pu) or_return
    return nil
}

@(private="file")
jmpeq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    addr := next(pu) or_return
    cond := bool(odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return)

    verbose_print("JMPEQ:", cond, fmt.aprintf("%08x", addr))

    if cond {
        pu.ip = int(addr)
        return Error{.DO_NOT_SKIP, ""}
    } else {
        return nil
    }
}

@(private="file")
jmpneq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    addr := next(pu) or_return
    cond := bool(odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return)

    verbose_print("JMPNEQ:", cond, fmt.aprintf("%08x", addr))

    if !cond {
        pu.ip = int(addr)
        return Error{.DO_NOT_SKIP, ""}
    } else {
        return nil
    }
}

@(private="file")
jmp :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    addr := next(pu) or_return
    pu.ip = int(addr)
    return Error{.DO_NOT_SKIP, ""}
}

@(private="file")
end :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return nil
}

@(private="file")
jmpstack :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    addr := odari_popstack(&pu.memory_scopes[pu.scope_index]) or_return
    pu.ip = int(addr)
    return Error{.DO_NOT_SKIP, ""}
}

@(private="file")
puship :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_pushstack(u64(pu.ip), &pu.memory_scopes[pu.scope_index])
    return nil
}

@(private="file")
noop :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return nil
}
