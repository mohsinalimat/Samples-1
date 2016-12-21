//
//  ParallaxHeader.swift
//  ParallaxHeader
//
//  Created by Lasha Efremidze on 10/17/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

//class ParallaxHeader: NSObject {
//    
//    lazy var contentView: UIView = { [unowned self] in
//        let view = ParallaxView()
//        view.parent = self
//        view.clipsToBounds = true
//        return view
//    }()
//    
//    var scrollView: UIScrollView! {
//        didSet {
//            adjustScrollViewTopInset(scrollView.contentInset.top + height)
//            scrollView.addSubview(contentView)
//            layoutContentView()
//        }
//    }
//    
//    var view: UIView! {
//        didSet {
//            updateConstraints()
//        }
//    }
//    
//    var minimumHeight: CGFloat = 0 {
//        didSet {
//            layoutContentView()
//        }
//    }
//    
//    var height: CGFloat = 0 {
//        didSet {
//            adjustScrollViewTopInset(scrollView.contentInset.top - oldValue + height)
//            updateConstraints()
//            layoutContentView()
//        }
//    }
//    
//    enum Mode {
//        case Fill, TopFill, Top, Center, Bottom
//    }
//    
//    var mode: Mode = .Fill
//
//    func updateConstraints() {
//        view.removeFromSuperview()
//        contentView.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        let views = ["view": view]
//        let metrics: [String: AnyObject] = ["height": height, "highPriority": UILayoutPriorityDefaultHigh]
//        switch mode {
//        case .Fill:
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
//        case .TopFill:
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(>=height)]-0.0@highPriority-|", options: [], metrics: metrics, views: views))
//        case .Top:
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(==height)]", options: [], metrics: metrics, views: views))
//        case .Center:
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
//            contentView.addConstraint(view.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor))
//            contentView.addConstraint(view.heightAnchor.constraintEqualToConstant(height))
//        case .Bottom:
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
//            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==height)]|", options: [], metrics: metrics, views: views))
//        }
//    }
//
//    func layoutContentView() {
//        let offset = scrollView.contentOffset.y + scrollView.contentInset.top - height
//        contentView.frame.origin.y = offset
//        contentView.frame.size.height = max(-offset, min(minimumHeight, height))
//    }
//    
//    func adjustScrollViewTopInset(top: CGFloat) {
//        var inset = scrollView.contentInset
//        var offset = scrollView.contentOffset
//        offset.y += inset.top - top
//        self.scrollView.contentOffset = offset
//        inset.top = top
//        scrollView.contentInset = inset
//    }
//
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "contentOffset" {
//            layoutContentView()
//        } else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
//    
//}
//
//private class ParallaxView: UIView {
//    
//    var parent: ParallaxHeader!
//    
//    override func willMoveToSuperview(newSuperview: UIView?) {
//        if let view = self.superview as? UIScrollView {
//            view.removeObserver(parent, forKeyPath: "contentOffset", context: nil)
//        }
//    }
//    
//    override func didMoveToSuperview() {
//        if let view = self.superview as? UIScrollView {
//            view.addObserver(parent, forKeyPath: "contentOffset", options: .New, context: nil)
//        }
//    }
//    
//}
//
//class ScrollView: UIScrollView {
//    
//    lazy var parallaxHeader: ParallaxHeader = { [unowned self] in
//        let parallaxHeader = ParallaxHeader()
//        parallaxHeader.scrollView = self
//        return parallaxHeader
//    }()
//    
//    private var observedViews = Set<UIScrollView>()
//    private var observing = true
//    private var lock = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        commonInit()
//    }
//    
//    func commonInit() {
//        self.delegate = self
//        self.showsVerticalScrollIndicator = false
//        self.directionalLockEnabled = true
//        self.bounces = true
//        self.panGestureRecognizer.cancelsTouchesInView = false
//        addObserver(self)
//    }
//    
//    deinit {
//        observedViews.forEach { removeObserver($0) }
//        removeObserver(self)
//    }
//    
//}
//
//extension ScrollView: UIScrollViewDelegate {
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if self.contentOffset.y > -parallaxHeader.minimumHeight {
//            self.scrollView(self, setContentOffset: CGPoint(x: self.contentOffset.x, y: -parallaxHeader.minimumHeight))
//        }
//    }
//    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        lock = false
//        observedViews.forEach { removeObserver($0) }
//    }
//    
//}
//
//extension ScrollView: UIGestureRecognizerDelegate {
//    
//    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
//            let velocity = recognizer.velocityInView(self)
//            return abs(velocity.y) > abs(velocity.x)
//        }
//        return true
//    }
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard let scrollView = otherGestureRecognizer.view as? UIScrollView where scrollView != self else { return false }
//        if !observedViews.contains(scrollView) {
//            observedViews.insert(scrollView)
//            addObserver(scrollView)
//        }
//        return true
//    }
//    
//}
//
//extension ScrollView {
//    
//    func scrollView(scrollView: UIScrollView, setContentOffset offset: CGPoint) {
//        observing = false
//        scrollView.contentOffset = offset
//        observing = true
//    }
//    
//    func addObserver(scrollView: UIScrollView) {
//        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.Old, .New], context: nil)
//        lock = scrollView.contentOffset.y > -scrollView.contentInset.top
//    }
//    
//    func removeObserver(scrollView: UIScrollView) {
//        scrollView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
//    }
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "contentOffset" {
//            guard let scrollView = object as? UIScrollView else { return }
//            let new = change?[NSKeyValueChangeNewKey] as? CGPoint ?? CGPoint()
//            let old = change?[NSKeyValueChangeOldKey] as? CGPoint ?? CGPoint()
//            let diff = old.y - new.y
//            if diff == 0 || !observing { return }
//            if self == scrollView {
//                if diff > 0 && lock {
//                    self.scrollView(scrollView, setContentOffset: old)
//                } else if (self.contentOffset.y < -self.contentInset.top) && !self.bounces {
//                    self.scrollView(scrollView, setContentOffset: CGPoint(x: self.contentOffset.x, y: -self.contentInset.top))
//                }
//            } else {
//                lock = scrollView.contentOffset.y > -scrollView.contentInset.top
//                if lock && self.contentOffset.y < -parallaxHeader.minimumHeight && diff < 0 {
//                    self.scrollView(scrollView, setContentOffset: old)
//                }
//                if !lock && ((self.contentOffset.y > -self.contentInset.top) || self.bounces) {
//                    self.scrollView(scrollView, setContentOffset: CGPoint(x: self.contentOffset.x, y: -self.contentInset.top))
//                }
//            }
//        } else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
//    
//}







typealias ScrollViewContentOffsetChangedBlock = CGPoint -> Void
typealias ScrollViewContentSizeChangedBlock = CGSize -> Void

// MARK: - Key Paths
private let contentOffsetKeyPath = "contentOffset"
private let contentSizeKeyPath = "contentSize"

// MARK: - ParallaxHeaderMode
enum ParallaxHeaderMode {
    case Fill, TopFill, Top, Center, Bottom
}

// MARK: - ParallaxHeader
class ParallaxHeader: UIView {
    
    var view: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let view = view else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let views = ["view": view]
            let metrics: [String: AnyObject] = ["height": height, "highPriority": UILayoutPriorityDefaultHigh]
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
            switch mode {
            case .Fill:
                self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
            case .TopFill:
                self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(>=height)]-0.0@highPriority-|", options: [], metrics: metrics, views: views))
            case .Top:
                self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(==height)]", options: [], metrics: metrics, views: views))
            case .Center:
                self.addConstraint(view.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor))
                self.addConstraint(view.heightAnchor.constraintEqualToConstant(height))
            case .Bottom:
                self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==height)]|", options: [], metrics: metrics, views: views))
            }
        }
    }
    var minimumHeight: CGFloat = 0
    var height: CGFloat = 0
    var mode: ParallaxHeaderMode = .Fill
    
    var contentOffsetChangedBlock: ScrollViewContentOffsetChangedBlock?
    var contentSizeChangedBlock: ScrollViewContentSizeChangedBlock?
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        self.superview?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: nil)
        self.superview?.removeObserver(self, forKeyPath: contentSizeKeyPath, context: nil)
        if let newSuperview = newSuperview {
            newSuperview.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .New, context: nil)
            newSuperview.addObserver(self, forKeyPath: contentSizeKeyPath, options: .New, context: nil)
        }
        
        layoutContentView() // TEMP
        adjustScrollViewTopInset() // TEMP
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetKeyPath {
            if let scrollView = object as? UIScrollView {
                contentOffsetChangedBlock?(scrollView.contentOffset)
            }
        } else if keyPath == contentSizeKeyPath {
            if let scrollView = object as? UIScrollView {
                contentSizeChangedBlock?(scrollView.contentSize)
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func layoutContentView() {
        guard let scrollView = self.superview as? UIScrollView else { return }
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top - height
        self.frame.origin.y = offset
        self.frame.size.height = max(-offset, min(minimumHeight, height))
    }
    
    func adjustScrollViewTopInset() {
        guard let scrollView = self.superview as? UIScrollView else { return }
        let top = scrollView.contentInset.top + height
        var inset = scrollView.contentInset
        var offset = scrollView.contentOffset
        offset.y += inset.top - top
        scrollView.contentOffset = offset
        inset.top = top
        scrollView.contentInset = inset
    }
    
}
