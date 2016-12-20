//
//  TransitionManager.swift
//
//  Created by Lasha Efremidze on 5/5/16.
//

import UIKit

protocol TransitionManagerAnimationProtocol {
    func transition(transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), showing: Bool, duration: TimeInterval, completion: () -> ())
    var interactionController: UIPercentDrivenInteractiveTransition? { get set }
}

class TransitionManagerAnimation: NSObject, TransitionManagerAnimationProtocol {
    func transition(transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), showing: Bool, duration: TimeInterval, completion: () -> ()) { completion() }
    var interactionController: UIPercentDrivenInteractiveTransition?
}

class TransitionManager: NSObject {
    
    fileprivate(set) var transitionAnimation: TransitionManagerAnimationProtocol
    fileprivate(set) var showing = false
    var duration: TimeInterval = 0.3
    
    init(transitionAnimation: TransitionManagerAnimationProtocol) {
        self.transitionAnimation = transitionAnimation
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension TransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let viewControllers: (from: UIViewController, to: UIViewController) = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!, transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
        let views: (from: UIView, to: UIView) = (transitionContext.view(forKey: UITransitionContextViewKey.from) ?? viewControllers.from.view, transitionContext.view(forKey: UITransitionContextViewKey.to) ?? viewControllers.to.view)
        transitionAnimation.transition(transitionContext: transitionContext, container: container, viewControllers: viewControllers, views: views, showing: showing, duration: transitionDuration(using: transitionContext), completion: {
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
            
            if !cancelled && !UIApplication.shared.keyWindow!.subviews.contains(views.to) {
                UIApplication.shared.keyWindow!.addSubview(views.to)
            }
        })
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension TransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.showing = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.showing = false
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        showing = true
        return transitionAnimation.interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        showing = false
        return transitionAnimation.interactionController
    }
    
}

// MARK: - UINavigationControllerDelegate
extension TransitionManager: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.showing = (operation == .push)
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transitionAnimation.interactionController
    }
    
}

// MARK: - ShowTransitionAnimation
class ShowTransitionAnimation: TransitionManagerAnimation {
    
    override func transition(transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), showing: Bool, duration: TimeInterval, completion: @escaping () -> ()) {
        if showing {
            container.insertSubview(views.to, aboveSubview: views.from)
        } else {
            container.insertSubview(views.from, aboveSubview: views.to)
        }
        UIView.animate(withDuration: duration, animations: {}, completion: { _ in completion() })
    }
    
}

// MARK: - OverlayTransitionAnimation
class OverlayTransitionAnimation: TransitionManagerAnimation {
    
    private weak var panningViewController: UIViewController? {
        didSet {
            panningViewController?.view.addGestureRecognizer(UIPanGestureRecognizer { [unowned self] recognizer in
                guard let recognizer = recognizer as? UIPanGestureRecognizer, let view = recognizer.view else { return }
                let translationY = recognizer.translation(in: view).y
                switch recognizer.state {
                case .began:
                    self.interactionController = UIPercentDrivenInteractiveTransition()
                    self.panningViewController?.dismiss(animated: true) { [unowned self] in
                        self.interactionController?.finish()
                    }
                case .changed:
                    let percent = -translationY / view.bounds.height
                    self.interactionController?.update(percent)
                default:
                    let velocityY = recognizer.velocity(in: view).y
                    let percent = -(translationY + (velocityY / 6)) / view.bounds.height
                    if percent > 0.5 {
                        self.interactionController?.finish()
                        self.panningViewController = nil
                    } else {
                        self.interactionController?.cancel()
                    }
                    self.interactionController = nil
                }
            })
        }
    }
    
    override func transition(transitionContext: UIViewControllerContextTransitioning, container: UIView, viewControllers: (from: UIViewController, to: UIViewController), views: (from: UIView, to: UIView), showing: Bool, duration: TimeInterval, completion: @escaping () -> ()) {
        if showing {
            panningViewController = viewControllers.to
        }
        if showing {
            container.insertSubview(views.to, aboveSubview: views.from)
        } else {
            container.insertSubview(views.from, aboveSubview: views.to)
        }
        UIView.animate(withDuration: showing ? 0 : duration, animations: {
            if !showing {
                views.from.transform = CGAffineTransform(translationX: 0, y: -container.frame.height)
            }
        }, completion: { _ in completion() })
    }
    
}
