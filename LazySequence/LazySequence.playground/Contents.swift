//: Playground - noun: a place where people can play

import UIKit

let range = 0..<10000

// sequence
func first() -> Int? {
    let filter = range.filter { $0 > 2 }.map { $0 * 2 } // 19998 times
    return filter.first
}

// lazy sequence
func lazyFirst() -> Int? {
    let lazy = range.lazy
    let filter = lazy.filter { $0 > 2 }.map { $0 * 2 } // 6 times
    return filter.first
}

first()
lazyFirst()
