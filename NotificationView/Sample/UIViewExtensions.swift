//
//  UIViewExtensions.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/17/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func constrain(constraints: (UIView) -> [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self))
    }
    
}
