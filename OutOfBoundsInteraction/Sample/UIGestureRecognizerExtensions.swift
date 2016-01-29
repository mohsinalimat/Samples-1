//
//  UIGestureRecognizerExtensions.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/28/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

private var targets = [Target]()

extension UIGestureRecognizer {
    
    convenience init(action: UIGestureRecognizer -> ()) {
        self.init()
        addAction(action)
    }
    
    func addAction(action: UIGestureRecognizer -> ()) {
        let target = Target(action)
        targets.append(target)
        addTarget(target, action: "invoke:")
    }
    
}

private class Target {
    
    private var closure: UIGestureRecognizer -> ()
    
    init(_ closure: UIGestureRecognizer -> ()) {
        self.closure = closure
    }
    
    @IBAction func invoke(recognizer: UIGestureRecognizer) {
        self.closure(recognizer)
    }
    
}
