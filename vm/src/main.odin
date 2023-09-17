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
}