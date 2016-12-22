//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 12/19/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(invoke)))
    }
    
    @IBAction func invoke(_ recognizer: UIGestureRecognizer) {
        let layer = CATextLayer()
        layer.string = "HELLO"
        layer.foregroundColor = UIColor.red.cgColor
        
        let shape = CAShapeLayer()
        shape.path = verticalSinePath(in: self.view.bounds).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        shape.lineWidth = 2
        self.view.layer.addSublayer(shape)
    }
    
}

private func verticalSinePath(in rect: CGRect) -> UIBezierPath {
    let offset = CGFloat.random(0..<(.pi * 2))
    let amplitude = 0.3 + CGFloat.random(-0.1..<0.1)
    // note, since sine returns values between -1 and 1, let's add 1 and divide by two to get it between 0 and 1
    return parametricPath(in: rect) { CGPoint(x: (amplitude * sin(offset + $0 * .pi * 2) + 1) / 2, y: $0) }
}

private func parametricPath(in rect: CGRect, function: (CGFloat) -> (CGPoint)) -> UIBezierPath {
    let numberOfPoints = max(Int(rect.size.width), Int(rect.size.height))
    let path = UIBezierPath()
    let result = function(0)
    path.move(to: convert(point: CGPoint(x: result.x, y: result.y), in: rect))
    for i in 1 ..< numberOfPoints {
        let t = CGFloat(i) / CGFloat(numberOfPoints - 1)
        let result = function(t)
        path.addLine(to: convert(point: CGPoint(x: result.x, y: result.y), in: rect))
    }
    return path
}

private func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
    return CGPoint(
        x: rect.origin.x + point.x * rect.size.width,
        y: rect.origin.y + rect.size.height - point.y * rect.size.height
    )
}

private extension UInt32 {
    
    static func random(_ range: Range<UInt32>) -> UInt32 {
        return arc4random_uniform(range.upperBound - range.lowerBound) + range.lowerBound
    }
    
}

private extension CGFloat {
    
    static func random(_ range: Range<CGFloat>) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
    }
    
}
