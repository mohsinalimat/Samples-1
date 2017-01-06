//
//  ProgressView.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/6/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    private lazy var progressView: UIView = { [unowned self] in
        let view = UIView()
        view.frame = self.bounds
        self.addSubview(view)
        return view
    }()
    
    override var tintColor: UIColor! {
        didSet {
            progressView.backgroundColor = tintColor
        }
    }
    
    var foregroundColor: UIColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
            progressView.layer.cornerRadius = newValue
        }
    }
    
    private(set) var progress: Float = 0 // 0.0 .. 1.0, default is 0.0.
    
    func setProgress(_ progress: Float, animated: Bool) {
        if animated {
            let duration = TimeInterval(abs(self.progress - progress))
            UIView.animate(withDuration: duration) { [unowned self] in
                self.setProgress(progress, animated: false)
            }
        } else {
            progressView.frame.size.width = self.bounds.width * CGFloat(progress)
            self.progress = progress
        }
    }
    
}
