//
//  PauseButton.swift
//  Debate Timer
//
//  Created by Evžen Wybitul on 12.02.18.
//  Copyright © 2018 Evžen Wybitul. All rights reserved.
//

import UIKit

protocol PauseButtonDelegate {
    func tapped()
}

class PauseButton: UIView {
    var delegate: PauseButtonDelegate?

    public func togglePaused(to state: Bool? = nil) {
        if let state = state {
            playPauseView.isPaused = state
        } else {
            playPauseView.isPaused = !playPauseView.isPaused!
        }
    }

    var team: Team? {
        didSet {
            guard let team = team else { return }

            if team == .affirmative {
                teamLabel.backgroundColor = UIColor(named: "Affirmative")
                //backgroundColor = UIColor(named: "LightBlue")
            } else {
                teamLabel.backgroundColor = UIColor(named: "Negative")
                //backgroundColor = UIColor(named: "LightRed")
            }
        }
    }

    private let playPauseView = PlayPauseView()
    private let teamLabel = CircledLabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        addSubview(teamLabel) { l in
            l.edges.pinToSuperview()
        }

        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        teamLabel.addSubview(playPauseView) { v in
            v.edges.pinToSuperviewMargins(insets: insets, relation: .equal)
        }

        playPauseView.isPaused = true
        backgroundColor = .clear

        let gr = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(gr)

        isUserInteractionEnabled = true
    }

    @objc private func didTap() {
        delegate?.tapped()
    }
}
