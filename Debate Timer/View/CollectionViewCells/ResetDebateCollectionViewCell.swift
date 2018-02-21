//
//  RoundedCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 05.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class ResetDebateCollectionViewCell: CardesqueCollectionViewCell {

    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        topLabel.text = "↻"
        topLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = "Začít znovu"
        backgroundColor = UIColor(named: "NeutralGray")
    }
}
