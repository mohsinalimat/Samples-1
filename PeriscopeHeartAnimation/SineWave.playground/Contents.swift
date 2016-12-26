//: Playground - noun: a place where people can play

import UIKit

class SineView: UIView {
    let graphWidth: CGFloat = 0.8  // Graph is 80% of the width of the view
    let amplitude: CGFloat = 0.3   // Amplitude of sine wave is 30% of view height
    let periods: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)
        
        let path = UIBezierPath()
        path.move(to: origin)
        
        for angle in stride(from: 5.0, through: 360 * periods, by: 5) {
            let x = origin.x + angle / (360 * periods) * width * graphWidth
            let y = origin.y - sin(angle / 180 * .pi) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        UIColor.black.setStroke()
        path.stroke()
    }
}

let sineView = SineView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
sineView.backgroundColor = .white
