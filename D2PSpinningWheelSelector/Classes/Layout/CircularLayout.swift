//
//  CircularLayout.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 13/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class CircularLayout: UICollectionViewLayout {
    
    var itemSize = CGSize(width: D2PSpinningWheelSelector.DEFAULT_ITEM_SIZE, height:  D2PSpinningWheelSelector.DEFAULT_ITEM_SIZE)
    
    var radius: CGFloat = 125 {
        didSet {
            invalidateLayout()
        }
    }
    
    var anglePerItem: CGFloat {
        return CGFloat(Double.pi * 0.25)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width + CGFloat(collectionView!.numberOfItems(inSection: 0)-1) * collectionView!.bounds.width*0.5,
                      height: collectionView!.bounds.height)
    }
    
    convenience init(radius: CGFloat, itemSize: CGFloat) {
        self.init()
        self.radius = radius
        self.itemSize = CGSize(width: itemSize, height: itemSize)
    }
    
    override class var layoutAttributesClass: AnyClass {
        return CircularLayoutAttributes.self
    }
    
    var cache = [CircularLayoutAttributes]()
    
    var angleAtExtreme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
            -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
        return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    }
    
    
    override func prepare() {
        super.prepare()
        
        
        let scrollIndex = collectionView!.contentOffset.x/(collectionView!.bounds.width*0.5)
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width * 0.5)
        
        let anchorPointY = ((itemSize.height * 0.5) + radius) / itemSize.height
        
        cache = []
        
        cache = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i) -> CircularLayoutAttributes in
            
            
            let attributes = CircularLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            
            
            if((CGFloat(i-3) <= scrollIndex) && (scrollIndex <= CGFloat(i+3))) {
                
                attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
                
            } else {
                attributes.angle = CGFloat(Double.pi)
            }
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            
            return attributes
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        let scrollIndex = collectionView!.contentOffset.x/(collectionView!.bounds.width*0.5)
        
        for (index, attributes) in cache.enumerated() {
            if((CGFloat(index-3) <= scrollIndex) && (scrollIndex <= CGFloat(index+3))) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
