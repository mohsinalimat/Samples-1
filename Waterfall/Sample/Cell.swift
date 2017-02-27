//
//  Cell.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/29/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.font = .preferredFont(forTextStyle: .body)
        }
    }
    @IBOutlet weak var detailTextLabel: UILabel! {
        didSet {
            let count = Int(arc4random_uniform(10))
            detailTextLabel.text = "\(count) likes"
            detailTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        }
    }
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.setTitle(nil, for: .normal)
            button.setImage(UIImage(named: "star"), for: .normal)
            button.tintColor = UIColor(red: 1, green: 0.77, blue: 0.01, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .white
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 3
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 0.01
        self.layer.shadowOpacity = 0.1
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(_ item: Item) {
        imageView.image = item.image
        textLabel.text = item.title
    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        print("---> 2")
//        print(layoutAttributes.size)
//        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
//        print(layoutAttributes.size)
//        layoutAttributes.size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
//        print(layoutAttributes.size)
//        return layoutAttributes
//    }
    
}
