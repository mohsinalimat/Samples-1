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
    public var currentPage: (Section, Int) = (0, 0) {
        didSet {
            collectionView.selectItemAtIndexPath(NSIndexPath(forItem: currentPage.1, inSection: currentPage.0), animated: false, scrollPosition: .None)
        }
    }
    
    public var pageIndicatorTintColor: UIColor?
    public var currentPageIndicatorTintColor: UIColor?
    
    public var pageIndicatorSize: CGSize {
        get { return layout.itemSize }
        set { layout.itemSize = newValue }
    }
    
    public var pageIndicatorSpacing: CGFloat {
        get { return layout.minimumLineSpacing }
        set { layout.minimumLineSpacing = newValue }
    }
    
    public var sectionSpacing: CGFloat {
        get { return layout.sectionInset.top }
        set { layout.sectionInset = UIEdgeInsets(top: newValue, left: newValue, bottom: newValue, right: newValue) }
    }
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        collectionView.backgroundColor = .clearColor()
        collectionView.scrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
        self.addSubview(collectionView)
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
        
        pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
        currentPageIndicatorTintColor = .whiteColor()
        
        pageIndicatorSize = CGSize(width: 16, height: 16)
        pageIndicatorSpacing = 0
        sectionSpacing = 5
    }
    
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
extension PageControl: UICollectionViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? Cell else { return }
        cell.tintColor = pageIndicatorTintColor
        cell.selectedTintColor = currentPageIndicatorTintColor
        cell.circleShape.fillColor = UIColor.clearColor().CGColor
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentPage = (indexPath.section, indexPath.item)
        sendActionsForControlEvents(.ValueChanged)
    }
    
}

// MARK: - Cell
class Cell: UICollectionViewCell {
    
    lazy var circleShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.fillColor = self.tintColor?.CGColor
        shape.strokeColor = self.tintColor?.CGColor
        shape.path = UIBezierPath(ovalInRect: CGRectInset(self.bounds, 5, 5)).CGPath
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
    
    override var selected: Bool {
        didSet {
            if selected == oldValue { return }
            setSelected(selected, animated: true)
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted == oldValue { return }
            circleShape.opacity = highlighted ? 0.2 : 1
        }
    }
    
    var selectedAnimationDuration: NSTimeInterval = 0.25
    
    func setSelected(selected: Bool, animated: Bool) {
        func scaleAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale", layer: circleShape)
            animation.toValue = selected ? 1.5 : 1
            return animation
        }
        
        func fillColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "fillColor", layer: circleShape)
            animation.toValue = (selected ? selectedTintColor : tintColor)?.CGColor
            return animation
        }
        
        func strokeColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "strokeColor", layer: circleShape)
            animation.toValue = (selected ? selectedTintColor : tintColor)?.CGColor
            return animation
        }
        
        let group = CAAnimationGroup()
        group.duration = animated ? CFTimeInterval(selectedAnimationDuration) : 0
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [scaleAnimation(), fillColorAnimation(), strokeColorAnimation()]
        circleShape.addAnimation(group, forKey: "animations")
    }
    
}

// MARK: - CABasicAnimation
private extension CABasicAnimation {
    
    convenience init(keyPath path: String, layer: CALayer) {
        self.init(keyPath: path)
        self.fromValue = (layer.presentationLayer() as? CALayer)?.valueForKeyPath(path)
    }
    
}
