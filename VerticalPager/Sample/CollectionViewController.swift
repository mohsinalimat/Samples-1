//
//  CollectionViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/23/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
    }
    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! Cell
        
        
        
        return cell
    }
    
}

// MARK: - Cell
private class Cell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.contentView.bounds
        imageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
}
