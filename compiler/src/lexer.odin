package main

import "core:strings"
import "core:fmt"
import "core:os"

@(private="file")
shift :: proc(arr: ^[]string) -> string {
    f := arr[0]
    arr^ = arr[1:]
    return f
}

@(private="file")
isalpha :: proc(src: string) -> bool {
    return strings.to_upper(src) != strings.to_lower(src)
}

@(private="file")
isint :: proc(src: string) -> bool {
    c: u8 =  src[0]
    bounds := []u8{u8("0"[0]), u8("9"[0])}
    return c >= bounds[0] && c <= bounds[1]
}

@(private="file")
isskippable :: proc(src: string) -> bool {
    return src == " " || src == "\n" || src == "\t"
}

odari_lexer_generate :: proc(source: string) -> []Odari_Token {
    toks := make([dynamic]Odari_Token)
    src := strings.split(source, "")

    for len(src) > 0 {
        if src[0] == "(" do append(&toks, Odari_Token{.OpenParen, shift(&src)})
        else if src[0] == ")" do append(&toks, Odari_Token{.CloseParen, shift(&src)})
        else if src[0] == "+" || src[0] == "-" || src[0] == "*" || src[0] == "/" {
            append(&toks, Odari_Token{.BinaryOperator, shift(&src)})
        }
        else if src[0] == "=" do append(&toks, Odari_Token{.Equals, shift(&src)})
        else {
            if isint(src[0]) { // build number token
                num := ""
                verbose_print("Building number...")
                for len(src) > 0 && isint(src[0]) {
                    f := shift(&src)
                    verbose_print("[N]: ", f, ", ", num, separ="")
                    num = strings.concatenate({num, f})
                }
                append(&toks, Odari_Token{.Number, num})
            } else if isalpha(src[0]) { // build indentifier
                ident := ""
                verbose_print("Building identifier...")
                for len(src) > 0 && isalpha(src[0]) {
                    f := shift(&src)
                    verbose_print("[I]: ", f, ", ", ident, separ="")
                    ident = strings.concatenate({ident, f})
                }

                reserved := Odari_Keywords[ident]
                if reserved == nil {
                    append(&toks, Odari_Token{.Identifier, ident})
                } else {
                    append(&toks, Odari_Token{reserved, ident})
                }
            } else if isskippable(src[0]) {
                shift(&src)
            } else {
                fmt.println("Unrecognized character found in source: ", src[0])
                os.exit(-1)
            }
        }

    }

    return toks[:]
}