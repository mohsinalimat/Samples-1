//: Playground - noun: a place where people can play

import UIKit

var str = "babad"

extension String {
    func index(_ i: Int) -> Index {
        return index(startIndex, offsetBy: i)
    }
    
    subscript (i: Int) -> Character {
        return self[index(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(r.lowerBound)
        let end = index(r.upperBound)
        return substring(with: start..<end)
    }
}

func longestPalindrome(_ s: String) -> String {
    var str = ""
    for i in 0..<s.characters.count {
        let newStr = longest(s, i, i) // odds
        if newStr.characters.count > str.characters.count {
            str = newStr
        }
        let newStr2 = longest(s, i, i + 1) // evens
        if newStr2.characters.count > str.characters.count {
            str = newStr2
        }
    }
    return str
}

func longest(_ s: String, _ j: Int, _ k: Int) -> String {
    var j = j, k = k
    let range = (0..<s.characters.count)
    while range.contains(j), range.contains(k), s[j] == s[k] {
        j -= 1
        k += 1
    }
    return s[j + 1..<k]
}

longestPalindrome(str)
