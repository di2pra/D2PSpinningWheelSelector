//
//  CircularCell.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 21/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class CircularCell: UICollectionViewCell {
    
    fileprivate let animInitScale: CGFloat = 0.001
    fileprivate let animDuration: TimeInterval = 0.3
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectedBgView: UIView!
    
    var isAnimating:Bool = false // cell animation flag
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.containerView.backgroundColor = D2PSpinningWheelSelector.itemColor
        self.selectedBgView.backgroundColor = D2PSpinningWheelSelector.itemSelectedColor
        
        self.selectedBgView.isHidden = true
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = self.bounds.width * 0.5
        self.selectedBgView.layer.cornerRadius = self.bounds.width * 0.5
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        if let circularlayoutAttributes = layoutAttributes as? CircularLayoutAttributes {
            
            self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
            self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.updateUIToNewState()
        
    }
    
    /* ==========
     function to update the cell state selected/not selected with optional animation (by default no) and a completion handler.
    ========== */
    func updateUIToNewState(animated: Bool? = false, completion: (() -> Void)? = nil) {
        
        selectedBgView.isHidden = false
        
        if isSelected {
            
            if animated! {
                
                
                if !isAnimating {
                    
                    isAnimating = true
                    
                    self.selectedBgView.transform = .init(scaleX: animInitScale, y: animInitScale)
                    
                    UIView.animate(withDuration: animDuration, animations: {
                        self.selectedBgView.transform = .identity
                    }, completion: { (finished) in
                        self.selectedBgView.isHidden = false
                        self.isAnimating = false
                        
                        if let compl = completion {
                            compl()
                        }
                        
                    })
                }
                
                
            } else {
                self.selectedBgView.transform = .identity
                self.selectedBgView.isHidden = false
            }
            
            
            
        } else {
            
            if animated! {
                
                if !isAnimating {
                    
                    isAnimating = true
                    
                    UIView.animate(withDuration: animDuration, animations: {
                        self.selectedBgView.transform = .init(scaleX: self.animInitScale, y: self.animInitScale)
                    }, completion: { (finished) in
                        self.selectedBgView.isHidden = true
                        self.isAnimating = false
                    })
                    
                }
                
            } else {
                self.selectedBgView.isHidden = true
            }
            
            
        }
    }
    
}
