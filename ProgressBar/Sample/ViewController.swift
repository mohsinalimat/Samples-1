//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/4/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: ProgressBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressBar.backgroundColor = UIColor(white: 0.9, alpha: 1)
        progressBar.foregroundColor = UIColor(red: 0, green: 0.46, blue: 0.76, alpha: 1)
        progressBar.cornerRadius = progressBar.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBar.progress = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class ProgressBar: UIView {
    
    private lazy var progressShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.cornerRadius = shape.frame.height / 2
        shape.backgroundColor = self.tintColor.cgColor
//        shape.strokeColor = self.tintColor.cgColor
//        shape.lineCap = kCALineCapRound
//        shape.lineWidth = shape.frame.height
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: self.frame.height / 2))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 2))
//        shape.path = path.cgPath
        self.layer.addSublayer(shape)
        return shape
    }()
    
    var progress: CGFloat = 0 {
        didSet {
            update(progress: progress)
        }
    }
    
    var foregroundColor: UIColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    override var tintColor: UIColor! {
        didSet {
            progressShape.strokeColor = tintColor.cgColor
        }
    }
    
    func update(progress: CGFloat) {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [unowned self] in
            self.progressShape.frame.size.width = progress * self.bounds.width
        }, completion: nil)
//        CATransaction.begin()
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.duration = CFTimeInterval(5)
//        animation.toValue = progress
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = kCAFillModeForwards
//        progressShape.add(animation, forKey: "strokeEnd")
        
//        if animated {
//            CATransaction.setAnimationDuration(5)
//        } else {
//            CATransaction.setDisableActions(true)
//        }
//        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
//        progressShape.frame.size.width = progress * self.bounds.width
//        CATransaction.commit()
    }
    
}
