package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:mem"

FLAGS :: enum {
    DEBUG,
    VERBOSE,
    SUPER_SECRET_FLAG,
}

FLAG_SET :: bit_set[FLAGS]


file_name: string = ""
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
                case "-super-secret-flag": enabled_flags += {.SUPER_SECRET_FLAG}; continue
            }
        }
        if strings.contains(i, ".odaric") do file_name = i
    }

    if file_name == "" {
        fmt.println("No file supplied to OdariVM")
        os.exit(-1)
    }

    PROGRAM_x64 := NO_PROGRAM

    if .SUPER_SECRET_FLAG in enabled_flags {
        PROGRAM_x64 = LOOP_TEST
    } else {
        debug_print("Loading bytecode from '", file_name, "'", separ="")
        if !os.exists(file_name) {
            fmt.println("File '", file_name, "' does not exist!", sep="")
            os.exit(-1)
        }
        data, s := os.read_entire_file_from_filename(file_name)
        if !s {
            fmt.println("Failed to read from file '", file_name, "'", sep="")
            os.exit(-1)
        }
        i := 0
        final_program: [dynamic]u64 = {}
        for _ in 0..<len(data) / 8 {
            b1, b2, b3, b4, b5, b6, b7, b8_ := data[i], data[i + 1], data[i + 2], data[i + 3], data[i + 4], data[i + 5], data[i + 6], data[i + 7]
            byte_list := make([]u8, 8)
            byte_list = {b1, b2, b3, b4, b5, b6, b7, b8_}
            final: u64 = 0
            mem.copy(&final, raw_data(byte_list), 8)
            append(&final_program, final)
            i += 8
        }
        PROGRAM_x64 = make([]u64, len(final_program))
        for n in 0..<len(final_program) {
            PROGRAM_x64[n] = final_program[n]
        }

    }
    
    debug_print("Running Odari Virutal Machine with Debug Information")
    verbose_print("Running Odari Virtual Machine with Verbose Output")

    pu: Odari_PU

    if err := odari_execute_bytecode(&pu, PROGRAM_x64); err != nil {
        fmt.println("ERROR:", err.?.message)
    }
}