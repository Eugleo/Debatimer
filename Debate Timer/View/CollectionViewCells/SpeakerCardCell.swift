//
//  SpeakerCardCell.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 17.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

class SpeakerCardCell: UICollectionViewCell {
    static let reuseID = "SpeakerCollectionViewCell"

    var viewModel: SpeakerCardCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            speaker1Label.text = viewModel.speaker1name
            if let speaker2Name = viewModel.speaker2Name {
                speaker2Label.text = speaker2Name
                speaker2Label.isHidden = false
            } else {
                speaker2Label.isHidden = true
            }
            timeLabel.text = viewModel.timeLeft

            backgroundColor =
                viewModel.team == .affirmative ?
                    UIColor(named: "Affirmative") :
                    UIColor(named: "Negative")
        }
    }

    private var speaker1Label = CircledLabel()
    private var speaker2Label = CircledLabel()

    private let timeLabel = UILabel {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 35)
        $0.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        layer.cornerRadius = 15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        layer.masksToBounds = false
        layer.backgroundColor = UIColor(named: "Affirmative")!.cgColor
        

        addSubview(timeLabel) {
            $0.center.alignWithSuperview()
        }
        addSubview(speaker1Label) {
            $0.leading.pinToSuperviewMargin()
            $0.top.pinToSuperviewMargin()
            $0.height.set(30)
            $0.width.set(30)
        }
        addSubview(speaker2Label) {
            $0.leading.pinToSuperviewMargin()
            $0.top.align(with: speaker1Label.al.bottom.offsetting(by: 10))
            $0.height.set(30)
            $0.width.set(30)
        }
        speaker2Label.isHidden = true

        speaker1Label.backgroundColor = UIColor(white: 1, alpha: 0.3)
        speaker2Label.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        speaker1Label.layer.cornerRadius = speaker1Label.frame.height / 2
        speaker2Label.layer.cornerRadius = speaker1Label.frame.height / 2
    }
}
