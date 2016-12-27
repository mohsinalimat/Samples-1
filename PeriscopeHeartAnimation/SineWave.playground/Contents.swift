//: Playground - noun: a place where people can play

import UIKit

class SineView: UIView {
    let amplitude: CGFloat = 0.5
    let wavelength: CGFloat = 0.5
    
    override func draw(_ rect: CGRect) {
        let height = rect.height / 2
        
        let origin = CGPoint(x: 0, y: height)
        
        let path = UIBezierPath()
        path.move(to: origin)
        
        for angle: CGFloat in stride(from: 5, through: 360, by: 5) {
//        (1 ..< 360).map { CGFloat($0) }.forEach { angle in
            let x = origin.x + angle / 360 * rect.width
            let y = origin.y - sin(angle / 360 * .pi * 2 * 1 / wavelength) * height * amplitude
//            let y = origin.y - sin(angle / 360 * .pi * 2) * height
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
//        CGPoint(x: (amplitude * sin(offset + wavelength * $0 * .pi * 2) + 1) / 2, y: $0)
        
        UIColor.black.setStroke()
        path.stroke()
    }
}

let sineView = SineView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
sineView.backgroundColor = .white
