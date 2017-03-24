//: Playground - noun: a place where people can play

import UIKit

// Write a program with a function complete() that autocompletes all the matching Swift keywords (listed below)

// For example
// complete("a") -> ["associativity"]
// complete("tr") -> ["true", "try"]
// complete("x") -> []
// Less than or equal comparisons to length of the prefix string

let keywords = ["associativity", "break", "case", "catch", "class", "continue", "convenience", "default", "deinit", "didSet", "do", "else", "enum", "extension", "fallthrough", "false", "final", "for", "func", "get", "guard", "if", "in", "infix", "init", "inout", "internal", "lazy", "let", "mutating", "nil", "operator", "override", "postfix", "precedence", "prefix", "private", "public", "repeat", "required", "return", "self", "set", "static", "struct", "subscript", "super", "switch", "throws", "true", "try", "var", "weak", "where", "while", "willSet"
]

// ["associativity": ["a", "as", "ass"]]
let cache: [String: [String]] = {
    var dict = [String: [String]]()
    for keyword in keywords {
        var word = ""
        var array = [String]()
        for character in keyword.characters {
            word += String(character)
            array += [word]
        }
        dict[keyword] = array
    }
    return dict
}()

func complete(_ s: String) -> [String] {
    var array = [String]()
    for (key, value) in cache where value.contains(s) {
        array.append(key)
    }
    return array
}

let str = "tr"

complete(str)
