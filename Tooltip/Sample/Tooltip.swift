//
//  Tooltip.swift
//  Sample
//
//  Created by Lasha Efremidze on 4/14/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class Tooltip: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let roundedRect = CAShapeLayer()
        roundedRect.frame = self.bounds
        roundedRect.fillColor = UIColor.redColor().CGColor
        roundedRect.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).CGPath
        self.layer.addSublayer(roundedRect)
        
        let tip = CAShapeLayer()
        tip.frame = CGRect(x: self.bounds.width / 4, y: self.bounds.maxY, width: self.bounds.width / 2, height: self.bounds.height / 2)
        tip.fillColor = UIColor.redColor().CGColor
        tip.path = {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint())
            path.addLineToPoint(CGPoint(x: tip.frame.width, y: 0))
            path.addLineToPoint(CGPoint(x: tip.frame.width / 2, y: tip.frame.height))
            return path.CGPath
            }()
        self.layer.addSublayer(tip)
    }
    
}
