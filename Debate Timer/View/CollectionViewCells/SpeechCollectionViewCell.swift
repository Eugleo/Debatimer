//
//  SpeakerCardCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

class SpeechCollectionViewCell: CardesqueCollectionViewCell {
    // MARK: Public properties
    var viewModel: SpeechCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            topLabel.text = viewModel.speaker1Name
            if let speaker2Name = viewModel.speaker2Name {
                bottomLabel.text = speaker2Name
                bottomLabel.isHidden = false
                middleLabel.isHidden = false
            } else {
                bottomLabel.isHidden = true
                middleLabel.isHidden = true
            }
            titleLabel.text = viewModel.timeLeftStr
            backgroundColor = viewModel.backgroundColor
        }
    }
}
