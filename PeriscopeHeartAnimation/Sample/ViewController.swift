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
        let layer: CALayer = {
            switch arc4random_uniform(2) {
            case 0:
                let layer = CATextLayer()
                layer.frame.size = CGSize(width: 30, height: 30)
                layer.string = "+10"
                layer.fontSize = 16
                layer.foregroundColor = UIColor.red.cgColor
                layer.alignmentMode = kCAAlignmentCenter
                layer.contentsScale = UIScreen.main.scale
                self.view.layer.addSublayer(layer)
                return layer
            default:
                let layer = CALayer()
                layer.frame.size = CGSize(width: 30, height: 30)
                layer.contents = UIImage(named: "heart")?.cgImage
                self.view.layer.addSublayer(layer)
                return layer
            }
        }()
        
        let duration = 4 + TimeInterval(random(-1..<1))
        let delay = duration / 2
        
        let position = CAKeyframeAnimation(keyPath: "position")
        position.path = verticalSinePath(in: self.view.bounds).cgPath
        position.duration = duration
        position.fillMode = kCAFillModeForwards
        position.isRemovedOnCompletion = false
        layer.add(position, forKey: "position")
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0
        opacity.beginTime = CACurrentMediaTime() + delay
        opacity.duration = duration - delay - 0.5
        opacity.fillMode = kCAFillModeForwards
        opacity.isRemovedOnCompletion = false
        layer.add(opacity, forKey: "opacity")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double(random(-1..<1) * .pi * 0.2)
        rotation.duration = duration
        rotation.fillMode = kCAFillModeForwards
        rotation.isRemovedOnCompletion = false
        layer.add(rotation, forKey: "rotation")
    }
    
}

func verticalSinePath(in rect: CGRect) -> UIBezierPath {
    let offset = random(0..<(.pi * 2))
    let amplitude = 0.3 + random(-0.1..<0.1)
    return parametricPath(in: rect) { CGPoint(x: (amplitude * sin(offset + $0 * .pi * 2) + 1) / 2, y: $0) }
}

func parametricPath(in rect: CGRect, function: (CGFloat) -> (CGPoint)) -> UIBezierPath {
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

func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
    return CGPoint(
        x: rect.origin.x + point.x * rect.size.width,
        y: rect.origin.y + rect.size.height - point.y * rect.size.height
    )
}

func random(_ range: Range<CGFloat>) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
}
