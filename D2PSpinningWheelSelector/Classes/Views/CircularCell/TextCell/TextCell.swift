//
//  TextCell.swift
//  D2PSpinningWheel
//
//  Created by Pradheep Rajendirane on 21/02/2018.
//  Copyright © 2018 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class TextCell: CircularCell {
    
    @IBOutlet weak var textLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textLabel.textColor = .white
        self.textLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
    }

}
