package main

Odari_TokenType :: enum {
    Number,
    Identifier,
    Equals,
    OpenParen,
    CloseParen,
    BinaryOperator,
    Let,
}

Odari_Token :: struct {
    type: Odari_TokenType,
    value: string,
}

Odari_Keywords := map[string]Odari_TokenType {
    "let" = .Let,
}