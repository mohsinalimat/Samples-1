//: Playground - noun: a place where people can play

import UIKit

enum Enum {
    case foo(Int)
    case bar(String)
    case qux(Int)
}

let items: [Enum] = [.foo(1), .bar("hi"), .foo(2)]

let filtered = items.filter { if case .foo = $0 { return true }; return false }
