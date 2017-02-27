//
//  Extensions.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/27/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

protocol Constrainable {}
extension Constrainable where Self: UIView {
    
    @discardableResult
    func constrain(constraints: (Self) -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = constraints(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
}

extension UIView: Constrainable {
    
    @discardableResult
    func constrainToEdges(_ inset: UIEdgeInsets = UIEdgeInsets()) -> [NSLayoutConstraint] {
        return constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: inset.top),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: inset.left),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: inset.bottom),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: inset.right)
        ]}
    }
    
}
