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
    
    private var open = false {
        didSet {
            displayLink?.invalidate()
            displayLink = CADisplayLink(target: self, selector: #selector(refresh))
            displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            
        }
    }
    
    @IBAction func buttonTapped(_: AnyObject) {
        open = !open
    }
    
    func refresh(displayLink: CADisplayLink) {
        
    }

}

private extension ViewController {
    
}

// MARK: - NEW

protocol Liquid {
    var radius: CGFloat { get }
}

private extension ViewController {
    
//    typealias LiquidView = protocol<T: Liquid where T: UIView>
    
    func foo<T: Liquid where T: UIView>(view: T) {
        view.radius
    }
    
}

// MARK: - OLD

class SimpleCircleLiquidEngine {
    
    let radiusThresh: CGFloat
    private var layer: CALayer = CAShapeLayer()
    
    var viscosity: CGFloat = 0.65
    var color = UIColor.redColor()
    var angleOpen: CGFloat = 1.0
    
    let ConnectThresh: CGFloat = 0.3
    var angleThresh: CGFloat   = 0.5
    
    init(radiusThresh: CGFloat, angleThresh: CGFloat) {
        self.radiusThresh = radiusThresh
        self.angleThresh = angleThresh
    }
    
    func push(circle: LiquittableCircle, other: LiquittableCircle) -> [LiquittableCircle] {
        if let paths = generateConnectedPath(circle, other: other) {
            let layers = paths.map(self.constructLayer)
            layers.forEach(layer.addSublayer)
            return [circle, other]
        }
        return []
    }
    
    func draw(parent: UIView) {
        parent.layer.addSublayer(layer)
    }
    
    func clear() {
        layer.removeFromSuperlayer()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layer = CAShapeLayer()
    }
    
    func constructLayer(path: UIBezierPath) -> CALayer {
        let pathBounds = CGPathGetBoundingBox(path.CGPath);
        
        let shape = CAShapeLayer()
        shape.fillColor = self.color.CGColor
        shape.path = path.CGPath
        shape.frame = CGRect(x: 0, y: 0, width: pathBounds.width, height: pathBounds.height)
        
        return shape
    }
    
    private func circleConnectedPoint(circle: LiquittableCircle, other: LiquittableCircle, angle: CGFloat) -> (CGPoint, CGPoint) {
        let vec = other.center.minus(circle.center)
        let radian = atan2(vec.y, vec.x)
        let p1 = circle.circlePoint(radian + angle)
        let p2 = circle.circlePoint(radian - angle)
        return (p1, p2)
    }
    
    private func circleConnectedPoint(circle: LiquittableCircle, other: LiquittableCircle) -> (CGPoint, CGPoint) {
        var ratio = circleRatio(circle, other: other)
        ratio = (ratio + ConnectThresh) / (1.0 + ConnectThresh)
        let angle = CGFloat(M_PI_2) * angleOpen * ratio
        return circleConnectedPoint(circle, other: other, angle: angle)
    }
    
    func generateConnectedPath(circle: LiquittableCircle, other: LiquittableCircle) -> [UIBezierPath]? {
        if isConnected(circle, other: other) {
            let ratio = circleRatio(circle, other: other)
            switch ratio {
            case angleThresh...1.0:
                if let path = normalPath(circle, other: other) {
                    return [path]
                }
                return nil
            case 0.0..<angleThresh:
                return splitPath(circle, other: other, ratio: ratio)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func normalPath(circle: LiquittableCircle, other: LiquittableCircle) -> UIBezierPath? {
        let (p1, p2) = circleConnectedPoint(circle, other: other)
        let (p3, p4) = circleConnectedPoint(other, other: circle)
        if let crossed = CGPoint.intersection(p1, to: p3, from2: p2, to2: p4) {
            return withBezier { path in
                let r = self.circleRatio(circle, other: other)
                path.moveToPoint(p1)
                let r1 = p2.mid(p3)
                let r2 = p1.mid(p4)
                let rate = (1 - r) / (1 - self.angleThresh) * self.viscosity
                let mul = r1.mid(crossed).split(r2, ratio: rate)
                let mul2 = r2.mid(crossed).split(r1, ratio: rate)
                path.addQuadCurveToPoint(p4, controlPoint: mul)
                path.addLineToPoint(p3)
                path.addQuadCurveToPoint(p2, controlPoint: mul2)
            }
        }
        return nil
    }
    
    private func splitPath(circle: LiquittableCircle, other: LiquittableCircle, ratio: CGFloat) -> [UIBezierPath] {
        let (p1, p2) = circleConnectedPoint(circle, other: other, angle: CGMath.degToRad(60))
        let (p3, p4) = circleConnectedPoint(other, other: circle, angle: CGMath.degToRad(60))
        
        if let crossed = CGPoint.intersection(p1, to: p3, from2: p2, to2: p4) {
            let (d1, _) = self.circleConnectedPoint(circle, other: other, angle: 0)
            let (d2, _) = self.circleConnectedPoint(other, other: circle, angle: 0)
            let r = (ratio - ConnectThresh) / (angleThresh - ConnectThresh)
            
            let a1 = d2.split(crossed, ratio: (r * r))
            let part = withBezier { path in
                path.moveToPoint(p1)
                path.addQuadCurveToPoint(p2, controlPoint: a1)
            }
            let a2 = d1.split(crossed, ratio: (r * r))
            let part2 = withBezier { path in
                path.moveToPoint(p3)
                path.addQuadCurveToPoint(p4, controlPoint: a2)
            }
            return [part, part2]
        }
        return []
    }
    
    private func circleRatio(circle: LiquittableCircle, other: LiquittableCircle) -> CGFloat {
        let distance = other.center.minus(circle.center).length()
        let ratio = 1.0 - (distance - radiusThresh) / (circle.radius + other.radius + radiusThresh)
        return min(max(ratio, 0.0), 1.0)
    }
    
    func isConnected(circle: LiquittableCircle, other: LiquittableCircle) -> Bool {
        let distance = circle.center.minus(other.center).length()
        return distance - circle.radius - other.radius < radiusThresh
    }
    
}

public class LiquittableCircle : UIView {
    
    var points: [CGPoint] = []
    var radius: CGFloat {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    var color: UIColor = UIColor.redColor() {
        didSet {
            setup()
        }
    }
    
    override public var center: CGPoint {
        didSet {
            self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
            setup()
        }
    }
    
    let circleLayer = CAShapeLayer()
    init(center: CGPoint, radius: CGFloat, color: UIColor) {
        let frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        self.radius = radius
        self.color = color
        super.init(frame: frame)
        setup()
        self.layer.addSublayer(circleLayer)
        self.opaque = false
    }
    
    init() {
        self.radius = 0
        super.init(frame: CGRectZero)
        setup()
        self.layer.addSublayer(circleLayer)
        self.opaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.frame = CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius)
        drawCircle()
    }
    
    func drawCircle() {
        let bezierPath = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: radius * 2, height: radius * 2)))
        draw(bezierPath)
    }
    
