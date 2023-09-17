package main

import "core:fmt"

BASE_FUNCTIONS := [](proc(^Odari_PU) -> Maybe(Error)) {
    print,
}

print :: proc(pu: ^Odari_PU) -> Maybe(Error) {
    address := odari_popstack(&pu.memory) or_return
    size := odari_getheap(address, &pu.memory) or_return
    verbose_print(fmt.aprintf("Printing out string from address %08x with length of %d", address, size))
    old := enabled_flags
    enabled_flags = {}
    for i in 0..=size {
        fmt.printf("%c", odari_getheap(address + u64(i), &pu.memory) or_return)
    }
    enabled_flags = old
    return nil
}