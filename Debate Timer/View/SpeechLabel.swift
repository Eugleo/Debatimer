//
//  ColorfulLabel.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 15.01.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit
import Yalta

protocol SpeechLabelDelegate {
    func tapped(sender: SpeechLabel)
}

final class SpeechLabel: UIView {
    public var delegate: SpeechLabelDelegate?
    public var viewModel: SpeechLabelViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            speechTimeLabel.text = viewModel.speechTime
            crossQuestionsTimeLabel.text = viewModel.crossQuestionTime
            speakerLabel.text = viewModel.name
            speakerLabel.backgroundColor =
                viewModel.team == .affirmative ?
                    UIColor(named: "Affirmative") :
                    UIColor(named: "Negative")
            crossQuestionsLabel.text = "?"
        }
    }

    private let speakerLabel = CircledLabel()
    private let crossQuestionsLabel = CircledLabel()

    private let crossQuestionsTimeLabel = UILabel {
        $0.textColor = .lightGray
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 26)
    }

    private let speechTimeLabel = UILabel {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 26)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.03
        layer.cornerRadius = 15

        addSubview(speakerLabel) {
            $0.top.pinToSuperviewMargin()
            $0.leading.pinToSuperviewMargin()
            $0.height.set(30)
            $0.width.set(30)
        }
        speakerLabel.clipsToBounds = true

        addSubview(crossQuestionsLabel) {
            $0.top.align(with: speakerLabel.al.bottom.offsetting(by: 7))
            $0.bottom.pinToSuperviewMargin()
            $0.leading.pinToSuperviewMargin()
            $0.width.set(30)
            $0.height.set(30)
        }
        crossQuestionsLabel.text = "?"
        crossQuestionsLabel.backgroundColor = UIColor(named: "NeutralGray")

        addSubview(speechTimeLabel) {
            $0.leading.align(with: speakerLabel.al.trailing.offsetting(by: 7))
            $0.trailing.pinToSuperviewMargin()
            $0.centerY.align(with: speakerLabel.al.centerY)
        }

        addSubview(crossQuestionsTimeLabel) {
            $0.leading.align(with: crossQuestionsLabel.al.trailing.offsetting(by: 7))
            $0.trailing.pinToSuperviewMargin()
            $0.centerY.align(with: crossQuestionsLabel.al.centerY)
        }

        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(gr)
    }

    @objc private func tapped() {
        delegate?.tapped(sender: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        speakerLabel.layer.cornerRadius = speakerLabel.frame.height / 2
    }
}
