//
//  NotificationView.swift
//  Unplanner
//
//  Created by Lasha Efremidze on 11/11/15.
//  Copyright © 2015 StubHubLabs. All rights reserved.
//

import UIKit

private let maskBackgroundColor = UIColor(red: 56, green: 57, blue: 57)
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
            subtitleLabel.font = .boldSystemFont(ofSize: 15)
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
    
}

// MARK: - Public
extension NotificationView {
    
    class func show(title: String, subtitle: String, backgroundColor: UIColor, hideAfter: TimeInterval = 2.0) {
        let view = NotificationView.nib()
        view.backgroundView.backgroundColor = backgroundColor
        view.title = title
        view.subtitle = subtitle
        view.layer.addDropShadow()
        
        view.addGestureRecognizer(UITapGestureRecognizer { recognizer in
            view.hide()
        })
        
        view.addGestureRecognizer(UIPanGestureRecognizer { recognizer in
            guard let recognizer = recognizer as? UIPanGestureRecognizer else { return }
            switch recognizer.state {
            case .began:
                view.timer?.invalidate()
                view.initialY = view.frame.origin.y
            case .changed:
                let translation = recognizer.translation(in: window)
                let top = view.initialY + translation.y
                if top > 0 {
                    view.top?.constant = top * 0.2
                } else {
                    view.top?.constant = top
                }
            case .ended:
                if view.frame.origin.y < 0 {
                    view.hide()
                } else {
                    view.hideAfter(hideAfter)
                    view.top?.constant = 0
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.allowUserInteraction], animations: { 
                        window.layoutIfNeeded()
                    }, completion: nil)
                }
            case .failed, .cancelled:
                view.hideAfter(2.0)
            default: break
            }
        })
        
        view.show()
        view.hideAfter(hideAfter)
    }
    
}

// MARK: -
extension NotificationView {
    
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
        }) { finished in
            self.removeFromSuperview()
            window.isHidden = true
        }
    }
    
    func hideAfter(_ interval: TimeInterval) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
}

private class Window: UIWindow {
    
    let backgroundView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    func initialize() {
        self.addSubview(backgroundView)
        backgroundView.constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor)
        ]}
    }
    
}

private extension UIView {
    
    class func loadFromNibNamed<T: UIView>(_ name: String, owner: Any? = nil) -> T {
        return Bundle.main.loadNibNamed(name, owner: owner, options: nil)!.first as! T
    }
    
    class func nib(owner: Any? = nil) -> Self {
        return loadFromNibNamed(String(describing: self), owner: owner)
    }
    
    @discardableResult
    func constrain(constraints: (UIView) -> [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self))
    }
    
}

private extension CALayer {
    
    func addDropShadow() {
        shadowOffset = CGSize(width: 0, height: 0.5)
        shadowColor = UIColor.black.cgColor
        shadowRadius = 0.01
        shadowOpacity = 0.1
    }
    
}

extension NSAttributedString {
    
    convenience init(string str: String, minimumLineHeight: CGFloat, alignment: NSTextAlignment = .natural) {
        self.init(string: str, attributes: [NSParagraphStyleAttributeName: NSMutableParagraphStyle(minimumLineHeight: minimumLineHeight, alignment: alignment)])
    }
    
}

extension NSMutableParagraphStyle {
    
    convenience init(minimumLineHeight: CGFloat, alignment: NSTextAlignment = .natural) {
        self.init()
        self.minimumLineHeight = minimumLineHeight
        self.alignment = alignment
    }
    
}

class MultilineLabel: UILabel {
    
    var insets = UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
    
}
