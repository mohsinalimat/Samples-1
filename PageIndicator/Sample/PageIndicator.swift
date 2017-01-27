//
//  PageIndicator.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/27/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class PageIndicator: UIControl {
    
    typealias Section = Int
    typealias Page = (section: Section, index: Int)
    
    var numberOfSections: Int = 0
    var numberOfPagesInSection: ((Section) -> Int) = { _ in 0 }
    
    var currentPage: Page = (0, 0) {
        didSet {
            let indexPath = IndexPath(item: currentPage.index, section: currentPage.section)
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) == false {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            }
        }
    }
    
    var pageIndicatorTintColor: ((Page) -> UIColor?)?
    var currentPageIndicatorTintColor: ((Page) -> UIColor?)?
    
    var pageIndicatorSize: CGSize {
        get { return layout.itemSize }
        set { layout.itemSize = newValue }
    }
    
    var pageIndicatorSpacing: CGFloat {
        get { return layout.minimumLineSpacing }
        set { layout.minimumLineSpacing = newValue }
    }
    
    var sectionSpacing: CGFloat {
        get { return layout.sectionInset.top }
        set { layout.sectionInset = UIEdgeInsets.all(newValue) }
    }
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
        self.addSubview(collectionView)
        return collectionView
    }()
    
    fileprivate var layout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .clear
        
        pageIndicatorSize = CGSize(width: 5, height: 5)
        pageIndicatorSpacing = 8
        sectionSpacing = 10
    }
    
    func fillItemAtIndexPath(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else { return }
        cell.setFilled(true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension PageIndicator: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPagesInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        let page = (indexPath.section, indexPath.item)
        cell.tintColor = pageIndicatorTintColor?(page)
        cell.selectedTintColor = currentPageIndicatorTintColor?(page)
        cell.circleShape.fillColor = UIColor.clear.cgColor
        return cell
    }
    
}

// MARK: - Cell
private class Cell: UICollectionViewCell {
    
    lazy var circleShape: CAShapeLayer = { [unowned self] in
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = UIBezierPath(ovalIn: self.bounds).cgPath
        self.layer.addSublayer(shape)
        return shape
    }()
    
    override var tintColor: UIColor? {
        didSet {
            circleShape.fillColor = tintColor?.cgColor
            circleShape.strokeColor = tintColor?.cgColor
        }
    }
    
    var selectedTintColor: UIColor?
    
    override var isSelected: Bool {
        didSet {
            if isSelected == oldValue { return }
            _setSelected(isSelected)
        }
    }
    
    func _setSelected(_ selected: Bool) {
        func scaleAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale", layer: circleShape)
            animation.toValue = selected ? 1.5 : 1
            return animation
        }
        
        func fillColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "fillColor", layer: circleShape)
            animation.toValue = (selected ? selectedTintColor : tintColor)?.cgColor
            return animation
        }
        
        func strokeColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "strokeColor", layer: circleShape)
            animation.toValue = (selected ? selectedTintColor : tintColor)?.cgColor
            return animation
        }
        
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [scaleAnimation(), fillColorAnimation(), strokeColorAnimation()]
        circleShape.add(group, forKey: "animations")
    }
    
    func setFilled(_ filled: Bool) {
        func fillColorAnimation() -> CAAnimation {
            let animation = CABasicAnimation(keyPath: "fillColor", layer: circleShape)
            animation.toValue = tintColor?.cgColor
            return animation
        }
        
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.animations = [fillColorAnimation()]
        circleShape.add(group, forKey: "animations")
    }
    
}

// MARK: - CABasicAnimation
private extension CABasicAnimation {
    
    convenience init(keyPath path: String, layer: CALayer) {
        self.init(keyPath: path)
        self.fromValue = layer.presentation()?.value(forKeyPath: path)
    }
    
}

// MARK: - UIEdgeInsets
private extension UIEdgeInsets {
    
    static func all(_ size: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
    
}
