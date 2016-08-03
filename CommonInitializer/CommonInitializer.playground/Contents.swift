//: Playground - noun: a place where people can play

import UIKit

class Foo {
    
    private let 👻: String
    private let 🐼: String
    
    init() {
        (👻, 🐼) = Foo.commonInit()
    }
    
    private static func commonInit() -> (String, String) {
        return ("🐰", "🐼")
    }
    
}

class Bar: UIView {
    
    private let 👻: String
    private let 🐼: String
    
    override init(frame: CGRect) {
        (👻, 🐼) = Foo.commonInit()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        (👻, 🐼) = Foo.commonInit()
        super.init(coder: aDecoder)
    }
    
    private static func commonInit() -> (String, String) {
        return ("🐰", "🐼")
    }
    
}
