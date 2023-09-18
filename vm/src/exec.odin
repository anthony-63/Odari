package main

import "core:fmt"

OPCODE_CALL_TABLE := [](proc(^Odari_PU) -> Maybe(Error)){
    moveheap,
    movereg,
    push,
    pushreg,
    pushfp,
    pop,
    moveheaptoreg,
    moveregtoheap,
    moveregtoreg,
    moveheaptoheap,
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
    native,
    jmpeq,
    jmpneq,
    jmp,
    dbg,
}

next :: proc(pu: ^Odari_PU) -> (u64, Maybe(Error)) {
    pu.ip += 1
    if pu.ip >= len(pu.memory.exec) {
        return 0, Error{.FAILED_TO_ACCESS_EXEC, "Failed to get next exec opcode"}
    }
    
    verbose_print("Next: ", pu.memory.exec[pu.ip])
    return pu.memory.exec[pu.ip], nil
}

@(private="file")
moveheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        next(pu) or_return,
        next(pu) or_return,
        &pu.memory,
    )

    return nil
}

@(private="file")
movereg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        next(pu) or_return,
        next(pu) or_return, 
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
push :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_pushstack(
        next(pu) or_return, 
        &pu.memory,
    )

    return nil
}

@(private="file")
pushreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_pushstack(
        odari_getreg(next(pu) or_return, &pu.memory) or_return, 
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
pushfp :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return nil
}

@(private="file")
pop :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_popstack(&pu.memory) or_return, 
        next(pu) or_return, &pu.memory,
    ) or_return

    return nil
}

@(private="file")
moveheaptoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_getheap(next(pu) or_return, &pu.memory) or_return,
        next(pu) or_return, 
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
moveregtoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        odari_getreg(next(pu) or_return, &pu.memory) or_return, 
        next(pu) or_return, 
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
moveregtoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setreg(
        odari_getreg(next(pu) or_return, &pu.memory) or_return,
        next(pu) or_return,
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
moveheaptoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    odari_setheap(
        odari_getheap(next(pu) or_return, &pu.memory) or_return,
        next(pu) or_return,
        &pu.memory,
    ) or_return

    return nil
}

@(private="file")
ret :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction ret not implemented"}
}

@(private="file")
add :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val + r2val, &pu.memory) or_return
    return nil
}

@(private="file")
sub :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val - r2val, &pu.memory) or_return
    return nil
}

@(private="file")
mul :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val * r2val, &pu.memory) or_return
    return nil
}

@(private="file")
div :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val / r2val, &pu.memory) or_return
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
        (odari_getreg(reg, &pu.memory) or_return) + 1,
        reg,
        &pu.memory,
    ) or_return
    return nil
}

@(private="file")
dec :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    reg := next(pu) or_return
    odari_setreg(
        (odari_getreg(reg, &pu.memory) or_return) - 1,
        reg,
        &pu.memory,
    ) or_return
    return nil
}

@(private="file")
bitwiseor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val | r2val, &pu.memory) or_return
    return nil
}

@(private="file")
bitsizeand :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val & r2val, &pu.memory) or_return
    return nil
}

@(private="file")
bitwisexor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val ~ r2val, &pu.memory) or_return
    return nil
}

@(private="file")
bitwisenot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(r1val &~ r1val, &pu.memory) or_return
    return nil
}

@(private="file")
logicalor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(bool(r1val) || bool(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
logicaland :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(bool(r1val) && bool(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
logicalnot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(!bool(r1val)), &pu.memory) or_return
    return nil
}

@(private="file")
eq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(bool(r1val) == bool(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
neq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(bool(r1val) != bool(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
gt :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(int(r1val) > int(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
lt :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(int(r1val) < int(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
gteq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(int(r1val) >= int(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
lteg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    r2val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    r1val := odari_getreg(next(pu) or_return, &pu.memory) or_return
    odari_pushstack(u64(int(r1val) <= int(r2val)), &pu.memory) or_return
    return nil
}

@(private="file")
call :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction call not implemented"}
}

@(private="file")
func :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction func not implemented"}
}

@(private="file")
native :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    func_idx := odari_popstack(&pu.memory) or_return
    verbose_print("Calling native function index:", func_idx)
    BASE_FUNCTIONS[func_idx](pu) or_return
    return nil
}

@(private="file")
jmpeq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    addr := next(pu) or_return
    cond := bool(odari_popstack(&pu.memory) or_return)

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
    cond := bool(odari_popstack(&pu.memory) or_return)

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
dbg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    fmt.println("DEBUG PRINT:", odari_getreg(next(pu) or_return, &pu.memory) or_return)
    return nil
}
