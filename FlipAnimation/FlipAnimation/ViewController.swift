//
//  ViewController.swift
//  FlipAnimation
//
//  Created by Lasha Efremidze on 10/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flipView: FlipView! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        flipView.animate(toString: "0") { 
//            self.flipView.animate(toString: "1") {
//                self.flipView.animate(toString: "2") {
//                    
//                }
//            }
//        }
        
        snapshot()
    }
    
    func snapshot() {
        let string = "https://robohash.org/my-own-slug.png?size=50x50"
        let imageView = UIImageView(image: UIImage(data: try! Data(contentsOf: URL(string: string)!))!)
        self.view.addSubview(imageView)
        
        let snapshot = imageView.snapshotView(afterScreenUpdates: true)!
        DispatchQueue.main.async {
            let image = self.snapshotImage(from: snapshot)
            let imageView = UIImageView(image: image)
            imageView.center = self.view.center
            self.view.addSubview(imageView)
        }
//        imageView.removeFromSuperview()
    }
    
    func snapshotImage(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
