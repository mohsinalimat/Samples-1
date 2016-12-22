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
        let path = verticalSinePath(in: self.view.bounds).cgPath
        let duration = 4 + TimeInterval(random(-1..<1))
        addTrack(path: path, duration: duration, delay: duration / 2)
        addPiece(path: path, duration: duration, delay: duration / 2, rotation: Double(random(-1..<1) * .pi * 0.2))
    }
    
    func addTrack(path: CGPath, duration: TimeInterval, delay: TimeInterval) {
        let layer = CAShapeLayer()
        layer.path = path
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.withAlphaComponent(0.2).cgColor
        self.view.layer.addSublayer(layer)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
        }
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration = delay
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey: "opacity")
        
        CATransaction.commit()
    }
    
    func addPiece(path: CGPath, duration: TimeInterval, delay: TimeInterval, rotation: Double) {
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
        
        func positionAnimation() -> CAAnimation {
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.path = path
            return animation
        }
        
        func opacityAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 1
            animation.toValue = 0
            animation.beginTime = delay
            animation.duration = delay
            return animation
        }
        
        func rotationAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = rotation
            return animation
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            layer.removeFromSuperlayer()
        }
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [positionAnimation(), opacityAnimation(), rotationAnimation()]
        layer.add(group, forKey: "animations")
        
        CATransaction.commit()
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
