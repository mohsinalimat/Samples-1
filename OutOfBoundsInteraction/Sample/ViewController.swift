//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/28/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: 40, height: 40)
                layout.scrollDirection = .Horizontal
            }
            collectionView.clipsToBounds = false
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = .redColor()
        cell.contentView.addGestureRecognizer(UITapGestureRecognizer { recognizer in
            UIView.animateWithDuration(0.1) {
                cell.frame.origin.y = (cell.frame.origin.y == 0 ? -50 : 0)
            }
        })
        return cell
    }
    
}

extension UICollectionView {
    
    override public func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        if !super.pointInside(point, withEvent: event) {
            if let
                indexPath = indexPathForItemAtPoint(point),
                cell = cellForItemAtIndexPath(indexPath)
            {
                return cell.pointInside(point, withEvent: event)
            }
        }
        return true
    }
    
}
