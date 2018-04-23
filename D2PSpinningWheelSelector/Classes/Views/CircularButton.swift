//
//  CircularButton.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 26/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

final class CircularButton: UIButton {
    
    fileprivate var btnState:BtnState = .Close
    fileprivate var isAnimating: Bool = false
    
    /*fileprivate let closeImage = UIImage(named: "close", in: Bundle(for: type(of: self)), compatibleWith: nil)
    fileprivate let submitImage = UIImage(named: "submit", in: Bundle(for: type(of: self)), compatibleWith: nil)*/
    
    enum BtnState {
        case Close
        case Submit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        updateUI()
        
    }
    
    func setState(_ state: BtnState, animated: Bool) {
        
        guard state != self.btnState else {
            return
        }
        
        if !animated {
            self.btnState = state
            self.updateUI()
        } else {
            
            if !isAnimating {
                
                isAnimating = true
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = .init(scaleX: 0.001, y: 0.001)
                }, completion: { (terminated) in
                    
                    self.btnState = state
                    self.updateUI()
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.transform = .identity
                        self.isAnimating = false
                    })
                    
                })
                
            }
            
        }
        
    }
    
    private func updateUI() {
        if self.btnState == .Close {
            self.backgroundColor = UIColor(red:0.82, green:0.30, blue:0.34, alpha:1.0) // #D24D57
            
            self.setImage( UIImage(named: "close", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            self.setImage( UIImage(named: "close", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .highlighted)
            
        } else {
            self.backgroundColor = UIColor(red:0.11, green:0.74, blue:0.61, alpha:1.0) // #1BBC9B
            self.setImage( UIImage(named: "submit", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            self.setImage( UIImage(named: "submit", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .highlighted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width * 0.5
        
    }
    
    

}