    func draw(path: UIBezierPath) -> CAShapeLayer {
        circleLayer.lineWidth = 3.0
        circleLayer.fillColor = self.color.CGColor
        circleLayer.path = path.CGPath
        return circleLayer
    }
    
    func circlePoint(rad: CGFloat) -> CGPoint {
        return CGMath.circlePoint(center, radius: radius, rad: rad)
    }
    
    public override func drawRect(rect: CGRect) {
        drawCircle()
    }
    
}

func withBezier(f: (UIBezierPath) -> ()) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    f(bezierPath)
    bezierPath.closePath()
    return bezierPath
}

class CGMath {
    static func radToDeg(rad: CGFloat) -> CGFloat {
        return rad * 180 / CGFloat(M_PI)
    }
    
    static func degToRad(deg: CGFloat) -> CGFloat {
        return deg * CGFloat(M_PI) / 180
    }
    
    static func circlePoint(center: CGPoint, radius: CGFloat, rad: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(rad)
        let y = center.y + radius * sin(rad)
        return CGPoint(x: x, y: y)
    }
    
    static func linSpace(from: CGFloat, to: CGFloat, n: Int) -> [CGFloat] {
        var values: [CGFloat] = []
        for i in 0..<n {
            values.append((to - from) * CGFloat(i) / CGFloat(n - 1) + from)
        }
        return values
    }
}

extension CGPoint {
    
    // 足し算
    func plus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
    
    // 引き算
    func minus(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
    }
    
    func minusX(dx: CGFloat) -> CGPoint {
        return CGPoint(x: self.x - dx, y: self.y)
    }
    
    func minusY(dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y - dy)
    }
    
    // 掛け算
    func mul(rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * rhs, y: self.y * rhs)
    }
    
    // 割り算
    func div(rhs: CGFloat) -> CGPoint {
        return CGPoint(x: self.x / rhs, y: self.y / rhs)
    }
    
    // 長さ
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    // 正規化
    func normalized() -> CGPoint {
        return self.div(self.length())
    }
    
    // 内積
    func dot(point: CGPoint) -> CGFloat {
        return self.x * point.x + self.y * point.y
    }
    
    // 外積
    func cross(point: CGPoint) -> CGFloat {
        return self.x * point.y - self.y * point.x
    }
    
    func split(point: CGPoint, ratio: CGFloat) -> CGPoint {
        return self.mul(ratio).plus(point.mul(1.0 - ratio))
    }
    
    func mid(point: CGPoint) -> CGPoint {
        return split(point, ratio: 0.5)
    }
    
    static func intersection(from: CGPoint, to: CGPoint, from2: CGPoint, to2: CGPoint) -> CGPoint? {
        let ac = CGPoint(x: to.x - from.x, y: to.y - from.y)
        let bd = CGPoint(x: to2.x - from2.x, y: to2.y - from2.y)
        let ab = CGPoint(x: from2.x - from.x, y: from2.y - from.y)
        let bc = CGPoint(x: to.x - from2.x, y: to.y - from2.y)
        
        let area = bd.cross(ab)
        let area2 = bd.cross(bc)
        
        if abs(area + area2) >= 0.1 {
            let ratio = area / (area + area2)
            return CGPoint(x: from.x + ratio * ac.x, y: from.y + ratio * ac.y)
        }
        
        return nil
    }
    
}
