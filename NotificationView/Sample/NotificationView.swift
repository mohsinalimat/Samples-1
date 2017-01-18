//
//  NotificationView.swift
//  Unplanner
//
//  Created by Lasha Efremidze on 11/11/15.
//  Copyright © 2015 StubHubLabs. All rights reserved.
//

import UIKit

private let maskBackgroundColor = UIColor(white: 0.7, alpha: 1)
private let maskBackgroundOpacity: CGFloat = 0.5

class NotificationView: UIView {
    
    @IBOutlet fileprivate weak var backgroundView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .boldSystemFont(ofSize: 15)
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet fileprivate weak var subtitleLabel: UILabel! {
        didSet {
            subtitleLabel.font = .boldSystemFont(ofSize: 18)
            subtitleLabel.textColor = .white
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
        }
    }
    @IBOutlet fileprivate weak var backgroundViewTopConstraint: NSLayoutConstraint! {
        didSet {
            backgroundViewTopConstraint.constant = -UIScreen.main.bounds.height
        }
    }
    
    fileprivate var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    fileprivate var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    fileprivate var timer: Timer?
    fileprivate var top: NSLayoutConstraint?
    fileprivate var initialY: CGFloat = 0
    fileprivate var hideAfter: TimeInterval = 0
    
    fileprivate static let window: Window = {
        let window = Window()
        window.windowLevel = UIWindowLevelAlert
        window.backgroundColor = .clear
        window.backgroundView.backgroundColor = maskBackgroundColor
        window.addGestureRecognizer(UITapGestureRecognizer { recognizer in
            window.subviews.forEach { ($0 as? NotificationView)?.hide() }
        })
        return window
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 0.01
        self.layer.shadowOpacity = 0.1
        
        self.addGestureRecognizer(UITapGestureRecognizer { [unowned self] recognizer in
            self.hide()
        })
        
        self.addGestureRecognizer(UIPanGestureRecognizer { [unowned self] recognizer in
            guard let recognizer = recognizer as? UIPanGestureRecognizer else { return }
            switch recognizer.state {
            case .began:
                self.timer?.invalidate()
                self.initialY = self.frame.origin.y
            case .changed:
                let translation = recognizer.translation(in: type(of: self).window)
                let top = self.initialY + translation.y
                if top > 0 {
                    self.top?.constant = top * 0.2
                } else {
                    self.top?.constant = top
                }
            case .ended:
                if self.frame.origin.y < 0 {
                    self.hide()
                } else {
                    self.hideAfter(self.hideAfter)
                    self.top?.constant = 0
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
                        type(of: self).window.layoutIfNeeded()
                    }, completion: nil)
                }
            case .failed, .cancelled:
                self.hideAfter(2.0)
            default: break
            }
        })
    }
    
    class func show(title: String, subtitle: String, backgroundColor: UIColor, hideAfter: TimeInterval = 4) {
        let view = NotificationView.nib()
        view.backgroundView.backgroundColor = backgroundColor
        view.title = title
        view.subtitle = subtitle
        view.hideAfter = hideAfter
        view.show()
        view.hideAfter(hideAfter)
    }
    
    func show() {
        let window = NotificationView.window
        
        window.frame = UIScreen.main.bounds
        window.isHidden = false
        window.addSubview(self)
        
        top = topAnchor.constraint(equalTo: superview!.topAnchor)
        
        constrain {[
            top!,
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor)
        ]}
        
        top?.constant = -frame.height
        window.layoutIfNeeded()
        
        window.backgroundView.alpha = 0
        top?.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: {
            window.layoutIfNeeded()
            window.backgroundView.alpha = maskBackgroundOpacity
        }, completion: nil)
    }
    
    func hide() {
        let window = NotificationView.window
        
        timer?.invalidate()
        
        top?.constant = -frame.height
        UIView.animate(withDuration: 0.25, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
            window.layoutIfNeeded()
            window.backgroundView.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
            window.isHidden = true
        })
    }
    
    func hideAfter(_ interval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
}

private class Window: UIWindow {
    
    lazy var backgroundView: UIView = { [unowned self] in
        let view = UIView()
        self.addSubview(view)
        view.constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor)
        ]}
        return view
    }()
    
}

private extension UIView {
    
    class func nib() -> Self {
        return nib(self)
    }
    
    private class func nib<T>(_ type: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: type), owner: nil, options: nil)!.first as! T
    }
    
}
