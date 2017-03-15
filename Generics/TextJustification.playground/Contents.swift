//: Playground - noun: a place where people can play

import Foundation

extension String {
    
    func justified(max: Int) -> String {
        typealias T = (stack: [[String]], current: [String])
        let lines: [[String]] = {
            let accumulator = self.components(separatedBy: " ").reduce((stack: [], current: [])) { (result: T, element: String) -> T in
                if (result.current + [element]).joined(separator: " ").characters.count > max {
                    var current = result.current
                    let remainder = max - current.joined(separator: "").characters.count
                    (0...remainder).reversed().forEach { index in
                        if current.count > 1 {
                            current[index % (current.count - 1)] += " "
                        }
                    }
                    return (stack: result.stack + [current], current: [element])
                } else {
                    return (stack: result.stack, current: result.current + [element])
                }
            }
            return accumulator.stack + [accumulator.current]
        }()
        return lines.map { $0.joined(separator: "") }.joined(separator: "\n")
    }
    
}

let string = "given a list of words, and a window size of w. justification"
let justified = string.justified(max: 20)
print(justified)
