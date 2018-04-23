//
//  PresentationAnimator.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 24/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    let isPresentation: Bool
    
    fileprivate let animInitScale: CGFloat = 0.001
    fileprivate let animDuration: TimeInterval = 0.3
    
    
    // MARK: - Initializers
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let key = isPresentation ? UITransitionContextViewControllerKey.to
            : UITransitionContextViewControllerKey.from
        
        let controller = transitionContext.viewController(forKey: key) as! D2PSpinningWheelSelector
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        
        
        if isPresentation {
            controller.maskView.transform = .init(scaleX: animInitScale, y: animInitScale)
            
            controller.hideVisibleCells()
            
            UIView.animate(withDuration: animDuration, animations: {
                
                controller.maskView.transform = .identity
                controller.showVisibleCells()
                
            }, completion: { (terminated) in
                
                let success = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(success)
                
            })
            
        } else {
            
            UIView.animate(withDuration: animDuration, animations: {
                
                controller.maskView.transform = .init(scaleX: self.animInitScale, y: self.animInitScale)
                controller.hideVisibleCells()
                controller.hideMainButton()
                
            }, completion: { (terminated) in
                
                let success = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(success)
                
            })
            
        }
        
    }

}
