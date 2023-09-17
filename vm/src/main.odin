package main

import "core:fmt"
import "core:os"

FLAGS :: enum {
    DEBUG,
    VERBOSE,
}

FLAG_SET :: bit_set[FLAGS]

enabled_flags: FLAG_SET = {}

debug_print :: proc(args: ..any, separ := " ") {
    if .DEBUG in enabled_flags do fmt.println(..args, sep=separ)
}

verbose_print :: proc(args: ..any, separ := " ") {
    if .VERBOSE in enabled_flags do fmt.println(..args, sep=separ)
}

main :: proc() {
    for i in os.args {
        switch i {
            case "-debug": enabled_flags += {.DEBUG}
            case "-verbose": enabled_flags += {.VERBOSE}
        }
    }
    
    debug_print("Running Odari Virutal Machine with Debug Information")
    verbose_print("Running Odari Virtual Machine with Verbose Output")

    TEST_PROGRAM :: []u64{
        u64(OPCODES.MOVEREG), 0xAB, 0,
        u64(OPCODES.MOVEREG), 0xCD, 1,
        u64(OPCODES.ADD), 0, 1,
        u64(OPCODES.POP), 2,
        u64(OPCODES.DBG), 2,
    }

    HELLO_WORLD :: []u64{
        // 48 65 6C 6C 6F 20 57 6F 72 6C 64 21
        // "Hello World!"
        u64(OPCODES.MOVEHEAP), 0x0D, 0x00,
        u64(OPCODES.MOVEHEAP), 0x48, 0x01,
        u64(OPCODES.MOVEHEAP), 0x65, 0x02,
        u64(OPCODES.MOVEHEAP), 0x6C, 0x03,
        u64(OPCODES.MOVEHEAP), 0x6C, 0x04,
        u64(OPCODES.MOVEHEAP), 0x6F, 0x05,
        u64(OPCODES.MOVEHEAP), 0x20, 0x06,
        u64(OPCODES.MOVEHEAP), 0x57, 0x07,
        u64(OPCODES.MOVEHEAP), 0x6F, 0x08,
        u64(OPCODES.MOVEHEAP), 0x72, 0x09,
        u64(OPCODES.MOVEHEAP), 0x6C, 0x0A,
        u64(OPCODES.MOVEHEAP), 0x64, 0x0B,
        u64(OPCODES.MOVEHEAP), 0x21, 0x0C,
        u64(OPCODES.MOVEHEAP), 0x0A, 0x0D,
        u64(OPCODES.PUSH),     0x00,
        u64(OPCODES.PUSH),     0x00,
        u64(OPCODES.NATIVE), 
    }

    pu: Odari_PU

    if err := odari_execute_bytecode(&pu, HELLO_WORLD); err != nil {
        fmt.println("ERROR:", err.?.message)
    }
}