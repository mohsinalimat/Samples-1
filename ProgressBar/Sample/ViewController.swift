//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/4/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: ProgressBar! {
        didSet {
            progressBar.backgroundColor = UIColor(white: 0.9, alpha: 1)
            progressBar.foregroundColor = UIColor(red: 0, green: 0.46, blue: 0.76, alpha: 1)
            progressBar.cornerRadius = progressBar.frame.height / 2
        }
    }
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.trackTintColor = UIColor(white: 0.9, alpha: 1)
            progressView.progressTintColor = UIColor(red: 0, green: 0.46, blue: 0.76, alpha: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let deadlineTime = DispatchTime.now() + .seconds(1)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//            self.progressBar.set(progress: 0.5, animated: true)
//        }
    }
    
}

class ProgressBar: UIView {
    
    private lazy var progressShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.backgroundColor = self.tintColor.cgColor
        shape.cornerRadius = self.cornerRadius
        self.layer.addSublayer(shape)
        return shape
    }()
    
    var progress: Float = 0 {
        didSet {
            setProgress(progress, animated: false)
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            progressShape.strokeColor = tintColor.cgColor
        }
    }
    
    var foregroundColor: UIColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            progressShape.cornerRadius = newValue
        }
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        let animation = CASpringAnimation(keyPath: "bounds")
        animation.fromValue = 0
        animation.toValue = 1
        animation.damping = 10
        animation.duration = 5
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        progressShape.add(animation, forKey: "bounds")
        
//        self.progressShape.frame.size.width = progress * self.bounds.width
    }
    
}
