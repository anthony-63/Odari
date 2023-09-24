package main

import "core:fmt"

Odari_FuncStackItem :: struct {
    ret_addr: u64,
}

Odari_PtrItem :: struct {
    address: u64,
    size: u64,
}

Odari_MEM :: struct {
    exec: [dynamic]u64,
    heap: [dynamic]u64,
    registers: [dynamic]u64,
    stack: [dynamic]u64,
    ptrs: [dynamic]Odari_PtrItem,
    sp: u64,
    heap_size: u64,
    registers_size: u64,
}

odari_pushstack :: proc(value: u64, mem: ^Odari_MEM) -> Maybe(Error) {
    verbose_print("Pushing", value, "to stack")
    resize_dynamic_array(&mem.stack, int(mem.sp + 1))
    mem.stack[mem.sp] = value
    mem.sp += 1
    verbose_print("Stack:", mem.stack)
    return nil
}

odari_popstack :: proc(mem: ^Odari_MEM) -> (u64, Maybe(Error)) {
    if int(mem.sp - 1) < 0 {
        return 0, Error{.STACK_UNDERFLOW, fmt.aprint("Attempted to pop from empty stack")}
    }

    mem.sp -= 1

    top := mem.stack[mem.sp]

    verbose_print("Popped", top, "from stack")
    verbose_print("SP:", mem.sp)
    resize_dynamic_array(&mem.stack, int(mem.sp + 1))
    verbose_print("Stack:", mem.stack)

    if mem.sp == 0 do mem.stack = {}

    return top, nil
}

odari_getreg :: proc(reg: u64, mem: ^Odari_MEM) -> (u64, Maybe(Error)) {
    if reg > mem.registers_size {
        return 0, Error{.INVALID_REGISTER, fmt.aprint("Attempted to access register:", reg)}
    }
    verbose_print("Accessing register:", reg)
    return mem.registers[reg], nil
}

odari_setreg :: proc(value: u64, reg: u64, mem: ^Odari_MEM) -> Maybe(Error) {
    if reg + 1 > mem.registers_size {
        mem.registers_size = reg
        verbose_print("Resizing register size to:", mem.registers_size)
        resize_dynamic_array(&mem.registers, int(mem.registers_size + 1))
    }

    mem.registers[reg] = value
    verbose_print("Set r", reg, " to value '", value, "'", separ="")
    return nil
}

odari_setheap :: proc(value: u64, address: u64, mem: ^Odari_MEM) -> Maybe(Error) {
    if address + 1 > mem.heap_size {
        mem.heap_size = address
        verbose_print("Resizing heap to:", mem.heap_size)
        resize_dynamic_array(&mem.heap, int(mem.heap_size + 1))
    }

    mem.heap[address] = value
    verbose_print(fmt.aprintf("Set address 0x%08x to value '%d'", address, value))
    verbose_print("Heap:", mem.heap)
    return nil
}

odari_getheap :: proc(address: u64, mem: ^Odari_MEM) -> (u64, Maybe(Error)) {
    if address > mem.heap_size {
        return 0, Error{.INVALID_MEMORY_ADDRESS, fmt.aprintf("Attempted to access heap address 0x%08x which is out of bounds of size 0x%08x", address, mem.heap_size)}
    }

    verbose_print(fmt.aprintf("Accessing heap address %08x which has value %08x", address, mem.heap[address]))

    return mem.heap[address], nil
}