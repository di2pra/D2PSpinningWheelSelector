//
//  D2PItem.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 27/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

public struct D2PItem {
    public let icon:UIImage?
    public let label: String?
    
    public init(label: String, icon: UIImage? = nil) {
        self.label = label
        self.icon = icon
    }
    
    public init(_ icon: UIImage?) {
        self.icon = icon
        self.label = nil
    }
    
}
