//: Playground - noun: a place where people can play

import UIKit

//protocol Funnel {
//    associatedtype T
//    var value: T? { get set }
//    var blocks: [(T) -> Void]? { get set }
//}
//
//extension Funnel where Self: AnyObject {
//    mutating func once(perform: (_ next: @escaping (T) -> Void) -> Void, block: @escaping (T) -> Void) {
//        if let value = value {
//            block(value)
//        } else {
//            if blocks?.isEmpty ?? false {
//                perform { [weak self] value in
//                    self?.blocks?.forEach { $0(value) }
//                    self?.blocks = nil
//                }
//            }
//            blocks?.append(block)
//        }
//    }
//}
//
//extension NSObject: Funnel {}

class Funnel<T> {
    
    typealias Closure = (T) -> Void
    
    private var value: T?
    private var blocks = [(T) -> Void]()
    
    func once(perform: (_ next: @escaping Closure) -> Void, block: @escaping Closure) {
        if let value = value {
            block(value)
        } else {
            if blocks.isEmpty {
                perform { [weak self] value in
                    self?.value = value
                    self?.blocks.forEach { $0(value) }
                    self?.blocks = []
                }
            }
            blocks += [block]
        }
    }
    
}

// perform async block once
Funnel<String>().once(perform: { next in
    // do something async
    DispatchQueue.global().async {
        // call next when completed
        next("hello")
    }
}, block: { value in
    // calls block once ready
    print(value)
})
