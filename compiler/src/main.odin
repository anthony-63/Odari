package main

import "core:fmt"

FLAGS :: enum {
    DEBUG,
    VERBOSE,
}

main :: proc() {
    fmt.println("Hello From Compiler!")
}