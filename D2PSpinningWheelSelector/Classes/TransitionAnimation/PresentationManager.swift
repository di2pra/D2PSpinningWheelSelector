//
//  PresentationManager.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 24/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private var height: CGFloat = 0.0 {
        didSet {
            presentationInteractionController.height = height
        }
    }
    
    var presentationInteractionController = PresentationInteractionController()
    
    convenience init(withHeight height: CGFloat) {
        self.init()
        self.height = height
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        if let vc = presented as? D2PSpinningWheelSelector {
            let presentationController = PresentationController(presentedViewController: presented, presenting: presenting, height: height)
            
            presentationInteractionController.selector = vc
            
            let closeGestureRecognizer = UIPanGestureRecognizer(target: presentationInteractionController, action: #selector(presentationInteractionController.handlePanGesture))
            presentationController.dimmingView.addGestureRecognizer(closeGestureRecognizer)
            
            return presentationController
        } else {
            return nil
        }
        
        
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationAnimator(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return PresentationAnimator(isPresentation: false)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        
        return presentationInteractionController.transitionInProgress ? presentationInteractionController : nil
        
    }
    
}
