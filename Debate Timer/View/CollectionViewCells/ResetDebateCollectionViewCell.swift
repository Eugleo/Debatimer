//
//  RoundedCollectionViewCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 05.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

class ResetDebateCollectionViewCell: CardesqueCollectionViewCell {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Private functions

    private func setupView() {
        topLabel.text = "↻"
        topLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.text = "Vymazat"
        gradientColors = Constants.UI.GradientColors.gray
    }
}
