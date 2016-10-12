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
        let view = View(frame: self.bounds)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 4
        view.textLayer.string = string
        view.textLayer.alignmentMode = kCAAlignmentCenter
        self.addSubview(view)
        
//        let snapshotView = view.snapshotView(afterScreenUpdates: true)! // doesn't work in xcode 8
        let snapshotView = view.snapshotView()
//        view.removeFromSuperview()
        self.addSubview(snapshotView)
        
//        let nextTopHalf = snapshotView.topHalf()
//        let nextBottomHalf = snapshotView.bottomHalf()
//        if let topHalf = topHalf, let bottomHalf = bottomHalf {
//            self.insertSubview(nextTopHalf, belowSubview: topHalf)
//            self.insertSubview(nextBottomHalf, belowSubview: bottomHalf)
//        } else {
//            self.addSubview(nextTopHalf)
//            self.addSubview(nextBottomHalf)
//        }
        
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

private class View: UIView {
    
    var textLayer: CATextLayer {
        return layer as! CATextLayer
    }
    
    override class var layerClass: AnyClass {
        return CATextLayer.self
    }
    
}

private extension UIView {
    
    func topHalf() -> UIView {
        var frame = self.bounds
        frame.size.height /= 2
        let view = resizableSnapshotView(from: frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets())!
        view.isUserInteractionEnabled = false
        return view
    }
    
    func bottomHalf() -> UIView {
        var frame = self.bounds
        frame.size.height /= 2
        frame.origin.y = frame.height
        let view = resizableSnapshotView(from: frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets())!
        view.frame.origin.y += frame.height
        view.isUserInteractionEnabled = false
        return view
    }
    
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func snapshotView() -> UIView {
        return UIImageView(image: snapshotImage())
    }
    
}
