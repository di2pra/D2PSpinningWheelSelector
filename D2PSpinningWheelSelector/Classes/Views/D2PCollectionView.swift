//
//  D2PCollectionView.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 22/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

final class D2PCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.allowsSelection = true
        
        self.register(UINib(nibName: "TextCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "textCell")
        self.register(UINib(nibName: "IconCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "iconCell")
        self.register(UINib(nibName: "IconTextCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "iconTextCell")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
