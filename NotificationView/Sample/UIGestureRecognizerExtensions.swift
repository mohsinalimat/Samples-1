//
//  UIGestureRecognizerExtensions.swift
//  Throwback
//
//  Created by Lasha Efremidze on 6/28/16.
//  Copyright © 2016 stubhublabs. All rights reserved.
//

import UIKit

private var targets = [Target]()

extension UIGestureRecognizer {
    
    convenience init(action: @escaping (UIGestureRecognizer) -> ()) {
        self.init()
        addAction(action)
    }
    
    func addAction(_ action: @escaping (UIGestureRecognizer) -> ()) {
        let target = Target(action)
        targets.append(target)
        addTarget(target, action: #selector(target.invoke))
    }
    
}

private class Target {
    
    fileprivate var closure: (UIGestureRecognizer) -> ()
    
    init(_ closure: @escaping (UIGestureRecognizer) -> ()) {
        self.closure = closure
    }
    
    @objc @IBAction func invoke(_ recognizer: UIGestureRecognizer) {
        self.closure(recognizer)
    }
    
}
