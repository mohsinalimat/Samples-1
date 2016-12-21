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
//        shape.path = self.view.bounds.path2().cgPath
        shape.path = sinePath(in: self.view.bounds, amplitude: 0.3).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        shape.lineWidth = 2
        self.view.layer.addSublayer(shape)
    }
    
}

private extension CGRect {
    
//    func path() -> UIBezierPath {
//        let amplitude = 3
//        let amplitudeRange = 12
//        
//        let path = UIBezierPath()
//        let offset = CGFloat(arc4random() % 1000)
//        let finalAmplitude: CGFloat = amplitude + arc4random() % amplitudeRange * 2 - amplitudeRange
//        var delta: CGFloat = 0
//        var y = height
//        while y >= 0  {
//            let x = finalAmplitude * sinf((y + offset) * M_PI / 180)
//            if y == height {
//                delta = x
//                path.move(to: CGPoint(x: midX, y: y))
//            } else {
//                path.addLine(to: CGPoint(x: x + midX - delta, y: y))
//            }
//            y = y - 1
//        }
//        return path
//    }
    
    func path2() -> UIBezierPath {
        let centerY = height / 2  // find the vertical center
        let steps = 200                 // Divide the curve into steps
        let stepX = width / CGFloat(steps) // find the horizontal step distance
        // Make a path
        let path = UIBezierPath()
        // Start in the lower left corner
        path.move(to: CGPoint(x: 0, y: centerY))
        // Loop and draw steps in straingt line segments
        for i in 0...steps {
            let x = CGFloat(i) * stepX
            let y = (sin(Double(i) * 0.1) * 40) + Double(centerY)
            path.addLine(to: CGPoint(x: x, y: CGFloat(y)))
        }
        return path
    }
    
}

func parametricPath(in rect: CGRect, count: Int? = nil, function: (CGFloat) -> (CGPoint)) -> UIBezierPath {
    let numberOfPoints = count ?? max(Int(rect.size.width), Int(rect.size.height))
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

func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
    return CGPoint(
        x: rect.origin.x + point.x * rect.size.width,
        y: rect.origin.y + rect.size.height - point.y * rect.size.height
    )
}

func sinePath(in rect: CGRect, count: Int? = nil, amplitude: CGFloat = 1) -> UIBezierPath {
    // note, since sine returns values between -1 and 1, let's add 1 and divide by two to get it between 0 and 1
    return parametricPath(in: rect, count: count) { CGPoint(x: $0, y: (amplitude * sin($0 * .pi * 2) + 1) / 2) }
}

func verticalSinePath(in rect: CGRect, count: Int? = nil, amplitude: CGFloat = 1) -> UIBezierPath {
    // note, since sine returns values between -1 and 1, let's add 1 and divide by two to get it between 0 and 1
    return parametricPath(in: rect, count: count) { CGPoint(x: (amplitude * sin($0 * .pi * 2) + 1) / 2, y: $0) }
}

private extension UInt32 {
    
    static func random(_ upperBound: UInt32) -> UInt32 {
        return random(0..<upperBound)
    }
    
    static func random(_ range: Range<UInt32>) -> UInt32 {
        return arc4random_uniform(range.upperBound - range.lowerBound) + range.lowerBound
    }
    
}
