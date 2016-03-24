//
//  CircularProgressView.swift
//  Sample
//
//  Created by Lasha Efremidze on 3/21/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    private lazy var button: UIButton = { [unowned self] in
        let button = UIButton(type: .Custom)
        button.frame = CGRectInset(self.bounds, 20, 20)
        button.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        button.userInteractionEnabled = false
        button.titleLabel?.font = .boldSystemFontOfSize(18)
        button.backgroundColor = self.tintColor
        button.layer.cornerRadius = button.bounds.width / 2
        button.layer.masksToBounds = true
        self.addSubview(button)
        return button
    }()
    
    private lazy var progressShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.fillColor = UIColor.clearColor().CGColor
        shape.strokeColor = self.tintColor.CGColor
        shape.lineCap = kCALineCapRound
        shape.lineWidth = 3.5
        shape.path = self.path.CGPath
        self.layer.addSublayer(shape)
        return shape
    }()
    
    private lazy var pulseShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.fillColor = self.tintColor.CGColor
        shape.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        self.addPulseAnimation(shape, duration: 1)
        self.layer.addSublayer(shape)
        return shape
    }()
    
    var startAngle: CGFloat = -CGFloat(M_PI_2)
    var endAngle: CGFloat = -CGFloat(M_PI_2) + CGFloat(M_PI) * 2
    var clockwise: Bool = true
    
    private var path: UIBezierPath {
        return UIBezierPath(arcCenter: boundsCenter, radius: boundsCenter.x - 1, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    }
    
    private var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        drawCircleTrack()
    }
    
    func setProgress(progress: CGFloat, duration: Int) {
        let _ = progressShape
        
        button.setTitle("\(duration)", forState: .Normal)
        
        button.transform = CGAffineTransformMakeScale(0.001, 0.001)
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveLinear], animations: {
            self.button.transform = CGAffineTransformIdentity
        }, completion: { _ in
            self.pulseShape.hidden = false
            
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = CFTimeInterval(duration)
            animation.toValue = progress
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            CATransaction.setCompletionBlock {
                self.pulseShape.hidden = true
                
                UIView.animateWithDuration(0.3, delay: 0, options: [.CurveLinear], animations: {
                    self.button.transform = CGAffineTransformMakeScale(0.001, 0.001)
                }, completion: nil)
            }
            self.progressShape.addAnimation(animation, forKey: "strokeEnd")
            CATransaction.commit()
            
            Timer(duration: duration) { [weak self] elapsedTime in
                self?.button.setTitle("\(duration - elapsedTime)", forState: .Normal)
            }.start()
        })
    }
    
    private func drawCircleTrack() {
        let path = self.path
        path.lineWidth = 2
        UIColor(white: 0.895, alpha: 1).setStroke()
        path.stroke()
    }
    
    private func addPulseAnimation(layer: CALayer, duration: Int) {
        if true {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.duration = CFTimeInterval(duration)
            animation.fromValue = 0.55
            animation.toValue = 0.75
            animation.repeatCount = FLT_MAX
            animation.autoreverses = true
            layer.addAnimation(animation, forKey: "transform.scale")
        }
        if true {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.duration = CFTimeInterval(duration)
            animation.fromValue = 0.1
            animation.toValue = 0.2
            animation.repeatCount = FLT_MAX
            animation.autoreverses = true
            layer.addAnimation(animation, forKey: "opacity")
        }
    }
    
}

class Timer {
    
    var timer = NSTimer()
    let duration: Int
    var elapsedTime: Int = 0
    var handler: (Int) -> ()
    
    init(duration: Int, handler: (Int) -> ()) {
        self.duration = duration
        self.handler = handler
    }
    
    deinit {
        timer.invalidate()
    }
    
    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer.invalidate()
    }
    
    @objc func tick() {
        elapsedTime += 1
        handler(elapsedTime)
        if elapsedTime == duration {
            stop()
        }
    }
    
}
