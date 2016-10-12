//
//  FlipView.swift
//  FlipAnimation
//
//  Created by Lasha Efremidze on 10/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class FlipView: UIView {
    
    private var topHalf: UIView?
    private var bottomHalf: UIView?
    
    func animate(toString string: String, completion: @escaping () -> ()) {
        let view = UILabel(frame: self.bounds)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 4
        view.text = string
        view.textColor = .white
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: 100)
        self.insertSubview(view, at: 0)
        
//        let snapshotView = view.snapshotView(afterScreenUpdates: true)! // doesn't work in xcode 8
        
        let nextTopHalf = view.topHalf()
        let nextBottomHalf = view.bottomHalf()
        self.insertSubview(nextTopHalf, at: 0)
        self.insertSubview(nextBottomHalf, at: 0)
        
        view.removeFromSuperview()
        
//        UIView.animate(withDuration: 1, animations: { [weak self] in
//            var transform = CATransform3DIdentity
//            transform.m34 = -1.0 / 2000.0
//            transform = CATransform3DRotate(transform, CGFloat(-M_PI), 1, 0, 0)
//            self?.topHalf?.layer.transform = transform
//        }, completion: { [weak self] finished in
//            self?.topHalf?.removeFromSuperview()
//            self?.bottomHalf?.removeFromSuperview()
//            self?.topHalf = nextTopHalf
//            self?.bottomHalf = nextBottomHalf
//            completion()
//        })
    }
    
}

private extension UIView {
    
    func topHalf() -> UIView {
        var frame = self.bounds
        frame.size.height /= 2
        return snapshotView(from: frame)
    }
    
    func bottomHalf() -> UIView {
        var frame = self.bounds
        frame.size.height /= 2
        frame.origin.y = frame.height
        let view = snapshotView(from: frame)
        view.frame.origin.y = frame.height
        return view
    }
    
    func snapshotView(from rect: CGRect) -> UIView {
        return UIImageView(image: snapshotImage(from: rect))
    }
    
    func snapshotImage(from rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cgImage = image.cgImage!.cropping(to: rect.scale(scale: image.scale))!
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
    }
    
}

private extension CGRect {
    
    func scale(scale: CGFloat) -> CGRect {
        return CGRect(x: minX * scale, y: minY * scale, width: width * scale, height: height * scale)
    }
    
}
