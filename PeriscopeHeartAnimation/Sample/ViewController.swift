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
        
    }
    
}

private extension CGRect {
    
//    func path() -> UIBezierPath {
//        let amplitude = 3
//        let amplitudeRange = 12
//        
//        let path = UIBezierPath()
//        let offset = CGFloat(arc4random() % 1000)
//        let finalAmplitude: CGFloat = amplitude + Int(arc4random()) % amplitudeRange * 2 - amplitudeRange
//        var delta: CGFloat = 0
//        var y = height
//        while y >= 0  {
//            let x = finalAmplitude * sinf((y + offset) * M_PI / 180)
//            if y == height {
//                delta = x
//                path.move(to: CGPoint(x: midX, y: y))
//            } else {
//                path.addLineToPoint(CGPoint(x: x + midX - delta, y: y))
//            }
//            y = y - 1
//        }
//        return path
//    }
    
//    func travelPath(inView view: UIView) -> UIBezierPath? {
//        guard let endPointDirection = RotationDirection(rawValue: CGFloat(1 - Int(2 * randomNumber(2)))) else { return nil }
//        
//        let heartCenterX = center.x
//        let heartSize = bounds.width
//        let viewHeight = view.bounds.height
//        
//        //random end point
//        let endPointX = heartCenterX + (endPointDirection.rawValue * randomNumber(2 * heartSize))
//        let endPointY = viewHeight / 8.0 + randomNumber(viewHeight / 4.0)
//        let endPoint = CGPoint(x: endPointX, y: endPointY)
//        
//        //random Control Points
//        let travelDirection = CGFloat(1 - Int(2 * randomNumber(2)))
//        let xDelta = (heartSize / 2.0 + randomNumber(2 * heartSize)) * travelDirection
//        let yDelta = max(endPoint.y ,max(randomNumber(8 * heartSize), heartSize))
//        let controlPoint1 = CGPoint(x: heartCenterX + xDelta, y: viewHeight - yDelta)
//        let controlPoint2 = CGPoint(x: heartCenterX - 2 * xDelta, y: yDelta)
//        
//        let path = UIBezierPath()
//        path.moveToPoint(center)
//        path.addCurveToPoint(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
//        return path
//    }
    
}

private extension UInt32 {
    
    static func random(_ upperBound: UInt32) -> UInt32 {
        return random(0..<upperBound)
    }
    
    static func random(_ range: Range<UInt32>) -> UInt32 {
        return arc4random_uniform(range.upperBound - range.lowerBound) + range.lowerBound
    }
    
}
