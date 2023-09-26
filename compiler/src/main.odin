package main

import "core:fmt"
import "core:os"
import "core:strings"

FLAGS :: enum {
    DEBUG,
    VERBOSE,
}

FLAG_SET :: bit_set[FLAGS]

file_name: string = ""
output_file_name: string = ""
enabled_flags: FLAG_SET = {}

debug_print :: proc(args: ..any, separ := " ") {
    if .DEBUG in enabled_flags do fmt.println(..args, sep=separ)
}

verbose_print :: proc(args: ..any, separ := " ") {
    if .VERBOSE in enabled_flags do fmt.println(..args, sep=separ)
}

main :: proc() {
    for i in os.args {
        if i[0] == '-' {
            switch i {
                case "-debug": enabled_flags += {.DEBUG}; continue
                case "-verbose": enabled_flags += {.VERBOSE}; continue
            }
        }
        if strings.contains(i, ".odaric") do output_file_name = i
        else if strings.contains(i, ".odari") do file_name = i
    }

    if file_name == "" {
        fmt.println("No source file supplied to OdariC")
        os.exit(-1)
    }

    if output_file_name == "" {
        fmt.println("No output file supplied to OdariC")
        os.exit(-1)
    }
    file_input, ok := os.read_entire_file_from_filename(file_name)
    if !ok {
        fmt.println("Failed to open file:", file_name)
        os.exit(-1)
    }

    tokens := odari_lexer_generate(string(file_input))

   verbose_print("Generated tokens:", tokens)

}