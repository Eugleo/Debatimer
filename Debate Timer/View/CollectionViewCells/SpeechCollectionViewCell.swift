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

    // MARK: - Public properties

    var timeLeft: String? {
        didSet {
            titleLabel.text = timeLeft
        }
    }
    
    var viewModel: SpeechCollectionViewCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            topLabel.text = viewModel.speaker1Name
            if let speaker2Name = viewModel.speaker2Name {
                bottomLabel.text = speaker2Name
                bottomLabel.alpha = 1
                middleLabel.alpha = 1
            } else {
                bottomLabel.alpha = 0
                middleLabel.alpha = 0
            }
            gradientColors = viewModel.backgroundGradient
            titleLabel.text = timeLeft ?? viewModel.timeLimit
        }
    }
}
