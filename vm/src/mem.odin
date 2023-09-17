package main

Odari_FuncStackItem :: struct {
    ret_addr: u64,
    arg_size: u64,
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
    func_stack: [dynamic]Odari_FuncStackItem,
}