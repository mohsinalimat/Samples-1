//
//  ResizingImageView.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/30/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit
import AVFoundation

class ResizingImageView: UIImageView {
    
    private var heightConstraint: NSLayoutConstraint?
    
    override var image: UIImage? {
        didSet {
            _ = heightConstraint.map { NSLayoutConstraint.deactivate([$0]) }
            var boundingRect = self.bounds
            boundingRect.size.height = .greatestFiniteMagnitude
            let rect = AVMakeRect(aspectRatio: image?.size ?? CGSize(), insideRect: boundingRect)
            heightConstraint = self.heightAnchor.constraint(equalToConstant: rect.height)
            _ = heightConstraint.map { NSLayoutConstraint.activate([$0]) }
        }
    }
    
}
