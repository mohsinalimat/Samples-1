//
//  CustomTransition.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/17/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class CustomTransition: UIPercentDrivenInteractiveTransition {
    
    private var presenting = false
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension CustomTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let viewControllers: (from: UIViewController, to: UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        let views: (from: UIView, to: UIView) = (transitionContext.viewForKey(UITransitionContextFromViewKey) ?? viewControllers.from.view, transitionContext.viewForKey(UITransitionContextToViewKey) ?? viewControllers.to.view)
        let duration = transitionDuration(transitionContext)
        
        let offScreenBottom = CGAffineTransformMakeTranslation(0, container.frame.height)
        
        if presenting {
            views.to.frame = container.bounds
            views.to.transform = offScreenBottom
            container.addSubview(views.from)
            container.addSubview(views.to)
        } else {
            views.to.frame = container.bounds
            views.to.transform = CGAffineTransformIdentity
            container.addSubview(views.to)
            container.addSubview(views.from)
        }
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            if self.presenting {
                views.to.transform = CGAffineTransformIdentity
            } else {
                views.from.transform = offScreenBottom
            }
        }) { _ in
            transitionContext.completeTransition(true)
            
            if !UIApplication.sharedApplication().keyWindow!.subviews.contains(views.to) {
                UIApplication.sharedApplication().keyWindow!.addSubview(views.to)
            }
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension CustomTransition: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
