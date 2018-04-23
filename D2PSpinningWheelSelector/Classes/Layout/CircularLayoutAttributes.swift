//
//  CircularLayoutAttributes.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 13/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class CircularLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var angle: CGFloat = 0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copiedAttributes:CircularLayoutAttributes = super.copy(with: zone) as! CircularLayoutAttributes
        
        copiedAttributes.anchorPoint = self.anchorPoint
        copiedAttributes.angle = self.angle
        
        return copiedAttributes
        
    }

}
