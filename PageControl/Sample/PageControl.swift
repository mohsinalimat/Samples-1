//
//  PageControl.swift
//  Sample
//
//  Created by Lasha Efremidze on 6/14/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

//UIPageControl

public class PageControl: UIControl {
    
    public typealias Section = Int
    
    public var sections: Int = 0
    public var pages: (Section -> Int) = { _ in 0 }
    public var currentPage: (Section, Int) = (0, 0)
    
    public var pageIndicatorTintColor: UIColor? = UIColor(white: 1, alpha: 0.5)
    public var currentPageIndicatorTintColor: UIColor? = .whiteColor()
    
    public var indicatorSize: CGSize {
        get { return layout.itemSize }
        set { layout.itemSize = newValue }
    }
    
    public var sectionInset: UIEdgeInsets {
        get { return layout.sectionInset }
        set { layout.sectionInset = newValue }
    }
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clearColor()
        collectionView.scrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
        self.addSubview(collectionView)
        let views = ["collectionView": collectionView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
        return collectionView
    }()
    
    var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .clearColor()
        
        indicatorSize = CGSize(width: 7, height: 7)
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}

extension PageControl: UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath)
    }
    
}

extension PageControl: UICollectionViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.tintColor = pageIndicatorTintColor
        cell.selectedTintColor = currentPageIndicatorTintColor
        cell.highlightedTintColor = pageIndicatorTintColor?.colorWithAlphaComponent(0.2)
        cell.circleShape.fillColor = UIColor.clearColor().CGColor
    }
    
}

// MARK: - Cell
class Cell: UICollectionViewCell {
    
    lazy var circleShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.fillColor = self.tintColor?.CGColor
        shape.strokeColor = self.tintColor?.CGColor
        shape.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        self.layer.addSublayer(shape)
        return shape
    }()
    
    override var tintColor: UIColor? {
        didSet {
            circleShape.fillColor = tintColor?.CGColor
            circleShape.strokeColor = tintColor?.CGColor
        }
    }
    
    var selectedTintColor: UIColor?
    var highlightedTintColor: UIColor?
    
    override var selected: Bool {
        didSet {
            if selected == oldValue { return }
            setSelected(selected, animated: true)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted == oldValue { return }
            circleShape.fillColor = highlighted ? highlightedTintColor?.CGColor : tintColor?.CGColor
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        if animated {
            _setSelected(selected, duration: 0.25)
        } else {
            _setSelected(selected, duration: 0)
        }
    }
    
    func _setSelected(selected: Bool, duration: NSTimeInterval) {
        func scaleAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = (circleShape.presentationLayer() as? CALayer)?.valueForKeyPath("transform.scale")
            animation.toValue = selected ? 1.5 : 1
            return animation
        }
        
        func fillColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "fillColor")
            animation.fromValue = (circleShape.presentationLayer() as? CALayer)?.valueForKeyPath("fillColor")
            animation.toValue = (selected ? selectedTintColor : tintColor)?.CGColor
            return animation
        }
        
        func strokeColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "strokeColor")
            animation.fromValue = (circleShape.presentationLayer() as? CALayer)?.valueForKeyPath("strokeColor")
            animation.toValue = (selected ? selectedTintColor : tintColor)?.CGColor
            return animation
        }
        
        let group = CAAnimationGroup()
        group.duration = CFTimeInterval(duration)
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [scaleAnimation(), fillColorAnimation(), strokeColorAnimation()]
        circleShape.addAnimation(group, forKey: "animations")
    }
    
}
