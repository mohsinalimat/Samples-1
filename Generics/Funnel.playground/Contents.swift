//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

protocol SomeProtocol {
    associatedtype T
    typealias Closure = (T) -> Void
    var blocks: [Closure] { get set }
}

class SomeClass<T>: SomeProtocol {
    typealias Closure = (T) -> Void
    var blocks: [Closure]
    
    init() {
        self.blocks = [Closure]()
    }
    
    func bar(perform: (_ next: @escaping Closure) -> Void, completion: @escaping Closure) {
        if blocks.isEmpty {
            perform { [unowned self] value in
                self.blocks.forEach { $0(value) }
                self.blocks = []
            }
        }
        blocks += [completion]
    }
    
    deinit {
        print("CompilerWarning DEALLOCATED")
    }
}

// example
PlaygroundPage.current.needsIndefiniteExecution = true
var foo: SomeClass? = SomeClass<String>()
foo?.bar(perform: { next in
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        next("hello") // call next when completed
    }
}, completion: { value in // completion
    print(value)
    foo = nil
    PlaygroundPage.current.finishExecution()
})

class SomeSubclass<T>: SomeClass<T> {
    var value: T?
    
    override func bar(perform: (_ next: @escaping Closure) -> Void, completion: @escaping Closure) {
        if let value = value {
            completion(value)
        } else {
            super.bar(perform: perform) { [unowned self] value in
                self.value = value
                completion(value)
            }
        }
    }
}

// example
PlaygroundPage.current.needsIndefiniteExecution = true
var foo2: SomeSubclass? = SomeSubclass<String>()
foo2?.bar(perform: { next in
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        next("hello2") // call next when completed
    }
}, completion: { value in // completion
    print(value)
    foo2 = nil
    PlaygroundPage.current.finishExecution()
})

//extension SomeProtocol where Self: AnyObject {
//    mutating func bar(perform: (_ next: @escaping Closure) -> Void, completion: @escaping Closure) {
//        if blocks.isEmpty {
//            perform { [unowned self] value in
//                var this = self
//                this.blocks.forEach { $0(value) }
//                this.blocks = []
//            }
//        }
//        blocks += [completion]
//    }
//}
