//
//  PresentationController.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 24/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    private var height: CGFloat
    var dimmingView: UIView!
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         height: CGFloat? = D2PSpinningWheelSelector.DEFAULT_HEIGHT) {
        
        self.height = height ?? D2PSpinningWheelSelector.DEFAULT_HEIGHT
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        
        return CGSize(width: parentSize.width, height: height)
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        //1
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        
        frame.origin.y = containerView!.frame.height - height
        return frame
    }

}

private extension PresentationController {
    func setupDimmingView() {
        
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
    }
}
