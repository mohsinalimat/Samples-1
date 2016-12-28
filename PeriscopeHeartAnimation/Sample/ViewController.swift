//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 12/19/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(invoke)))
    }
    
    @IBAction func invoke(_ recognizer: UIGestureRecognizer) {
        addLayer(duration: 8, durationRange: 0, amplitude: 0.5, amplitudeRange: 0.2, wavelength: 0.5, wavelengthRange: 0.2, rotationRange: 0.2)
    }
    
    func addLayer(duration: TimeInterval, durationRange: TimeInterval, amplitude: CGFloat, amplitudeRange: CGFloat, wavelength: CGFloat, wavelengthRange: CGFloat, rotationRange: CGFloat) {
        let rect = self.view.bounds.insetBy(dx: 20, dy: 20)
        let offset = CGFloat(arc4random_uniform(2)) * .pi // left or right curve
        let amplitude = amplitude + Random.random(amplitudeRange)
        let wavelength = wavelength + Random.random(wavelengthRange)
        let path = Path.verticalSinePath(in: rect, offset: offset, amplitude: amplitude, wavelength: wavelength).cgPath
        let duration = duration + Random.random(durationRange)
        let rotation = Double(Random.random(rotationRange) * .pi)
        addTrack(path: path, duration: duration, delay: duration / 2)
        let layer = addPiece(path: path, duration: duration, delay: duration / 2, rotation: rotation)
        layer.position = Path.verticalSinePath(in: rect, offset: offset, amplitude: amplitude, wavelength: wavelength, angle: 0)
        layer.float(path: path, duration: duration, delay: duration / 2, rotation: rotation)
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
    
    func addPiece(path: CGPath, duration: TimeInterval, delay: TimeInterval, rotation: Double) -> CALayer {
        let layer: CALayer = {
            switch arc4random_uniform(2) {
            case 0:
                let layer = CATextLayer()
                layer.string = "+10"
                layer.fontSize = 16
                layer.foregroundColor = UIColor.red.cgColor
                layer.alignmentMode = kCAAlignmentCenter
                return layer
            default:
                let layer = CALayer()
                layer.contents = UIImage(named: "heart")?.cgImage
                return layer
            }
        }()
        layer.frame.size = CGSize(width: 30, height: 30)
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.view.layer.addSublayer(layer)
        return layer
    }
    
}

extension CALayer {
    
    func float(path: CGPath, duration: TimeInterval, delay: TimeInterval, rotation: Double) {
        Animations.showAnimation(layer: self, duration: 1) {
            Animations.positionAnimation(layer: self, path: path, duration: duration, delay: delay, rotation: rotation) {
                self.removeFromSuperlayer()
            }
        }
    }
    
}

extension CGPoint {
    
    /// convert sine wave to CGPoint
    func `in`(rect: CGRect) -> CGPoint {
        return CGPoint(
            x: rect.origin.x + self.x * rect.size.width,
            y: rect.origin.y + self.y * rect.size.height
        )
    }
    
}

struct Random {
    
    static func random(_ range: Double) -> Double {
        return Double(random(CGFloat(range)))
    }
    
    static func random(_ range: CGFloat) -> CGFloat {
        return random(-range..<range)
    }
    
    static func random(_ range: Range<CGFloat>) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
    }
    
}

struct Path {
    
    static func verticalSinePath(in rect: CGRect, offset: CGFloat, amplitude: CGFloat, wavelength: CGFloat) -> UIBezierPath {
        return parametricPath(in: rect) { verticalSinePath(in: rect, offset: offset, amplitude: amplitude, wavelength: wavelength, angle: $0) }
    }
    
    static func verticalSinePath(in rect: CGRect, offset: CGFloat, amplitude: CGFloat, wavelength: CGFloat, angle: CGFloat) -> CGPoint {
        let width = rect.width / 2
        let origin = CGPoint(x: width, y: rect.height)
        let x = origin.x + sin(offset + angle / 360 * .pi * 2 * 1 / wavelength) * width * amplitude
        let y = origin.y - angle / 360 * rect.height
        return CGPoint(x: x, y: y)
    }
    
    static func parametricPath(in rect: CGRect, function: (CGFloat) -> (CGPoint)) -> UIBezierPath {
        let path = UIBezierPath()
        let result = function(0)
        path.move(to: CGPoint(x: result.x, y: result.y))
        for angle: CGFloat in stride(from: 5, through: 360, by: 5) {
            let result = function(angle)
            path.addLine(to: CGPoint(x: result.x, y: result.y))
        }
        return path
    }
    
}

struct Animations {
    
    static func showAnimation(layer: CALayer, duration: TimeInterval, completion: @escaping () -> ()) {
        func scaleAnimation() -> CAAnimation {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = 0
            animation.toValue = 1
            animation.damping = 10
            return animation
        }
        
        func opacityAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = 1
            return animation
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [scaleAnimation(), opacityAnimation()]
        layer.add(group, forKey: "animations")
        
        CATransaction.commit()
    }
    
    static func positionAnimation(layer: CALayer, path: CGPath, duration: TimeInterval, delay: TimeInterval, rotation: Double, completion: @escaping () -> ()) {
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
        CATransaction.setCompletionBlock(completion)
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [positionAnimation(), opacityAnimation(), rotationAnimation()]
        layer.add(group, forKey: "animations")
        
        CATransaction.commit()
    }
    
}
