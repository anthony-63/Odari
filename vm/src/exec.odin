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
    bitwiseor,
    bitsizeand,
    bitwisexor,
    bitwisenot,
    logicalor,
    logicaland,
    logicalnot,
    eq,
    neq,
    ge,
    le,
    geq,
    leg,
    call,
    func,
    native,
    jmpeq,
    jmpneq,
    jmp,
    dbg,
}

next :: proc(pu: ^Odari_PU) -> (u64, Maybe(Error)) {
    verbose_print("Next: ", pu.memory.exec[pu.ip])
    pu.ip += 1
    return pu.memory.exec[pu.ip], nil
}

@(private="file")
moveheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    val := next(pu) or_return
    addr := next(pu) or_return
    odari_setheap(val, addr, &pu.memory)
    return nil
}

@(private="file")
movereg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    val := next(pu) or_return
    reg := next(pu) or_return
    odari_setreg(val, reg, &pu.memory) or_return
    return nil
}

@(private="file")
push :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    val := next(pu) or_return
    odari_pushstack(val, &pu.memory)
    return nil
}

@(private="file")
pushreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction pushreg not implemented"}
}

@(private="file")
pushfp :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction pushfp not implemented"}
}

@(private="file")
pop :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    regtoset := next(pu) or_return
    val := odari_popstack(&pu.memory) or_return
    odari_setreg(val, regtoset, &pu.memory) or_return
    return nil
}

@(private="file")
moveheaptoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction moveheaptoreg not implemented"}
}

@(private="file")
moveregtoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction moveregtoheap not implemented"}
}

@(private="file")
moveregtoreg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction moveregtoreg not implementedproc"}
}

@(private="file")
moveheaptoheap :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction moveheaptoheap not implemented"}
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
    return Error{.NOT_IMPLEMENTED, "Instruction sub not implemented"}
}

@(private="file")
mul :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction mul not implemented"}
}

@(private="file")
div :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction div not implemented"}
}

@(private="file")
fdiv :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction fdiv not implemented"}
}

@(private="file")
bitwiseor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction bitwiseor not implementedc"}
}

@(private="file")
bitsizeand :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction bitsizeand not implementedoc"}
}

@(private="file")
bitwisexor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction bitwisexor not implementedoc"}
}

@(private="file")
bitwisenot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction bitwisenot not implementedoc"}
}

@(private="file")
logicalor :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction logicalor not implementedc"}
}

@(private="file")
logicaland :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction logicaland not implementedoc"}
}

@(private="file")
logicalnot :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction logicalnot not implementedoc"}
}

@(private="file")
eq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction eq not implemented"}
}

@(private="file")
neq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction neq not implemented"}
}

@(private="file")
ge :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction ge not implemented"}
}

@(private="file")
le :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction le not implemented"}
}

@(private="file")
geq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction geq not implemented"}
}

@(private="file")
leg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction leg not implemented"}
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
    index := odari_popstack(&pu.memory) or_return
    BASE_FUNCTIONS[index](pu) or_return
    return nil
}

@(private="file")
jmpeq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction jmpeq not implemented"}
}

@(private="file")
jmpneq :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction jmpneq not implemented"}
}

@(private="file")
jmp :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    return Error{.NOT_IMPLEMENTED, "Instruction jmp not implemented"}
}

@(private="file")
dbg :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    v := odari_getreg(next(pu) or_return, &pu.memory) or_return
    fmt.println("DEBUG PRINT:", v)
    return nil
}
