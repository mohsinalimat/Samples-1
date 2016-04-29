//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 4/7/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.backgroundColor = .blueColor()
            button.tintColor = .whiteColor()
            button.layer.cornerRadius = button.bounds.width / 2
            button.layer.masksToBounds = true
        }
    }
    
    private var displayLink: CADisplayLink?
    
//    private var opening = false
    private var open = false {
        didSet {
            displayLink?.invalidate()
            displayLink = CADisplayLink(target: self, selector: #selector(refresh))
            displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    
    private var keyDuration: CGFloat = 0
    
    private var radius: CGFloat = 20
    private var color = UIColor.redColor()

    private lazy var circles: [LiquittableCircle] = { [unowned self] in
        return (0...3).map {
            LiquittableCircle(center: CGPoint(x: self.view.center.x + (CGFloat($0) * 50), y: self.view.center.y), radius: self.radius, color: self.color)
        }
    }()
    
//    var key: CGFloat = 0.0 {
//        didSet {
//            updateKeyframe(self.key)
//        }
//    }
    
    private lazy var baseLiquid: LiquittableCircle = { [unowned self] in
        let circle = LiquittableCircle(center: self.view.center.minus(self.view.frame.origin), radius: self.radius, color: self.color)
        circle.clipsToBounds = false
        circle.layer.masksToBounds = false
        self.view.addSubview(circle)
        return circle
    }()
    
    var engine: SimpleCircleLiquidEngine!
    var bigEngine: SimpleCircleLiquidEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.engine = SimpleCircleLiquidEngine(radiusThresh: radius * 0.73, angleThresh: 0.45)
        self.bigEngine = SimpleCircleLiquidEngine(radiusThresh: radius, angleThresh: 0.55)
        self.engine?.color = self.color
        self.bigEngine?.color = self.color
        
        let _ = self.baseLiquid
        
        let _ = self.circles
    }
    
    @IBAction func buttonTapped(_: AnyObject) {
        open = !open
    }
    
    func refresh(displayLink: CADisplayLink) {
        keyDuration += CGFloat(displayLink.duration)
        
        engine.clear()
        bigEngine.clear()
        
        circles.forEach {
            $0.center.x = self.view.center.x
        }
        
        if let firstCell = circles.first {
            bigEngine?.push(baseLiquid, other: firstCell)
        }
        for i in 1..<circles.count {
            let prev = circles[i - 1]
            let cell = circles[i]
            engine?.push(prev, other: cell)
        }
        engine?.draw(baseLiquid)
        bigEngine?.draw(baseLiquid)
    }
    
//    func updateKeyframe(key: CGFloat) {
//        self.engine?.clear()
//        let movePos = movePosition(key)
//        
//        // move subviews positions
//        moveCircle?.center = movePos
//        shadowCircle?.center = movePos
//        circles.each { circle in
//            if self.moveCircle != nil {
//                self.engine?.push(self.moveCircle!, other: circle)
//            }
//        }
//        
//        resize()
//        
//        // draw and show grow
//        if let parent = loader {
//            self.engine?.draw(parent)
//        }
//        if let shadow = shadowCircle {
//            loader?.bringSubviewToFront(shadow)
//        }
//    }
//    
//    func movePosition(key: CGFloat) -> CGPoint {
//        if loader != nil {
//            return CGPoint(
//                x:  (circles.last!.frame.rightBottom.x + circleInter)  * sineTransform(key),
//                y: loader.frame.height * 0.5
//            )
//        } else {
//            return CGPointZero
//        }
//    }

}
