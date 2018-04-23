//
//  PresentationInteractionController.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 15/03/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PresentationInteractionController: UIPercentDrivenInteractiveTransition {

    weak var selector: D2PSpinningWheelSelector!
    var transitionInProgress = false
    var shouldCompleteTransition = false
    var height: CGFloat = 100
    
    @objc func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let velocity = gestureRecognizer.velocity(in:  gestureRecognizer.view!.superview!)
        
        switch gestureRecognizer.state {
        case .began:
            
            if velocity.y > 0 {
                shouldCompleteTransition = false
                transitionInProgress = true
                selector.dismiss(animated: true, completion: nil)
            }
            
        case .changed:
            
            if transitionInProgress {
                let const = CGFloat(fminf(fmaxf(Float(translation.y / height*0.5), 0.0), 1.0))
                shouldCompleteTransition = const > 0.3
                
                update(const)
                
            }
            
            
        case .cancelled, .ended:
            if transitionInProgress {
                transitionInProgress = false
                if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                    cancel()
                } else {
                    finish()
                }
            }
            
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
    
}
