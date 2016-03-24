//
//  CircularProgressView.swift
//  Sample
//
//  Created by Lasha Efremidze on 3/21/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    private lazy var label: UILabel = { [unowned self] in
        let label = UILabel()
        label.frame = CGRectInset(self.bounds, 40, 40)
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.textAlignment = .Center
        self.addSubview(label)
        
        let shape = CAShapeLayer()
        shape.fillColor = self.tintColor.CGColor
        shape.path = UIBezierPath(ovalInRect: label.bounds).CGPath
        label.layer.insertSublayer(shape, atIndex: 0)
        
        return label
    }()
    
    private lazy var shape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.fillColor = UIColor.clearColor().CGColor
        shape.strokeColor = self.tintColor.CGColor
        shape.lineWidth = 2
        shape.path = self.path.CGPath
        self.layer.addSublayer(shape)
        return shape
    }()
    
    var startAngle: CGFloat = -CGFloat(M_PI_2)
    var endAngle: CGFloat = CGFloat(M_PI) * 2
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
    
    func drawCircleTrack() {
        let path = self.path
        path.lineWidth = 1
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    func setProgress(progress: CGFloat, duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.toValue = progress
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        shape.addAnimation(animation, forKey: "strokeEnd")
        
        let duration = Int(duration)
        label.text = "\(duration)"
        Timer(duration: duration) { [weak self] elapsedTime in
            let time = duration - elapsedTime
            self?.label.text = "\(time)"
        }.start()
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
