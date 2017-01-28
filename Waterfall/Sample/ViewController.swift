//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/27/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

struct Item {
    let image: UIImage
    let title: String
    
    static func make() -> Item {
        return Item(image: randomImage(), title: randomText())
    }
}

class ViewController: UICollectionViewController {
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.collectionView?.showsVerticalScrollIndicator = false
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.collectionView?.collectionViewLayout = layout
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.items = (0...10).map { _ in Item.make() }
            DispatchQueue.main.async { [unowned self] in
                self.collectionView?.reloadData()
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        cell.configure(items[indexPath.item])
        return cell
    }
    
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension ViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let item = items[indexPath.row]
        var size = item.image.size
        return size
    }
    
}

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel! {
        didSet {
            let count = Int(arc4random_uniform(10))
            detailTextLabel.text = "\(count) likes"
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
    
}

private func randomImage() -> UIImage {
    let width = Int(arc4random_uniform(200)) + 100
    let height = Int(arc4random_uniform(200)) + 100
    return URL(string: "https://unsplash.it/\(width)/\(height)/?random").map { try! Data(contentsOf: $0) }.flatMap { UIImage(data: $0) } ?? UIImage()
}

private func randomText() -> String {
    let text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    let length = Int(arc4random_uniform(200)) + 10
    let end = text.characters.index(text.startIndex, offsetBy: length)
    return text.substring(with: (text.startIndex ..< end))
}
